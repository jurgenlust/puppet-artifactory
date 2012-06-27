puppet-artifactory
==================

Puppet module for managing Artifactory on Debian and Ubuntu.

# Installation #

Clone this repository in /etc/puppet/modules, but make sure you clone it as directory
'artifactory':

	cd /etc/puppet/modules
	git clone https://github.com/jurgenlust/puppet-artifactory.git artifactory

You also need the puppet-tomcat module:

	cd /etc/puppet/modules
	git clone https://github.com/jurgenlust/puppet-tomcat.git tomcat
	
You should also make sure the unzip package is installed, as well as a JDK.

	
# Usage #

The manifest in the tests directory shows how you can install Artifactory.
For convenience, a Vagrantfile was also added, which starts a
Debian Squeeze x64 VM and applies the init.pp. When the virtual machine is ready,
you should be able to access artifactory at
[http://localhost:8680/artifactory](http://localhost:8680/artifactory).

Note that the vagrant VM will only be provisioned correctly if the artifactory
and tomcat modules are in the same parent directory.
	