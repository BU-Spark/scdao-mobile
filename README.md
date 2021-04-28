# scdao-new
[![Build Status](https://travis-ci.com/eeshagholap/scdao-new.svg?token=uYKifbxq8pLi7ixxvyaZ&branch=master)](https://travis-ci.com/eeshagholap/scdao-new)

# Suffolk County District Attorney's Office OCR iOS App
Front End developed by Eesha Gholap, Wail Attauabi, Neilkaran Rawal, Victor Figueroa, Dingjie Chen 
### Link to the Back End
https://github.com/BU-Spark/scdao-api
(currently the app is connected to this backend server: http://dharmesh.mywire.org:3000/).
Note, that the above is not running as of Spring 21'. You'll need to use the local API until we get it re-deployed in AWS

## How to run and use the Swift app for iOS:
1. Go to the "ocrdataentryapp/" directory.
2. Open "OCRDataEntryApp.xcworkspace" on a Mac with Xcode installed.
3. Run the app with Command+R.
4. On the login page, login using the following credentials:  
    email: "admin@scdao-api.org"  
    password: "password"

## Description
### Problem
The DA’s office process a ton of data via physical forms. Inaccurate reporting or missing data has the potential to change the outcome of a court ruling, or whether or not the DA’s office decides to prosecute a particular case. It is absolutely vital for them to receive data accurately and efficiently.

### Our Solution
In this project our team created an iOS app for the DA's Office, so that they can quickly scan physical documents and have them digitized and uploaded to a database where the data is easily searchable and secure.

When a user opens the application the user can choose to register or login if they already have an account. When a user logs in we verify that they are a county-authorized user. From there they will be brought to the documents page where they can select “upload” in the tab bar to upload a document via their camera role or by taking a picture using the phone’s camera. When a document is uploaded it is then stored in the Back End’s database. The rest of the documents page will be developed at a later time such that implementing the buttons on the page will eventually be used to query documents that have been uploaded. For instance, clicking the Criminal Complaint Form(CCF) button will segue to a list of previously uploaded CCF forms. Additionally, the OCR functionality needs to be incorporated when clicking the take a photo button. This will be developed at a later time.

This project has the potential to serve as a proof of concept for the Suffolk county DA’s office so that they can develop a more streamlined process that can be shared with DA Offices around the country 

### Our App
Starting from the top, you can create a user from the sign up page. Once the user is created, the signup page will re-route you to the log in page to sign in with the email and password you just created. If you resigter as a new user is will give the response from the api call:

response data = {“detail”:“Incorrect username or password”}

As of Spring 2021, this error has been fixed. The bugs in signup have been fixed so that a user can now properly sign up and log in after successfully. 

Once you log in, the document page will show up from which you can upload your image or scan. Currently, the image that is being accepted is a png, jpeg, or pdf however, due to potential issues with the connection or backend, the image upload sends the following response:  
response data = {“detail”:“Bad uploaded file format”}

As of Spring 2021, this error has been fixed. The app will now accept uploads and return the job id as supposed to.

### Known bugs (Spring 2021)
Since the API is running locally on our computers, having the app run on our actual mobile phone is not possible as the phone cannot connect to the local API that is running on the computer. 

