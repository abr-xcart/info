#!/bin/bash

# Функция для вывода ошибки и завершения скрипта
_exit_err() {
  local CODE=$1
  local MESSAGE=$2
  if [ -n "$MESSAGE" ]; then
    echo "ERROR $CODE: $MESSAGE" >&2
  fi
  exit "$CODE"
}

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

# Скачиваем удаленный файл с помощью curl
if ! curl -sSL --fail --show-error -o "$temp_file" "https://info.x-dev.us/x-dev-remote-setup/bash_aliases"; then
    _exit_err 1 "Не удалось скачать файл."
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
        _exit_err 0 ""
    fi
else
    # Если оригинальный файл не существует, перемещаем временный файл на его место
    mv "$temp_file" ~/.bash_aliases
    echo "Файл ~/.bash_aliases создан."
fi
