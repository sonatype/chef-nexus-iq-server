## Cookbook for Nexus IQ Server

#### Usage

Simply include the `nexus_iq_server` recipe wherever you would like Nexus IQ Server installed. Simply add
`recipe['nexus_iq_server']` to your runlist or `include_recipe 'nexus_iq_server'` to your cookbook. This will
install Nexus IQ Server managed as a systemd service.

We also provide a `nexus_iq_server::docker` recipe which is exactly the same but without installing a systemd service.

#### Recipes

 - nexus_iq_server::default
   Installs Nexus IQ Server and starts it as systemd service.
 - nexus_iq_server::docker
   Installs Nexus IQ Server. Instead of a systemd service a startup script `start_nexus_iq_server.sh` is provided in install_dir.
 - nexus_iq_server::rh-docker
   Uses the nexus_iq_server:docker recipe but includes additional metadata to conform with Kubernetes
   and OpenShift standards, a directory with the licenses applicable to the software and a man
   file for help on how to use the software. It also uses an ENTRYPOINT script to ensure the running
   user has access to the appropriate permissions for OpenShift 'restricted' SCC.
   
#### Red Hat help.1

The man file included in the Red Hat image is generated from this [help markdown](files/rh-docker/help.md). Markdown
can be converted to the appropriate format using [md2roff](https://github.com/nereusx/md2roff). This process is
currently not part of the automated build and needs to be done manually after any update to the help markdown.

#### Testing

We provide a simple smoke test for this cookbook. Use this command to run it:

    kitchen test
    
#### Supported platforms

We run our tests against `centos-7.3` as well as `ubuntu-16.04`. However all major systemd based distributions should
work fine.

The alternative `nexus_iq_server::docker` recipe does not require systemd.
