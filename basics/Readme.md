# terraform task


## Terrafom commands more [hier](https://developer.hashicorp.com/terraform/cli/run)

``` sh

 terraform plan  # check the configuration to see whath will be applied

 terraform plan -out [filePlanName]
```

Apply configuartio

```sh
    terraform apply # apply configuration
    terraform appy "[filePlanName]" apply configuration from result of a plan
```

Delete resource

```sh
    terraform destroy
```

Validate Terraform file use `terraform validate`. Terraform can also update format of your file `terrafom fmt`.

## Multiple Environments with Workspace

```sh
    terraform workspace
```

To manage workspaces in terraform.
