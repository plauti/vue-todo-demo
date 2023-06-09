# Getting started
To get started with building a Salesforce frontend using Vue, run `cd ./force-app/ui` 
and make sure to have all dependencies of the frontend installed, by running `npm install`.

# Local Dev Server
To start the local dev server, first connect it to a Scratch Org to be able to access Apex classes from your Vue application.

Prerequisite, use SFDX to create a scratch org and push this project to it.
Run `npm run sf:connect` to connect your backend.

Start the webserver by `cd ./force-app/ui` and `npm run dev`. 

# Building and Pushing
To build the frontent assets and publish them into the Static Resources directory:
Run `cd ./force-app/ui` and `npm run build`. 
After this completes, you should be able to push the static resource to your org using SFDX.
