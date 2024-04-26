# LoadableView Component for SwiftUI

## Overview
This component simplifies the handling of loading states and errors in SwiftUI applications. It's designed to make UI management cleaner and more efficient by automatically displaying loading indicators or content based on the data's state.

## Key Components

### `AppError`
- **Description**: Enumerates common errors like network failures or unauthorized access, along with associated user messages. Can be associated with custom alert types for create a custom alert modifier.

### `LoadableView`
- **Description**: A SwiftUI view that switches between displaying a loading indicator and the actual content based on the data state managed by an associated view model.

### `LoadableViewModel`
- **Description**: A protocol that defines the essential functionalities a view model must implement to work with `LoadableView`, such as loading state and error handling.

### `StateManager`
- **Description**: Manages the loading and error states by observing the view model, updating the UI to reflect changes like displaying alerts for errors.

### `ContentViewModel`
- **Description**: An example implementation of `LoadableViewModel` that demonstrates how to manage data loading and error handling specifically for `LoadableView`.

## Features

- **Dynamic Content Display**: Automatically shows a loading spinner during data fetch and displays content once data is available or an error if something goes wrong.
- **Error Handling**: Uses `AppError` to handle and display errors in a consistent, user-friendly way.
- **State Management**: `StateManager` integrates closely with the view model to manage UI states seamlessly, reducing boilerplate and improving readability.

## Usage Examples

### Basic Setup
Here's a simple example of how you can integrate `LoadableView` in your SwiftUI views:

```swift
struct ContentView: View {
    var body: some View {
        LoadableView(viewModel: ContentViewModel()) {
            Text("Data loaded successfully")
        }
    }
}
