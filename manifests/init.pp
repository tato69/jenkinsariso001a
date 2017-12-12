class jenkinsariso001a {
  case $::osfamily {
    'RedHat': { include jenkinsariso001a::rhel }
    'Debian': { include jenkinsariso001a::debian }
  }
}
