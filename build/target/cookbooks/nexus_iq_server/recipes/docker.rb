#
# Cookbook:: nexus_iq_server
# Recipe:: default
#
# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.

include_recipe 'java'
include_recipe 'nexus_iq_server::download'
include_recipe 'nexus_iq_server::configure'
