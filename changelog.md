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

###V0.2 Beta (2016-10-17)

* It's able to:
	* Manual IP addressment. Before, only POOL addressment was supported.
	* Configure vShield firewall to filter VM's ports during the instanciation and the attach/detach NIC's.

###V0.3 Beta (2016-12-15)
* It's able to:
	* Cold Attach & detach volatile disks to VM's
    * Resize disks during the instantiation
    * Select the profile storage

###TODO

* Integrate VMRC (VMware Remote Console) to OpenNebula.
* Hot Attach & detach volatile disks to VM's