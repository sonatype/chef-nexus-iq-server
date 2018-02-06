#
# Cookbook:: nexus_iq_server
# Recipe:: configure
#
# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.

config_path = node['nexus_iq_server']['conf_dir'] + '/config.yml'
start_script = node['nexus_iq_server']['install_dir'] + '/start-nexus-iq-server.sh'

directory node['nexus_iq_server']['conf_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

directory node['nexus_iq_server']['logs_dir'] do
  owner 'nexus'
  group 'nexus'
  mode '0755'
  action :create
  recursive true
end

directory node['nexus_iq_server']['config']['sonatypeWork'] do
  owner 'nexus'
  group 'nexus'
  mode '0755'
  action :create
  recursive true
end

template config_path do
  source 'config.yml.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template start_script do
  source 'start-nexus-iq-server.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
