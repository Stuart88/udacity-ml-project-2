![python integration workflow](https://github.com/Stuart88/udacity-ml-project-2/actions/workflows/pythonapp.yml/badge.svg)

# Overview

This is a Flask ML web application project, with a makefile prepared for linting and testing in Continuous Integration, and an Azure yml file prepared for Continuous Deployment in an Azure pipeline. 

## Project Plan

#### Trello Board
https://trello.com/b/ApLkvcC4/udacity-devops-course

#### Spreadsheet
https://github.com/Stuart88/udacity-ml-project-2/blob/main/project-management-template.xlsx

## Instructions

The deployed CI/CD pipeline will work like so:
 - Code is commited to repository via git commit/push
 - CI process runs linting and testing to ensure the update is going to work
 - CD process builds and deploys the application to the existing web app

# Getting Started
## Create an SSH key

In Azure Portal bash CLI, run the following command:
```bash
ssh-keygen -t rsa
```
Prompts can be left blank.
In the outputted text find the public key path, it will look something like:

```bash
Your public key has been saved in /home/xx<username>xx/.ssh/id_rsa.pub
```

Display the public key by running the cat command with the public key path:

```bash
cat /home/xx<username>xx/.ssh/id_rsa.pub
```

A complete example of this can be seen below:

![image](https://user-images.githubusercontent.com/23031872/226165392-0bd9e331-d19c-40d6-a50b-9f7a7f71c317.png)

Next you must copy the public key into your GitHub account.

## Copy Public Key to GitHub

In your GitHub account, navigate to **Settings**, then find **SSH and GPG Keys** in the side menu

Click **New SSH Key**

![image](https://user-images.githubusercontent.com/23031872/226165521-655ac981-62cf-448d-a46a-e69b57bbbb24.png)

Copy the key from your Azure bash terminal into the GitHub SSH key box, then click **Add SSH Key**

![image](https://user-images.githubusercontent.com/23031872/226165562-f0bfc350-4d38-411d-a52f-0d2ed7ad0526.png)

Now you will be able to clone the project from your GitHub account into the Azure Portal bash CLI

## Clone the Repository

Copy the SSH clone path from your GitHub repository, then run the Azure bash command to clone it into your cloud terminal:

```bash
git clone git@github.com:xxgitaccountxxx/udacity-ml-project-2.git
```

Be sure to use the SSH clone url, not HTTPS
As a check, you can then run the `ls` command to see that the project repo has been cloned

![image](https://user-images.githubusercontent.com/23031872/226165616-f8403b56-08d2-43c2-b26f-cf2acfe52625.png)

Now we can check the project builds as expected.

## Install, Lint and Test in a Virtual Environment 

It is important to use a virtual environment to ensure the configuration and tools being used are what the project expects.

Navigate into the project directory:

```bash
cd udacity-ml-project-2
```
Then run the following commands:

```bash
make setup
source ~/.udacity-ml-project-2/bin/activate
make all
```

These steps will create a virtual environment, navigate into the environment, then build the project as defined by the makefile, which runs linting and testing on the underlying code.

The result should be as below:

![image](https://user-images.githubusercontent.com/23031872/226165695-bb1aeeaf-79c0-4645-8158-4ea2b4ab4196.png)


Now we are confident that the project is in good order, and so we can move onto creating a build pipeline in Azure.

## Setup Azure Pipeline

Open your Azure DevOps organisation account.

First, ensure the **Allow public projects** policy is set to **On**

![image](https://user-images.githubusercontent.com/23031872/226165714-8926edcf-ede5-4cf0-8b29-f9ab4a1f6fb8.png)

Then create a new project and ensure **Visibility** is set to **Public**

![image](https://user-images.githubusercontent.com/23031872/226165792-d7a57c53-f265-4249-bf25-db4853ce60ac.png)

Now go to project settings and add a GitHub connection to your project repository

![image](https://user-images.githubusercontent.com/23031872/226165797-5543fb6b-7717-4c38-919e-1f14c89866a5.png)

Now that we have connected Azure DevOps to GitHub, we will need to create build a web app and a build agent for deploying the project each time the pipeline runs.

## Create a web app using the Azure Portal bash CLI

In the same bash CLI folder as you were in before, enter the following command:

```bash
az webapp up --name <YOUR WEB APP NAME> --resource-group Azuredevops --runtime "PYTHON:3.10"
```

This will create and launch a web app for the project.

Upon completion, you can view the project live on:
`https://<YOUR WEB APP NAME>.azurewebsites.net`

![image](https://user-images.githubusercontent.com/23031872/226165836-ce8160e9-c1a3-4237-a472-790b5165f5f6.png)

At this point, if you have correct user privileges in your bash shell, you can run `./make_predict_azure_app.sh` to obtain results from the ML application.

**Be sure to first modify the `make_predict_azure_app.sh` file so that it navigates to the URL of the web app you just created.**

Here is an example of the result:

![image](https://user-images.githubusercontent.com/23031872/226165877-5b2dd214-c948-4300-92ae-e490973fac5a.png)

## Create a Service Connection

In Azure DevOps, navigate to Service connections in the settings menu, and create a new service connection.

Select Azure Resource Manager, then name it myServiceConnection and leave everything else as default.

Ensure **Grant access permission to all pipelines** is checked :heavy_check_mark:

![image](https://user-images.githubusercontent.com/23031872/226165944-657b7c80-e3d8-4720-a32e-79e48c0656d7.png)

![image](https://user-images.githubusercontent.com/23031872/226165947-a22c0a71-407e-4be9-bef1-61367394dcc7.png)

## Create an Agent Pool

First, create a new Personal Access Token will full permissions granted in your Azure DevOps account. Don’t forget to make a note of the token.

Next, go **settings** and **Agent pools**, then create a new **self-hosted** agent pool called myAgentPool, with **full access permissions granted**.

![image](https://user-images.githubusercontent.com/23031872/226165983-5f1721a0-b2cc-4f80-a00a-70d37da214b4.png)

Next we need to create a Linux Virtual Machine in the Azure Portal for running the build and deployment jobs.

## Create a Linux VM

In Azure Portal, create a new Azure virtual machine named myLinuxVM, using Ubuntu Server 20.04, password authentication (create your own username and password), and allow public inbound ports SSH(22)

![image](https://user-images.githubusercontent.com/23031872/226166013-88a17142-579f-47d3-9e4b-b73e8400e1ef.png)

Leave all else as default, then **Review + Create**

Now we can install the build agent on the virtual machine

## Install a Build Agent on the VM

Note the public ip address of the new VM, then use the bash terminal to navigate into the vm using the command:

```bash
ssh <YOUR VM USERNAME>@xx.xx.xx.xx  the public ip address
```

Once inside the vm, perform the following commands to setup Docker

```bash
sudo snap install docker
sudo groupadd docker
sudo usermod -aG docker $USER
exit
```

Restart the VM from within Azure Portal

Now go back to Azure DevOps agent pool, create a new agent, select Linux, then copy the link for downloading the agent. We will use this link in the vm we just created.

![image](https://user-images.githubusercontent.com/23031872/226166060-04b03ba1-058e-4b5c-9400-17ad6f1610e8.png)

Use the ssh command to navigate back into the vm, then run the following commands:

```bash
curl -O https://<download-url-you-just-copied>../the-file-name...tar.gz
mkdir myagent && cd myagent
tar zxvf ./the-file-name...tar.gz
./config.sh
```

This will download and unpack the build agent, then begin the configuration process.

In the config process, press Y to accept the agreement, then provide your Azure DevOps org URL, the access token you made earlier, and the name of the agent pool we made earlier.

The image below shows how this should look.

![image](https://user-images.githubusercontent.com/23031872/226166084-d59d1bfa-2b62-4318-a07f-f00a004ecdd7.png)

Now run the following commands to complete the agent installation and start the service:

```bash
sudo ./svc.sh install
sudo ./svc.sh start
```

Finally, run the follow specific commands for handling this python application:

```bash
sudo apt-get update
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.10
sudo apt-get install libpython3.10
sudo apt-get install python3.10-venv
sudo apt-get install python3-pip
sudo apt-get install python3.10-distutils
sudo apt-get -y install zip
```

To overcome pylint problems, run the following:

```bash
pip install pylint==2.13.7
pip show --files pylint
echo $PATH
export PATH=$HOME/.local/bin:$PATH
echo $PATH
```

Now in Azure DevOps you can navigate to the Agents tab of **myAgentPool** to confirm the newly created agent exists.

![image](https://user-images.githubusercontent.com/23031872/226166108-ad0fef7c-7287-4057-b9e2-b53b92c78180.png)

Next we will create an Azure deployment pipeline.

## Create an Azure Deployment Pipeline

In Azure DevOps, navigate to **Pipelines** and **Create a Pipeline**

Select **GitHub**, and it should show you a list of repositories from your GitHub account which we connected earlier. Select the correct repository for this project.

The pipeline file already exists in the project. It will be shown on the next screen.

In the file, modify webAppName to show the name of the web app you created in the _Create a web app using the Azure Portal bash CLI_ section above.

![image](https://user-images.githubusercontent.com/23031872/226166137-d70939b5-9eb2-4ee1-b22c-816574cfc237.png)

Then click **Save and Run**, and the first pipeline job will start automatically.

You might be asked to give permissions during the Deploy stage. If so, please do this:

![image](https://user-images.githubusercontent.com/23031872/226166159-055dc150-f32e-45aa-bcf3-db88b5d4675a.png)

Finally, the deployment will complete.

![image](https://user-images.githubusercontent.com/23031872/226166167-d1016893-85ea-4c04-abbd-2befb8b08fe0.png)

If you encounter any errors, click on the failed part and inspect any console output.

## CI/CD Pipeline is Complete

Now, any time changes are committed to the main branch of the project repository, the pipeline will test and lint the project, then automatically deploy the changes to the live web app.

## Logging

To view a tail log of your web app, run the following in the Azure Portal bash terminal:

```bash
az webapp log tail -n <YOUR WEB APP NAME>
```

This will produce a live tail log of the app while it runs. 

For example, here we can see the log result after running the script `./make_predict_azure_app.sh` from another bash terminal:

![image](https://user-images.githubusercontent.com/23031872/226166224-fa1f82e3-c6c7-4635-94f3-ec5634b61fa7.png)


## Enhancements

To improve the project in future, it would be best to set up staging and production environments. The CICD pipeline would automatically deploy to staging, whereas prod should be limited to manual triggering.

## Demo 

https://youtu.be/a7tO42ngET0

