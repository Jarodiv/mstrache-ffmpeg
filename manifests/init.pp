class ffmpeg (
  $package_ensure = $ffmpeg::params::package_ensure,
  $include_devel    = $ffmpeg::params::include_devel,
) inherits ffmpeg::params {

  #Validate params
  validate_string($package_ensure)
  validate_bool($include_devel)


  # <OS family handling>
  case $::osfamily {
    'RedHat': {
      # TODO: support 'ensure => absent'
      file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-nux.ro':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro',
      }

      $full_rpm_path = "${ffmpeg::params::nux_repo}${ffmpeg::params::nux_rpm}"

      package { $ffmpeg::params::nux_package_name:
        provider	=> 'rpm',
        ensure		=> installed,
        source		=> $full_rpm_path,
      }
    }
    default: {}
  }
  # </ OS family handling>

  package{ $ffmpeg::params::base_package:
    ensure => $package_ensure,
  }

  if ($include_devel == true){
    package{ $ffmpeg::params::devel_package:
      ensure => $package_ensure,
    }
  }
}
