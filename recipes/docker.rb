#
# Cookbook:: nexus_iq_server
# Recipe:: default
#
# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.

node.default['nexus_iq_server']['config']['server']['requestLog']['appenders'][0]['archivedFileCount'] = 5
node.default['nexus_iq_server']['config']['logging']['appenders'][1]['archivedFileCount'] = 5

include_recipe 'java'
include_recipe 'nexus_iq_server::download'
include_recipe 'nexus_iq_server::configure'
