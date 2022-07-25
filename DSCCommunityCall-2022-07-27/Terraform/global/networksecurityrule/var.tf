variable "network_security_rule_name" {
  description = "The name of the security rule."
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "network_security_group_name" {
  description = "The name of the Network Security Group that we want to attach the rule to."
}

variable "description" {
  description = "A description for this rule. Restricted to 140 characters."
}

variable "protocol" {
  description = "Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, or * (which matches all)."
}

variable "source_port_range" {
  description = "Source Port or Range. Integer or range between 0 and 65535 or * to match any."
}

variable "destination_port_range" {
  description = "Destination Port or Range. Integer or range between 0 and 65535 or * to match any."
}

variable "source_address_prefix" {
  description = "CIDR or source IP range or * to match any IP. Tags such as ?VirtualNetwork?, ?AzureLoadBalancer? and ?Internet? can also be used."
}

variable "destination_address_prefix" {
  description = "CIDR or destination IP range or * to match any IP."
}

variable "access" {
  description = "Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny."
}

variable "priority" {
  description = "Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule."
}

variable "direction" {
  description = "The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound."
}
