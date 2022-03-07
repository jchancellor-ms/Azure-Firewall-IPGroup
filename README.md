# Azure-Firewall-IPGroup
# Create Azure Policy Initiatives with Built-in and Custom Policies

<!-- Project description -->
I created this project to enable the implementation of Azure Firewall artificts in batch.  The goal was to minimize the writing of additional terraform code while being able to add firewall policy and ip groups using input files. This first iteration only supports IP group bulk creation, but long-term the goal is to allow for creation of policy and rule collections as well.

# Table of contents

- [Installation](#installation)
- [Usage](#usage)
- [Issues](#Issues)
- [Appendix](#Appendix)
- [Footer](#footer)

# Installation
[(Back to top)](#table-of-contents)

To use the terraform code, perform the following steps:
- Configure the deployment machine to use terraform with Azure. If deploying from cloud shell, terraform and azure cli applications are preinstalled and login is done automatically so those steps can be skipped.
    - Install terraform.  Instructions can be found at this [link](https://learn.hashicorp.com/tutorials/terraform/install-cli)
    - Install the Azure CLI.  Instructions can be found at this [link](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    - Sign-in to the Azure CLI. Instructions for sign-in options can be found at this [link](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
    - Set the subscription context to the subscription that will hold the terraform state using the cli `az account set --subscription <id>` or `az account set --subscription "<subscription name>"`
- Clone the repo (assumes git is installed)
    - `git clone https://github.com/jchancellor-ms/Azure-Firewall-IPGroup.git`
    - Change directory into the cloned directory `cd Azure-Firewall-IPGroup`
- Optionally, configure a remote state configuration using an Azure Storage Account
    - Create a resource group (or use an existing resource group) 
    - Create a storage account configured to your retention needs and ensure the account logged in has the ability to write and read blobs
    - Create a blob container for storing tfstate files
    - Open the providers.tf file
    - Remove the comment start/stop text and populate the storage account details from the previous step 
    - Save the providers.tf file
- At this point you can proceed to using the project

# Usage
[(Back to top)](#table-of-contents)

The project works by creating a template JSON file which refences individual CSV files containing the large numbers of CIDR ranges that will be included in each IP group.  The terraform code parses the JSON input and recursively identifies if the IP groups exist, and then creates or updates them. This project currently only works for IP group creation from a CSV, but future iterations could also allow for defining the IP group members directly in the JSON definition file.

A JSON template is included as well as an example file that creates IP groups for the RU and BY regions using an extract from the https://www.countryipblocks.net/acl.php site split into individual files under the 5k IP group object limit. The CSV file should have a single column with column header `cidr` containing CIDR address ranges or individual IP addresses one per row.  These entries will be used to populate the IP Group being defined by the referenced CSV file in the JSON input file. To configure a working sample, copy the `template_ip_group.csv' file and replace the details with the values for your environment and save with a unique filename. Update the JSON template file with an IP group definition pointing to this new IP group CSV file.

Once the JSON input file has been configured then it is possible to run the terraform workflow to implement or update the IP Groups.

```
terraform init
terraform plan -var="input_filename=<input JSON filename>" -out=<planfilename>.tfplan
terraform apply <planfilename>.tfplan
```

or if you're feeling brave:
```
terraform init
terraform apply -var="input_filename=<input JSON filename>" 
```

After accepting the config changes you should now be able to see the policies and initiatives in the portal.

If you need to update an existing initiative to add or remove policies or create additional policy initiatives the only requirement is to modify the JSON file containing the definition details and re-run the terraform init/plan/apply sequence.

To deploy the RU and BY example complete the following items:
- Update the `ip_group_ru_by_sample.json` file with your resource group details
```
{  
    "ip_groups": [
        {
            "comment": "ru group 1 of 5",
            "ip_group_name": "ipg_ru_1",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",            
            "csv_filename": "ru_1.csv"
        },
        {
            "comment": "ru group 2 of 5",
            "ip_group_name": "ipg_ru_2",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",           
            "csv_filename": "ru_2.csv"
        },
        {
            "comment": "ru group 3 of 5",
            "ip_group_name": "ipg_ru_3",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",            
            "csv_filename": "ru_3.csv"
        },
        {
            "comment": "ru group 4 of 5",
            "ip_group_name": "ipg_ru_4",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",             
            "csv_filename": "ru_4.csv"
        },
        {
            "comment": "ru group 5 of 5",
            "ip_group_name": "ipg_ru_5",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",          
            "csv_filename": "ru_5.csv"
        },
        {
            "comment": "by group 1 of 1",
            "ip_group_name": "ipg_by_1",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",             
            "csv_filename": "by_1.csv"
        }
    ]
}
```
- Then run the Terraform workflow referencing the input file
```
terraform init
terraform plan -var="input_filename=ip_group_ru_by_sample" -out=implement_example.tfplan
terraform apply implement_example.tfplan
```


# Issues
[(Back to top)](#table-of-contents)

There are several issues to pay attention to when using this configuration.
- Ensure that the JSON file is properly formed JSON with a configuration that is valid. Invalid JSON can generate unusual errors that may be difficult to troubleshoot.


<!-- Add the footer here 
# Footer
[(Back to top)](#table-of-contents)

Leave a star in GitHub, give a clap in Medium and share this guide if you found this helpful.


 ![Footer](https://github.com/navendu-pottekkat/awesome-readme/blob/master/fooooooter.png) -->
