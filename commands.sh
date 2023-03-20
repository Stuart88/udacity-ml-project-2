# A script for cloning, building and deploying the 
# project automatically， after ssh keys have been generated

git clone git@github.com:<REDACTED>/udacity-ml-project-2.git
cd udacity-ml-project-2
git pull
make setup
source ~/.udacity-ml-project-2/bin/activate
make all
az webapp up -n udacityassessmentappmlstuartca