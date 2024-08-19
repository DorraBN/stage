# Utiliser une image PHP avec Apache comme base
FROM php:8.1-apache

# Installer les extensions PHP nécessaires
RUN docker-php-ext-install pdo pdo_mysql

# Installer Composer (gestionnaire de dépendances PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copier les fichiers du projet dans le répertoire de l'application
COPY . /var/www/html/

# Définir le répertoire de travail
WORKDIR /var/www/html

# Définir les permissions appropriées
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Installer les dépendances de Laravel
RUN composer install --no-dev --optimize-autoloader

# Exposer le port 80 pour accéder à l'application
EXPOSE 80

# Commande par défaut pour démarrer Apache
CMD ["apache2-foreground"]
