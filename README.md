# Vonage Video Express iOS and Android Demo

This project shows how to use [Vonage Video Express](https://tokbox.com/developer/video-express/) in an iOS/Android app using a Webview.

The project consists of 3 parts:

+ A backend server in Node.JS.

+ The iOS and Android applications.

## Backend Server

The backend server handles creating sessions for the iOS and Android application, as well as hosting the website that uses the Vonage Video Express library. To get the backend server running, first install the dependencies:

```
cd server
npm install
```

Then run the server with:

```
node index.js
```

This will start the server on your local machine using port 3000. You can now expose your server to the internet using tools such as [ngrok](https://ngrok.com) or [localtunnel](https://github.com/localtunnel/localtunnel):

```
ngrok http 3000
```

The HTTPS URL for your server is needed for the iOS and Android applications.

## iOS and Android Applications

Open the iOS and Android application in Xcode or Android Studio respectively. Replace the `baseUrl` variable in the `AppDelegate.swift` and the `MainActivity.kt`. You can search the projects for `BASE_URL_HERE` to find the exact line. You can now run either application.