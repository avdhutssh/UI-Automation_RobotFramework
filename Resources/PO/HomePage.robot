*** Settings ***
Resource    ../common.robot

*** Variables ***
${homeLink}         xpath://*[normalize-space(text())='Home']
${LogoutBtn}         xpath://*[normalize-space(text())='Logout']

*** Keywords ***
Verify user is on Home Page
    Wait until page contains element       ${homeLink}       15s
    Verify selected page is getting displayed       ${homeLink}
    Capture page screenshot

Logout from Application
     Click element     ${LogoutBtn}


