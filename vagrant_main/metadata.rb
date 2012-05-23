maintainer        "Gabriel Evans"
maintainer_email  "gabriel@codeconcoction.com"
license           "Apache 2.0"
description       "Provisions Vagrant boxes with tools and services needed to run Kohana applications"
version           "0.1.0"

depends "apt"
depends "nginx"
depends "php"
depends "php-fpm"
depends "xdebug"
depends "phpmyadmin"

%w{ ubuntu }.each do |os|
  supports os
end

recipe "vagrant_main", "Installs software and services needed to run Kohana applications."
recipe "vagrant_main::phpmyadmin", "Installs and configure phpMyAdmin and adds a vhost to Nginx."