*** Settings ***
Resource        common.robot
#Resource       ../Resources/PO/CartPage.robot
Resource        ../Resources/PO/ContactUsPage.robot
#Resource       ../Resources/PO/DeleteAccountPage.robot
Resource        ../Resources/PO/HomePage.robot
Resource        ../Resources/PO/LoginSignUpPage.robot
#Resource       ../Resources/PO/ProductsPage.robot
Resource        ../Resources/PO/SignUpPage.robot
Resource        DataManager.robot

*** Keywords ***
Launch Browser and open application
    common.Launch Browser
    common.Navigate to Application

Verify that home page is visible successfully
    HomePage.Verify user is on Home Page

SignUp with new user creds
    ${randomUser}    ${randomMail}    Generate Random username and email
    LoginSignUpPage.Navigate to "login Sign up" page
    LoginSignUpPage.Verify "New User Signup!" is visible
    LoginSignUpPage.Enter "name and email address" in sign up field     ${randomUser}        ${randomMail}
    LoginSignUpPage.Click "Signup" button
    Set suite variable    ${randomUser}     ${randomUser}

SignUp with existing user creds
    LoginSignUpPage.Navigate to "login Sign up" page
    LoginSignUpPage.Verify "New User Signup!" is visible
    LoginSignUpPage.Enter "name and email address" in sign up field     ${user_name}        ${email_Id}
    LoginSignUpPage.Click "Signup" button

Create new user account
    SignUp with new user creds
    ${password}  ${f_name}  ${l_name}      common.Generate password firstname lastname
    SignUpPage.Verify that 'ENTER ACCOUNT INFORMATION' is visible
    SignUpPage.Fill details: Title, Name, Email, Password, Date of birth    ${password}  ${f_name}  ${l_name}
    SignUpPage.Verify that 'ACCOUNT CREATED!' is visible
    SignUpPage.Click 'Continue' button
    Verify user successfully login      ${randomUser}

Login using correct email and password
    LoginSignUpPage.Navigate to "login Sign up" page
    LoginSignUpPage.Verify 'Login to your account' is visible
    LoginSignUpPage.Enter email address and password in login section   ${email_Id}     ${pwd}
    LoginSignUpPage.Click 'login' button

Login using incorrect email and password
    ${wrongPwd}    ${randomMail}    Generate Random username and email
    LoginSignUpPage.Successfully switch to login Signup page
    LoginSignUpPage.Enter email address and password in login section   ${randomMail}     ${wrongPwd}
    LoginSignUpPage.Click 'login' button

Fill and submit the "Contact Us" form
    [Arguments]     ${FileName}
    ContactUsPage.Navigate to "contact us" page
    ContactUsPage.Fill the "contact us" form       ${FileName}
    ContactUsPage.Submit the "contact us form"

Multiple Logins using incorrect emails and passwords using RF Builtin
    [Arguments]     ${Invalid_Data}
    Application.Launch Browser and open application
    Application.Verify that home page is visible successfully
    LoginSignUpPage.Successfully switch to login Signup page
    LoginSignUpPage.Enter email address and password in login section   ${Invalid_Data.Email}     ${Invalid_Data.Password}
    LoginSignUpPage.Click 'login' button
    LoginSignUpPage.Verify error when user tries to login with wrong credential

Multiple Logins using correct emails and passwords using CSV
    [Arguments]    ${file}
    ${file_path}=    Normalize Path    ${CURDIR}${/}..${/}Test Data${/}${file}
    ${correctCreds}=    datamanager.get csv data     ${file_path}
    FOR   ${i}   IN RANGE    0    3
        ${rowData}=        Get from list     ${correctCreds}    ${i}
        LoginSignUpPage.Enter email address and password in login section   ${rowData[0]}     ${rowData[1]}
        LoginSignUpPage.Click 'login' button
        common.Verify user successfully login      ${rowData[2]}
        common.Logout from the application
        sleep   3s
    END

#Multiple Logins using correct emails and passwords using CSV
#    [Arguments]    ${file}
#    ${file_path}=    Normalize Path    ${CURDIR}${/}..${/}Test Data${/}${file}
#    ${correctCreds}=    datamanager.get csv data     ${file_path}
#    FOR   ${i}   IN RANGE    0    3
#            ${abc}=        Get from list     ${correctCreds}    ${i}
#            Log   Email is : ${abc[0]}
#            Log   Password is : ${abc[1]}
#            Log   User is : ${abc[2]}
#    END