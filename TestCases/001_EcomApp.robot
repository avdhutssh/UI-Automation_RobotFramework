*** Settings ***
Resource    ../Resources/Application.robot
Resource    ../Test Data/InputData.robot
Test Teardown     Close Browser

*** Variables ***
${fileToUpload}     fileToUpload.txt
${csvFile}          creds.csv

*** Test Cases ***
Test Case 1: Register User
    [Tags]       Smoke
    Application.Launch Browser and open application
    Application.Verify that home page is visible successfully
    Application.Create new user account
    common.Logout from the application

#Data Driven using CSV
Test Case 2: Multiple Login User with correct emails and passwords
    [Tags]      Critical
    Application.Launch Browser and open application
    Application.Verify that home page is visible successfully
    LoginSignUpPage.Successfully switch to login Signup page
    Application.Multiple Logins using correct emails and passwords using CSV    ${csvFile}

#Data Driven using RF Built In
Test Case 3: Login User with multiple incorrect emails and passwords combination
    [Tags]       Critical
    [Template]    Application.Multiple Logins using incorrect emails and passwords using RF Builtin
    ${incorrectCred1}
    ${incorrectCred2}
    ${incorrectCred3}

Test Case 4: Register User with existing email      #TODO: Json Data Driven
    [Tags]       Critical
    Application.Launch Browser and open application
    Application.Verify that home page is visible successfully
    Application.SignUp with existing user creds
    LoginSignUpPage.Verify error when user tries to register with already used email

Test Case 5: Contact Us Form
    [Tags]       Critical
    Application.Launch Browser and open application
    Application.Verify that home page is visible successfully
    Application.Fill and submit the "Contact Us" form    ${fileToUpload}