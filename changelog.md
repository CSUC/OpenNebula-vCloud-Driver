## Changelog

###V0.1 Beta (2016-07-13)

* Basic, initial version.
* It's able to:
    * Deploy,reboot,shutdown,reset,suspend,reboot and destroy VM's.
    * Monitor hosts and VM's.
    * Create, revert and delete VM's snapshots.
    * Change RAM and CPU values of VM.
    * Hot-attach and detach NICs to VM's (To detach NICs is necessary to reboot the VM).
    * Automatized customization of the VMs instanciated. The templates must be configured for that.
    * Import networks, hosts, templates and datastores hosted in vCloud using onevcloud script.

###TODO

* Manual IP addressment. Now, only POOL addressment is supported.
* Attach and detach Hard Disks to VM's.
* Configure vShield firewall to filter VM's ports during the instanciation and the attach/detach NIC's.