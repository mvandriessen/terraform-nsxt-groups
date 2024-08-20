terraform {
   required_providers {
      nsxt = {
         source = "vmware/nsxt"
         version = ">= 3.1.1"
      }
   }
}

resource "nsxt_policy_group" "grp" {
   for_each = var.map_grp
   display_name = each.key

   dynamic "conjunction" {
      for_each = length(each.value) > 1 ? [1] : []
     content {
     operator = "OR"
      }
   }
   dynamic "criteria" {
   #The for_each contain a for loop with filter to create the criteriia only if there is a list with the name TAG
   for_each = { for key,val in each.value : key => val if key == "TAG" }
      content {
         dynamic "condition" {
            #looping over the set to create every tags
            for_each = criteria.value

            content {
               key = "Tag"
               member_type = "VirtualMachine"
               operator = "EQUALS"
               value = condition.value
            }
         }
      }
   }

   dynamic "criteria" {
   #The for_each contain a for loop with filter to create the criteriia only if there is a list with the name IP
   for_each = { for key,val in each.value : key => val if key == "IP" }
      content {
         ipaddress_expression  {
            ip_addresses = criteria.value
         }
      }
   }

   dynamic "criteria" {
   #The for_each contain a for loop with filter to create the criteriia only if there is a list with the name SEGMENT
   for_each = { for key,val in each.value : key => val if key == "SEGMENT" }
      content {
         dynamic "condition" {
            #looping over the set to create every tags
            for_each = criteria.value

            content {
               key = "Tag"
               member_type = "Segment"
               operator = "EQUALS"
               value = condition.value
            }
         }
      }
   }
}
