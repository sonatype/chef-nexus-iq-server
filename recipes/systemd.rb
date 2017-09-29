#
# Cookbook:: nexus_iq_server
# Recipe:: systemd
#
# Copyright:: Copyright (c) 2017-present Sonatype, Inc. Apache License, Version 2.0.

systemd_unit 'nexus_iq_server.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Nexus IQ Server service
  After=network.target
  [Service]
  Type=simple
  LimitNOFILE=65536
  WorkingDirectory=#{ node['nexus_iq_server']['install_dir'] }
  ExecStart=#{ node['nexus_iq_server']['install_dir'] }/start_nexus_iq_server.sh
  User=nexus
  Restart=on-abort
  [Install]
  WantedBy=multi-user.target
  EOU
  action [:create, :enable, :start]
end
