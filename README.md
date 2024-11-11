# SwipeProductApp

A SwiftUI-based iOS application for managing product inventory with image upload capabilities and real-time network connectivity monitoring.

## Table of Contents
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Network Layer](#network-layer)
- [UI Components](#ui-components)
- [Error Handling](#error-handling)
- [Contributing](#contributing)

## Features

- ✨ Product entry with image upload support
- 📱 Clean and intuitive user interface
- 🔄 Real-time network connectivity monitoring
- ✅ Form validation
- 🖼️ PhotoKit integration
- 🎯 Type-safe API integration
- 📊 Progress tracking for uploads
- 💫 Smooth animations and transitions

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.5+
- Active internet connection for API functionality (Required atleast once) (Data is saved locally using SwiftData, once its loaded from the internet)

## Installation

1. Clone the repository:
```bash
git clone [your-repository-url]
cd SwipeProductApp
```

2. Open the project in Xcode:
```bash
open SwipeProductApp.xcodeproj
```

3. Install any dependencies (if using CocoaPods or SPM):
```bash
pod install  # If using CocoaPods
```

4. Build and run the project in Xcode (⌘+R)

## Project Structure

```
SwipeProductApp/
├── Views/
│   ├── NewProductEntryView.swift
│   └── GenericTFView.swift
├── Models/
│   └── ProductModel.swift
├── Networking/
│   └── NetworkManagerSingleton.swift
├── Utilities/
│   └── NetworkMonitor.swift
└── Resources/
    └── Assets.xcassets
```

## Usage

### Adding a New Product

1. Launch the app
2. Tap the "+" button to access the product entry form
3. Fill in the required fields:
   - Product image (tap the image placeholder)
   - Product name
   - Product type (select from menu)
   - Price
   - Tax percentage
4. Tap "Add Product" to submit

### Form Field Requirements

- **Product Image**: Required, must be selected from photo library
- **Product Name**: Non-empty string
- **Product Type**: Must select one from the provided options
- **Price**: Numbers only
- **Tax**: Numbers only, percentage format

### Error Handling

The app provides clear feedback for:
- Network connectivity issues
- Image loading failures
- Validation errors
- API response errors

## Network Layer

### NetworkManagerSingleton

The app uses a singleton pattern for network operations:

```swift
NetworkManagerSingleton.shared.uploadProductData(
    with: "https://app.getswipe.in/api/public/add",
    product: newProduct
) { result in
    // Handle response
}
```

### Network Monitoring

The app includes real-time network connectivity monitoring:

```swift
@Binding var isConnected: Bool  // Tracks network status
```

## UI Components

### GenericTFView

Reusable text field component with the following properties:

```swift
GenericTFView(
    tfTitle: String,          // Placeholder text
    imageName: String,        // SF Symbol name
    textBinding: Binding,     // Text binding
    needsFiltering: Bool,     // Text validation flag
    callout: String,         // Helper text
    keyboardType: UIKeyboardType  // Keyboard type
)
```

### PhotosPicker Integration

```swift
PhotosPicker(
    selection: $selectedImage,
    preferredItemEncoding: .automatic
) {
    // Custom view content
}
```

## Error Handling

The app implements comprehensive error handling:

1. **Validation Errors**:
   - Empty fields
   - Invalid image selection
   - Invalid number formats

2. **Network Errors**:
   - Connection loss
   - API failures
   - Upload failures

3. **Image Processing Errors**:
   - Loading failures
   - Conversion errors

Error messages are displayed using SwiftUI alerts:

```swift
.alert(alertTitle, isPresented: $showAlert) {
    Button("OK", role: .cancel) {
        if alertTitle == "Success" {
            dismiss()
        }
    }
} message: {
    Text(alertMessage)
}
```


## Build and Run Instructions

1. **Clone and Setup**:
   ```bash
   git clone [repository-url]
   cd SwipeProductApp
   ```

2. **Configure API Endpoint**:
   - Open `NetworkManagerSingleton.swift`
   - Verify the API endpoint is correctly set:
     ```swift
     static let baseURL = "https://app.getswipe.in/api/public/"
     ```

3. **Build Configuration**:
   - Open Xcode project
   - Select your target device/simulator
   - Set the active scheme to "SwipeProductApp"
   - Verify build settings:
     - Deployment Target: iOS 15.0+
     - Swift Language Version: Swift 5
     - Signing & Capabilities: Configure your team

4. **Run the App**:
   - Press ⌘+R or click the Play button
   - The app should launch in your selected simulator/device

5. **Testing Network Features**:
   - Ensure you have an active internet connection
   - Test offline mode by toggling airplane mode
   - Verify error handling works as expected

## Common Issues and Solutions

1. **Build Errors**:
   - Clean build folder (⇧⌘K)
   - Clean build cache (⌥⌘K)
   - Delete derived data
   - Verify Xcode version compatibility

2. **Network Issues**:
   - Check API endpoint configuration
   - Verify network permissions in Info.plist
   - Test API endpoint separately

3. **Image Upload Issues**:
   - Check photo library permissions
   - Verify image size and format
   - Test with different image types

4. **Performance Issues**:
   - Check for memory leaks using Instruments
   - Verify background thread usage
   - Monitor network response times

For additional support or to report issues, please create an issue in the repository.
