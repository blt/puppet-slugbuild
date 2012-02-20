#  [*mquser*] - Set the RabbitMQ user that slugbuild will use.
#   *mqpass*  - Set the RabbitMQ user's password.
#  [*mqhost*] - Set the RabbitMQ host to communicate with. Default 'mq0'.
#  [*mqcert*] - Set the RabbitMQ certified client certificate. Default '/etc/rabbitmq/ssl/client/cert.pem
#  [*mqkey*]  - Set the RabbitMQ client private key. Default '/etc/rabbitmq/ssl/client/key.pem
#  [*mqport*] - Set the RabbitMQ port to communicate over. Default 5671.
define slugbuild::resource::sync(
  $ensure=present,
  $project=$title,
  $branch='master',
)
{
  traut::resource::event { $title:
    ensure => $ensure,
    route => "git.${project}.${branch}.build",
    command => "/usr/bin/slugsync",
  }
}
