*** Settings ***
Documentation    Get data from external files
Library          ../Utils/read_csv.py

*** Keywords ***
Get CSV Data
    [Arguments]    ${CSV_FilePath}
    ${Data} =    Read csv file    ${CSV_FilePath}
    [Return]    ${Data}