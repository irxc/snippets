#!/bin/bash
# commands out of the official guide from microsoft
# source https://support.office.com/en-us/article/Uninstall-Office-2016-for-Mac-eefa1199-5b58-43af-8a3d-b73dc1a8cae3
# Stolen from https://github.com/qu1gl3s/macos-scripts/blob/master/uninstall_office_2016.sh

currentuser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

    echo "Quitting any open Office applications..."
    osascript -e 'quit app "Microsoft Word"'
    osascript -e 'quit app "Microsoft Excel"'
    osascript -e 'quit app "Microsoft Powerpoint"'
    osascript -e 'quit app "Microsoft Outlook"'
    osascript -e 'quit app "Microsoft OneNote"'

    echo "Removing Office 2016 apps..."
    rm -rf "/Applications/Microsoft Excel.app"
    rm -rf "/Applications/Microsoft OneNote.app"
    rm -rf "/Applications/Microsoft Outlook.app"
    rm -rf "/Applications/Microsoft PowerPoint.app"
    rm -rf "/Applications/Microsoft Word.app"

    echo "Cleaning ~/Library..."
    rm -rf /Users/$currentuser/Library/Containers/com.microsoft.errorreporting
    rm -rf /Users/$currentuser/Library/Containers/com.microsoft.Excel
    rm -rf /Users/$currentuser/Library/Containers/com.microsoft.netlib.shipassertprocess
    rm -rf /Users/$currentuser/Library/Containers/com.microsoft.Office365ServiceV2
    rm -rf /Users/$currentuser/Library/Containers/com.microsoft.Outlook
    rm -rf /Users/$currentuser/Library/Containers/com.microsoft.Powerpoint
    rm -rf /Users/$currentuser/Library/Containers/com.microsoft.RMS-XPCService
    rm -rf /Users/$currentuser/Library/Containers/com.microsoft.Word
    rm -rf /Users/$currentuser/Library/Containers/com.microsoft.onenote.mac

    echo "Moving Outlook Database to /tmp folder..."
    mv "/Users/$currentuser/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook 15 Profiles" "/tmp"

    echo "Deleting Outlook files in User's library..."
    rm -rf "/Users/$currentuser/Library/Group Containers/UBF8T346G9.ms"
    rm -rf "/Users/$currentuser/Library/Group Containers/UBF8T346G9.Office"
    rm -rf "/Users/$currentuser/Library/Group Containers/UBF8T346G9.OfficeOsfWebHost"

    echo "Creating folder for Outlook Database, applying appropriate permissions and moving the database back..."
    mkdir -p "/Users/$currentuser/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook 15 Profiles"
    chown $currentuser: "/Users/$currentuser/Library/Group Containers/UBF8T346G9.Office/"
    chown $currentuser: "/Users/$currentuser/Library/Group Containers/UBF8T346G9.Office/Outlook/"
    chown $currentuser: "/Users/$currentuser/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook 15 Profiles"
    mv "/tmp/Outlook 15 Profiles/" "/Users/$currentuser/Library/Group Containers/UBF8T346G9.Office/Outlook/"

    echo "Cleaning system folders..."
    rm -rf "/Library/Application Support/Microsoft/MAU2.0"
    rm -rf "/Library/Fonts/Microsoft"
    rm /Library/LaunchDaemons/com.microsoft.office.licensing.helper.plist
    rm /Library/LaunchDaemons/com.microsoft.office.licensingV2.helper.plist
    rm /Library/Preferences/com.microsoft.Excel.plist
    rm /Library/Preferences/com.microsoft.office.plist
    rm /Library/Preferences/com.microsoft.office.setupassistant.plist
    rm /Library/Preferences/com.microsoft.outlook.databasedaemon.plist
    rm /Library/Preferences/com.microsoft.outlook.office_reminders.plist
    rm /Library/Preferences/com.microsoft.Outlook.plist
    rm /Library/Preferences/com.microsoft.PowerPoint.plist
    rm /Library/Preferences/com.microsoft.Word.plist
    rm /Library/Preferences/com.microsoft.office.licensingV2.plist
    rm /Library/Preferences/com.microsoft.autoupdate2.plist
    rm -rf /Library/Preferences/ByHost/com.microsoft
    rm -rf /Library/Receipts/Office2016_*
    rm /Library/PrivilegedHelperTools/com.microsoft.office.licensing.helper
    rm /Library/PrivilegedHelperTools/com.microsoft.office.licensingV2.helper

    echo "Making your Mac forget about Office 2016..."
    pkgutil --forget com.microsoft.package.Fonts
    pkgutil --forget com.microsoft.package.Microsoft_AutoUpdate.app
    pkgutil --forget com.microsoft.package.Microsoft_Excel.app
    pkgutil --forget com.microsoft.package.Microsoft_OneNote.app
    pkgutil --forget com.microsoft.package.Microsoft_Outlook.app
    pkgutil --forget com.microsoft.package.Microsoft_PowerPoint.app
    pkgutil --forget com.microsoft.package.Microsoft_Word.app
    pkgutil --forget com.microsoft.package.Proofing_Tools
    pkgutil --forget com.microsoft.package.licensing

    echo "Cleaned and ready to go!"

exit 0