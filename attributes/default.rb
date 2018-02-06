#
# Cookbook:: nexus_iq_server

# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.

default['java']['jdk_version'] = '8'
default['java']['install_flavor'] = 'oracle'
default['java']['oracle']['accept_oracle_download_terms'] = true

default['nexus_iq_server']['version'] = '1.43.0-01'
default['nexus_iq_server']['checksum'] = '91f0ad04ca0b3d99bc4384da11147abac75c6c0a9fa1201c2c44dd09731a62f0'
default['nexus_iq_server']['install_dir'] = '/opt/sonatype/nexus-iq-server'
default['nexus_iq_server']['logs_dir'] = '/var/log/nexus-iq-server'
default['nexus_iq_server']['conf_dir'] = '/etc/nexus-iq-server'
default['nexus_iq_server']['java_opts'] = ''
default['nexus_iq_server']['logging']['archived_file_count'] = 50
