# Class: artifactory
#
# This module manages artifactory
#
# Parameters:
#
# Actions:
#
# Requires:
#	Class['tomcat']
#   Tomcat::Webapp[$username]
#
#   See https://github.com/jurgenlust/puppet-tomcat
#
# Sample Usage:
#
class artifactory(
	$user = "artifactory",	
	$number = 6,
	$version = "2.6.1",
	$contextroot = "repo",
	$webapp_base = "/srv"
){
# configuration	
	$zip = "artifactory-${version}.zip"
	$war = "atlassian-bamboo-${version}.war"
	$download_url = "http://sourceforge.net/projects/artifactory/files/artifactory/${version}/${zip}/download"
	$artifactory_dir = "${webapp_base}/${user}"
	$artifactory_home = "${artifactory_dir}/artifactory-home"
	
	$webapp_context = $contextroot ? {
	  '/' => '',	
      '' => '',
      default  => "/${contextroot}"
    }
    
    $webapp_war = $contextroot ? {
    	'' => "ROOT.war",
    	'/' => "ROOT.war",
    	default => "${contextroot}.war"	
    }
    
	file { $artifactory_home:
		ensure => directory,
		mode => 0755,
		owner => $user,
		group => $user,
		require => Tomcat::Webapp::User[$user],
	}

	exec { "download-artifactory":
		command => "/usr/bin/wget -O /tmp/${zip} ${download_url}",
		require => Tomcat::Webapp::Tomcat[$user],
		creates => "/tmp/${zip}",
		timeout => 1200,	
	}
	
	file { "/tmp/${zip}":
		ensure => file,
		require => Exec["download-artifactory"],
	}
	
	exec { "extract-artifactory" :
		command => "/usr/bin/unzip ${zip}",
		creates => "/tmp/artifactory-${version}/webapps/artifactory.war",
		require => File["/tmp/${zip}"],
		cwd => "/tmp",
		user => "root" 	
	}
	
	exec { "move-artifactory-war":
		command => "/bin/mv /tmp/artifactory-${version}/webapps/artifactory.war ${artifactory_dir}/tomcat/webapps/${webapp_war}",
		creates => "${artifactory_dir}/tomcat/webapps/${webapp_war}",
		user => "root",
		require => Exec["extract-artifactory"],
	}

# the Artifactory war file
	file { 'artifactory-war':
		path => "${artifactory_dir}/tomcat/webapps/${webapp_war}", 
		ensure => file,
		owner => $user,
		group => $user,
		require => Exec["move-artifactory-war"],
	}

	tomcat::webapp { $user:
		username => $user,
		webapp_base => $webapp_base,
		number => $number,
		java_opts => "-server -Xms128m -Xmx512m -XX:MaxPermSize=256m -Djava.awt.headless=true -Dartifactory.home=${artifactory_home}",
		description => "Artifactory",
		service_require => [File['artifactory-war'], File[$artifactory_home]],
		require => Class["tomcat"],
	}
}
