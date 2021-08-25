# LangTrackAppIphone

# LTA apps readme 
This readme is about the iOS and Android apps and a little about firebase

## Apps

### iPhone

The iOS app is native and written in **Swift** with **Xcode**. It is made for iPhone and is not optimized for use with iPad.

You need to connect the app to your fire base account and implement dependencies.
For LTA we used [CocoaPods](https://cocoapods.org/) as dependency manager, see `LangTrackAppIphone/Podfile`.

### Android

The Android app is native and written in **Kotlin** with **Android Studio**, MVVM design pattern. It is made for phone and is not optimized for use with tablet.
You need to connect the app to your fire base account and implement dependencies, listed in `langTrackAppAndroid/app/build.gradle`.

### Login
To use the app, log in with one of the user accounts created on firebase. The app will download the list of assigned surveys for that login and display in the list.
### Register for messaging
At startup, the app is registered for firebase cloud messaging and the user ID is saved to the backend and linked to the username, so notification can be sent when a new survey is sent out to that user.
### Defining admin / team members in the apps
In the code you can enter the usernames of those who are part of the team, so that the test switch and staging server switch are displayed in the menu.

## Firebase
LTA use **Auth**, **cloud messaging** and **realtime database**. LTA also retrieves the correct url from firebase db depending on whether you selected to use prod or staging server.
### Auth
Users / participants are created manually on the firebase console. A fake email is used for login, as firebase needs email to create users. The fake e-mail is never visible to the user, it is put together in code before authentication is done.
`username` -> `username@fake_email.com`
### Cloud messaging
The app registers for push notification at startup and saves IDToken to the backend. A listener is also registered and updates the IDToken in the event of a change. The user's IDToken is used to send push notifications when a new survey is sent out. 
When the user receives a notification, the lists are updated and the new survey is displayed at the top of the list as active.
### Realtime database
URL to backend is managed from firebase realtime database. There, the url is saved for production and staging servers and retrieved for calls from the app.
Which url is downloaded depends on the staging switch in the menu.
`Database.database().reference().child("url")`
or
`Database.database().reference().child("stagingUrl")`

