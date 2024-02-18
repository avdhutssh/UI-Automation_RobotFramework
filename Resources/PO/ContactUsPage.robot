*** Settings ***
Resource    ../common.robot

*** Variables ***
${ContactUsLink}        xpath://*[normalize-space(text())='Contact us']
${CU_Name}              xpath://input[@name='name']
${CU_Email}             xpath://input[@name='email']
${CU_Subject}           xpath://input[@name='subject']
${CU_Msg}               xpath://*[@name='message']
${CU_File}              xpath://input[@name='upload_file']
${CU_SubmitBtn}         xpath://input[@type='submit']
${CU_HeaderMsg}         Get In Touch

*** Keywords ***

Navigate to "contact us" page
    Click element    ${ContactUsLink}
    Wait until page contains    Get In Touch        15s

Fill the "contact us" form
    [Arguments]     ${FileName}
    ${contactName}    ${contactMail}    Generate Random username and email
    Input text    ${CU_Name}      ${contactName}
    Input text    ${CU_Email}     ${contactMail}
    Input text    ${CU_Subject}   Automation
    Input text    ${CU_Msg}       Automation using RF
    ${file_path}=    Normalize Path    ${CURDIR}${/}../..${/}Test Data${/}${FileName}
    Sleep    2s
    Choose File    ${CU_File}   ${file_path}
    Capture page screenshot

Submit the "contact us form"
    Click element    ${CU_SubmitBtn}
    ${alertMsg}=      Handle alert    ACCEPT
    Log     ${alertMsg}