define slugbuild::resource::authorized_key(
  $ensure=present,
  $key,
  $slughome='/var/slugbuilder',
  $sluguser='slugbuilder',
  $sluggroup=$sluguser,
)
{
  ssh_authorized_key { "slugbuild for $title":
    ensure => $ensure,
    key    => $key,
    type   => 'rsa',
    target => "$slughome/.ssh/authorized_keys",
    user   => $sluguser,
  }
}
