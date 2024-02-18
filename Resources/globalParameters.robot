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

*** Variables ***
${browser}      Chrome
${url}          http://automationexercise.com
${user_name}    nhnPb8nMq
${email_Id}     nhnPb8nMq@gmail.com
${pwd}          77641350
