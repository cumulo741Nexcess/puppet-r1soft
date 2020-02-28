class r1soft::agent::hcpdriver {

  if $r1soft::agent::kmod_manage {
    if $facts['system_uptime']['seconds'] >= $r1soft::agent::delay_factor {
      # check for the hcpdriver_installed fact to prevent weirdness on fresh installs
      if $facts['hcpdriver_installed'] {
        exec {'update hcpdriver kmod':
          command => "${r1soft::agent::kmod_tool} --get-module --silent",
          creates => $facts['hcpdriver']['kmod_wanted'],
          notify  => Service[$r1soft::agent::service_name],
        }

        unless ( 
          $facts['hcpdriver']['is_loaded'] and 
          $facts['hcpdriver']['kmod_wanted'] == $facts['hcpdriver']['kmod_selected'] and 
          $facts['hcpdriver']['kmod_wanted_is_built']
        ) {
          exec {'trigger cdp-agent restart':
            command => '/bin/true',
            notify  => Service[$r1soft::agent::service_name],
          }
        }
      }
    }
  }
}
