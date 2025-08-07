set -e

psql -v ON_ERROR_STOP=1 --username postgres --dbname postgres <<-EOSQL
    CREATE DATABASE sentry;
    GRANT ALL PRIVILEGES ON DATABASE sentry TO postgres;
EOSQL
