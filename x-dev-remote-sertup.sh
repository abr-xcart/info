#!/bin/bash

# Функция для создания временного файла
create_temp_file() {
    if command -v mktemp >/dev/null 2>&1; then
        # Используем mktemp, если он доступен
        mktemp
    else
        # Альтернатива для систем, где mktemp отсутствует
        temp_dir="${TMPDIR:-/tmp}"
        temp_file="${temp_dir}/tempfile.$$.$(date +%s)"
        touch "$temp_file"
        echo "$temp_file"
    fi
}

# Создаем временный файл
temp_file=$(create_temp_file)

# Устанавливаем ловушку для автоматического удаления временного файла при завершении скрипта
trap 'rm -f "$temp_file"' EXIT

# Скачиваем удаленный файл во временный файл
if ! wget -O "$temp_file" https://info.x-dev.us/x-dev-remote-sertup/bash_aliases; then
    echo "Ошибка: не удалось скачать файл." >&2
    exit 1
fi

# Проверяем, существует ли оригинальный файл
if [ -e ~/.bash_aliases ]; then
    # Сравниваем содержимое файлов
    if ! cmp -s ~/.bash_aliases "$temp_file"; then
        # Если файлы различаются, открываем vimdiff
        vimdiff ~/.bash_aliases "$temp_file"
    else
        # Если файлы идентичны, выводим сообщение и завершаем скрипт
        echo "Файлы идентичны. Временный файл будет удален."
        exit 0
    fi
else
    # Если оригинальный файл не существует, перемещаем временный файл на его место
    mv "$temp_file" ~/.bash_aliases
    echo "Файл ~/.bash_aliases создан."
fi
