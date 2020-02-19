#
# Cookbook:: nexus_iq_server
#
# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.
#

# Permissions test for recipe nexus_iq_server::rh-docker

control 'rh-docker-perms-test-001' do
  title 'Allows nexus user to mutate system password file'
  describe user('nexus') do
    it { should exist }
  end

  describe file('/etc/passwd') do
    it { should be_allowed('write', by_user: 'nexus') }
  end
end

control 'rh-docker-perms-test-002' do
 title 'Creates a template for passwd'
  describe file('/etc/passwd.template') do
    it { should exist }
  end
end
