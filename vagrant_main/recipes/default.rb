#
# Cookbook Name:: vagrant_main
# Recipe:: default
#
# Author:: Gabriel Evans <gabriel@codeconcoction.com>
#
# Copyright 2012, Gabriel Evans
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_recipe "apt"
require_recipe "nginx::ppa"
require_recipe "mysql::server"

# Configure PHP5 PPA
# We'll install PHP 5.4 from Ondřej Surý's backports
apt_repository "ondrej-php5" do
  uri "http://ppa.launchpad.net/ondrej/php5/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E5267A6C"
  action :add
end

include_recipe "php"

# Required packages for PHP development
%w(php5-dev php5-cli php5-curl php5-gd php5-mcrypt php5-mysql php5-tidy libyaml-dev).each do |pkg|
  package pkg do
    action :install
  end
end

# YAML parser
php_pear "yaml" do
  action :install
end

include_recipe "php-fpm"
include_recipe "xdebug::fpm"

cookbook_file "/etc/php5/cgi/php.ini" do
  source "php.ini"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/php5/fpm/php.ini" do
  source "php.ini"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/php5/cli/php.ini" do
  source "php.ini"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/php5/fpm/pool.d/www.conf" do
  source "pool.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "php5-fpm"), :immediately
end

cookbook_file "/etc/php5/fpm/php.ini" do
  source "php.ini"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "php5-fpm"), :immediately
end

template "#{node[:nginx][:dir]}/sites-available/application" do
  source "nginx_site.erb"
  owner "root"
  group "root"
  mode  0644
end

nginx_site "default" do
  enable false
end

nginx_site "000-default" do
  enable false
end

nginx_site "application" do
  enable true
end

bluepill_service :nginx do
  action :restart
end