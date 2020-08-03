Infrastructure as a service code. To get started with it, there are multiple steps, including installing Terraform and the AWS provider. 

## Software requirements
Terraform 0.12
AWS CLI

## Big Bang Step

*In this, and all future steps, $ROOT is the root of the git repo.*
You shouldn't run this step if you are not sure. There is a terraform.tfstate file in the source control, you can delete it if you want 
to start from the begining.

```cd $ROOT/infrastructure/init``` 
```terraform init``` 
```terraform apply``` 

This will create the lock table in DynamoDB and the S3 bucket for storing the current Terraform state for all other modules. In all other directories listed below, you will need to do, at a minimum terraform init to get your working directory synced with the live state.

## Source Layout

**environments:** folder to isolate various environment (development/test/stage/production) specific configuration.
**modules:** folder to host reusable resource sets (modules)
**init:** folder with sources for Big Bang Step

## Working with the setup

aws-profile.sh sets up your AWS profile in your environment. If you have multiple profiles in your AWS config, you can use it with 

 ```./aws-profile.sh profile_name```

**Initialize terraform**
Navigate to the environment folder, development for example, on the terminal.
To get started, first initialize your local terraform state information

```terraform init```

**Plan & apply changes**

```terraform plan```
```terraform apply```