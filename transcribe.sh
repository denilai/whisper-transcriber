#!/bin/bash

# --- Переменные и цвета ---
WHISPER_PROJECT_DIR="whisper_transcriber"
PYTHON_SCRIPT_NAME="transcribe.py"
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_NC='\033[0m' # No Color

# --- Шаг 1: Проверка входных данных ---

# Проверяем, был ли передан аргумент (путь к файлу)
if [ -z "$1" ]; then
    echo -e "${COLOR_RED}Ошибка: Вы не указали путь к аудиофайлу.${COLOR_NC}"
    echo -e "Пример использования: ${COLOR_GREEN}./run_transcribe.sh /путь/к/вашему/аудио.mp3${COLOR_NC}"
    exit 1
fi

AUDIO_FILE_PATH="$1"

# Проверяем, существует ли указанный файл
if [ ! -f "$AUDIO_FILE_PATH" ]; then
    echo -e "${COLOR_RED}Ошибка: Файл не найден по пути '${AUDIO_FILE_PATH}'${COLOR_NC}"
    exit 1
fi

# Проверяем, существует ли директория проекта
if [ ! -d "$WHISPER_PROJECT_DIR" ]; then
    echo -e "${COLOR_RED}Ошибка: Директория проекта '$WHISPER_PROJECT_DIR' не найдена.${COLOR_NC}"
    echo -e "Пожалуйста, сначала запустите скрипт установки ${COLOR_YELLOW}setup_whisper.sh${COLOR_NC}"
    exit 1
fi

# --- Шаг 2: Выполнение транскрибации ---

echo -e "${COLOR_YELLOW}--- Запуск транскрибации для файла: $AUDIO_FILE_PATH ---${COLOR_NC}"

# Запоминаем текущую директорию
ORIGINAL_DIR=$(pwd)

# Переходим в директорию проекта
cd "$WHISPER_PROJECT_DIR"

# Активируем виртуальное окружение
echo "Активация виртуального окружения..."
source venv/bin/activate

# Запускаем Python-скрипт, передавая ему абсолютный путь к файлу
# realpath преобразует относительный путь в абсолютный, чтобы скрипт нашел файл
python "$PYTHON_SCRIPT_NAME" "$(realpath "$AUDIO_FILE_PATH")"

# Деактивируем окружение
deactivate
echo "Виртуальное окружение деактивировано."

# Возвращаемся в исходную директорию
cd "$ORIGINAL_DIR"

echo -e "\n${COLOR_GREEN}--- Транскрибация завершена. ---${COLOR_NC}"
echo -e "Текстовый файл (.txt) должен находиться в той же папке, что и ваш аудиофайл."
