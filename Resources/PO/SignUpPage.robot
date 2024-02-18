*** Settings ***
Resource    ../common.robot

*** Variables ***
${MaleRadioBtn}        id:id_gender1
${Pwd_Field}           id:password
${DDL_Days}            xpath://select[@name='days']
${DDL_Months}          xpath://select[@name='months']
${DDL_Years}           xpath://select[@name='years']
${FirstNameTx}         xpath://input[@name='first_name']
${LastNameTx}          xpath://input[@name='last_name']
${AddressTx}           xpath://input[@name='address1']
${StateTx}             xpath://input[@name='state']
${CityTx}              xpath://input[@name='city']
${ZipcodeTx}           xpath://input[@name='zipcode']
${MobileTx}            xpath://input[@name='mobile_number']
${CreateAccBtn}        xpath://*[normalize-space(text())='Create Account']
${AccCreateHeader}     xpath://h2/b
${AccSuccessHeader}    xpath:(//div/p)[1]
${ContinueBtn}         xpath://*[normalize-space(text())='Continue']
${infoHeaderMsg}       Enter Account Information
${AccCreateMsg}        ACCOUNT CREATED!
${AccSuccessMsg}       Congratulations! Your new account has been successfully created!


*** Keywords ***
Verify that 'ENTER ACCOUNT INFORMATION' is visible
    Wait until page contains    ${infoHeaderMsg}       15s
    Capture page screenshot

Fill details: Title, Name, Email, Password, Date of birth
    [Arguments]    ${password}      ${f_name}       ${l_name}
    Click element    ${MaleRadioBtn}
    Input password   ${Pwd_Field}    ${password}
    Select from list by label    ${DDL_Days}       3
    Select from list by label    ${DDL_Months}     April
    Select from list by label    ${DDL_Years}      2000
    Input text    ${FirstNameTx}     ${f_name}
    Input text    ${LastNameTx}      ${l_name}
    Input text    ${AddressTx}       Hinjewadi
    Input text    ${StateTx}           MH
    Input text    ${CityTx}            Pune
    Input text    ${ZipcodeTx}        12345
    Input text    ${MobileTx}      9876543211
    Capture page screenshot
    Click element    ${CreateAccBtn}

Verify that 'ACCOUNT CREATED!' is visible
    Element text should be    ${AccCreateHeader}     ${AccCreateMsg}
    Element text should be    ${AccSuccessHeader}    ${AccSuccessMsg}
    Capture page screenshot

Click 'Continue' button
    Click element    ${ContinueBtn}
    sleep   5s
    Capture page screenshot
    Reload Page Until User logged in Appears
    Capture page screenshot

Reload Page Until User logged in Appears
    Reload page
    Sleep    3s
    FOR    ${i}    IN RANGE    10
        TRY
            Click element    ${ContinueBtn}
        EXCEPT
            Log    Continue btn not appear after refreshing the page
        END
        ${element_present}=    Run Keyword And Return Status    Element Should Be Visible    ${ContinueBtn}
        Run Keyword If    ${element_present}    Exit For Loop
    END