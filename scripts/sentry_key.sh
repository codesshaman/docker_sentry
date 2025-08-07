#!/bin/bash

KEY=$(docker run --rm sentry:latest generate-secret-key)

echo SENTRY_SECRET_KEY=${KEY} >> .env

