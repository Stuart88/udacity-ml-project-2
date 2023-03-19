# Overview

<TODO: complete this with an overview of your project>

## Project Plan
<TODO: Project Plan

* A link to a Trello board for the project
https://trello.com/b/ApLkvcC4/udacity-devops-course
* A link to a spreadsheet that includes the original and final project plan>
https://github.com/Stuart88/udacity-ml-project/blob/main/project-management-template.xlsx

## Instructions

<TODO:  
* Architectural Diagram (Shows how key parts of the system work)>

The deployed CI/CD pipeline will work like so:
 - Code is commited to repository via git commit/push
 - CI process runs linting and testing to ensure the update is going to work
 - CD process builds and deploys the application to the existing web app

<TODO:  Instructions for running the Python project.  How could a user with no context run this project without asking you for any help.  Include screenshots with explicit steps to create that work. Be sure to at least include the following screenshots:

I do not understand how I am supposed to include screensots in a README file. This is quite a ridiculous assessment.

* In Azure App cli, git clone the repo from its existing github location
* Navigate via cli into the cloned repository
* Run `make all` to prepare, lint and test the project
* Correct any issues if `make` fails
* Run `az webapp up -n <MyAppName> -g <MyResourceGroup>` to create and deploy as a web app in your Azure subscription
* Test the app by runnin 



* Project running on Azure App Service

* Project cloned into Azure Cloud Shell

* Passing tests that are displayed after running the `make all` command from the `Makefile`

* Output of a test run

* Successful deploy of the project in Azure Pipelines.  [Note the official documentation should be referred to and double checked as you setup CI/CD](https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python-webapp?view=azure-devops).

* Running Azure App Service from Azure Pipelines automatic deployment

* Successful prediction from deployed flask app in Azure Cloud Shell.  [Use this file as a template for the deployed prediction](https://github.com/udacity/nd082-Azure-Cloud-DevOps-Starter-Code/blob/master/C2-AgileDevelopmentwithAzure/project/starter_files/flask-sklearn/make_predict_azure_app.sh).
The output should look similar to this:

```bash
udacity@Azure:~$ ./make_predict_azure_app.sh
Port: 443
{"prediction":[20.35373177134412]}
```

* Output of streamed log files from deployed application

> 

## Enhancements

<TODO: A short description of how to improve the project in the future>

## Demo 

<TODO: Add link Screencast on YouTube>


