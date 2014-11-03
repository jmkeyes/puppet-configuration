# Supress the allow_virtual deprecation warning.
if versioncmp($::puppetversion, '3.6.1') >= 0 {
  Package {
    allow_virtual => false
  }
}

# Include all classes defined by Hiera.
hiera_include('classes')
