# PSForms

## Overview

A Simple way to generate Forms to via PowerShell, [PSHTML](1) and run them with the [Polaris Web Server](2).

## Installation

Currently, the only way is to build form source, I will be uploading to the PowerShell gallery shortly

## Examples

``` PowerShell
New-PSFormsSite -OutputPath 'D:\PSFormsSite\'

$Content = @()

$Content += New-PSFormsInput -Name "mobile" -DisplayName "Mobile Number" -InputType "tel" -ToolTip "Please enter your new mobile number."
$Content += New-PSFormsInput -Name "homeSite" -DisplayName "Your Home Page" -InputType "url" -Placeholder "https://github.com/YourUsernameHere/"
$Content += New-PSFormsInputTextBox -Name "bio" -DisplayName "Your Bio" -Rows 4 -Columns 10 -ToolTip "A Short bio to display on our internal staff directory."
$Content += New-PSFormsInputMultipleChoice -Name "office" -DisplayName "Your Main Office Address" -ToolTip "If you work on multiple sites select the one that you spend the most time at." -Options @("34, Some Street, Town, Bedfordshire, LXO1 111", "39, Some Avenue, Leeds, West Yorkshire, LS1 111")

New-PSFormsSimpleForm -Name "DetailsUpdate" -Header "Update your Details" -Description "Use this form to update your details in Outlook and the Staff Directory." -Content $Content -SucessMsg "Your Details have been updated, this may take up to 5 days to roll out to everyone in the organisation." -ErrorMsg "Something went wrong, Please contact the service Desk on 'Some Number' for assitance." -SiteRoot 'D:\PSFormsSite\'
```

The above example creates a new PSForms site with a simple form tto update people's contact detaisl. This example is missing the implmentation, which needs to be setup inside `D:\PSFormsSite\Scripts\DetailsUpdate.Submit.ps1` so that Polaris will process the result of the form.

``` PowerShell
D:\PSFormsSite\Start.ps1
```
The `Start.ps1` will start the Polaris Server accoding to the default settings in `config.json`


## [Changelog](Changelog.md)

## To Do
- [ ] `New-PSFomsHomePage` - Adds an optional homepage template that will be used as the default route endpoint e.g. `http:://servername:port/`


## Ideas
Aproval requires a GUID generated at request time which relates to a json file (e.g. `.\Approval\UpdateMobileNumber.c0aab650-f29c-4870-b0fb-4b0b19d4d449.json`) where the data needed for the script will be stored. This file will be created within the submit script.

### Routes
- `/$FormName/`= The Form
- `/$FormName/Submit` = The enpoint to submit the form
- `/$FormName/Approve?request=$GUID` = Optional Endpoint for when needing form approval

### Site Layout:
- `.\Views\` - ps1 template files used to genrate the layout files.
    - `.\Views\layout.ps1` - Contains the basic layout to be customised, intially generated but never updated if found. Requires Arguments for content and Page Title
    - `.\Views\$FormName.Form.htm` - The form definition stored as HTML
    - `.\Views\$FormName.Sucess.htm` - The Sucess Page for when a form is sucessfully submitted.
    - `.\Views\$FormName.Error.htm` - The Error Page for when a form errors.
    - `.\Views\$FormName.Approve.htm` - The Approval page template.
- `.\Scripts\` - Where the Scripts used to drive the forms will be located.
    - `.\Scripts\RouteImport.ps1` - Auto generated to import all other Scripts
    - `.\Scripts\$FormName.Form.ps1` - Auto generated but can be updated
    - `.\Scripts\$FormName.Submit.ps1` - To Edit by the Admin to actually do something
    - `.\Scripts\$FormName.Approve.ps1` - Optional defines the Approval actions
- `.\Cards\` - Where generated form description cards are located.
    - `.\Cards\$FormName.htm`
- `.\Approval\` - Where approval json files are stored.
    - `.\Approval\$FormName.$GUID.json`
- `.\Static\` - A Place to host static files e.g. css, favicon, and js files.
- `.\Start.ps1` - An intially generated file to import everything in and then run the Polaris Server Thread.
- `.\Stop.ps1` - An intially generated file to stop the Polaris Server and can optionally clean anything up as required
- `.\Config.json` - Provides a nice place to store some config settings that will be read into `.\start.ps1`

## License - MIT License

Copyright 2019 Liam Townsend

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[1]: https://github.com/Stephanevg/PSHTML
[2]: https://github.com/PowerShell/Polaris