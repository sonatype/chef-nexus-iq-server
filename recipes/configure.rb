#
# Cookbook:: nexus_iq_server
# Recipe:: configure
#
# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.

#
# default['nexus_iq_server']['config'] is used to generate config.yml. Parameter names and hierarchy must be the same as they
# are in config.yml.
#
node.default['nexus_iq_server']['config']['sonatypeWork'] = node['nexus_iq_server']['install_dir'] + '/sonatype-work/'
node.default['nexus_iq_server']['config']['server']['applicationConnectors'] = [{'type' => 'http', 'port' => 8070}]
node.default['nexus_iq_server']['config']['server']['adminConnectors'] = [{'type' => 'http', 'port' => 8071}]
node.default['nexus_iq_server']['config']['server']['requestLog']['appenders'] = [
  {
    'type' => 'file',
    'currentLogFilename' => node['nexus_iq_server']['logs_dir'] + '/request.log',
    'archivedLogFilenamePattern' => node['nexus_iq_server']['logs_dir'] + "/request-\%d.log.gz",
    'archivedFileCount' => node['nexus_iq_server']['logging']['archived_file_count']
  }
]
node.default['nexus_iq_server']['config']['logging']['level'] = 'DEBUG'
node.default['nexus_iq_server']['config']['logging']['loggers']['com.sonatype.insight.scan'] = 'INFO'
node.default['nexus_iq_server']['config']['logging']['loggers']['eu.medsea.mimeutil.MimeUtil2'] = 'INFO'
node.default['nexus_iq_server']['config']['logging']['loggers']['org.apache.http'] = 'INFO'
node.default['nexus_iq_server']['config']['logging']['loggers']['org.apache.http.wire'] = 'ERROR'
node.default['nexus_iq_server']['config']['logging']['loggers']['org.eclipse.birt.report.engine.layout.pdf.font.FontConfigReader'] = 'WARN'
node.default['nexus_iq_server']['config']['logging']['loggers']['org.eclipse.jetty'] = 'INFO'
# WARNING: BasicHttpAuthenticationFilter reveals credentials at DEBUG level
node.default['nexus_iq_server']['config']['logging']['loggers']['org.apache.shiro.web.filter.authc.BasicHttpAuthenticationFilter'] = 'INFO'
node.default['nexus_iq_server']['config']['logging']['appenders'] = [
  {
    'type' => 'console',
    'threshold' => 'INFO',
    'logFormat' => "%d{'yyyy-MM-dd HH:mm:ss,SSSZ'} %level [%thread] %X{username} %logger - %msg%n"
  },
  {
    'type' => 'file',
    'threshold' => 'ALL',
    'currentLogFilename' => "/var/log/nexus-iq-server/clm-server.log",
    'archivedLogFilenamePattern' => "/var/log/nexus-iq-server/clm-server-%d.log.gz",
    'logFormat' => "%d{'yyyy-MM-dd HH:mm:ss,SSSZ'} %level [%thread] %X{username} %logger - %msg%n",
    'archivedFileCount' => node['nexus_iq_server']['logging']['archived_file_count']
  }
]

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

node.override['nexus_iq_server']['logging']['archived_file_count'] = 5

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
