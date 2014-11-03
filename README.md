Example Puppet Configuration
============================
This repository contains an example Puppet configuration using r10k.

 * Sets up and uses directory environments properly.
 * Sets catalog version to use the Git SHA-1 short-ref.
 * Modifies `modulepath` to include `r10k`-deployed modules

Installation
------------
On your Puppet Master, execute `puppet apply setup.pp` and watch the fireworks.

You may need to restart your Puppet Master for changes to take effect.
