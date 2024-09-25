# ShazamKit iOS 18 Background Issue Demo

## Overview
This repository contains a demo project that illustrates a bug in ShazamKit's background operation on iOS 18. The issue causes ShazamKit to stop identifying songs after a period of time when the app is in the background.

## Problem Description
On iOS 18, the ShazamKit framework stops working properly in the background after a short period (approximately 20 seconds). This issue does not occur on iOS 17 or earlier versions.

Specific behaviors:
- Music identification times out after a few seconds when the app is backgrounded or the device is locked.
- The app works fine when in the foreground.
- The microphone indicator remains on, suggesting the app still has microphone access.

## Reproduction Steps
1. Run the app on an iOS 18 device.
2. Start the song identification process.
3. Send the app to the background.
4. Play music near the device for a short period.
5. Observe that after some time, new songs are no longer identified until the app is brought to the foreground.

## Technical Details
- The app uses `SHManagedSession` for continuous song matching.
- Background modes are properly configured in Info.plist.
- The issue occurs even with audio background mode enabled.

## Feedback Ticket
This issue has been reported to Apple with the feedback number: FB15255903

## Additional Information
- Xcode Version: Xcode 16.0
- iOS Version: 18.0 and 18.1

## Contributing
If you have any insights or potential solutions, please feel free to open an issue or submit a pull request.

## Support
For questions or further information, please open an issue in this repository.
