RG='FedEx-B5-HUB-RG'

az group create --location eastus -n ${RG}


az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.5.0.0/16 \
    --subnet-name ${RG}-subnet-1 --subnet-prefix 10.5.1.0/24 -l eastus

az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"

IMAGE='Ubuntu2404'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name WEBSVR1 --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-subnet-1 --admin-username madhan --admin-password "madhan@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.5.1.10 \
    --zone 1 --custom-data ./clouddrive/SLB-Config.txt

az vm create --resource-group ${RG} --name WEBSVR2 --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-subnet-1 --admin-username madhan --admin-password "madhan@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.5.1.20 \
    --zone 2 --custom-data ./clouddrive/SLB-Config.txt

az vm create --resource-group ${RG} --name WEBSVR3 --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-subnet-1 --admin-username madhan --admin-password "madhan@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.5.1.30 \
    --zone 3 --custom-data ./clouddrive/SLB-Config.txt

az vm create --resource-group ${RG} --name WEBSVR4 --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-subnet-1 --admin-username madhan --admin-password "madhan@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.5.1.40 \
    --zone 3 --custom-data ./clouddrive/SLB-Config.txt