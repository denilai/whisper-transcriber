#!/bin/bash


REPO_PATH="/home/denilai/repos/personal/whisper-transcriber"

# --- Конфигурация (должна совпадать с setup_whisper.sh) ---
PROJECT_DIR="$REPO_PATH"
VENV_DIR="venv"
SCRIPT_NAME="transcribe.py"

# --- Функции для цветного вывода ---
print_info() {
    echo -e "\e[34mINFO: $1\e[0m"
}

print_success() {
    echo -e "\e[32mУСПЕШНО: $1\e[0m"
}

print_error() {
    echo -e "\e[31mОШИБКА: $1\e[0m" >&2
}

# --- Начальные проверки ---
# 1. Проверка наличия аргумента (пути к файлу)
if [ -z "$1" ]; then
    print_error "Не указан путь к аудиофайлу."
    echo "Использование: $0 /путь/к/вашему/аудиофайлу.mp3"
    exit 1
fi

AUDIO_FILE="$1"

# 2. Проверка существования директории проекта и скрипта
if [ ! -f "$PROJECT_DIR/$SCRIPT_NAME" ]; then
    print_error "Скрипт '$PROJECT_DIR/$SCRIPT_NAME' не найден."
    echo "Пожалуйста, сначала запустите скрипт 'setup_whisper.sh' для установки."
    exit 1
fi

# --- Основной процесс ---
print_info "Активация виртуального окружения..."
source "$PROJECT_DIR/$VENV_DIR/bin/activate"

print_info "Запуск Python-скрипта для транскрибации..."
echo "----------------------------------------------------"

# Запускаем Python-скрипт и ПРОВЕРЯЕМ его код завершения
if python3 "$PROJECT_DIR/$SCRIPT_NAME" "$AUDIO_FILE"; then
    # Этот блок выполняется, если Python-скрипт завершился с кодом 0 (успех)
    EXIT_CODE=$?
    echo "----------------------------------------------------"
    print_success "Процесс транскрибации завершен."
else
    # Этот блок выполняется, если Python-скрипт завершился с ненулевым кодом (ошибка)
    EXIT_CODE=$?
    echo "----------------------------------------------------"
    print_error "Python-скрипт завершился с ошибкой (код: $EXIT_CODE)."
    print_error "Проверьте сообщения об ошибках выше. Транскрибация не удалась."
fi

print_info "Деактивация виртуального окружения."
deactivate

# Завершаем скрипт-обертку с тем же кодом, что и основной скрипт
exit $EXIT_CODE
