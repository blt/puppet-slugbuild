define slugbuild::resource::traut(
  $ensure=present,
  $project=$title,
  $branch='master',
  $slughome='/var/slugbuilder',
  $sluguser='slugbuilder',
  $sluggroup=$sluguser,
)
{
  traut::resource::event { $title:
    ensure => $ensure,
    route => "git.${project}.${branch}",
    command => "$slughome/bin/builder",
    user => $sluguser,
    group => $sluggroup,
  }
}
