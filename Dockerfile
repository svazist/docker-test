FROM phusion/baseimage

CMD ["/sbin/my_init"]

RUN add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
        php7.1-fpm \
        php7.1-cli \
        php7.1-mysql \
        php7.1-gd \
        php7.1-json \
        php7.1-mbstring \
        php7.1-opcache \
        php7.1-mcrypt \
        php7.1-curl \
        php7.1-dom \
        php7.1-xml \
        php7.1-xmlwriter \
        php-redis \
        php-xdebug \
        php7.1-zip \
        php-memcached  \
        git && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /run/php

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

RUN npm install -g webpack gulp
RUN apt-get update && \
    apt-get install -y iputils-ping nmap

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt && \
    git clone https://github.com/vishnubob/wait-for-it.git && \
    cd wait-for-it && \
    chmod +x wait-for-it.sh && \
    ln -s /opt/wait-for-it/wait-for-it.sh /usr/bin/wait-for-it.sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get -y install imagemagick && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /app

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.1", "-F", "-R", "--pid" , "/run/php/php-fpm.pid", "-c", "/etc/php/7.1/fpm/php-fpm.conf"]
