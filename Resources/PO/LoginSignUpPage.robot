*** Settings ***
Resource    ../common.robot

*** Variables ***
${LoginLink}         xpath://*[normalize-space(text())='Signup / Login']
${SignUpHeader}      css:.signup-form>h2
${SignUpname}        css:[name='name']
${SignUpEmail}       css:.signup-form [name='email']
${SignupBtn}         xpath://*[normalize-space(text())='Signup']
${LoginHeader}       css:.login-form>h2
${LoginEmail}        css:.login-form [name='email']
${LoginPassword}     css:[name='password']
${LoginBtn}          xpath://*[normalize-space(text())='Login']
${SignUpMsg}         New User Signup!
${RegisterError}     Email Address already exist!
${LoginHeaderMsg}    Login to your account
${LoginError}        Your email or password is incorrect!

*** Keywords ***
Navigate to "login Sign up" page
    Click element    ${LoginLink}

Verify "New User Signup!" is visible
    Element text should be    ${SignUpHeader}        ${SignUpMsg}

Enter "name and email address" in sign up field
    [Arguments]    ${uname}     ${mail_id}
    Input text    ${SignUpname}     ${uname}
    Input text    ${SignUpEmail}     ${mail_id}
    Capture page screenshot

Click "Signup" button
    Click element    ${SignupBtn}

Verify error when user tries to register with already used email
    Page should contain     ${RegisterError}
    Capture page screenshot

Verify 'Login to your account' is visible
    Element text should be    ${LoginHeader}       ${LoginHeaderMsg}

Enter email address and password in login section
    [Arguments]    ${logMail}       ${logPwd}
    Input text    ${LoginEmail}     ${logMail}
    Input text    ${LoginPassword}     ${logPwd}
    Capture page screenshot

Click 'login' button
    Click element    ${LoginBtn}

Verify error when user tries to login with wrong credential
    Page should contain     ${LoginError}
    Capture page screenshot

Successfully switch to login Signup page
    Navigate to "login Sign up" page
    Verify 'Login to your account' is visible

Clear login section
    Clear element text    ${LoginEmail}
    Clear element text    ${LoginPassword}
    Sleep    2s
