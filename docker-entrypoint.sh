#!/bin/bash
set -e

cd /var/www/html

# Défini les bonne permision sur le dossier stockage.
chown -R www-data:www-data /var/www/html/storage
chmod -R 755 /var/www/html/storage

# Attente de la base de données
until nc -z -v -w30 "$DB_HOST" "$DB_PORT"; do
  echo "Waiting for database connection at $DB_HOST:$DB_PORT..."
  sleep 5
done

# Installation uniquement via le PHP1
if [ "$SERVER_ID" = "1" ]; then

  # Génération du fichier .env à partir de .env.example si manquant
  if [ ! -f ".env" ]; then
      cp .env.example .env
      echo "Copie de .env.example en .env"

      # Configuration DB
      sed "s/^DB_HOST=.*/DB_HOST=$DB_HOST/" .env
      sed "s/^DB_PORT=.*/DB_PORT=$DB_PORT/" .env
      sed "s/^DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/" .env
      sed "s/^DB_USERNAME=.*/DB_USERNAME=$DB_USERNAME/" .env
      sed "s/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" .env

      # Configuration MAIL
      sed "s/^MAIL_HOST=.*/MAIL_HOST=$MAIL_HOST/" .env
      sed "s/^MAIL_PORT=.*/MAIL_PORT=$MAIL_PORT/" .env

      # Configuration APP_URL
      sed "s|^APP_URL=.*|APP_URL=$APP_URL|" .env

      echo "SERVER_ID=$SERVER_ID" >> .env
  fi

  # Installation des dépendances
  composer install --no-interaction --prefer-dist --optimize-autoloader
  npm install && npm run build

  # Laravel init
  php artisan key:generate --force
  php artisan config:clear
  php artisan cache:clear
  php artisan view:clear
  php artisan route:clear
  php artisan storage:link
  php artisan migrate:fresh --seed --force
fi

exec "$@"
