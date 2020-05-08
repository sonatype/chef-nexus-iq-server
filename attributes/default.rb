#
# Cookbook:: nexus_iq_server

# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.

default['java']['jdk_version'] = '8'
default['java']['install_flavor'] = 'openjdk'
default['java']['accept_license_agreement'] = true

default['nexus_iq_server']['version'] = '1.91.0-01'
default['nexus_iq_server']['checksum'] = 'eda616cddaf78513dc6a869acb188a07897734bbfbb3bfad7f57b1314ade760e'
default['nexus_iq_server']['install_dir'] = '/opt/sonatype/nexus-iq-server'
default['nexus_iq_server']['logs_dir'] = '/var/log/nexus-iq-server'
default['nexus_iq_server']['conf_dir'] = '/etc/nexus-iq-server'
default['nexus_iq_server']['java_opts'] = ''

#
# default['nexus_iq_server']['config'] is used to generate config.yml. Parameter names and hierarchy must be the same as they
# are in config.yml.
#
default['nexus_iq_server']['config']['sonatypeWork'] = node['nexus_iq_server']['install_dir'] + '/sonatype-work/'
default['nexus_iq_server']['config']['server']['applicationConnectors'] = [{'type' => 'http', 'port' => 8070}]
default['nexus_iq_server']['config']['server']['adminConnectors'] = [{'type' => 'http', 'port' => 8071}]
default['nexus_iq_server']['config']['server']['requestLog']['appenders'] = [
  {
    'type' => 'file',
    'currentLogFilename' => node['nexus_iq_server']['logs_dir'] + '/request.log',
    'archivedLogFilenamePattern' => node['nexus_iq_server']['logs_dir'] + "/request-\%d.log.gz",
    'archivedFileCount' => 50
  }
]
default['nexus_iq_server']['config']['logging']['level'] = 'DEBUG'
default['nexus_iq_server']['config']['logging']['loggers']['com.sonatype.insight.scan'] = 'INFO'
default['nexus_iq_server']['config']['logging']['loggers']['eu.medsea.mimeutil.MimeUtil2'] = 'INFO'
default['nexus_iq_server']['config']['logging']['loggers']['org.apache.http'] = 'INFO'
default['nexus_iq_server']['config']['logging']['loggers']['org.apache.http.wire'] = 'ERROR'
default['nexus_iq_server']['config']['logging']['loggers']['org.eclipse.birt.report.engine.layout.pdf.font.FontConfigReader'] = 'WARN'
default['nexus_iq_server']['config']['logging']['loggers']['org.eclipse.jetty'] = 'INFO'
# WARNING: BasicHttpAuthenticationFilter reveals credentials at DEBUG level
default['nexus_iq_server']['config']['logging']['loggers']['org.apache.shiro.web.filter.authc.BasicHttpAuthenticationFilter'] = 'INFO'
default['nexus_iq_server']['config']['logging']['appenders'] = [
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
    'archivedFileCount' => 50
  }
]
default['nexus_iq_server']['config']['createSampleData'] = true
