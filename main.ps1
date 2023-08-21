# -----------------------------------------------------------------------------------
# Header
# -----------------------------------------------------------------------------------
# Programname: PS-SetUserPreferences
# Current version: v0.1
# Owner: C. Huebner
# Creation date: 2023-08-21
# -----------------------------------------------------------------------------------
# Changes
#
# -----------------------------------------------------------------------------------
# Parameters
# -----------------------------------------------------------------------------------
# Color theme (default: 0 - dark, 1 - light)
[int]$colorTheme = 0;
# Date format (default: yyyy-MM-dd)
[string]$dateFormat = "yyyy-MM-dd";
# Debug mode (only messages will shown, no action applied)
[boolean]$DEBUG = $true;
# -----------------------------------------------------------------------------------
# Main function
# -----------------------------------------------------------------------------------
function main() {

    Write-Host "Start with the user preferences (dark/ light theme, date format, show files extensions)..." -ForegroundColor White;
    if (!$DEBUG) {

        # Set the theme
        REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
            /v AppsUseLightTheme /t REG_DWORD /d $colorTheme /f;
        REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
            /v SystemUsesLightTheme /t REG_DWORD /d $colorTheme /f;
        
        # Change the date format
        REG ADD "HKEY_CURRENT_USER\Control Panel\International" /v sShortDate /t REG_SZ /d $dateFormat /f;

        # Hide file extensions for known file types
        REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
            /v HideFileExt /t REG_DWORD /d 0 /f;

        if(((Get-WmiObject -class Win32_OperatingSystem).Caption | Select-String "Windows 11") -ne $null) { $winVersion = "Win11"; }
        else { $winVersion = "win10" };

        # Settings for windows 11
        if ($winVersion -eq "win11") { 
        
            # Set the old context menu (after right click)
            REG ADD "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve; 
        }
    }
    Write-Host "Finish with the preferences (see above).`n" -ForegroundColor DarkGreen;

    # User data policity settings
    # ----------------------------

    Write-Host "Start with the individual data policity setting (deny all)..." -ForegroundColor White;
    if (!$DEBUG) {

        # Windows policity
        # ----------------
        # Turn off website access of language list
        REG ADD "HKEY_CURRENT_USER\Control Panel\International\User Profile" `
        /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f;
        # Turn off app launch tracking by windows
        REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
        /v Start_TrackProgs /t REG_DWORD /d 0 /f;
        # Disable speech recognition
        REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" `
        /v HasAccepted /t REG_DWORD /d 0 /f;

        # Turn off inking & typing personalization
        REG ADD "HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization" `
        /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f;
        REG ADD "HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization" `
        /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f;
        REG ADD "HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization\TrainedDataStore" `
        /v HarvestContacts /t REG_DWORD /d 0 /f;
        REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Personalization\Settings" `
        /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f;

        # Disable tailored experiences with diagnostic data
        REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy" `
        /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f;

        # App Policity
        # -------------
        # Permit Apps to access to the location
        REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" `
        /v Value /t REG_SZ /d "deny" /f;
    }
    Write-Host "Finish with the individual data policity settings.`n" -ForegroundColor DarkGreen;

    return $true;
}
# Entry point for the main function
try {

    main;
}
catch {

    $e = $_.Exception;
    $line = $_.InvocationInfo.ScriptLineNumber;
    $msg = $e.Message;

    Write-Error "In script main.ps $($msg) see line $($line)" -Category InvalidOperation -TargetObject $e;
}
finally {

    #    Write-Host "Done";
}