## Description

This is my CML2 lab for goofing around with ansible, terraform, and netbox. 

Netbox is the main data source, and the idea is to have all lab and device information modeled and maintained only within it. I use Terraform to build out the labs based on the data in Netbox, and then run up with ansible for any additional configuration.

## Getting Started

### Dependencies

* Netbox 3.7.8 (the provider does not work with 4.0+)
* CML 2.7.0 or later
* Ansible Community 2.17.2 or later
* Terraform 1.8.5 or later
   * Providers:
       * [e-breuninger/netbox](https://registry.terraform.io/providers/e-breuninger/netbox/latest)
       * [CiscoDevNet/cml2](https://registry.terraform.io/providers/CiscoDevNet/cml2/latest)
       * [hashicorp/http](https://registry.terraform.io/providers/hashicorp/http/latest)

### Details

The ansible inventory plugin configuration I'm using is provided under files/netbox_inventory.example. Just move it under plugins/inventory, change it to .yml, and add the missing vars.

There are vault variables in some group or host vars files. These need to be in a vault file somewhere.

The following mappings are made between Netbox and CML:
* Sites -> Labs
* Devices -> Nodes
* Cables -> Links
* Platforms -> Node Definitions

Resources will only be created if they're 'Active' (labs, nodes) or 'Connected' (links) in Netbox.

* I use an interface custom field in Netbox called 'cml_slot_no' which I use to define the slot number for interfaces in CML.
* All lab nodes should be reachable from wherever you're running this, obviously.

I use the following Netbox roles and tags in this lab:
* Device Roles:
  * External Connector, WAN Router, Edge Router, Core Switch, LAN Switch
* Platforms:
  * IOSv, IOSvL2
* Prefix Role:
  * Site Subnet
* Tags:
  * Device Tags:
    * Ansible
  * Interface Tags:
    * Default Route, WAN Interface, LAN Interface, OSPF Interface

I'm also using configuration templates and contexts to build a day-0 that is pushed with Terraform, but those are not in this repo. It's just basic connectivity.

## Authors

[Pythbit](https://github.com/pythbit)

## License

This project is licensed under the MIT License
