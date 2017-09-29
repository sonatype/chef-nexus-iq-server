#
# Cookbook:: nexus_iq_server
#
# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.
#

# Inspec test for recipe nexus_iq_server::systemd

describe service 'nexus_iq_server' do
  it { should be_enabled }
  it { should be_running }
end
