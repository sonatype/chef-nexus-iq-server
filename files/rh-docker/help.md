% NEXUS(1) Container Image Pages
% Sonatype
% February 2, 2020

# NAME
nexus-iq-server \- Nexus IQ Server container image

# DESCRIPTION
The nexus iq server image provides a containerized packaging of the Nexus IQ Server.
Nexus IQ Server  is a policy engine powered by precise intelligence on open source components. It provides a number of tools to improve component usage in your software supply chain, allowing you to automate your processes and achieve accelerated speed to delivery while also increasing product quality.

The nexus iq server image is designed to be run by the atomic command with one of these options:

`run`

Starts the installed container with selected privileges to the host.

`stop`

Stops the installed container

The container itself consists of:
    - Linux base image
    - Oracle Java JDK
    - Nexus IQ Server
    - Atomic help file

Files added to the container during docker build include: /help.1.

# USAGE
To use the nexus iq server container, you can run the atomic command with run, stop, or uninstall options:

To run the nexus iq server container:

  atomic run nexus-iq-server

To stop the nexus iq server container (after it is installed), run:

  atomic stop nexus-iq-server

# LABELS
The nexus iq server container includes the following LABEL settings:

That atomic command runs the docker command set in this label:

`RUN=`

  LABEL RUN='docker run -d -p 8071:8071 --name ${NAME} ${IMAGE}'

  The contents of the RUN label tells an `atomic run nexus-iq-server` command to open port 8071 & set the name of the container.

`STOP=`

  LABEL STOP='docker stop ${NAME}'

`Name=`

The registry location and name of the image. For example, Name="Nexus IQ Server".

`Version=`

The Nexus IQ Server version from which the container was built. For example, Version="1.84.0-01".

When the atomic command runs the nexus container, it reads the command line associated with the selected option
from a LABEL set within the Docker container itself. It then runs that command. The following sections detail
each option and associated LABEL:

# SECURITY IMPLICATIONS

`-d`

Runs continuously as a daemon process in the background
