# Amazon Managed Service for Apache Flink - PyFlink Starter Kit

Amazon Managed Service for Apache Fink PyFlink Starter Kit helps you with the development of Pythong based Flink Application with Kinesis Stream as a source and Amazon Aurora Postgress SQL as a sink. This starter Kit includes an end to end application building process and would help you with faster Python based streaming app development. 
#

Earlier blog/guides for building Python based Flink Application outlines barebones manual process and documentation, here the focus is automated application building process to minimizes the time and complexity. The code also includes basic flink functionality like:
* Flink uber jar - flink-table-uber, Packages the API modules above plus the old planner into a distribution for most Table & SQL API use cases.
* Json deserialization - this function would deserialize the text format to json.
* Map function - this function would take care of converting json dictionay to json object for sink processing 
* KeyedProcessFunction 5/DB Sink - is a low-level stream processing operation, giving access to the basic building blocks of all (acyclic) streaming applications, and here is an example how to store states, convert the stream depending of some actions or process.

Contents:

* [Architecture](#architecture)
* [Application Overview](#application-overview)
* [Build Instructions](#build-instructions)
* [Deployment Instructions](#deployment-instructions)
* [Testing Instructions](#testing-instructions)
* [Future Releases](#future-releases)

#


## Architecture

The Architecture of this starter kit is shown in the below diagram

![Alt](./images/kda-pyflink.drawio.png)

For ease of deployment this architecture uses Terraform based application deployment, and for which the below are the pre-requisites.

### Pre-requisites

* JDK 11 - as we are using java mvn to build the uber jar, you need to rebuild if there is a need to change the uber jar name etc.
* Apache Maven
* Python 3.8 - as it work perfectly with Flink version 1.11.1 (For local deployment and testing it will be ideal follow this blog - https://github.com/aws-samples/pyflink-getting-started)
    * this will create a python3.8 virtual environment for local debugging and testing
    * IDE Microsoft vs code
* AWS CLI
* [Terraform](https://developer.hashicorp.com/terraform/install?ajs_aid=8dfc75dd-430d-4960-b576-87fc8a49b931&product_intent=terraform) - one can download and install Terraform using this link 
# 
### AWS Account Requirements
* AWS S3 Bucket to store the terraform state file (this will keep the state file secured)
* AWS IAM user - with policies to create:
    * AWS CLI access (access key, secret key)
    * IAM Role
    * Amazon Kinessis Data Streams
    * Amazon Managed Apache Flink Application
    * Amazon S3 Bucket (to store application related data)
    * Amazon Aurora DB
    * AWS Lambda

# 
### Applicaiton Repository Information

<img src="./images/kda-pyflink-repo.png" alt="drawing" width="500"/>

* fink-java-dependency folder has the code to build the flink uber jar
* images is to store readme markup images
* kda-pyflink-starter-data-pipeline folder has the code to build the flink application
* lambda_code folder has the utility code for data generator and sql table creation and checking
* tf folder has the terraform related code for creating infrastructure, automated deployment
#

### Applicaiton Setup Instructions

***Before starting clone the starter kit locally***

#### Building Apache Flink Uber Jar
* Navigate to fink-java-dependency folder, and run
    ```
    cd flink-java-dependency 
    mvn clean install
    ```
* Once build is completed, navigate to fink-java-dependency/target folder, the uber jar will be ```kda-pyflink-starter-uber.jar```
* Copy the jar file to kda-pyflink-starter-data-pipeline/lib folder 
    ```
    mkdir -p ../kda-pyflink-starter-data-pipeline/lib
    cp target/kda-pyflink-starter-uber.jar ../kda-pyflink-starter-data-pipeline/lib
    ```
* >Note: this jar will be 100+ mb

### setting up python environment - assuming conda is already installed
Using Command Line : Navigate to root folder "kda-pyflink-starterkit"
 run the command
```       
which python
> /home/$USER/miniconda3/envs/flink-env/bin/python
```
create virtual environment


```
conda create -n flink-env pip python=3.8
```
activate virtual environment
```
conda activate flink-env
pip install boto3
pip install apache-flink==1.15.2
```
#

### setting up pyflink application dependencies 

Using Command Line : Navigate to root folder "kda-pyflink-starterkit"
 run the command
```       
./build.sh
```
this would do two operations:<\br>
* Install the python libraries (required for functioning of KDA application) listed in requirement.txt to a temporary directory 's-package'
* Create a dependencies folder inside kda-pyflink-starter-data-pipeline
* Copy the libraries from 's-package' to dependencies

### Deployment Instructions
#
Checking for deployment pre-requisites.
1. Terraform
    ```
    terraform --version
    ```
    ```
    Terraform v1.2.3
    on darwin_amd64
    + provider registry.terraform.io/hashicorp/aws v5.30.0
    + provider registry.terraform.io/hashicorp/local v2.4.1
    + provider registry.terraform.io/hashicorp/null v3.2.2
    ```
    
2. AWS CLI - for this you need to have a AWS User with mentioned access
    ```
    aws s3 ls
    ```
    should like the s3 buckets in the account

3. [Create AWS Bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html) - to store tf state file and this bucket can be also used to store kda applicaiton data
    this can be done using AWS CLI COMMAND - ```aws s3api create-bucket --bucket <unique bucket name> --region us-east-1```
    once bucket is created, modify the terraform main.tf file
    ```
    backend "s3" {
        bucket = "<unique bucket name>"  -- update with newly created bucket
        key    = "starterkit/state_file"
        region = "us-east-1"
     }
    }
    ```
    >Note: make sure the bucket is version and encryption enabed
4. Update "kda_application_bucket_name" variable in terraform variables.tfvars with the newly created bucket (step 3).
#

### Infrastructure Deployment Instructions
1. Terraform base Deployment Instructions </br>
    navigate to kda-pyflink-starterkit/tf folder - open variables.tfvars

    **Update the following**
    | Key   | Value  | Description |
    |-------| -------| ----------- |
    | aws_region     | us-east-1 | AWS region |
    | environment | dev | a name holder to identify the infra environment only change if needed |
    | aws_account      | "aws account no" |AWS account number - found at top right corner fot he AWS console page |
    | aws_profile      | "profile" | only use this if you have a profle update in .aws/conifg file |
    | rds_master_username      | "username"| Aurora DB Postgress username |
    | rds_master_password      | "password" | Aurora DB Postgress password |

2. Terraform plan - this will show the infra changes (this is not a mandatory step)</br>
    navigate to kda-pyflink-starterkit/tf
    ```
    terraform plan -var-file="variables.tfvars"
    ```
3. Terraform apply - this will create the inrastructure for building the kda-pyflink-starterkit application
    navigate to kda-pyflink-starterkit/tf
    ```
    terraform apply -var-file="variables.tfvars"
    ```
    ```
    Plan: 1 to add, 1 to change, 1 to destroy.

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: Yes

    ....
    ....
    Apply complete! Resources: 1 added, 1 changed, 1 destroyed.

    ```
    >Note: once deployed successfully the following services will be available
    
    | Service   |Name  | Description |
    |-------| -------|------|
    | Amazon Kinesis Data Streams     | kda-pyflink-ingestor | Kinesis stream where data will be pushed|
    | Amazon Managed Apache Flink Application | kda-pyflink-starterkitdev | Flink application that reads and process data in stream|
    | Amazon Aurora (Postgress SQL)      |kda-pyflink-rds |Database to store data|
    | AWS Lambda      | kda-pyflink-starter-sql-function | Python function so init database table etc. |
    | AWS IAM      | kda-pyflink-starterkit-role | IAM Role to access kda |
   | AWS IAM      | kda-pyflink-starterkit-rds-role | IAM Role to access rds from kda |
   | AWS VPC      | kda-pyflink-vpc | Host all the service in a VPC |
   | AWS Subnets      | kda-pyflink-subnet-public-subnet-[1,2], kda-pyflink-subnet-private-subnet-[1,2] | Host all the service in a subnet |
   | AWS Security Group      | kda-pyflink-starterkit-allowed-ssh | Access open between rds and kda |
#

### KDA PyFlink Starter Application Execution
#
### Starting the Application - AWS Console
#### Navigate to Managed Apache Flink Service &rarr; Apache Flink applications &rarr; select "kda-pyflink-starterkit" &rarr; click on Run button (select Run without snapshot) &rarr; Run 
#### Select "kda-pyflink-starterkit"
<img src="./images/kda-pyflink-app-dashboard.png" alt="drawing" width="1500"/>

#
####  Click on Run button
<img src="./images/kda-pyflink-app-run.png" alt="drawing" width="1500"/>

#
####  Application Start in-progress
<img src="./images/kda-pyflink-app-run-starting.png" alt="drawing" width="1500"/>

#
####  Application Started 
<img src="./images/kda-pyflink-app-run-running.png" alt="drawing" width="1500"/>

#
####  Application Dashboard - view Flink dashboard (Click on Open Apache Flink dashboard button)
<img src="./images/kda-pyflink-app-dashboard-started.png" alt="drawing" width="1500"/>

#
####  Flink dashboard 
<img src="./images/kda-pyflink-app-flink-dashboard.png" alt="drawing" width="1500"/>

#
####  Flink dashboard - process view
<img src="./images/kda-pyflink-app-flink-detailed.png" alt="drawing" width="1500"/>

> Note: If the we are seeing above view then the Application is up and running.
#

### KDA PyFlink Starter Application Data Generator

#### Using Command Line : Navigate to root folder "kda-pyflink-starterkit" &rarr; lambda_code &rarr;kda-pyflink-starter-sql-function &rarr; run the command

```
python stock.py
>
{'event_time': '2024-01-10T12:31:42.388257', 'ticker': 'AMZN', 'price': 41.39}
{'event_time': '2024-01-10T12:31:42.610027', 'ticker': 'INTC', 'price': 64.24}
{'event_time': '2024-01-10T12:31:42.656582', 'ticker': 'AMZN', 'price': 75.9}
{'event_time': '2024-01-10T12:31:42.688643', 'ticker': 'AAPL', 'price': 45.34}
{'event_time': '2024-01-10T12:31:42.721439', 'ticker': 'AMZN', 'price': 73.17}
{'event_time': '2024-01-10T12:31:42.757034', 'ticker': 'AMZN', 'price': 65.34}
```
>Note: stock.py python function has code to create a random json object string and push it to the KDA stream "kda-pyflink-ingestor" that we created earlier

####  Flink dashboard - will show the Byte received and Record Received/Sent
<img src="./images/kda-pyflink-app-flink-data.png" alt="drawing" width="1500"/>

#### Verify data recevied in Aurora DB using Lambda
#### Navigate to AWS Lambda &rarr; Functions &rarr; select "kda-pyflink-starter-sql-function" &rarr; click on Test button (configure an event) &rarr; Execution result &rarr; 
<img src="./images/kda-pyflink-app-lambda.png" alt="drawing" width="1500"/>

#

```
Test Event Name
test

Response
{
  "statusCode": 200,
  "body": "\"Kda PyFlink Testing Module!\""
}

Function Logs
START RequestId: 0e2b2f0f-387a-47dd-ac83-e717c96526be Version: $LATEST
Connecting to <connection object at 0x7f3caf7f37c0; dsn: 'user=gryffindor password=xxx dbname=dev host=kda-pyflink-rds.cluster-chud7gfdsajr.us-east-1.rds.amazonaws.com port=5432', closed: 0>
('public', 'stock_data', 'gryffindor', None, False, False, False, False)
ResultCount = 23410
END RequestId: 0e2b2f0f-387a-47dd-ac83-e717c96526be
```
>Note: as we re-test the ResultCount will increase (the application is pushing data to the database.)

```
Test Event Name
test

Response
{
  "statusCode": 200,
  "body": "\"Kda PyFlink Testing Module!\""
}

Function Logs
START RequestId: 4f404bb3-26c8-43f2-b238-f7a4dc975fd2 Version: $LATEST
Connecting to <connection object at 0x7f3caf7f37c0; dsn: 'user=gryffindor password=xxx dbname=dev host=kda-pyflink-rds.cluster-chud7gfdsajr.us-east-1.rds.amazonaws.com port=5432', closed: 0>
('public', 'stock_data', 'gryffindor', None, False, False, False, False)
ResultCount = 24242
END RequestId: 4f404bb3-26c8-43f2-b238-f7a4dc975fd2
```
#


# Appendix

### KDA Application exeception
This are steps to help with KDA application excetions and how to solve it.
#### Navigate to Managed Apache Flink Service &rarr; Apache Flink applications &rarr; select "kda-pyflink-starterkit" &rarr; Monitoring &rarr; Logs
<img src="./images/kda-pyflink-app-exception.png" alt="drawing" width="1500"/>

> throwableInformation
org.apache.flink.kinesis.shaded.com.amazonaws.SdkClientException: Unable to execute HTTP request: Connect to kinesis.us-east-1.amazonaws.com:443 [kinesis.us-east-1.amazonaws.com/3.227.250.175] failed: connect timed out

This exception means the KDA application is not able to talk to Kinesis Data Stream, ideally it will be a synchronization issue, and can be solved by restarting the KDA app "kda-pyflink-starterkit"



## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.