# Touchpad for macOS

## Overview

**Touchpad** is an application that allows you to control your Mac using your iPhone. The application uses Apple's Multipeer Connectivity framework to establish a connection between your devices, enabling seamless communication between them. By performing gestures on your iPhone, you can send corresponding commands to your Mac, which are then executed instantly.

## Features

### Gesture Controls
- **One Tap (One Finger):** Left mouse click on your Mac.
- **One Tap (Two Fingers):** Right mouse click on your Mac.
- **Two Fingers Pan:** Scroll in any direction (up, down, left, right).
- **Three Fingers Left Swipe:** Switch to the right screen on your Mac.
- **Three Fingers Right Swipe:** Switch to the left screen on your Mac.
- **Three Fingers Up Swipe:** Open Mission Control on your Mac.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following:
- An iPhone running the latest iOS version.
- A Mac running macOS.
- Xcode installed on your Mac.

### Installation

1. **Download and Run Tap&Send on Your iPhone:**
   - Open Xcode on your Mac.
   - Clone or download the Tap&Send project.
   - Connect your iPhone to your Mac.
   - Select your iPhone as the target device.
   - Build and run the project on your iPhone.

2. **Download and Run Tap&SendForMac on Your Mac:**
   - Open the Tap&SendForMac project in Xcode.
   - Archive the project by selecting **Product** > **Archive** in Xcode.
   - Once archived, export the application and run it on your Mac.

### Usage

Once both applications are running:
1. Launch the Tap&Send app on your iPhone.
2. Launch the Tap&SendForMac app on your Mac.
3. Your devices should automatically connect using the Multipeer Connectivity framework.
4. Start using gestures on your iPhone to control your Mac.

## Troubleshooting

- **Gesture Recognition:** Ensure that you are using the correct gestures as described above. Test with simple gestures first to ensure everything is functioning correctly.

## Future Improvements

- Additional gesture support for more macOS functions.
- Customizable gesture commands.
- Make list of possible for connection devies.
- Improved UI/UX for a more intuitive experience.

## Contributing

We welcome contributions! If you'd like to contribute to Touchpad, please fork the repository and submit a pull request.

## License

Touchpad is licensed under the MIT License. See `LICENSE` for more information.

## Acknowledgments

This project uses the [Multipeer Connectivity](https://developer.apple.com/documentation/multipeerconnectivity) framework by Apple to enable peer-to-peer communication between iOS and macOS devices.

---

Happy tapping!