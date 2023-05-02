*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
Library        RPA.Browser.Selenium
Library        RPA.HTTP
Library        RPA.PDF
Library        RPA.Tables
Library        RPA.Desktop
Library        RPA.Archive
Library        RPA.FileSystem


*** Tasks ***
Order robots from RobotSpareBin Industries Inc

  Open the robot order website
  Download the CSV file
  Open the CSV file
  Close the annoying modal
  Fill the order form
  Order robot
  Store the order receipt as a PDF file
  #Screenshot of order and robot image
  Create ZIP package from PDF files
  
 

*** Keywords ***
Open the robot order website
    Open Chrome Browser    https://robotsparebinindustries.com/#/robot-order

Download the CSV file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=True

Open the CSV file
    Open File  orders.csv
      ${orders}=    Read table from CSV    orders.csv
    FOR    ${orders}    IN    @{orders}
          Log    ${orders}
    END   
      
Close the annoying modal
    Click Button  css=button[class='btn btn-dark'] 
    
Fill the order form
    # choose a head
    Select From List By Label    head    Peanut crusher head
    # choose a body
    Select Radio Button     body    1
    #Click Button        css=div[class='form-group'] button[class='btn btn-secondary']                       
    # input legs
    Input Text   css=body > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > form:nth-child(2) > div:nth-child(3) > input:nth-child(3)     2
    # input address
    Input Text      css=#address    Address 123
    # preview robot
    Click Button    id=preview
    # screenshot robot
    Sleep    3s
    Capture Page Screenshot
    
Order robot
    # wait until order shows including receipt no. and image
    Run Keyword And Continue On Failure      Click Button    id:order

Store the order receipt as a PDF file
    Run Keyword And Continue On Failure      Wait Until Element Is Visible      id:receipt
    ${receipt_html}=    Get Element Attribute    id:receipt     outerHTML
    Html To Pdf    ${receipt_html}    ${OUTPUT DIR}${/}receipt.pdf

#Screenshot of order and robot image
    #Capture Page Screenshot
    #${screenshot_html}=     Get Element Attribute    xpath://img[@alt='Head']    outerHTML
    #Html To Pdf   ${screenshot_html}    ${OUTPUT DIR}${/}head.pdf
 

Create ZIP package from PDF files
...    Archive Folder With Zip    ${OUTPUT DIR}    robot_orders
...    

