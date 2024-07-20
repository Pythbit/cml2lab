## Description

This is my CML2 lab for goofing around with ansible, terraform, and netbox. 

Netbox is the main data source, and the idea is to have all lab and device information modeled and maintained only within it. I use Terraform to build out the labs based on the data in Netbox (with a 0 day config), and then run up with ansible for any additional configuration.

## Getting Started

### Dependencies

* Netbox 3.7.8 (the provider does not work with 4.0+)
* CML 2.7.0 or later
* Terraform 1.8.5 or later
   * Providers:
       * [e-breuninger/netbox](https://registry.terraform.io/providers/e-breuninger/netbox/latest)
       * [CiscoDevNet/cml2](https://registry.terraform.io/providers/CiscoDevNet/cml2/latest)
       * [hashicorp/http](https://registry.terraform.io/providers/hashicorp/http/latest)

### Details

The following mappings are made between Netbox and CML:
* Sites -> Labs
* Devices -> Nodes
* Cables -> Links

Resources will only be created if they're 'Active' (labs, nodes) or 'Connected' (links) in Netbox.

* I use an interface custom field in Netbox called 'cml_slot_no' which I use to define the slot number for interfaces in CML.
* All lab nodes should be reachable from wherever you're running this, obviously.

## Authors

[Pythbit](https://github.com/pythbit)

## License

This project is licensed under the GPL2 License