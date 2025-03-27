# Task Manager App

A Flutter-based task management app with Back4App integration, designed as part of MTech assignment in Cross Platform Application Development.

## Getting Started

To get this project up and running on your local machine for development and testing purposes, follow these simple example steps.

### Prerequisites

- Flutter installed on your machine
- Android SDK or Android Studio installed on your machine
- An IDE (e.g., Android Studio, VS Code, etc.)
- An account on Back4App and your unique Application ID and Client Key

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/shub007pat/task-manager-app.git
2. Navigate to the project directory:
   ```sh
   cd task-manager-app
3. Install dependencies:
   ```sh
   flutter pub get
4. Create a Back4App account via [https://www.back4app.com/]
5. In Back4App create a class named "Tasks" with coloums:
   - title (string)
   - description (string)
   - status (boolean)
6. Edit the class's "Class Level Permission" to allow Read and Write for Public and Authenticated.
7. Replace "YOUR_PARSE_APPLICATION_ID" and "YOUR_PARSE_CLIENT_KEY" in lib/main.dart with your actual keys from Back4App.
8. Run the app:
   ```sh
   flutter run

### Usage

Once the app is running on an emulator or device, you can:

- Add new tasks using the '+' button.
- Tap on a task to view its details.
- Use the edit icon to modify a task or the delete icon to remove it.
- Switch the status of a task to 'Done' or 'In Progress' from the task details screen.

### License

Distributed under the MIT License. See LICENSE for more information.
