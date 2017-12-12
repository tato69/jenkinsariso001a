class jenkinsariso001a::debian (
) {

exec { 'clone repository key':
  command  => "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add - ",
  path     => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin:/root/bin',
  provider => shell,
  onlyif   => 'test ! -f /etc/apt/sources.list.d/jenkins.list',
}

file { '/etc/apt/sources.list.d/jenkins.list':
      ensure       => 'file',
      mode         => '0750',
      owner        => 'root',
      group        => 'root',
      content      => template('jenkinsariso001a/jenkins.list.erb'),
}

exec { "apt-get update":
  command => "/usr/bin/apt-get update && touch /tmp/apt.update",
  #onlyif => "/bin/sh -c '[ ! -f /tmp/apt.update ] || /usr/bin/find /etc/apt -cnewer /tmp/apt.update | /bin/grep . > /dev/null'",
  subscribe => File['/etc/apt/sources.list.d/jenkins.list'],
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
        require   => Package['jenkins'],
}

#close class
}
