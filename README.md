# PS-SetUserPreferences

## Set the windows user preferences (data policy, theme, date format, etc.) for Windows 10/ 11 machines

This tool set the Windows theme (dark by default), the date format and the shows the file extensions. Only for Windows 11 systems: the "old" context menu after right click will enabled. 

The following data policy settings will made:

* Turn off website access of language list
* Turn off app launch tracking by windows
* Disable speech recognition
* Turn off inking & typing personalization
* Disable tailored experiences with diagnostic data
* Not permit apps to access to the location

## Notifications

* Maybe a reboot is needed that the data format will changed for example.

## How to install the PS-SetUserPreferences program

1. Clone this project
2. Edit the main.ps1 as following:
    - Set the Debug flag to false if the actions should be applied
    - Change to color what do you prefer (light or dark theme)
3. Save the main.ps1 after the modifications
4. Run the PS script with the user that should get this preferences
