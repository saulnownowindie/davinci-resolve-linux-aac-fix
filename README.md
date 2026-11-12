# DaVinci Resolve Linux - AAC Fix

Repositorio privado para instalación de **DaVinci Resolve** en Linux con el **Fix AAC** integrado.

## Problema

DaVinci Resolve en Linux **no soporta el codec de audio AAC** nativamente. Esto significa que:

- No puedes exportar videos H.264/H.265 con audio AAC
- Los archivos MP4 con audio AAC no se exportan correctamente
- La versión free tampoco soporta importación de MP4

## Solución

Este repo contiene un **plugin AAC Encoder** basado en FFmpeg que se integra con el sistema IOPlugins de DaVinci Resolve Studio en Linux. Permite codificar audio AAC al exportar a MP4, MOV o MKV.

> **Nota:** El plugin requiere **DaVinci Resolve Studio** (la versión gratuita no soporta plugins de terceros).

## Estructura del repo

```
.
├── README.md                  # Este archivo
├── LICENSE                    # GPLv3
├── .gitignore
├── aac-plugin/                # Código fuente del plugin AAC
│   ├── audio_encoder.cpp      # Lógica principal del encoder AAC
│   ├── audio_encoder.h        # Header del encoder
│   ├── plugin.cpp             # Punto de entrada del plugin
│   ├── plugin.h               # Header del plugin
│   ├── build.sh               # Script de compilación
│   ├── install.sh             # Script de instalación
│   ├── Makefile               # Build system
│   ├── .mk.defs               # Definiciones del Makefile
│   ├── include/               # Headers de la API de IOPlugins
│   │   ├── IOPluginDefs.h
│   │   └── IOPluginProps.h
│   └── wrapper/               # Wrapper de la API del host
│       ├── host_api.cpp
│       ├── host_api.h
│       ├── plugin_api.cpp
│       ├── plugin_api.h
│       └── Makefile
├── scripts/                   # Scripts auxiliares
│   ├── download-resolve.sh    # Guía de descarga del instalador oficial
│   ├── install-all.sh         # Instalación todo-en-uno
│   └── convert-media.sh       # Workaround para versión free (FFmpeg)
└── docs/                      # Documentación adicional
    └── INSTALL.md             # Guía detallada de instalación
```

## Requisitos

- **DaVinci Resolve Studio 21** (o superior) para Linux
- Linux x86-64 (Rocky Linux 8.6+ o CentOS 7.3+ recomendado)
- FFmpeg instalado (`sudo apt install ffmpeg` o equivalente)
- Compilador C++ (clang++ o g++ >= 9)
- Librerías de desarrollo de FFmpeg:
  ```bash
  # Ubuntu/Debian
  sudo apt update
  sudo apt install build-essential pkg-config libavcodec-dev libavutil-dev

  # Rocky Linux/CentOS
  sudo dnf install clang pkgconfig ffmpeg-devel
  ```

## Instalación rápida

### 1. Descargar DaVinci Resolve Studio

Descarga el instalador oficial desde:
> https://www.blackmagicdesign.com/products/davinciresolve

Selecciona la versión para **Linux**. El archivo se llamará algo como:
```
DaVinci_Resolve_Studio_21.x_Linux.run
```

### 2. Instalar DaVinci Resolve

```bash
chmod +x DaVinci_Resolve_Studio_*.run
sudo ./DaVinci_Resolve_Studio_*.run
```

### 3. Compilar e instalar el plugin AAC

```bash
cd aac-plugin
./build.sh
sudo ./install.sh
```

El plugin se instalará en:
```
/opt/resolve/IOPlugins/aac_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/aac_encoder_plugin.dvcp
```

### 4. Verificar

Abre DaVinci Resolve Studio, ve a la pestaña **Deliver**, selecciona **MP4** como formato, y deberías ver **"AAC (FFMpeg Plugin)"** como opción de codec de audio.

## Instalación automatizada (todo-en-uno)

```bash
# Coloca el instalador .run en el directorio raíz del repo
chmod +x scripts/install-all.sh
sudo ./scripts/install-all.sh
```

## Workaround para versión FREE (sin plugins)

Si usas la versión gratuita de DaVinci Resolve (que no soporta plugins), puedes convertir tus videos con FFmpeg antes de importarlos:

```bash
# Convertir MP4 a MOV con ProRes + PCM (compatible con Resolve free)
ffmpeg -i input.mp4 -c:v prores_ks -profile:v 3 -qscale:v 9 -acodec pcm_s16le output.mov

# Conversión por lotes
for i in *.mp4; do ffmpeg -i "$i" -c:v prores_ks -profile:v 3 -qscale:v 9 -acodec pcm_s16le "${i%.*}.mov"; done
```

Ver `scripts/convert-media.sh` para más opciones.

## Características del plugin

- **Codec AAC** vía FFmpeg (AV_CODEC_ID_AAC)
- **Bitrate configurable** (128-512 kbps) con slider en la UI
- **Formatos soportados:** MP4, MOV, MKV
- **Sample rates:** 44100, 48000 Hz
- **Bit depths:** 16-bit, 24-bit PCM
- **Formato interno:** Planar float (FLTP) - óptimo para AAC

## Créditos

- Plugin AAC original: [Toxblh/davinci-linux-aac-codec](https://github.com/Toxblh/davinci-linux-aac-codec) (GPLv3)
- Guía de instalación Linux: [flolu/davinci-resolve-linux](https://github.com/flolu/davinci-resolve-linux)
- DaVinci Resolve es producto de [Blackmagic Design](https://www.blackmagicdesign.com/)

## Licencia

GPLv3 - Ver [LICENSE](LICENSE)

## Aviso legal

DaVinci Resolve es un producto de Blackmagic Design. Este repositorio es para uso personal y no redistribuye el software de Blackmagic. El instalador debe descargarse oficialmente desde su sitio web.
