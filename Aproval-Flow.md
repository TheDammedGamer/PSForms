# Approval Flow

User Submits Initial Form -> Submit Success ->  Creates Approval Json file -> Send an email to Approver -> Result is Sucess Submit or Error

Visits `/$name/Approve?request=$GUID` -> Loads the Json or Errors -> Check that user can Approve-> Injects Message to approve in HTML -> Returns HTML to User

Visits `/$name/Approve/Submit?guid=$GUID;option=Yes` -> Runs Action to do When Approved -> Email's User to Tell them that the request has been Approved -> Delete JSON file -> Returns `$name.Approve.Submit.Approve.htm` Template

Visits `/$name/Approve/Submit?guid=$GUID;option=Yes` -> Email's User to Tell them that the request has been denied -> Delete JSON file -> Returns `$name.Approve.Submit.Deny.htm` Template

# Templates
- Form.Form.ps1 - Powershell Route File
    - Form.Form.htm - Inital Form
- Form.Submit.ps1 - Powershell Route File
    - Form.Submit.htm - Success Submit HTML Template
    - Form.Submit.Send.htm - Email Full Template - Send To Approver
    - Form.Submit.Fail.htm - Submit Denied HTML Template
    - Form.Submit.Error.htm - Error Submit HTML Template
- Form.Approve.ps1 - Powershell Route File
    - Form.Approve.Form.htm - Approval Form HTML Template
- Form.Approve.Submit.ps1 - Powershell Route File
    - Form.Approve.Submit.Approve.htm - Approval Aproved HTML Template 
    - Form.Approve.Submit.Deny.htm - Approval Denied HTML Template
    - Form.Approve.Send.Approved.htm - Approval Aproved Email Full Template - Send To Inital User
    - Form.Approve.Send.Denied.htm - Approval Denied Email Full Template - Send To Initial User