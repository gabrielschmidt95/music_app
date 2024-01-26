# Music Application

This is a music application built using Flutter. It allows users to listen to their favorite songs, create playlists, and discover new music.

## Features

- Browse and search for albuns
- Play albuns on Spotify

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/gabrieloliveira95/music-app.git
    ```

2. Change to the project directory:

    ```bash
    cd music-app
    ```

3. Install dependencies:

    ```bash
    flutter pub get
    ```

4. Add .env file in assets folder

    ```bash
    echo \
    OAUTH_CLIENT_ID= \
    OAUTH_CLIENT_SECRET= \
    OAUTH_AUDIENCE= \
    OAUTH_DOMAIN= \
    API_DOMAIN= \
    DISCOGS_TOKEN= \
    >> assets/.env
    ```

5. Add Firebase 

[Firebase Installation](https://firebase.flutter.dev/docs/manual-installation/ios/)
    
[Firebase Google Sign-in](https://firebase.flutter.dev/docs/auth/social#google)

6. For IOS only
    
    Add the following to your Info.plist file, located in 
    
    <project root>/ios/Runner/Info.plist:

    [Google Sign-in for iOS](https://developers.google.com/identity/sign-in/ios/start-integrating)
    
        ```
        <!-- Google Sign-in Section -->
            <key>CFBundleURLTypes</key>
            <array>
                <dict>
                    <key>CFBundleTypeRole</key>
                    <string>Editor</string>
                    <key>CFBundleURLSchemes</key>
                    <array>
                        <string>YOUR FIREBASE REVERSED_CLIENT_ID</string>
                    </array>
                </dict>
            </array>
            <!-- End of the Google Sign-in Section -->
        ```

7. For Android Only

    Add the following to your <project>/build.gradle

    [Google Sign-in for Android](https://developers.google.com/identity/sign-in/android/start-integrating)

    [Firebase Android](https://firebase.flutter.dev/docs/installation/android/)

    - Add Fingerprint to your add (Need Java 8)      
        ```
        keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
        ```

        ```
        ./gradlew signingReport 
        ```


8. Run the application:

    ```bash
    flutter run
    ```

## Screenshots

Artists Screen            |  Artists Albuns Screeen          |  Album Details Screen
:-------------------------:|:-------------------------:| :-------------------------:
![](screenshots/screenshot1.png)  |  ![](screenshots/screenshot2.png) | ![](screenshots/screenshot3.png)

## Contributing

Contributions are welcome! If you find any bugs or have suggestions for new features, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Flutter Packages](https://pub.dev/flutter/packages)
- [Icons8](https://icons8.com/)

