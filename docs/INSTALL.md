# Guia de Instalacion Detallada

## Requisitos del sistema

| Componente | Minimo | Recomendado |
|------------|--------|-------------|
| OS | Rocky Linux 8.6 / CentOS 7.3 | Rocky Linux 9.x |
| GPU | NVIDIA con drivers propietarios | NVIDIA RTX 3060+ |
| RAM | 16 GB | 32 GB+ |
| Storage | SSD 500 GB | NVMe 1 TB+ |
| CPU | Intel i5 / Ryzen 5 | Intel i7 / Ryzen 7+ |

## Paso 1: Preparar el sistema

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y build-essential pkg-config clang \
  libavcodec-dev libavutil-dev ffmpeg \
  ocl-icd-opencl-dev
```

### Rocky Linux/CentOS
```bash
sudo dnf install -y clang pkgconfig ffmpeg-devel make \
  ocl-icd ocl-icd-devel
```

### NVIDIA Drivers
```bash
# Ubuntu
ubuntu-drivers devices | grep recommended
sudo apt install nvidia-driver-550

# Rocky Linux
sudo dnf install kmod-nvidia
```

Reiniciar despues de instalar drivers NVIDIA.

## Paso 2: Descargar DaVinci Resolve Studio

1. Ir a https://www.blackmagicdesign.com/products/davinciresolve
2. Click "Download"
3. Seleccionar "DaVinci Resolve Studio" para **Linux**
4. Completar el formulario
5. Descargar el archivo `.zip`
6. Descomprimir:
   ```bash
   unzip DaVinci_Resolve_Studio_21.x_Linux.zip
   ```

## Paso 3: Instalar DaVinci Resolve

```bash
chmod +x DaVinci_Resolve_Studio_21.x_Linux.run
sudo ./DaVinci_Resolve_Studio_21.x_Linux.run
```

Seguir el asistente de instalacion. Resolve se instalara en `/opt/resolve/`.

### Verificar instalacion
```bash
/opt/resolve/bin/resolve
```

## Paso 4: Compilar el plugin AAC

```bash
cd aac-plugin

# Limpiar builds previos
make clean 2>/dev/null || true

# Compilar
./build.sh
```

Si todo sale bien, veras:
```
Bundle created at aac_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/aac_encoder_plugin.dvcp
```

### Solucion de problemas de compilacion

**Error: clang++ no encontrado**
```bash
sudo apt install clang
# o
sudo dnf install clang
```

**Error: libavcodec no encontrado**
```bash
sudo apt install libavcodec-dev libavutil-dev
# o
sudo dnf install ffmpeg-devel
```

**Error: -lc++ not found**
El Makefile ya esta configurado para usar libstdc++ en Linux. Si persiste:
```bash
export CXXFLAGS="-stdlib=libstdc++"
./build.sh
```

## Paso 5: Instalar el plugin

```bash
sudo ./install.sh
```

Esto copiara el plugin a:
```
/opt/resolve/IOPlugins/aac_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/aac_encoder_plugin.dvcp
```

## Paso 6: Verificar

1. Abrir DaVinci Resolve Studio
2. Crear un proyecto nuevo
3. Ir a la pestana **Deliver**
4. En **Format**, seleccionar **MP4**
5. En **Audio**, habilitar **Export Audio**
6. El codec de audio deberia mostrar **"AAC (FFMpeg Plugin)"**
7. Configurar el bitrate (128-512 kbps) con el slider

## Desinstalacion

### Plugin AAC
```bash
sudo rm -rf /opt/resolve/IOPlugins/aac_encoder_plugin.dvcp.bundle
```

### DaVinci Resolve
```bash
# Metodo 1: Usar el instalador
sudo ./DaVinci_Resolve_Studio_*.run

# Metodo 2: Borrado manual
sudo rm -rf /opt/resolve
sudo rm -rf ~/Documents/BlackmagicDesign
```

## Notas

- El plugin solo funciona con **DaVinci Resolve Studio** (no la version gratuita)
- La version gratuita de Resolve en Linux no soporta import de MP4 ni plugins
- Para la version gratuita, usar `scripts/convert-media.sh` como workaround
- El plugin usa FFmpeg internamente para la codificacion AAC
