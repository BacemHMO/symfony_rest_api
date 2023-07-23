# Use the official PHP image
FROM php:8.1-fpm

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Remove the default Nginx configuration
RUN rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Copy your Nginx configuration
COPY default.conf /etc/nginx/conf.d/

# Set the working directory
WORKDIR /var/www/html

# Install PHP extensions and other required packages
RUN apt-get install -y libicu-dev git unzip && docker-php-ext-install intl pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the Symfony project files
COPY . .

# Install Symfony dependencies
RUN composer install --no-scripts --no-autoloader

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM and Nginx
CMD service nginx start && php-fpm