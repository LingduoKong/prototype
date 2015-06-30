# prototype

#Running the app
ruby run master_script.rb

#What this does
1. Checks commits for {issue#1234} format and extracts the number
2. Adds green fixed label on github and checks checklist item off of trello
3. Once checklist is complete, card automatically moved from "deployment to staging" to "deployment to production"
4. Email sent- still needs customization
5. Web page generated with list of issues and release
