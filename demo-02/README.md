# demo-02
## overview


### Initialize the directory

When you create a new configuration — or check out an existing configuration
from version control — you need to initialize the directory with `terraform
init`. This step downloads the providers defined in the configuration.

Initialize the directory.

```shell script
terraform init
```
```
Initializing modules...

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/kubernetes from the dependency lock file
- Reusing previous version of hashicorp/helm from the dependency lock file
- Using previously-installed hashicorp/aws v5.9.0
- Using previously-installed hashicorp/kubernetes v2.22.0
- Using previously-installed hashicorp/helm v2.10.1

Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
### Apply Configuration

 **copy this command**

```shell script
terraform apply 
```
```

```

# congratulations your app is ready 
## now now open app url (www.app.com) 
# Notes:
Be careful of Rout53 domain = 12$ for 12 month for domain
 
