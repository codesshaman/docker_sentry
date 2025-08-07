#!/bin/bash

# Получаем имя образа из .env
SENTRY_IMAGE=$(grep "^SENTRY_IMAGE=" .env | cut -d '=' -f2)

# Генерация ключа
KEY=$(docker run --rm "$SENTRY_IMAGE" sentry generate-secret-key 2>/dev/null)

# Проверка, что ключ получен
if [[ -n "$KEY" ]]; then
    echo "✅ Секретный ключ: $KEY"
    # Удалим старую строку (если есть)
    sed -i '/^SENTRY_SECRET_KEY=/d' .env
    # Запишем новую строку
    echo "SENTRY_SECRET_KEY=$KEY" >> .env
    echo "✅ Ключ записан в .env"
else
    echo "❌ Ошибка: ключ не получен. Возможно, образ не содержит CLI-команду."
    echo "Попробуй вручную:"
    echo "docker run --rm $SENTRY_IMAGE sentry generate-secret-key"
    exit 1
fi
