#
# Cookbook Name:: vagrant_main
# Attributes:: default
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

default[:vagrant_main][:root]             = "/vagrant"
default[:vagrant_main][:docroot]          = "/vagrant/public"
default[:vagrant_main][:application_name] = "application"

# Bluepill options
set[:bluepill][:bin] = "/opt/ruby/bin/bluepill"

# MySQL options
set[:mysql][:server_root_password] = ""
set[:mysql][:allow_remote_root] = "true"

# Nginx options
set[:nginx][:install_method] = "ppa"
set[:nginx][:init_style]     = "bluepill"
set[:nginx][:user]           = "vagrant"

# Xdebug options
set[:xdebug][:version]                 = "2.2.0RC2"
set[:xdebug][:file_link_format]        = "txmt://open?url=file://%f&line=%l"
set[:xdebug][:cli_color]               = 1
set[:xdebug][:remote_autostart]        = 1
set[:xdebug][:remote_connect_back]     = 1
set[:xdebug][:remote_enable]           = 1
set[:xdebug][:profiler_enable_trigger] = 1
set[:xdebug][:profile_output_name]     = "cachegrind.out.%s"
set[:xdebug][:trace_enable_trigger]    = 1
set[:xdebug][:trace_output_name]       = "trace.out.%s"
