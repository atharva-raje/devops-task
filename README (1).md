# SQS-LAMBDA-S3
## created by atharva raje

### Statement:
created a sample application that reads a message
from an SQS queue using a Lambda function
and then puts the message as a JSON object in an S3 bucket

 ## Introduction
    1.Amazon SQS (Simple Queue Service):Amazon SQS is a fully managed message queuing service that enables you to decouple and scale microservices, distributed systems, and serverless applications.
    In this application, we utilize SQS as the message queue, where messages are stored and processed by a consumer.
    2.AWS Lambda:AWS Lambda is a serverless compute service that lets you run code without provisioning or managing servers.
    In this application, Lambda functions are triggered automatically whenever a new message is available in the SQS queue and processes them, and then uploads them as JSON objects to an S3 bucket.
    3.Amazon S3 (Simple Storage Service):Amazon S3 is an object storage service.In this application,we used it to store messages in the form of JSON objects.
### Workflow
    1.Messages are sent to an SQS queue
    2.When a new message is detected in SQS queue, the Lambda function is triggered automatically.
    3.The Lambda function retrieves the message from the SQS queue, processes it, and converts it into a JSON object.
    4.The processed message, is uploaded to an S3 bucket for storage.




## Installation



#### AWS Toolkit:
To install the AWS Toolkit for Visual Studio, follow these steps:

    1.Open Visual Studio: Launch Visual Studio on your computer.
    2.Open Extensions: Go to the "Extensions" menu at the top of Visual Studio and select "Manage Extensions."
    3.Search for AWS Toolkit: In the Extensions window, search for "AWS Toolkit" using the search bar at the top right corner.
    4.Install AWS Toolkit: Find the AWS Toolkit for Visual Studio in the search results and click the "Download" button next to it.
    5.Follow Installation Steps: Follow the prompts to complete the installation process. 
    You may need to restart Visual Studio after the installation is complete.
    6.Configure AWS Credentials: Once the toolkit is installed, you'll need to configure your AWS credentials in Visual Studio. Go to the "AWS Explorer" window, 
    which should now be available in Visual Studio after installing the toolkit. Follow the prompts to enter your AWS Access Key ID and Secret Access Key.

#### AWS Command Line Interface (CLI):
    1.Visit the AWS CLI documentation page and download AWS CLI 
    2.Verify AWS CLI Installation:open a command prompt and run "aws --version"
    3.Configure AWS CLI:Enter the command "aws configure" in the command prompt.
    Enter your AWS Access Key ID and Secret Access Key when prompted. These credentials belong to an IAM user.Enter the AWS region
#### Terraform:
    1.Visit the Terraform download page,Download the Terraform for Windows.Terraform is distributed as a zip archive.
    2.Extract the contents of the zip archive to a directory of your choice
    3.Right-click on the "Start" button and select "System", click on "Advanced system settings",click the "Edit" button,
    Click the "New" button and add the path to the directory where Terraform is installed,
    Click the "New" button and add the path to the directory where Terraform is installed
    4.Verify the Installation:Open a new command prompt window
    5.Run the following command to verify that Terraform is installed and accessible from the command prompt:"terraform version",
    you should see the version number displayed in the command prompt.
### AWS Account
    1.sign up for aws Account
    2.Create a New IAM User
    3.After creating the user, you'll be presented with the user's access key ID and secret access key.Add these credentials to vs.net
   



## Documentation
#### Manual Inplementation
    1.Sign in to the AWS Management Console as IAM user
    2.In the Simple Queue Service (SQS)  dashboard, click on the "Create Queue" button,Enter a name for queue.
    3.In the S3 (Simple Storage Service) bucket dashboard, click on the "Create bucket" button.
    Enter a unique name for your bucket. Bucket names must be globally unique across all of AWS.
- now u can either use the inbuilt code editor to write lambda functions in python or java (or) 
- Go to Vs.net select the the template ,AWS Lambda Poject and click on next ,enter a name for lambda function,click on create and choose "Simple SQS Function" as blue print
- Lambda function code has "lambda_handler" and it has 2 parameters event and context.
- write the relevant code for achieveing the task using the inbuilt libraries in awstookit
- the zip the lambda file and publish it to the aws account using the awstoolkit

##### To add a trigger to an AWS Lambda function that is invoked by an SQS (Simple Queue Service) queue, follow these steps
    1.Select the Lambda Function: Click on the Lambda function to which you want to add the SQS trigger.
    2.In the Lambda function's configuration page, scroll down to the "Add triggers" section.Click on the "Add trigger" button.
    3.Select "SQS" from the list of trigger types and select the queue to add trigger.
    4.Click "Add" to add the SQS trigger to your Lambda function.
    5.click "Save" to apply the changes to your Lambda function.
- then we can send a message through the sqs queue and it will trigger the lambda function 
- then the lambda function will process the message and convert the string  to a  json file using json methods and then load it into the s3 bucket using putobjet method 

### IAC(Terraform)
- Terraform is an open-source infrastructure as code software tool created by HashiCorp. 
- It allows users to define and provision data center infrastructure using a declarative configuration language. 
- With Terraform, you can describe the components of your infrastructure, such as virtual machines, networks, and storage, in code rather than through manual processes. 
- terraform is used to automate the creation of various aws resources like the s3 bucket and sqs queue and also publish the lambda into the aws acoount and add a trigger related sqs queue that is created
- basically terraform allows us to automate most of the manually process which was described earlier in the documentation
### terraform Inplementation
now lets talk briefly about how i went through creating the code for automating the genration of resources

- Before you deploy or create the sample application , make sure you have the following:
  
  An AWS account
  
  Terraform installed on your local machine
  
  AWS CLI configured with appropriate credentials
- then we need to write the configuration file for generating the infrastructurein a aws account in a .tf file
- we can use the terraform provider to get the code needed for creating the different aws resources
- using the help of provider we create a sqs queue and s3 bucket dynamically 
- then we create polices which contain the roles and permissons to help access the s3 bucket and sqs queue respectively
= IAM roles and permissions for the Lambda function to access SQS and S3 are 

    1.SQS queue:ReceiveMessage.
    2.S3:GetObject,PutObject.
    3.Logs:CreateLogGroup,CreateLogStream,PutLogEvents.

- then we create a lambda fucntion and provide the various parameters like name,version,role, ide Etc 
- we also provide the zip lambda file which contains our lambda function for the application
- we add the policies we created to the lambda function so that it can acces the sqs and s3 bucket
### Deploying and testing the Application
    1.Run `terraform init` to initialize the Terraform project.
    2.Run `terraform apply` to create the AWS resources 
    3.Test the application by sending messages to the SQS queue by
    Open command prompt and enter the below command to send message to queue
    -- aws sqs send-message --queue-url "QUEUE_URL" --message-body "This is a test message" and confrim from cloudwatch whether the lambada triggered or not
    4.you can also test the applicatio by usig the aws console to send message from the sqs queue that was created after running the file and confirming from cloudwatch whether lambda was triggered or not
    5.there are 2 lambda files in the sample application the lambda(awsconsole) file is for when input message is in json format and the lambda file is for when message is in string format

###observation made during the creation of application
- if the user wants to create mutliple instace of the code on the same aws account user must change the names of the resources in the code for there can exist only one uiquely named resource in account
### comments on the arthitecture and suggestion for improvement if possible
- firstly the choice to opt for a serverless arthitecture is a fairly big plus in iteself since server arthitectures like lambda 
take away the burden of constantly worrying about scablitly and finding the right configuration for the code u want to run
- serverless arhitecture automatically configures iteself based on the type of code the user is running and also auto scales based on the traffic it is expriencing and then down scale when the extra resources are not required unlike ec2 instance which need to be deactivated manually
- another best choice in the structure of application is choosing terraform as the IAC since terraform is a independent iac which is not associated with any of the cloud platform like cloudformation
is to aws.it provides us with the flexiblity of being able to use the same code with different providers or even use the resources of different providers at the same time to create every effiective code for auomation
- in terms of improvement since this a serverless arthitecture there is no big improvement that can  be implemented which comes to my mind as everthing server related is handled by aws lambda and terraform 
- of course in terms of improvement the code could always be improved to have better error handling and better speifieced way fo storing the data other than the default way but that would cause and significant change in the design
- and we can ofcourse built a pipeline to efficetively reduce our task to a single click of the buttona and since lambda is a serverless arthitecture we wont even have to worry about server cnfigurations but i am still learning on how to implement pipelines into the application and i regret for not being able to implement them in time but since they are not the primary task speifieced inthe pdf i hope wont affect my performance

## thank you for reading!!


