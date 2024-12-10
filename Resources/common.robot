*** Settings ***
Resource    globalParameters.robot

*** Variables ***
${LoggedUser}          xpath://*[normalize-space(text())='Logged in as']/b
${LogoutBtn}           xpath://*[normalize-space(text())='Logout']

*** Keywords ***
Launch Browser
    [Documentation]     Launch browser and set download directory
    ${download_directory}=    Normalize Path    ${CURDIR}${/}..${/}Downloads
    Create Directory    ${download_directory}
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}=    Create Dictionary    download.default_directory=${download_directory}
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    Create Webdriver    ${browser}    options=${chrome_options}
    Maximize Browser Window

Navigate to Application
    [Documentation]     Navigate to the Application
    Go to   http://automationexercise.com\
    Wait For Condition	return document.readyState == "complete"    50s

Verify selected page is getting displayed
    [Arguments]    ${pageLink}
    ${attributeColor}=     Get element attribute    ${pageLink}      style
    ${color}=    Get Color from String    ${attributeColor}
    Log    Color extracted: ${color}
    Should be equal as strings     ${color}     orange

Get Color from String
    [Arguments]    ${string}
    ${color}=    Get Regexp Matches    ${string}   \s*([a-zA-Z]+);
    ${color}=    Get From List    ${color}          0
    ${color}=    Remove string    ${color}       ;
    [Return]    ${color}

Generate Random name
    ${u_name} =	Generate Random String	5-10
    [Return]    ${u_name}

Generate random email
    [Arguments]      ${u_name}
    ${mail} =   Catenate    SEPARATOR=@   ${u_name}   gmail.com
    [Return]     ${mail}

Generate Random username and email
     ${u_name} =     Generate Random name
     ${mail} =   Generate random email      ${u_name}
     [Return]     ${u_name}         ${mail}

Close frame popup
    [Arguments]    ${frame}
    TRY
        Select frame        ${frame}
        Click element       xpath://*[@aria-label='Close ad']
    EXCEPT
        Log    No ads appear for closing
    END

Verify user successfully login
    [Arguments]    ${user}
    Wait until page contains element    ${LoggedUser}     15s
    Element text should be    ${LoggedUser}       ${user}

Logout from the application
    Click element    ${LogoutBtn}
    Capture page screenshot

Generate password firstname lastname
    ${password} =  Generate Random String  8  [NUMBERS]
    ${f_name}       Generate Random name
    ${l_name}       Generate Random name
    [Return]    ${password}     ${f_name}    ${l_name}

Check User Type Based on Open URL
    ${current_url}=    Get Location
    Log    Current URL: ${current_url}
    ${user_type}=    Run Keyword If    'admin.html' in ${current_url}    Set Variable    Admin
    ...    ELSE IF    'seller.html' in ${current_url}    Set Variable    Seller
    ...    ELSE IF    'customer.html' in ${current_url}    Set Variable    Customer
    ...    ELSE    Set Variable    Unknown
    Log    User Type: ${user_type}
    [Return]    ${user_type}