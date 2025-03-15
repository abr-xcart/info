#!/bin/bash

# Скачиваем удаленный файл во временный файл
wget -O ~/.bash_aliases.x-dev https://info.x-dev.us/x-dev-remote-sertup/bash_aliases

# Проверяем, существует ли оригинальный файл
if [ -e ~/.bash_aliases ]; then
    # Сравниваем содержимое файлов
    if ! cmp -s ~/.bash_aliases ~/.bash_aliases.x-dev; then
        # Если файлы различаются, открываем vimdiff
        vimdiff ~/.bash_aliases ~/.bash_aliases.x-dev
    else
        # Если файлы идентичны, удаляем временный файл
        rm ~/.bash_aliases.x-dev
        echo "Файлы идентичны. Временный файл удален."
        exit 0
    fi
else
    # Если оригинальный файл не существует, просто перемещаем временный файл
    mv ~/.bash_aliases.x-dev ~/.bash_aliases
    echo "Файл ~/.bash_aliases создан."
fi
