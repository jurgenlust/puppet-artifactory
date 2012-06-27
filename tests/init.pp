include tomcat

package { "unzip":
	ensure => present,
}

package { "openjdk-6-jdk":
	ensure => present,
}

class { "artifactory": 
	user => "artifactory", #the system user that will own the Artifactory Tomcat instance
	number => 6, # the Tomcat http port will be 8680
	version => "2.6.1", # the Artifactory version
	contextroot => "/",
	webapp_base => "/opt", # Artifactory will be installed in /opt/artifactory
	require => [
		Package["unzip"],
		Package["tomcat6"],
		Package["openjdk-6-jdk"]
	]
}
