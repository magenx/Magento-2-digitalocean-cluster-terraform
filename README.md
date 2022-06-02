## Magento 2 auto scaling cluster with Terraform on DigitalOcean cloud
> Deploy a full-scale secure and flexible e-commerce infrastructure based on Magento 2 in a matter of seconds.  
> Enterprise-grade solution for companies of all sizes, B2B B2C, providing the best customer experience.  


<img src="https://user-images.githubusercontent.com/1591200/117845471-7abda280-b278-11eb-8c88-db3fa307ae40.jpeg" width="155" height="105"> <img src="https://user-images.githubusercontent.com/1591200/117845982-edc71900-b278-11eb-81ec-e19465f1344c.jpeg" width="140" height="130"> <img src="https://user-images.githubusercontent.com/1591200/170114082-7fea7101-e342-459b-8eb3-6fbe0a98ba46.png" width="235" height="120">
<img src="https://user-images.githubusercontent.com/1591200/130320410-91749ce8-5af1-4802-af25-ffb36e7ded98.png" width="105" height="120"><img src="https://user-images.githubusercontent.com/1591200/143559434-7593c7bf-79b5-4a1f-b6cc-71060cf0bbec.png" width="160" height="170">

<br />
  
```
export DIGITALOCEAN_ACCESS_TOKEN=xxx
export SPACES_ACCESS_KEY_ID=xxx
export SPACES_SECRET_ACCESS_KEY=xxx
```

## Deploy each environment into isolated project and vpc:
Using Workspaces
Each Terraform configuration has an associated backend that defines how operations are executed and where persistent data such as the Terraform state are stored. The persistent data stored in the backend belongs to a workspace. Initially the backend has only one workspace, called "default", and thus there is only one Terraform state associated with that configuration. Workspaces are managed with the terraform workspace set of commands. To create a new workspace and switch to it, you can use `terraform workspace new`.  
For example, creating a new workspace:  
  
```
$ terraform workspace new development  
Created and switched to workspace "development"!  
```
Workspaces are technically equivalent to renaming your state file. Within your Terraform configuration, you may include the name of the current workspace using the ${terraform.workspace} interpolation sequence. This can be used anywhere interpolations are allowed.
Referencing the current workspace is useful for changing behavior based on the workspace.
Named workspaces allow conveniently switching between multiple instances of a single configuration within its single backend. They are convenient in a number of situations, but cannot solve all problems.

A common use for multiple workspaces is to create a parallel, distinct copy of a set of infrastructure in order to test a set of changes before modifying the main production infrastructure. For example, a developer working on a complex set of infrastructure changes might create a new temporary workspace in order to freely experiment with changes without affecting the default workspace.

Create working directory:  
`mkdir magento && cd magento`

Using git clone download terraform configuration:  
`git clone https://github.com/magenx/Magento-2-digitalocean-cluster-terraform .`  
  
For ssl certificate configuration add domains and email   
Point your domains to [DigitalOcean DNS](https://docs.digitalocean.com/tutorials/dns-registrars/)  

Add ssh keys to digitalocean for `admin` and `manager` users.  
  
Update configuration variables according to your project requirements.
To simplify configuration initialization and lower chances to damage your environment with typos, run init script:
`bash init.sh`

## Get $100 in credit over 60 days.
[![DigitalOcean Referral Badge](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg)](https://www.digitalocean.com/?refcode=ccc5d115377f&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)
