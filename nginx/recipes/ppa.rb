#
# Cookbook Name:: nginx
# Recipe:: default
# Author:: Gabriel Evans <gabe@counterless.com>
#
# Copyright 2012, Opscode, Inc.
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

include_recipe "nginx::ohai_plugin"

apt_repository "nginx-stable" do
  uri "http://ppa.launchpad.net/nginx/stable/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C300EE8C"
  action :add
end

package "nginx"

case node[:nginx][:init_style]
when "runit"
  node.set[:nginx][:src_binary] = node[:nginx][:binary]
  include_recipe "runit"

  runit_service "nginx"

  service "nginx" do
    supports :status => true, :restart => true, :reload => true
    reload_command "[[ -f #{node[:nginx][:pid]} ]] && kill -HUP `cat #{node[:nginx][:pid]}` || true"
  end
when "bluepill"
  include_recipe "bluepill"

  template "#{node['bluepill']['conf_dir']}/nginx.pill" do
    source "nginx.pill.erb"
    mode 0644
    variables(
      :working_dir => nil,
      :src_binary => node[:nginx][:binary],
      :nginx_dir => node[:nginx][:dir],
      :log_dir => node[:nginx][:log_dir],
      :pid => node[:nginx][:pid]
    )
  end

  bluepill_service "nginx" do
    action [ :enable, :load ]
  end

  service "nginx" do
    supports :status => true, :restart => true, :reload => true
    reload_command "[[ -f #{node[:nginx][:pid]} ]] && kill -HUP `cat #{node[:nginx][:pid]}` || true"
    action :nothing
  end
else
  node.set[:nginx][:daemon_disable] = false

  template "/etc/init.d/nginx" do
    source "nginx.init.erb"
    owner "root"
    group "root"
    mode "0755"
    variables(
      :working_dir => nil,
      :src_binary => node[:nginx][:binary],
      :nginx_dir => node[:nginx][:dir],
      :log_dir => node[:nginx][:log_dir],
      :pid => node[:nginx][:pid]
    )
  end

  template "/etc/sysconfig/nginx" do
    source "nginx.sysconfig.erb"
    owner "root"
    group "root"
    mode "0644"
  end

  service "nginx" do
    supports :status => true, :restart => true, :reload => true
    action :enable
  end
end

include_recipe "nginx::commons"
