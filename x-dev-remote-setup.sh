#!/bin/bash

# Глобальная переменная для базового URL
X_DEV_URL="https://info.x-dev.us/x-dev-remote-setup"

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

# Функция для преобразования remote_script_name в local_script_name
get_local_script_name() {
    local remote_script_name=$1
    # Заменяем "dot_" на "." только если оно находится в начале строки
    if [[ "$remote_script_name" == dot_* ]]; then
        echo "${remote_script_name/dot_/.}"
    else
        echo "$remote_script_name"
    fi
}

# Функция для обработки удаленного файла
process_remote_file() {
    local temp_file=$1
    local remote_script_name=$2  # Второй параметр — имя удаленного файла

    # Вычисляем local_script_name
    local local_script_name
    local_script_name=$(get_local_script_name "$remote_script_name")

    # Формируем полный URL для скачивания
    local FULL_URL="${X_DEV_URL}/${remote_script_name}"

    # Скачиваем удаленный файл с помощью curl
    if ! curl -sSL --fail --show-error -o "$temp_file" "$FULL_URL"; then
        _exit_err 1 "Не удалось скачать файл."
    fi

    # Проверяем, существует ли оригинальный файл
    if [ -e ~/"$local_script_name" ]; then
        # Сравниваем содержимое файлов
        if ! cmp -s ~/"$local_script_name" "$temp_file"; then
            # Если файлы различаются, открываем vimdiff в интерактивном режиме
            export TERM=xterm-256color
            #vimdiff ~/"$local_script_name" "$temp_file" < /dev/tty > /dev/tty
            vimdiff ~/"$local_script_name" "$temp_file"
        else
            # Если файлы идентичны, выводим сообщение
            echo "Файлы идентичны. Временный файл будет удален."
        fi
    else
        # Если оригинальный файл не существует, перемещаем временный файл на его место
        mv "$temp_file" ~/"$local_script_name"
        echo "Файл ~/$local_script_name создан."
    fi
}

# Список удаленных файлов
REMOTE_SCRIPT_NAMES=("dot_vimrc" "dot_bash_aliases")

# Создаем один временный файл для всех элементов списка
temp_file=$(create_temp_file)

# Устанавливаем ловушку для автоматического удаления временного файла при завершении скрипта
trap 'rm -f "$temp_file"' EXIT

# Обрабатываем каждый файл из списка
for remote_script_name in "${REMOTE_SCRIPT_NAMES[@]}"; do
    # Обрабатываем удаленный файл
    process_remote_file "$temp_file" "$remote_script_name"
done
