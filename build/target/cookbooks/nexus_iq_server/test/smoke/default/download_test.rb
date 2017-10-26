#
# Cookbook:: nexus_iq_server
#
# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.
#
# Inspec test for recipe nexus_iq_server::download

describe user('nexus') do
  it { should exist }
end

describe group('nexus') do
  it { should exist }
end
