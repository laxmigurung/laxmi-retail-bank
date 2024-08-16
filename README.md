# laxmi-retail-bank

Purpose

This workload reduces the effort to manually deploy the application to AWS Beanstalk and interaction with the beanstalk UI. Within the EC2 instance, connection to jenkins and  beanstalk can be established and via the jenkins we can now deploy the application to beanstalk. This automation from the server to jenkins and beanstalk makes the application live and running.

I clone the workload repo from the GitHub. I also created a new access key under my IAM role. 
An access key grants programmatic access  or CLI-based access to AWS APIs to your resources. The access key ID is a unique identifier that authenticates and track users within the AWS environment, similar to username. The secret access key is a cryptographic key that pairs with the access key ID and is used t o sign requests and confirm the user’s identity. 

In my EC2 instance, I install required jenkins configurations and start it. Once the jenkins is actively running in our server, I can login to jenkins using my public-ipaddress:<jenkins-port>. As this was new instance where I needed to set the inbound rules for incoming traffic coming from jenkins. 
In the jenkins, I created a mutibranch pipeline and connected it with GitHub repo for the project. Multibranch can be very useful when your repo has multiple branches (in the case where 3-4 developers are contributing to the same repo), this pipeline builds and creates as many new jobs as there exists JekinFiles in each branch.

As the project builds in Jenkins, I installed AWS CLI in my EC2 with the following commands.
$curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$unzip awscliv2.zip
$sudo ./aws/install
$aws --version
In the above command using curl call, I made a GET request to the awscli url where the zip file is located and saved the file with name provided in -o <file-name>. Following the download, the rest commands unzips the file(I had to install the unzip to my EC2) and install the AWS CLI.

With the help of AWS CLI now we can login to Jenkins, set new passwords and navigate to the multibranch pipeline. Interestingly within my EC2 the connection was to jenkins was established and I was able to get all the details related to jenkins where I have the application built with the souce code also.

In this process we activate the python virtual environment. This step was important in our case because we are using python 3.7 and we know that our application source’s dependency is this version. Without activating this venv, we might run into issue such as configuration drift because of mis match of the python version available in our EC2.

The next step is to install awsebcli which is AWS Elastic Beanstalk CLI. These availability of CLI are very useful in my opinion as one doesn’t need to manually interact with the UI and saves so much time for the person to ru/build/test/deploy  everything in one stop. 
Now configuration to AWS CLI from Jenkins is required and this is where I needed the access key that was created earlier from IAM. Once the configuration is set, initialized the Elastic Beanstalk.
We then navigate to JenkinsFile in our source code and add a new stage 'Deploy' and push the  change to our repo in GitHub. In the Jenkins, I ran the build again and jenkins pulls the latest source code with deployment stage.

<img width="381" alt="Screenshot 2024-08-15 at 12 15 02 AM" src="https://github.com/user-attachments/assets/6115df1c-8de7-4e1d-b09a-00bf3041c48d">



With all the configuration in place with Jenkins, AWS CLI, updated code, AWS EB CLI, the application is loive running in elastic beanstalk.

The system_resources_test.sh script we added in the source code also runs in the backgroud and check the CPU usage, memory consumption, disk usage. This runs during test stage in Jenkins.

<img width="1512" alt="Screenshot 2024-08-15 at 12 18 15 AM" src="https://github.com/user-attachments/assets/ee947bfc-94d4-4657-97bd-7182ed654fb6">
<img width="998" alt="Screenshot 2024-08-15 at 11 53 19 PM" src="https://github.com/user-attachments/assets/21e3d7f7-88b6-4190-9a31-8dd5e3cc773a">

