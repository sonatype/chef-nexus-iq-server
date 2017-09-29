## Cookbook for Nexus IQ Server

#### Usage

Simply include the `nexus-iq-server` recipe wherever you would like Nexus IQ Server installed. Simply add
`recipe['nexus-iq-server']` to your runlist or `include_recipe 'nexus-iq-server'` to your cookbook. This will
install Nexus IQ Server managed as a systemd service.

We also provide a `nexus-iq-server::docker` recipe which is exactly the same but without installing a systemd service.

#### Recipes

 - nexus-iq-server::default
   Installs Nexus IQ Server and starts it as systemd service.
 - nexus-iq-server::docker
   Installs Nexus IQ Server. Instead of a systemd service a startup script `start-nexus-iq-server.sh` is provided in install_dir.
   
#### Testing

We provide a simple smoke test for this cookbook. Use this command to run it:

    kitchen test
    
#### Supported platforms

We run our tests against `centos-7.3` as well as `ubuntu-16.04`. However all major systemd based distributions should
work fine.

The alternative `nexus-iq-server::docker` recipe does not require systemd.