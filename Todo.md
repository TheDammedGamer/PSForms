
## To Do
- [ ] `New-PSFomsHomePage` - Adds an optional homepage template that will be used as the default route endpoint e.g. `http:://servername:port/`
    - [x] Template Created
    - [ ] Need to Setup the route.
- [x]Create a PSObject Containing the Result of the Form
- Approval Form
    - [ ] Display What the user is approving in the Main Form. RO view.
    - [ ] Allow user to Accept or Deny on the webpage only.
    - [ ] Allow Extra fields for the Approver to Fill out e.g. Budget code.
    - [ ] Access denied Error
- [x] `New-PSFormsInputRadialGroup` - Creates a radial group so only one option can be selected
- Simple Form
    - [ ] Add Optional Deny which boot the user back to the form, but now with a Alert Message; for a thats not allowed but here fill out the form again type of thing.
- All Forms
    - [ ] Change the HTML to dynamic genration using Inport/Export-CliXml for the form params
    