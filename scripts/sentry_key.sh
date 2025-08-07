#!/bin/bash

# Генерация случайного 32-символьного хэша из a-zA-Z0-9
HASH=$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 32)

echo "SENTRY_SECRET_KEY=$HASH" >> .env
