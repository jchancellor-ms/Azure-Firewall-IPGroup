# Azure-Firewall-IPGroup
# Create Azure IP Groups in batch using Terraform

<!-- Project description -->
I created this project to enable the implementation of Azure Firewall IP Groups in batch.  The goal was to minimize the writing of additional terraform code while being able to add IP groups using input files. This first iteration only supports IP group bulk creation, but long-term the goal is to allow for creation of policy and rule collections as well.

# Table of contents

- [Installation](#installation)
- [Usage](#usage)
- [Issues](#Issues)
- [Appendix](#Appendix)

# Installation
[(Back to top)](#table-of-contents)

To run the Terraform code, perform the following steps:
- Configure the deployment machine to use Terraform with Azure. If deploying from cloud shell, Terraform and azure cli applications are preinstalled and login is done automatically so those steps can be skipped.
    - Install Terraform.  Instructions can be found at this [link](https://learn.hashicorp.com/tutorials/terraform/install-cli)
    - Install the Azure CLI.  Instructions can be found at this [link](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    - Sign-in to the Azure CLI. Instructions for sign-in options can be found at this [link](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
    - Set the subscription context to the subscription that will hold the Terraform state using the cli `az account set --subscription <id>` or `az account set --subscription "<subscription name>"`
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

The project works by creating a template JSON file which references individual CSV files containing the large numbers of CIDR ranges that will be included in each IP group.  The Terraform code parses the JSON input and recursively identifies if the IP groups exist, and then creates or updates them. This project currently only works for IP group creation from a CSV, but future iterations could also allow for defining the IP group members directly in the JSON definition file. It assumes that the resource group where the IP groups will be created already exists or is being created with another Terraform module.

A JSON template is included as well as an example file that creates IP groups for a large input list split into individual files under the 5k IP group object limit. The CSV file should have a single column with column header `cidr` containing CIDR address ranges or individual IP addresses one per row.  These entries will be used to populate the IP Group being defined by the referenced CSV file in the JSON input file. To manually configure a working sample, copy the `template_ip_group.csv` file and replace the details with the values for your environment and save with a unique filename. Update the JSON template file `ip_group_template.json` with an IP group definition pointing to this new IP group CSV file and save with a descriptive name.

Once the JSON input file has been configured then it is possible to run the Terraform workflow to implement or update the IP Groups.

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

After accepting the config changes you should now be able to see the IP groups in the portal.

If you need to update an IP group or create additional IP Groups the only requirement is to modify the JSON file containing the definition details, create/update the CSV file, and re-run the Terraform init/plan/apply sequence.

## Included Example
To deploy the included example complete the following items:
- Update the `ip_group_input_example.json` file with your resource group details
```
{  
    "ip_groups": [
        {
            "comment": "ipg group 1 of 5",
            "ip_group_name": "ipg_part_1",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",            
            "csv_filename": "ipg_part_1.csv"
        },
        {
            "comment": "ipg group 2 of 5",
            "ip_group_name": "ipg_part_2",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",           
            "csv_filename": "ipg_part_2.csv"
        },
        {
            "comment": "ipg group 3 of 5",
            "ip_group_name": "ipg_part_3",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",            
            "csv_filename": "ipg_part_3.csv"
        },
        {
            "comment": "ipg group 4 of 5",
            "ip_group_name": "ipg_part_4",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",             
            "csv_filename": "ipg_part_4.csv"
        },
        {
            "comment": "ipg group 5 of 5",
            "ip_group_name": "ipg_part_5",
            "resource_group_name": "<enter creation resource group name>",
            "resource_group_location": "<enter creation resource group location>",          
            "csv_filename": "ipg_part_5.csv"
        }
    ]
}
```
- Then run the Terraform workflow referencing the input file
```
terraform init
terraform plan -var="input_filename=ip_group_input_example.json" -out=implement_example.tfplan
terraform apply implement_example.tfplan
```


# Issues
[(Back to top)](#table-of-contents)

- Ensure that the JSON file is properly formed JSON with a configuration that is valid. Invalid JSON can generate unusual errors that may be difficult to troubleshoot.


# Appendix - Powershell Script to split CSV into multiple files
To assist with large input files that exceed the limits for IP group sizes, a Powershell script that splits a CSV into smaller files has been included.  To run the script in the simplest form, just include the filename you want to split.
```
./splitCSV.ps1 "full_input_example.csv"
```

If you need to modify the maximum size or want to change things like the prefix values a full example with all parameters follows.
```
./splitCSV.ps1 -inputFile "full_input_example.csv" -maxRows 5000 -outFilePrefix "ipg_part_" -headerRow $true -headerValue "cidr"
```




<!-- Add the footer here 
# Footer
[(Back to top)](#table-of-contents)

Leave a star in GitHub, give a clap in Medium and share this guide if you found this helpful.


 ![Footer](https://github.com/navendu-pottekkat/awesome-readme/blob/master/fooooooter.png) -->
