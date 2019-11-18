# PSForms

## Overview

A Simple way to generate Forms to via PowerShell, [PSHTML](1) and run them with [Polaris](2).

## Installation

## Examples

## [Changelog](Changelog.md)


## To Do
- [ ] `New-PSFomsHomePage` - Adds an optional homepage template that will be used as the default route endpoint e.g. `http:://servername:port/` && `http:://servername:port/index`



## Ideas
Aproval requires a GUID generated at request time which relates to a json file (e.g. `.\Approval\UpdateMobileNumber.c0aab650-f29c-4870-b0fb-4b0b19d4d449.json`) where the data needed for the script will be stored. This file will be created within the submit script.

### Routes
Optionally Add a Prefix
- `/$FormName/` or `/PSWebForms/$FormName/` = The Form
- `/$FormName/Submit` or `/PSWebForms/$FormName/Submit` = The enpoint to submit the form
- `/$FormName/Approve?request=$GUID` or `/PSWebForms/$FormName/Approve?request=$GUID` = Optional Endpoint for when needing form approval

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

[1][https://github.com/Stephanevg/PSHTML]
[2][https://github.com/PowerShell/Polaris]