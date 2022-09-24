*** Settings ***
Library   SeleniumLibrary

*** Variables ***
${nic_email}  nicamirahmad@gmail.com
${nic_pw}    Abcd1234

${email_field}    //input[@type='email']
${pw_field}   //input[@type='password']
${submit_button}   //button[@type='submit']

${valid1}    test_1
${valid2}    test_test_2
${valid3}    test3
${invalid1}    1
${invalid2}    Lorem_Ipsum_is_simply_dummy_text_of_the_printing_and_typesetting_industry_
${invalid3}    test_!@#

${token_field}    //input[@name='token_name']
${disbaled_create_button}    //button[@disabled]
${create_button}    //button[@class='dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-btn__button-group da-api-token__button']

${read_container}    //div[label/input[@name='read']]
${payment_container}    //div[label/input[@name='payments']]

${delete_icon}    //*[name()='svg' and @data-testid='dt_token_delete_icon']
${visibility_icon}    //*[name()='svg' and @data-testid='dt_toggle_visibility_icon']

${popup_container}    //div[@class='dc-modal__container dc-modal__container--small dc-modal__container--enter-done']
${cancel_button}    //button[span[contains(string(),'Cancel')]]
${delete_button}    //button[span[contains(string(),'delete')]]



*** Keywords ***
Login To Deriv
    Open Browser    https://app.deriv.com/account/api-token    chrome
    Set Selenium Speed     0.125
    Maximize Browser Window
    Wait Until Page Contains Element   ${email_field}    100
    Input Text   ${email_field}    ${nic_email}
    Input Text    ${pw_field}   ${nic_pw}
    Click Element    //button[@type='submit']

Check Read Checkbox
    Wait Until Page Contains Element    ${read_container}
    Sleep    1
    Click Element    ${read_container}
Check Payment Checkbox
    Wait Until Page Contains Element    ${payment_container}
    Sleep    1
    Click Element    ${payment_container}

    
    
    
    
    


*** Test Cases *** 

Login
    Login To Deriv
    Wait Until Page Contains Element   ${token_field}    30

tc1-verify if user can press 'create' button with valid token name, but no box selected
    Press Keys   ${token_field}    CTRL+A+DELETE    ${valid1}
    Page Should Contain Element    ${disbaled_create_button}


tc2a-verify if user can press 'create' button with invalid token name 1 (below min), 1 box selected
    Check Read Checkbox
    Press Keys   ${token_field}    CTRL+A+DELETE    ${invalid1}
    Page Should Contain Element    ${disbaled_create_button}
tc2b-verify if user can press 'create' button with invalid token name 2 (above max), 1 box selected
    Press Keys   ${token_field}    CTRL+A+DELETE    ${invalid2}
    Page Should Contain Element    ${disbaled_create_button}
tc2c-verify if user can press 'create' button with invalid token name 3 (symbols), 1 box selected
    Press Keys   ${token_field}    CTRL+A+DELETE    ${invalid3}
    Page Should Contain Element    ${disbaled_create_button}


tc3a-verify if user can create token with valid inputs
    Press Keys   ${token_field}    CTRL+A+DELETE    ${valid1}
    Click Element    ${create_button}
tc3b-verify if user can create token with valid input (onlyletters)
    Check Read Checkbox
    Check Payment Checkbox
    Press Keys   ${token_field}    CTRL+A+DELETE    deletelater_shouldbedeleted
    Click Element    ${create_button}
tc3c-verify if user can create token with valid input (below max)
    Check Read Checkbox
    Check Payment Checkbox
    Press Keys   ${token_field}    CTRL+A+DELETE       a23456789012345678901234567890
    Click Element    ${create_button}



tc4-verify if user can create token with used name
    Check Read Checkbox
    Check Payment Checkbox
    Press Keys   ${token_field}    CTRL+A+DELETE    ${valid1}
    Click Element    ${create_button}


tc5-verify if name in list = input name 
    Page Should Contain Element    //tr/td/span[contains(string(),'${valid1}')]


tc6-verify if names in list have correct corresponding scopes
    Page Should Contain Element    //tr[td/span[contains(string(),'${valid1}')] and td/div/div[contains(string(),'Read')]]
    Page Should Contain Element    //tr[td/span[contains(string(),'${valid1}')] and td/div[div[contains(string(),'Read')] and div[contains(string(),'Payment')]]]


tc7-verify api token in list is hashed
    Page Should Not Contain Element    //div[@class='da-api-token__clipboard-wrapper']/p


tc8-verify if unhide button is functioning
    Click Element    ${visibility_icon}
    Page Should Contain Element    //div[@class='da-api-token__clipboard-wrapper']/p


tc9a-verify delete button should pop up confirmation window
    Click Element    ${delete_icon}
    Sleep    1
    Page Should Contain Element    ${popup_container}
tc9b-(from delete popup), click cancel should close the popup
    Click Element    ${cancel_button}
    Sleep    1
    Page Should Not Contain Element    ${popup_container}
tc9c-(from delete popup), click delete should delete and close the popup
    Click Element    //tr[td/span[contains(string(),'deletelater')]]/td[5]/div/div/div/*[name()='svg']
    Sleep    1
    Click Element    ${delete_button}
    Sleep    3
    Page Should Not Contain Element    ${popup_container}
tc10-verify copy paste function
   Click Element    //tr[td/span[contains(string(),'a23')]]/td[2]/div/div/div/div/*[name()='svg' and @data-testid='dt_copy_token_icon']
    Press Keys    ${token_field}    CTRL+A    CTRL+V
    ${pasted_value}=   Get Element Attribute    ${token_field}    value 
    ${copied_value}=    Get Text        //tr[td/span[contains(string(),'a23')]]/td[2]/div/p
    Should Be Equal As Strings    ${pasted_value}    ${copied_value}
    
    
    






