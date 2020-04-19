# == Type: dockerapp_spiped 
#
# @summary This type installs a spiped instance
#
# @example
#   dockerapp_spiped { 'to_sql': 
#     version = '1.5',
#   }
#
# @parameters
#
# [*version*]
#   Docker hub version of the image to be installed. Check spiped at docker hub to see the avaliable options
#
# [*port_in*]
#   Input port to use
#
# [*port_out*]
#   Output port to use
#
# [*ip_out*]
#   Destination IP
#
# [*net*]
#   Network to use
#
# [*link*]
#   Other containers to link
#
# [*key*]
#   Spiped security key
#
# [*Type*]
#   in or out
#
define dockerapp_spiped(
  $version = '1.5',
  $port_in = undef,
  $port_out = undef,
  $ip_out = undef,
  $link = undef,
  $net = undef,
  $key = undef,
  $type = 'in'
) {

  Exec {
    path => ['/usr/bin', '/bin', '/sbin', '/usr/local/bin', '/usr/sbin', '/usr/lib/jvm/jre-8u60/bin'],
  }

  if !defined(Class['dockerapp']) {class{'::dockerapp':}}
  if !defined(Class['stdlib']) {class{'::stdlib':}}

  if $link != undef and $ip_out != undef {
    fail ('You mus define link or ip_out')
  }

  $service_name = $title

  $base_app_config = $::dockerapp::params::config_dir

  $conf_configdir = "${base_app_config}/${service_name}"

  $sp_image_name = "spiped:${version}"

  $sp_key = $key

  if $type != 'in' and $type != 'out' {
    fail ('The parameter must be in or out')
  }

  if $key == undef or $key == nil {
    fail ('You must set a key!')
  }

  $req = [Exec["Restore - Spiped Key ${service_name}"], File[$conf_configdir]]

  $links = [$link]

  if !defined(File[$base_app_config]) {
    file{ $base_app_config:
      ensure => directory,
    }
  }
  if !defined(File[$conf_configdir]) {
    file{ $conf_configdir:
      ensure  => directory,
      require => File[$base_app_config],
    }
  }

  $sp_volumes = [
    "${conf_configdir}:/spiped/key:ro",
  ]

  $sp_ports = ["${port_in}:${port_out}"]

  if !defined(Exec["Restore - Spiped Key ${service_name}"]){
    exec {"Restore - Spiped Key ${service_name}":
      command => "echo \"${sp_key}\" | base64 -d > ${conf_configdir}/spiped-keyfile",
      creates => "${conf_configdir}/spiped-keyfile",
      require => File[$conf_configdir],
    }
  }

  if $type == 'out' {
    dockerapp::run { $service_name:
      image           => $sp_image_name,
      command         => "spiped -e -s \'[0.0.0.0]:${port_in}\' -t \'${ip_out}:${port_out}\' -k /spiped/key/spiped-keyfile -F",
      hostname        => $::fqdn,
      restart_service => true,
      #ports           => $sp_ports,
      volumes         => $sp_volumes,
      net             => $net,
      require         => $req,
    }
  }else{
    dockerapp::run { $service_name:
      image           => $sp_image_name,
      command         => "spiped -d -s \'[0.0.0.0]:${port_in}\' -t \'${link}:${port_out}\' -k /spiped/key/spiped-keyfile -F",
      hostname        => $::fqdn,
      links           => $links,
      net             => $net,
      restart_service => true,
      ports           => $sp_ports,
      volumes         => $sp_volumes,
      require         => $req,
    }
  }

}
