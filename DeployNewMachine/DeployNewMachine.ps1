#
# FILE: DeployNewMachine.ps1
#
# DESCRIPTION:  
#   As I was getting new machines every now and then, I thought about doing a script
#   which would cover the basic software-installation pretty smoothly. Voilá, grabbed 
#   some code done by a colleague at the time and went at it. 
#
# AUTHOR: marski
# VERSION: 1.1
#
# 1.0 2018-05-31 - Script created by marski
# 1.1 2021-09-02 - Updated with current urls, added 7zip.
# 1.2 2021-09-09 - Added Telegram portable, removed arsclip due to brokeness.
#
# USAGE: 
#     Open file using powershell, enter corresponding selection for what you want to be installed.
#     "Set-ExecutionPolicy unrestricted" has to be set, otherwise script wont run.
#
#
#
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   
   # Exit from the current, unelevated, process
   exit
 }

 #############


$path = "C:\temp"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

##########################################################################################################################################
# Change URI paths for new versions

# Notepad2-mod
$URI_1 = "https://github.com/XhmikosR/notepad2-mod/releases/download/4.2.25.998/Notepad2-mod.4.2.25.998.exe"

# Greenshot
$URI_2 = "https://github.com/greenshot/greenshot/releases/download/Greenshot-RELEASE-1.2.10.6/Greenshot-INSTALLER-1.2.10.6-RELEASE.exe"

# Google Backup and Sync
#$URI_3 = "this is broken"

# KeepassXC
$URI_4 = "https://github.com/keepassxreboot/keepassxc/releases/download/2.6.6/KeePassXC-2.6.6-Win64.msi"

# mRemoteNG
$URI_5 = "https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.76.20/mRemoteNG-Installer-1.76.20.24615.msi"
#
# Notepad++
$URI_6 = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.1.4/npp.8.1.4.Installer.exe"
#
# VS Code
$URI_7 = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
#
# XNView
$URI_8 = "https://download.xnview.com/XnViewMP-win-x64.exe"
#
# Git scm
$URI_9 ="https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/Git-2.33.0.2-64-bit.exe"

# Brave
$URI_10 ="https://laptop-updates.brave.com/latest/winx64"

#ArsClip
#$URI_11 = "http://www.joejoesoft.com/cms/file.php?f=userupload/8/files/acv533.zip&c=7293f0f0955f5a71a138f6be35da8d4f"

#Skype
$URI_12 = "https://go.skype.com/windows.desktop.download"

#Handbrake
$URI_13 = "https://github.com/HandBrake/HandBrake/releases/download/1.4.1/HandBrake-1.4.1-x86_64-Win_GUI.exe"

#Chrome
$URI_14 = "http://dl.google.com/chrome/install/375.126/chrome_installer.exe"

#Firefox
$URI_15 = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"

#VLC
$URI_16 = "https://ftp.lysator.liu.se/pub/videolan/vlc/3.0.16/win64/vlc-3.0.16-win64.exe"

#7zip
$URI_17 = "https://www.7-zip.org/a/7z1900-x64.exe"

#Telegram
$URI_18 ="https://telegram.org/dl/desktop/win64_portable"

#######################################################################################

# Test if server has a pending reboot or not.
Function Test-PendingReboot
{
 if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
 if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
 if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
 try { 
   $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
   $status = $util.DetermineIfRebootPending()
   if(($status -ne $null) -and $status.RebootPending){
     return $true
   }
 }catch{}
 
 return $false
}

##########################################################################################################################################
# Option 1 - Install Notepad2-mod.

Function Run-Option1
{
$downloadedfile="C:\Temp\Notepad2-mod.4.2.25.998.exe"

Write-Host "`r`n`tDownloading Notepad2-mod..."
Invoke-WebRequest -Uri $URI_1 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling Notepad2-mod"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

##########################################################################################################################################
# Option 2 - Install Greenshot.
Function Run-Option2
{
$downloadedfile="C:\Temp\Greenshot-INSTALLER-1.2.10.6-RELEASE.exe"

Write-Host "`r`n`tDownloading Greenshot..."
Invoke-WebRequest -Uri $URI_2 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling Greenshot - this is a bit buggy"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}
##########################################################################################################################################
# Option 3 - Install Google backup and sync.
Function Run-Option3
{
#$downloadedfile="C:\Temp\installbackupandsync.zip"

Write-Host "`r`n`tThis is broken and I havent fixed it yet"
#Invoke-WebRequest -Uri $URI_3 -OutFile $downloadedfile -ErrorAction SilentlyContinue
#Write-Host "`r`n`tExpanding zip-file..."
#Expand-Archive -Path $downloadedfile -DestinationPath "C:\Temp\"
#Write-Host "`r`n`tInstalling Google backup and sync"
#$ErrCode=(Start-Process -FilePath "C:\temp\installbackupandsync.exe" -Verb runas -Wait -Passthru).ExitCode;
#Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
#Remove-Item "C:\Temp\installbackupandsync.exe" -ErrorAction SilentlyContinue -Force;
}
	
##########################################################################################################################################
# Option 4 - Install KeepassXC.
Function Run-Option4
{
$downloadedfile="C:\Temp\KeePassXC-2.6.2-Win64.msi"

Write-Host "`r`n`tDownloading KeepassXC..."
Invoke-WebRequest -Uri $URI_4 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling KeepassXC"
$ErrCode=(Start-Process msiexec.exe -ArgumentList '/i',$downloadedfile,'/quiet','/norestart' -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;

}

##########################################################################################################################################
# Option 5 - Install mRemoteNG.
Function Run-Option5
{
$downloadedfile="C:\Temp\mRemoteNG-Installer-1.76.20.24615.msi"

Write-Host "`r`n`tDownloading mRemoteNG..."
Invoke-WebRequest -Uri $URI_5 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling mRemoteNG"
$ErrCode=(Start-Process msiexec.exe -ArgumentList '/i',$downloadedfile,'/quiet','/norestart' -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}
	
##########################################################################################################################################
# Option 6 - Install Notepad++.
Function Run-Option6
{
$downloadedfile="C:\Temp\npp.7.9.2.Installer.x64.exe"

Write-Host "`r`n`tDownloading Notepad++..."
Invoke-WebRequest -Uri $URI_6 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling Notepad++"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

##########################################################################################################################################
# Option 7 - Install VS Code.
Function Run-Option7
{
$downloadedfile="C:\Temp\VSCodeUserSetup-x64-1.52.1.exe"

Write-Host "`r`n`tDownloading VS Code..."
Invoke-WebRequest -Uri $URI_7 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling VS Code"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

##########################################################################################################################################
# Option 8 - Install XNView.
Function Run-Option8
{
$downloadedfile="C:\Temp\XnViewMP-win-x64.exe"

Write-Host "`r`n`tDownloading XnView..."
Invoke-WebRequest -Uri $URI_8 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling XnView"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

##########################################################################################################################################
# Option 9 - Install git-scm.
Function Run-Option9
{
$downloadedfile="C:\Temp\Git-2.30.0-64-bit.exe"

Write-Host "`r`n`tDownloading git..."
Invoke-WebRequest -Uri $URI_9 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling git"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

##########################################################################################################################################
# Option 10 - Install git-scm.
Function Run-Option10
{
$downloadedfile="C:\Temp\brave.exe"

Write-Host "`r`n`tDownloading Brave..."
Invoke-WebRequest -Uri $URI_10 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling Brave"
$ErrCode=(Start-Process -FilePath $downloadedfile )#-ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

##########################################################################################################################################
# Option 11 - Download arsclip
Function Run-Option11
{
$downloadedfile="C:\Temp\arsclip.zip"

Write-Host "`r`n`tSorry this installation doesnt work..."
#Write-Host "`r`n`tDownloading Arsclip..."
#Invoke-WebRequest -Uri $URI_11 -OutFile $downloadedfile -ErrorAction SilentlyContinue
#mkdir "C:\Program Files (x86)\ArsClip"
#Expand-Archive $downloadedfile -DestinationPath "C:\Program Files (x86)\ArsClip"

#Write-Host "`r`n`tInstalling ArsClip"

$ErrCode=(Start-Process -FilePath "C:\Program Files (x86)\ArsClip\setup.exe" -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

##########################################################################################################################################
# Option 12 - Install skype
Function Run-Option12
{
$downloadedfile="C:\Temp\skype.exe"

Write-Host "`r`n`tDownloading Skype..."
Invoke-WebRequest -Uri $URI_12 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling Skype"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}
##########################################################################################################################################
# Option 13 - Install Handbrake
Function Run-Option13
{
$downloadedfile="C:\Temp\handbrake.exe"

Write-Host "`r`n`tDownloading Handbrake..."
Invoke-WebRequest -Uri $URI_13 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling Handbrake"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}
##########################################################################################################################################
# Option 13 - Install Chrome
Function Run-Option14
{
$downloadedfile="C:\Temp\chrome.exe"

Write-Host "`r`n`tDownloading Chrome..."
Invoke-WebRequest -Uri $URI_14 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling Chrome"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}
###################################################
# Option 13 - Install Handbrake
Function Run-Option15
{
$downloadedfile="C:\Temp\firefox.exe"

Write-Host "`r`n`tDownloading Firefox..."
Invoke-WebRequest -Uri $URI_15 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling Firefox"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

################################################
###################################################
# Option 16 - Install VLC
Function Run-Option16
{
$downloadedfile="C:\Temp\vlc.exe"

Write-Host "`r`n`tDownloading VLC..."
Invoke-WebRequest -Uri $URI_16 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling VLC"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

###################################################
# Option 17 - Install 7zip
Function Run-Option17
{
$downloadedfile="C:\Temp\7zip.exe"

Write-Host "`r`n`tDownloading 7zip..."
Invoke-WebRequest -Uri $URI_17 -OutFile $downloadedfile -ErrorAction SilentlyContinue

Write-Host "`r`n`tInstalling 7zip"
$ErrCode=(Start-Process -FilePath $downloadedfile -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

################################################

# Option 18 - Install telegram
Function Run-Option18
{
$downloadedfile="C:\Temp\telegram.zip"

Write-Host "`r`n`tDownloading Telegram..."
Invoke-WebRequest -Uri $URI_18 -OutFile $downloadedfile -ErrorAction SilentlyContinue
#mkdir "C:\Program Files (x86)\ArsClip"
Expand-Archive $downloadedfile -DestinationPath "C:\temp\Telegram"

Write-Host "`r`n`tTelegram downloaded and extracted to C:\temp\"

#$ErrCode=(Start-Process -FilePath "C:\Program Files (x86)\ArsClip\setup.exe" -ArgumentList '/S /passive /norestart' -Verb runas -Wait -Passthru).ExitCode;
#Remove-Item $downloadedfile -ErrorAction SilentlyContinue -Force;
}

################################################


While ($selection -ne 0)
{
cls
$hostname = [System.Net.Dns]::GetHostByName(($env:computerName)) | select -ExpandProperty HostName
$ipaddress = Get-NetAdapter | Where status -eq "up" | Get-NetIPAddress | Where AddressFamily -eq IPv4 | Select -ExpandProperty IPAddress
$rebootrequired = Test-PendingReboot

If ( $rebootrequired -eq $True ) {
Write-Host "`n`tReboot pending. Please restart machine at the earliest possibility."
}

# Selection options
Write-Host "`r`n`tHostname:	$($hostname)`r`n
	IP address:	$($ipaddress)`r`n`r`n	
Select one of the following options:`r`n
    1. Install Notepad2-mod`r`n
    2. Install Greenshot (a bit buggy so far).`r`n
    3. Install Google Backup and Sync (now broken).`r`n	
    4. Install KeepassXC.`r`n
    5. Install mRemoteNG.`r`n	
    6. Install Notepad++.`r`n	
    7. Install VS Code.`r`n
    8. Install XnView.`r`n
    9. Install git-scm.`r`n
    10. Install Brave.`r`n
    11. Download ArsClip (now broken).`r`n
    12. Install Skype.`r`n
    13. Install Handbrake.`r`n
    14. Install Chrome.`r`n
    15. Install Firefox.`r`n
    16. Install VLC.`r`n
    17. Install 7zip.`r`n
    18. Install Telegram portable.`r`n
    0. Exit.`r`n"

do {
    try {
        $numOk = $true
        [int]$selection = Read-Host -Prompt "Enter selection (1 to 18)"
        } # end try
    catch {$numOK = $false}
    } # end do 
until (($selection -ge -1 -and $selection -le 18) -and $numOK)

#cls
switch ($selection)
{
	1 { Run-Option1 }

	2 { Run-Option2 }

	3 { Run-Option3 }

	4 { Run-Option4 }

	5 { Run-Option5 }

	6 { Run-Option6 }

	7 { Run-Option7 }
	
  8 { Run-Option8 }
    
  9 { Run-Option9 }

  10 { Run-Option10 }

  11 { Run-Option11 }

  12 { Run-Option12}

  13 { Run-Option13}

  14 { Run-Option14}

  15 { Run-Option15}

  16 { Run-Option16}

  17 { Run-Option17}

  18 { Run-Option18}

}

if ( $selection -ne 0 )
{	Sleep 2

Write-Host "`n"
switch ($ErrCode)
{	0 {Write-Host "Installation successful."}
	3010 {Write-Host "Installation successful. Restart required"}
	2359302 {Write-Host "Application already installed. Restart pending."}
}

	Write-Host "`n"
	Write-Host -NoNewLine "Press any key to continue...";
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

Sleep 1

}
Sleep 1