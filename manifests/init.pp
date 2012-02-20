# Sets or disables the slugbuilder user, operation.
#
# Parameters
#
#  [*ensure*] - Creates or destroys slugbuilder (present|absent)
#  [*home*]   - The home of slugbuilder. Default /var/slugbuilder
#  *gitcentral* - Domain from which slugbuilder will pull sources.
#  *githosts* - The hosts from which git sources will be pulled. Comma separated.
#  [*user*]   - The username of the slugbuilder. Default 'slugbuilder'
#  [*mquser*] - Set the RabbitMQ user that slugbuild will use.
#   *mqpass*  - Set the RabbitMQ user's password.
#  [*mqhost*] - Set the RabbitMQ host to communicate with. Default 'mq0'.
#  [*mqcert*] - Set the RabbitMQ certified client certificate. Default '/etc/rabbitmq/ssl/client/cert.pem
#  [*mqkey*]  - Set the RabbitMQ client private key. Default '/etc/rabbitmq/ssl/client/key.pem
#  [*mqport*] - Set the RabbitMQ port to communicate over. Default 5671.
#
class slugbuild(
  $ensure=present,
  $user='slugbuilder',
  $home="/var/$user",
  $gitcentral,
  $gituser='git',
  $githosts,
  $mquser='git',
  $mqpass,
  $mqhost='mq0',
  $mqcert='/etc/rabbitmq/ssl/client/cert.pem',
  $mqkey='/etc/rabbitmq/ssl/client/key.pem',
  $mqport='5671',
)
{
  # The home directory of slugbuilder and its user. Slugbuilder will work
  # nowhere outside of its home directory, though no steps are taken to chroot
  # it in. Other users--save root--have no ability to peek around inside.
  file { $home:
    ensure => directory,
    mode => 0700,
  }
  user { $user:
    ensure => present,
    home => $home,
    managehome => true,
  }

  # Create an ssh key for slugbuilder. This key will need to be manually
  # assigned R priveleges in the gitolite-admin for all projects requiring
  # slugbuilder's services.
  ssh::resource::key { 'id_rsa':
    root => "$home/.ssh",
    ensure => present,
    user => $user,
  }
  # Have to add known_hosts if slugbuilder's going to work without the
  # intervention of others.
  ssh::resource::known_hosts { $user:
    root => "$home/.ssh",
    hosts => $githosts,
    user => $user,
  }
  # To make git happy, configure slugbuilder's name and email address.
  git::resource::config { $user:
    root => $home,
    user => $user,
  }

  # The builder script is droped into $home/bin and will be called by traut for
  # posthook notifications.
  file { "$home/bin":
    ensure => directory,
    mode => 0700,
  }
  file { "$home/bin/builder":
    ensure => $ensure,
    mode => 0755,
    content => template('slugbuild/builder.erb'),
  }

  File {
    owner => $user,
    group => $user,
  }
}

# Ensures that all preliminary matters relating to pulling slubs from the
# builder central are satisifed.
class slugbuild::slugclient(
  $ensure=present,
  $mquser='git',
  $mqpass,
  $mqhost='mq0',
  $mqcert='/etc/rabbitmq/ssl/client/cert.pem',
  $mqkey='/etc/rabbitmq/ssl/client/key.pem',
  $mqport='5671',
  $slughome='/var/slugbuilder',
  $sluguser='slugbuilder',
  $sluggroup=$sluguser,
  $slughost,
)
{
  file { '/var/lib/slugs':
    ensure => $ensure ? { present => directory, default => absent, },
  }
  file { '/usr/bin/slugsync':
    ensure => $ensure ? { present => file, default => absent, },
    content => template('slugbuild/slugsync.erb'),
    mode => 0755,
  }
}
