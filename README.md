# Stereo
This project is a recreation of the "old" iOS (7.0-8.1) music app.
Stereo was created as a university project for an OOP subject.
The code is old, but it works, yet, surprisingly it compiles on the iOS 12 SDK, despite being 4 major releases ahead of the original target SDK.

## Getting started
Run `pod install`  (you'll need CocoaPods)

Open the `Stereo.xcworkspace` file, hit the play button.

## Known issues
Stereo was written during a time where Apple Music did not exist, and it only supported non-DRM music.
For this reason, it will not work with Apple Music, nor will it work with DRM-protected tracks (like non-iTunes Plus tracks).
Adding support for Apple Music should actually be quite simple, `NIFMusicPlayerController` implements the `MPMediaPlayback` protocol, it also includes a few other methods.
Inheriting `MPPlayerController` and adding the missing methods (mostly involing queueing functionality) should allow for playback of Apple Music and DRM tracks.