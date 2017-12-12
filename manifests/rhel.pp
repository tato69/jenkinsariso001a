class jenkinsariso001a::rhel (
) {

$fw             = 'firewalld'

service { $fw:
    ensure   => 'stopped',
    enable  => false,
}

file { '/etc/yum.repos.d/jenkins.repo':
    ensure       => 'file',
    mode         => '0644',
    owner        => 'root',
    group        => 'root',
    content      => template('jenkinsariso001a/jenkins.repo.erb'),
}

package { "java-1.8.0-openjdk":
  ensure => present,
}

package { "git":
  ensure  => latest,
}

vcsrepo { '/var/lib/jenkins':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/tato69/jenkins_home',
}

package { "jenkins":
  ensure  => latest,
  require  => Vcsrepo['/var/lib/jenkins']
}

file { '/var/lib/jenkins':
    ensure       => 'directory',
    mode         => '0744',
    owner        => 'jenkins',
    group        => 'jenkins',
    notify       => Service['jenkins'],
    require      => Package['jenkins'],
}

service { 'jenkins':
    ensure   => 'running',
	enable  => true,
	require  => Package['java-1.8.0-openjdk'],
	require   => Package['jenkins'],
}

#close class
}
