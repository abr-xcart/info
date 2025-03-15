#!/bin/bash

# Создаем временный файл
temp_file=$(mktemp)

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
