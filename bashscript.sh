
# Get the list of VMs in the resource group
vm_list=$(az vm list -g "test_group" --query "[].{name:name, resourceGroup:resourceGroup}" -o tsv)

# GitHub URLs for the scripts
subscribe_to_pro_script=$(curl -s "https://raw.githubusercontent.com/lolwww/azure-automation/main/subscribe-to-pro-with-token.sh")
subscribe_to_landscape_script=$(curl -s "https://raw.githubusercontent.com/lolwww/azure-automation/main/subscribe-to-landscape.sh")

# Iterate over the list of VMs
while read -r vm_name resource_group; do
  echo "Running scripts on VM: $vm_name"

  # Run the subscribe-to-pro-with-token.sh script
  az vm run-command invoke --command-id RunShellScript \
    --name $vm_name \
    --resource-group $resource_group \
    --scripts "$subscribe_to_pro_script" \
    --parameters token="ZZZZZZ"

  # Run the subscribe-to-landscape.sh script
  az vm run-command invoke --command-id RunShellScript \
    --name $vm_name \
    --resource-group $resource_group \
    --scripts "$subscribe_to_landscape_script" \
    --parameters account_name="lolwww"
done <<< "$vm_list"
