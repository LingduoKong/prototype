1. If a commit is detected that has an issue number in a certain format (We will come up with a convention to reference issue numbers) then the corresponding issue needs to be checked off on Trello card, and the corresponding issue on Github should have a new label on it "Fixed"

2. When deployment is initiated, we would like to scan last week's commits and retrieve comments with a certain format that reflect business features, parse those, and auto generate an email with those features, the issues fixed, and send to a pre-determined email list

3. We should create a web page with the breakdown of all issues and business features finished over releases, along with their respective release number

4. Automatically move all cards under Deployment to Staging to 
Deployment to Production at the end of each week or when the deployment is successful (triggered by CI)


5. Automatically move all cards under Deployment to Production to Completed, when a new production deployment happens.

6. Automatically move all cards from Completed to Archived, 
once a new set of cards are moved into Completed.
