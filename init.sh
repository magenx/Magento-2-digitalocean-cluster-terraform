
if [[ -e "this.init.lock" ]]; then
  echo
  echo "[!][ERROR]: Lock exists"
  terraform workspace list
  echo
  exit 1
fi

## install terraform and packer
dpkg-query -l terraform packer >/dev/null || {
apt-get update && apt-get install -y gnupg software-properties-common curl;
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -;
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main";
apt-get update && apt-get install terraform packer;
}

## set access token
if [ -z "${DIGITALOCEAN_ACCESS_TOKEN}" ]; then
    echo
    echo "[!][ERROR]: No DIGITALOCEAN_ACCESS_TOKEN token available"
    echo
    exit 1
fi

## start with development workspace
workspace=development

echo
## init packer plugin
/usr/bin/packer init modules/frontend/packer/packer.pkr.hcl

echo
## init terraform
terraform fmt
terraform init

if  [ $? -ne 0 ]; then
    echo
    echo "[!][ERROR]: Terraform init"
    echo
    exit 1
fi

echo
# create terraform workspace
if [ "$(terraform workspace list | grep ${workspace})" == "" ]; then
    terraform workspace new ${workspace}
fi

if  [ $? -ne 0 ]; then
    echo
    echo "[!][ERROR]: Terraform workspace ${workspace} not available"
    echo
    exit 1
fi

echo
echo "[!][INFO]: Running terraform plan to ${workspace}.plan.out"
terraform plan -out ${workspace}.plan.out -no-color | tee ${workspace}.plan.out.txt


if  [ $? -eq 0 ]; then
    echo
    echo "[X][LOCKED]: Init lock enabled"
    echo
    touch this.init.lock
fi
