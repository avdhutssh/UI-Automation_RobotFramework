*** Settings ***
Library         SeleniumLibrary         implicit_wait=0:00:10
Library         Collections
Library         String
Library         OperatingSystem
Library         RequestsLibrary
Library         JSONLibrary
Library         DateTime
Library         json
Library         Dialogs
Test Teardown     Close Browser

*** Keywords ***
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

Reload Page Until User logged in Appears
    FOR    ${i}    IN RANGE    10
        TRY
            Click element    xpath://*[normalize-space(text())='Continue']
        EXCEPT
            Log    Continue btn not appear after refreshing the page
        END
        ${element_present}=    Run Keyword And Return Status    Element Should Be Visible    xpath://*[normalize-space(text())='Continue']
        Run Keyword If    ${element_present}    Exit For Loop
    END

*** Test Cases ***
Test Case 1: Register User
#1. Launch browser
    Create Webdriver        Chrome
    Maximize browser window

#2. Navigate to url 'http://automationexercise.com'
    Go to   http://automationexercise.com

#3. Verify that home page is visible successfully
    Wait until page contains element    xpath://*[normalize-space(text())='Home']      15s
    ${attributeColor}=     Get element attribute    xpath://*[normalize-space(text())='Home']      style
    ${color}=    Get Color from String    ${attributeColor}
    Log    Color extracted: ${color}
    Should be equal as strings     ${color}     orange
    Capture page screenshot

#4. Click on 'Signup / Login' button
    Click element    xpath://*[normalize-space(text())='Signup / Login']

#5. Verify 'New User Signup!' is visible
    Element text should be    css:.signup-form>h2       New User Signup!

#6. Enter name and email address
    ${user_name}    ${mail}    Generate Random username and email
    Input text    css:[name='name']     ${user_name}
    Input text    css:.signup-form [name='email']     ${mail}
    Capture page screenshot

#7. Click 'Signup' button
    Click element    xpath://*[normalize-space(text())='Signup']

#8. Verify that 'ENTER ACCOUNT INFORMATION' is visible
    Wait until page contains    Enter Account Information       15s
    Capture page screenshot

#9. Fill details: Title, Name, Email, Password, Date of birth
    ${password} =  Generate Random String  8  [NUMBERS]
    ${f_name}       Generate Random name
    ${l_name}       Generate Random name
    Click element    id:id_gender1
    Input password   id:password    ${password}
    Select from list by label    xpath://select[@name='days']       3
    Select from list by label    xpath://select[@name='months']     April
    Select from list by label    xpath://select[@name='years']      2000
    Input text    xpath://input[@name='first_name']     ${f_name}
    Input text    xpath://input[@name='last_name']      ${l_name}
    Input text    xpath://input[@name='address1']       Hinjewadi
    Input text    xpath://input[@name='state']          MH
    Input text    xpath://input[@name='city']           Pune
    Input text    xpath://input[@name='zipcode']        12345
    Input text    xpath://input[@name='mobile_number']      9876543211
    Capture page screenshot
    Click element    xpath://*[normalize-space(text())='Create Account']

#14. Verify that 'ACCOUNT CREATED!' is visible
    Element text should be    xpath://h2/b      ACCOUNT CREATED!
    Element text should be    xpath:(//div/p)[1]      Congratulations! Your new account has been successfully created!
    Capture page screenshot
#15. Click 'Continue' button
    Click element    xpath://*[normalize-space(text())='Continue']
    sleep   5s
    Capture page screenshot
#    Pause execution
    ${TotalFrames}=     Get WebElements    xpath://iframe
    Log     ${TotalFrames}
    ${CountFrames}=     Get element count    xpath://iframe
    Log     ${CountFrames}
    FOR    ${frame}    IN    @{TotalFrames}
        Close frame popup       ${frame}
        Unselect frame
    END
    Reload page
    sleep   5s
    Reload Page Until User logged in Appears
    Capture page screenshot
    Wait until page contains element    xpath://*[normalize-space(text())='Logged in as']/b     15s

#16. Verify that 'Logged in as username' is visible
    Element text should be    xpath://*[normalize-space(text())='Logged in as']/b       ${user_name}
    Click element    xpath://*[normalize-space(text())='Delete Account']
    Element text should be    xpath://h2/b      ACCOUNT DELETED!
    Element text should be    xpath:(//div/p)[1]      Your account has been permanently deleted!
    Capture page screenshot


Test Case 2: Login User with correct email and password
#1. Launch browser
    Create webdriver    Chrome
    Maximize browser window

#2. Navigate to url 'http://automationexercise.com'
    Go to    http://automationexercise.com

#3. Verify that home page is visible successfully
    Wait until page contains element    xpath://*[normalize-space(text())='Home']      15s
    ${attributeColor}=     Get element attribute    xpath://*[normalize-space(text())='Home']      style
    ${color}=    Get Color from String    ${attributeColor}
    Log    Color extracted: ${color}
    Should be equal as strings     ${color}     orange
    Capture page screenshot
#4. Click on 'Signup / Login' button
    Click element    xpath://*[normalize-space(text())='Signup / Login']

#5. Verify 'Login to your account' is visible
    Element text should be    css:.login-form>h2       Login to your account

#6. Enter correct email address and password
    Input text    css:.login-form [name='email']     nhnPb8nMq@gmail.com
    Input text    css:[name='password']     77641350
    Capture page screenshot

#7. Click 'login' button
    Click element    xpath://*[normalize-space(text())='Login']

#8. Verify that 'Logged in as username' is visible

    Element text should be    xpath://*[normalize-space(text())='Logged in as']/b       nhnPb8nMq
    Capture page screenshot
    Click element    xpath://*[normalize-space(text())='Logout']

Test Case 3: Login User with incorrect email and password
#1. Launch browser
    Create webdriver    Chrome
    Maximize browser window

#2. Navigate to url 'http://automationexercise.com'
    Go to    http://automationexercise.com

#3. Verify that home page is visible successfully
    Wait until page contains element    xpath://*[normalize-space(text())='Home']      15s
    ${attributeColor}=     Get element attribute    xpath://*[normalize-space(text())='Home']      style
    ${color}=    Get Color from String    ${attributeColor}
    Log    Color extracted: ${color}
    Should be equal as strings     ${color}     orange
    Capture page screenshot
#4. Click on 'Signup / Login' button
    Click element    xpath://*[normalize-space(text())='Signup / Login']

#5. Verify 'Login to your account' is visible
    Element text should be    css:.login-form>h2       Login to your account

#6. Enter correct email address and password
    Input text    css:.login-form [name='email']     abfghjuo9899@huh.com
    Input text    css:[name='password']     58697
    Capture page screenshot

#7. Click 'login' button
    Click element    xpath://*[normalize-space(text())='Login']

#8. Verify error 'Your email or password is incorrect!' is visible
    Page should contain     Your email or password is incorrect!
    Capture page screenshot

Test Case 4: Register User with existing email
#1. Launch browser
    Create Webdriver        Chrome
    Maximize browser window

#2. Navigate to url 'http://automationexercise.com'
    Go to   http://automationexercise.com

#3. Verify that home page is visible successfully
    Wait until page contains element    xpath://*[normalize-space(text())='Home']      15s
    ${attributeColor}=     Get element attribute    xpath://*[normalize-space(text())='Home']      style
    ${color}=    Get Color from String    ${attributeColor}
    Log    Color extracted: ${color}
    Should be equal as strings     ${color}     orange
    Capture page screenshot

#4. Click on 'Signup / Login' button
    Click element    xpath://*[normalize-space(text())='Signup / Login']

#5. Verify 'New User Signup!' is visible
    Element text should be    css:.signup-form>h2       New User Signup!

#6. Enter name and already registered email address
    ${user_name}    Generate Random name
    Input text    css:[name='name']     ${user_name}
    Input text    css:.signup-form [name='email']     nhnPb8nMq@gmail.com
    Capture page screenshot

#7. Click 'Signup' button
    Click element    xpath://*[normalize-space(text())='Signup']

#8. Verify error 'Email Address already exist!' is visible
    Page should contain     Email Address already exist!
    Capture page screenshot

Test Case 5: Contact Us Form
#1. Launch browser
    Create Webdriver        Chrome
    Maximize browser window

#2. Navigate to url 'http://automationexercise.com'
    Go to   http://automationexercise.com

#3. Verify that home page is visible successfully
    Wait until page contains element    xpath://*[normalize-space(text())='Home']      15s
    ${attributeColor}=     Get element attribute    xpath://*[normalize-space(text())='Home']      style
    ${color}=    Get Color from String    ${attributeColor}
    Log    Color extracted: ${color}
    Should be equal as strings     ${color}     orange
    Capture page screenshot

#4. Click on 'Contact Us' button
    Click element    xpath://*[normalize-space(text())='Contact us']

#5. Verify 'GET IN TOUCH' is visible
    Wait until page contains    Get In Touch        15s

#6. Enter name, email, subject and message
    ${contactName}    ${contactMail}    Generate Random username and email
    Input text    xpath://input[@name='name']     ${contactName}
    Input text    xpath://input[@name='email']       ${contactMail}
    Input text    xpath://input[@name='subject']       Automation
    Input text    xpath://*[@name='message']      Automation using RF

#7. Upload file
    ${file_path}=    Normalize Path    ${CURDIR}${/}..${/}Test Data${/}fileToUpload.txt
    Sleep    2s
    Choose File    xpath://input[@name='upload_file']   ${file_path}
    Capture page screenshot

#8. Click 'Submit' button
    Click element    xpath://input[@type='submit']

#9. Click OK button
    ${alertMsg}=      Handle alert    ACCEPT
    Log     ${alertMsg}

Test Case 6: Search and Add Products in Cart and place order and Download Invoice after purchase order and content in downloaded file
#1. Launch browser
    ${download_directory}=    Normalize Path    ${CURDIR}${/}..${/}Downloads
    Create Directory    ${download_directory}
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}=    Create Dictionary    download.default_directory=${download_directory}
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    Create Webdriver    Chrome    options=${chrome_options}
    Maximize Browser Window

#2. Navigate to url 'http://automationexercise.com'
    Go to    http://automationexercise.com

#3. Verify that home page is visible successfully
    Wait until page contains element    xpath://*[normalize-space(text())='Home']      15s
    ${attributeColor}=     Get element attribute    xpath://*[normalize-space(text())='Home']      style
    ${color}=    Get Color from String    ${attributeColor}
    Log    Color extracted: ${color}
    Should be equal as strings     ${color}     orange
    Capture page screenshot

    Click element    xpath://*[normalize-space(text())='Signup / Login']

    Element text should be    css:.login-form>h2       Login to your account

    Input text    css:.login-form [name='email']     nhnPb8nMq@gmail.com
    Input text    css:[name='password']     77641350
    Capture page screenshot

    Click element    xpath://*[normalize-space(text())='Login']


    Element text should be    xpath://*[normalize-space(text())='Logged in as']/b       nhnPb8nMq
    Capture page screenshot

#4. Add products to cart
    Click element    xpath://a[@href='/products']
    Wait until page contains element        id:search_product       15s
    ${attributeColor}=     Get element attribute    xpath://a[@href='/products']      style
    ${color}=    Get Color from String    ${attributeColor}
    Log    Color extracted: ${color}
    Should be equal as strings     ${color}     orange
    Capture page screenshot

    Input text    id:search_product       tshirt
    Click element    css:.fa.fa-search
    Wait For Condition	return document.readyState == "complete"
    Wait until page contains element        xpath:(//img[@alt='ecommerce website products'])[1]       15s
    Mouse over    xpath:(//img[@alt='ecommerce website products'])[1]
    Sleep    2s
    ${productPrice} =       Get text        xpath:(//img[@alt='ecommerce website products'])[1]/../h2
    log     ${productPrice}
    ${productName} =       Get text        (//img[@alt='ecommerce website products'])[1]/../p
    log     ${productName}
    Execute Javascript    window.scrollTo(0,300)
    Click element    xpath:(//img[@alt='ecommerce website products'])[1]//../../div[@class='product-overlay']//*[normalize-space(text())='Add to cart']
    Sleep    3s

#5. Click 'Cart' button
    Click element    //p/a[@href='/view_cart']
    Sleep    2s

#6. Verify that cart page is displayed
    Wait until page contains element        xpath://*[normalize-space(text())='Proceed To Checkout']        15s

#7. Click Proceed To Checkout
    Click element     xpath://*[normalize-space(text())='Proceed To Checkout']
    Sleep    3s
    Go to    https://automationexercise.com/checkout

#15. click 'Place Order'
    Wait until page contains element    xpath://*[normalize-space(text())='Place Order']        15s
    Click element    xpath://*[normalize-space(text())='Place Order']

#16. Enter payment details: Name on Card, Card Number, CVC, Expiration date
    Input text    xpath://input[@name='name_on_card']     nhnPb8nMq
    Input text    xpath://input[@name='card_number']       222
    Input text    xpath://input[@name='cvc']       121
    Input text    xpath://input[@name='expiry_month']      12
    Input text    xpath://input[@name='expiry_year']       80
    Sleep    2s
    Capture page screenshot

#17. Click 'Pay and Confirm Order' button
    Click element       xpath://*[@data-qa='pay-button']
    Capture page screenshot
    Wait until page contains        Order Placed!

#18. Verify success message 'Your order has been placed successfully!'
    Element text should be      xpath://div/h2[@data-qa='order-placed']/../p          Congratulations! Your order has been confirmed!
    Capture page screenshot

#19. Click 'Downloads Invoice' button and verify invoice is downloaded successfully.
    Click element       xpath://*[normalize-space(text())='Download Invoice']