#!/usr/bin/env bash

# Skrypt do automatycznego backupu wolumenu Docker
# Użycie: ./backup_volume.sh <nazwa_wolumenu> [katalog_docelowy]

set -euo pipefail

# 1. Walidacja parametrów wejściowych
VOLUME_NAME="${1:-}"
BACKUP_DIR="${2:-./backups}"

if [ -z "$VOLUME_NAME" ]; then
    echo "Błąd: Nie podano nazwy wolumenu."
    echo "Użycie: $0 <nazwa_wolumenu> [katalog_docelowy]"
    exit 1
fi

# 2. Sprawdzenie, czy wolumen istnieje
if ! docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
    echo "Błąd: Wolumen '$VOLUME_NAME' nie istnieje."
    exit 1
fi

# 3. Przygotowanie ścieżki i nazwy pliku backupu
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILENAME="${VOLUME_NAME}_${TIMESTAMP}.tar.gz"

mkdir -p "$BACKUP_DIR"
# Pobranie pełnej ścieżki do podmontowania w kontenerze pomocniczym
ABS_BACKUP_DIR=$(cd "$BACKUP_DIR" && pwd)

echo "-> Rozpoczynanie backupu wolumenu '$VOLUME_NAME'..."

# 4. Wykonanie backupu za pomocą tymczasowego kontenera Alpine
docker run --rm \
    -v "$VOLUME_NAME":/volume:ro \
    -v "$ABS_BACKUP_DIR":/backup \
    alpine \
    tar -czf "/backup/$BACKUP_FILENAME" -C /volume .

echo "-> Kopia zapasowa została pomyślnie utworzona:"
echo "   Plik: $ABS_BACKUP_DIR/$BACKUP_FILENAME"
