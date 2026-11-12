# Creative EAX-style Room Echo for iPad

This is an original SwiftUI + AVFoundation audio-effects demo inspired by the
classic Creative EAX environment panel. It is not Creative's proprietary code,
and it does not claim to reproduce the exact SB0490 DSP.

## Included
- Room reverb presets using Apple's AVAudioUnitReverb
- Delay and feedback controls using AVAudioUnitDelay
- Effects amount control
- Enable/disable toggle and default settings button
- iPad-friendly SwiftUI interface

## Add to Xcode
1. On a Mac, create a new iOS App project named `CreativeEAX` using SwiftUI.
2. Add `ContentView.swift` and `EchoAudioEngine.swift` from this folder.
3. Replace the generated app entry point with `CreativeEAXApp.swift`, or merge its
   `@main` declaration into your existing app entry point.
4. In the app target's Info settings, add `Privacy - Microphone Usage Description`
   (`NSMicrophoneUsageDescription`) with a clear reason for microphone access.
5. Build and run on a real iPad, then allow microphone access.

## Test safely
Use headphones when testing microphone monitoring to reduce acoustic feedback.
Start with Effects Amount 35%, Delay 180 ms, Feedback 15%.

## Discord / Dylib limitation
This is an app-level audio processing example, not a Discord plugin or injectable
dynamic library. A normal iOS developer account does not grant permission or a
system API to inject a dylib into Discord, intercept Discord's microphone, or
create a system-wide virtual microphone. Discord on iPadOS does not expose a
general third-party audio-plugin input slot. Therefore this project cannot send
its processed microphone signal into a Discord call as-is.

GitHub stores the source; it does not convert Swift source into a usable iOS
Dylib. Build and sign the iOS app with Xcode on macOS.
