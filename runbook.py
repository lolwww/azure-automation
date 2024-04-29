import os
import sys
import requests
import azure.mgmt.resource
import automationassets

# Get the list of VM names from the input parameters
vm_names = os.environ.get('vmList')
if not vm_names:
    sys.exit('Error: vmList parameter is not set')

# Get the script URIs from the variables
landscape_uri = os.environ.get('landscapeUri')
ubuntu_pro_uri = os.environ.get('ubuntuProUri')

# Get the parameter values from the input parameters
ubuntu_pro_token = os.environ.get('ubuntuProToken')
landscape_account_name = os.environ.get('landscapeAccountName')

# Download the script contents from the provided URIs
landscape_content = requests.get(landscape_uri).text
ubuntu_pro_content = requests.get(ubuntu_pro_uri).text

# Run the scripts on each selected VM
for vm_name in vm_names.split(','):
    print('Running scripts on VM: {}'.format(vm_name))
    account_id = automationassets.get_automation_jb_run_as_account_id()
    resource_client = azure.mgmt.resource.ResourceManagementClient(acc_id, account_id)

    # Run the landscape script with parameters
    script_result = resource_client.virtual_machines.run_script(
        resource_group_name=os.environ.get('resourceGroupName'),
        vm_name=vm_name,
        script=landscape_content,
        parameters=[
            {"name": "accountName", "value": landscape_account_name}
        ]
    )
    print('Landscape script execution result: {}'.format(script_result.value))

    # Run the Ubuntu PRO script with parameters
    script_result = resource_client.virtual_machines.run_script(
        resource_group_name=os.environ.get('resourceGroupName'),
        vm_name=vm_name,
        script=ubuntu_pro_content,
        parameters=[
            {"name": "token", "value": ubuntu_pro_token}
        ]
    )
    print('Ubuntu PRO script execution result: {}'.format(script_result.value))
