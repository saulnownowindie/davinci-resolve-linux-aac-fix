#!/bin/bash
# ============================================================
# convert-media.sh - Workaround para DaVinci Resolve FREE (sin plugins)
# Convierte videos a formatos compatibles con Resolve usando FFmpeg
# ============================================================

case "$1" in
  --batch-mp4)
    echo "Convirtiendo todos los MP4 a MOV (ProRes + PCM)..."
    for i in *.mp4; do
      [ -f "$i" ] || continue
      echo "Convirtiendo: $i"
      ffmpeg -i "$i" -c:v prores_ks -profile:v 3 -qscale:v 9 -acodec pcm_s16le "${i%.*}.mov"
    done
    echo "Done."
    ;;
  --batch-audio)
    echo "Convirtiendo todos los MP3 a WAV (PCM)..."
    for i in *.mp3; do
      [ -f "$i" ] || continue
      echo "Convirtiendo: $i"
      ffmpeg -i "$i" -c:a pcm_s16le "${i%.*}.wav"
    done
    echo "Done."
    ;;
  --single)
    if [ -z "$2" ]; then
      echo "Uso: $0 --single input.mp4"
      exit 1
    fi
    INPUT="$2"
    OUTPUT="${2%.*}.mov"
    echo "Convirtiendo: $INPUT -> $OUTPUT"
    ffmpeg -i "$INPUT" -c:v prores_ks -profile:v 3 -qscale:v 9 -acodec pcm_s16le "$OUTPUT"
    echo "Done: $OUTPUT"
    ;;
  *)
    echo "Uso:"
    echo "  $0 --single <input.mp4>     Convierte un solo archivo"
    echo "  $0 --batch-mp4              Convierte todos los MP4 del directorio"
    echo "  $0 --batch-audio            Convierte todos los MP3 del directorio"
    echo ""
    echo "Formatos soportados por DaVinci Resolve FREE en Linux:"
    echo "  - Video: MOV (ProRes, DNxHD, DNxHR)"
    echo "  - Audio: PCM (pcm_s16le, pcm_s24le)"
    echo ""
    echo "NOTA: DaVinci Resolve FREE en Linux NO soporta:"
    echo "  - Import de MP4/H.264/H.265"
    echo "  - Codec AAC"
    echo "  - Plugins de terceros"
    ;;
esac
