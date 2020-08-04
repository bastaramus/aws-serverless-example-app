# AWS Lambda Application

This is my serverless application for the AWS Lambda service with Python anc C++ functions. It is just an example how to configure AWS infrastracture with the Terraform, develop and deploy an application with the AWS Serverless Application Model (AWS SAM) Framework, build and test it locally with Docker AWS Linux container. 

# Architecture

### AWS Infrastructure Scheme:

![AWS Infrastructure Scheme](/images/flow_aws_lambda_example_app.png)

There are two Lambda Functions:

**cpp-function** is an example of C++ function, it returns "Hellow World" at the endpoint **/cpphello [GET]**

**files-function** is a Python function that works with the AWS S3 service. It has next REST endpoints:
- **/files/getuploadurl [GET]** returns private presigned upload URL for the S3.
- **/files/list [GET]** returns a list of files with private presigned URLs that user can use to access files from the S3.

You can look at the next workflow diagram that shows how user gets access to a file from the S3 bucket via signed URL:

![Workflow diagram](/images/aws_lambda_example_app.png)

### 


# Source Layout

**infrastructure:** folder with Terraform configurations. Follow the readme file in that directory.

**xproject-app:** folder with source code of our example application.

**xproject-app/cpp-function:** source code of the C++ function. It is just a "HelloWorld" function.

**xproject-app/cpp-function:** source code of the Python function to work with s3 files (upload and download to s3 bucket via signed url).

**xproject-app/events:** folder with test events for local invocation.

**xproject-app/client-app.py:** just an example of the client application that works with our Lambda backend. It is a simple CLI app.

Also, there are shell scripts in the `xproject-app` directory to build, deploy, invoke our Lambda functions and etc.

# Infrastructure

Some part of the infrastructure is configured by Terraform. There are:
- VPC (separated VPC, private and public subnets, security groups)
- S3 buckets (one bucket to store Lambda artifacts and another one for media content)
- IAM policies and roles

Our application, API Gateway and functions are configured via SAM Framework.  These resources are defined in the `xproject-app/template.yaml` file in this project. It will be easy for a developer to configure new endpoints for the application, test it locally and deploy it to the AWS with this approach.

# Software Requirements

- [Python 3.7](https://www.python.org/downloads/)
- [The AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).
- [SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
- [Docker community edition](https://hub.docker.com/search/?type=edition&offering=community) to build C++ function and test the application locally.
- Optionally the Bash shell. For Linux and macOS, this is included by default. In Windows 10, you can install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to get a Windows-integrated version of Ubuntu and Bash.

If you prefer to use an integrated development environment (IDE) to build and test your application, you can use the AWS Toolkit. The AWS Toolkit is an open source plug-in for popular IDEs that uses the SAM CLI to build and deploy serverless applications on AWS. The AWS Toolkit also adds a simplified step-through debugging experience for Lambda function code. See the following links to get started.

- [PyCharm](https://docs.aws.amazon.com/toolkit-for-jetbrains/latest/userguide/welcome.html)
- [IntelliJ](https://docs.aws.amazon.com/toolkit-for-jetbrains/latest/userguide/welcome.html)
- [VS Code](https://docs.aws.amazon.com/toolkit-for-vscode/latest/userguide/welcome.html)
- [Visual Studio](https://docs.aws.amazon.com/toolkit-for-visual-studio/latest/user-guide/welcome.html)

# AWS Profile

For this step you should create an AWS account and get aws_access_key_id and aws_secret_access_key.
Then follow [this instruction](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) from AWS to configure your AWS profile.

There is a script `aws-profile.sh` that sets up your AWS profile in your environment. If you have multiple profiles in your AWS config, you can use it with 

 ```./aws-profile.sh profile_name```

 :information_source: **You should run this command every time when you start working with this project.**

# Build and Deploy the application

:warning: **If you build and deploy your application for the first time:**  Change *.sh scripts for your environment. At least, you should change:

`ARTIFACT_BUCKET` variable:  Your lambda functions will be stored in this S3 bucket. It is created by the Terraform.

`stack-name` parameter: The name of the stack to deploy to CloudFormation. This should be unique to your account and region, and a good starting point would be something matching your project name.

`region` parameter: The AWS region you want to deploy your app to.

### Python Functions

At first you should build a Lambda layer that contains the function's runtime dependencies, run `1-build-layer-python.sh`. Packaging dependencies in a layer reduces the size of the deployment package that you upload when you modify your code.

    xproject-app$ ./1-build-layer-python.sh

To deploy the application run `2-deploy.sh`.

    xproject-app$ ./2-deploy.sh

This script uses SAM CLI and AWS CloudFormation to deploy the Lambda functions, the API Gateway and other resources from the `template.yaml` file. If the AWS CloudFormation stack that contains the resources already exists, the script updates it with any changes to the template or function code.

### CPP Functions

At first you should build a docker image that will compile your C++ application. There is a Dockerfile in the `xproject-app/cpp-function` directory. This docker image is based on the AWS Linux image. It already contains all dependencies to compile our simple application.

    xproject-app/cpp-function$ docker build -t cpp-lambda-builder .

Then build your function via this docker container.

    xproject-app/cpp-function$ docker run --rm -v $(pwd)/hello-cpp-world:/root/hello-cpp-world cpp-lambda-builder /bin/bash /root/hello-cpp-world/build.sh

To deploy the application with this C++ function run the same `2-deploy.sh` script.

    xproject-app$ ./2-deploy.sh

After deployment is success you can invoke this C++ function with a script `3-invoke-cpp.sh`.

    xproject-app$ ./3-invoke-cpp.sh

### Test it locally

Test a single function by invoking it directly with a test event. An event is a JSON document that represents the input that the function receives from the event source. Test events are included in the `events` folder in this project.

Run functions locally and invoke them with the `sam local invoke` command.

    xproject-app$ sam local invoke HelloWorldCppFunction --event events/event.json 
    Invoking hello (provided)
    Decompressing /home/user/Learn/example_aws_lambda_app/xproject-app/cpp-function/hello-cpp-world/build/hello.zip

    Fetching lambci/lambda:provided Docker container image......
    Mounting /tmp/tmp56bvwyvd as /var/task:ro,delegated inside runtime container
    START RequestId: 1cfda9d1-a82f-1e82-41ee-66138e4e67d0 Version: $LATEST
    END RequestId: 1cfda9d1-a82f-1e82-41ee-66138e4e67d0
    REPORT RequestId: 1cfda9d1-a82f-1e82-41ee-66138e4e67d0  Init Duration: 56.65 ms Duration: 2.15 ms       Billed Duration: 100 ms Memory Size: 128 MB     Max Memory Used: 9 MB

    {"body":"Hello World!"}

The SAM CLI can also emulate your application's API. Use the `sam local start-api` to run the API locally on port 3000.

    xproject-app$ sam local start-api
    Mounting HelloWorldCppFunction at http://127.0.0.1:3000/cpphello [GET]
    Mounting FilesFunction at http://127.0.0.1:3000/files/getuploadurl [GET]
    Mounting FilesFunction at http://127.0.0.1:3000/files/list [GET]
    You can now browse to the above endpoints to invoke your functions. You do not need to restart/reload SAM CLI while working on your functions, changes will be reflected instantly/automatically. You only need to restart SAM CLI if you update your AWS SAM template
    2020-08-03 15:27:25  * Running on http://127.0.0.1:3000/ (Press CTRL+C to quit)

    xproject-app$ curl http://127.0.0.1:3000/files/list
    [{"Name": "pikachu.png", "URI": "https://xproject-dev-media-content-15308.s3.amazonaws.com/pikachu.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5JGR5YCN64D57RM2%2F20200803%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20200803T122752Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=a8b0c48d22d9e916ee6b37f50c966dd018a6c58ff3185c40f1322a7391aff753"}]

### Fetch, tail, and filter Lambda function logs

To simplify troubleshooting, SAM CLI has a command called `sam logs`. `sam logs` lets you fetch logs generated by your deployed Lambda function from the command line. In addition to printing the logs on the terminal, this command has several nifty features to help you quickly find the bug.

    xproject-app$ sam logs -n HelloWorldCppFunction --stack-name xproject-app --tail

You can find more information and examples about filtering Lambda function logs in the [SAM CLI Documentation](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-logging.html).


# Resources

[What is AWS Lambda?](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)

[AWS SAM developer guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html)

[AWS Lambda C++ Runtime](https://github.com/awslabs/aws-lambda-cpp)

[AWS Compute Blog - Introducing the C++ Lambda Runtime](https://aws.amazon.com/ru/blogs/compute/introducing-the-c-lambda-runtime/)

[AWS Serverless Application Repository main page](https://aws.amazon.com/serverless/serverlessrepo/)

[Safe Lambda deployments](https://github.com/awslabs/serverless-application-model/blob/master/docs/safe_lambda_deployments.rst)