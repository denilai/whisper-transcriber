import whisper
import time
import sys

# --- Настройки ---
# Модели: tiny, base, small, medium, large.
# 'tiny' - самая быстрая, 'medium' - хороший баланс для русского языка.
MODEL_SIZE = "medium"

def transcribe_audio(audio_file_path):
    """
    Функция для транскрибации аудиофайла с использованием Whisper.
    """
    output_file_path = audio_file_path + ".txt"

    try:
        print(f"Загрузка модели Whisper '{MODEL_SIZE}'...")
        # Модель будет скачана автоматически при первом запуске
        model = whisper.load_model(MODEL_SIZE)
        print("Модель успешно загружена.")

        print(f"Начинается транскрибация файла: {audio_file_path}")
        start_time = time.time()

        # Указание языка 'ru' может улучшить точность для русского языка
        result = model.transcribe(audio_file_path, language="ru", fp16=False)

        end_time = time.time()
        processing_time = end_time - start_time
        print(f"Транскрибация завершена за {processing_time:.2f} секунд.")

        # Сохранение результата в файл
        with open(output_file_path, "w", encoding="utf-8") as f:
            f.write(result["text"])
        print(f"Расшифровка сохранена в файл: {output_file_path}")

    except FileNotFoundError:
        print(f"Ошибка: Файл не найден по пути '{audio_file_path}'")
    except Exception as e:
        print(f"Произошла ошибка: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        # Если путь к файлу передан как аргумент командной строки
        file_to_process = sys.argv[1]
        transcribe_audio(file_to_process)
    else:
        # Если аргумент не передан, используется файл по умолчанию
        print("Путь к аудиофайлу не указан. Используется тестовый файл 'sample_audio.mp3'.")
        print("Для обработки своего файла, запустите: python transcribe.py /путь/к/вашему/файлу.mp3\n")
        transcribe_audio("sample_audio.mp3")

