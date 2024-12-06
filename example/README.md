
# Commandy Example

This project demonstrates the usage of the **Commandy** library with two practical examples: a counter and a countdown timer.

## Features

### Counter Example
The counter example demonstrates:
- Using a `Command<int, NoParams>` to handle the counter logic.
- Handling success and failure cases.
- Updating the UI reactively based on the command's result.

#### Key Functionality
- Increment the counter using the command.
- Reset the counter and show a failure message when it exceeds 3.

### Timer Example
The timer example demonstrates:
- Using a `StreamCommand<int, NoParams>` to manage a countdown timer.
- Listening to stream updates and updating the UI reactively.
- Displaying a notification when the countdown reaches 0.

#### Key Functionality
- Start a 30-second countdown.
- Stop the countdown and reset it.

### Video Preview
A quick demonstration of both examples is available in the [Commandy Example Video](commandy_example.mp4).

## How to Run

1. **Clone the Repository**
   

2. **Install Dependencies**
   Run the following command to install the required packages:
   ```bash
   flutter pub get
   ```

3. **Run the Application**
   Use the following command to start the application:
   ```bash
   flutter run
   ```

4. **Explore the Examples**
   - **Counter Example**: Shown on the home screen of the app.
   - **Timer Example**: Click the `Timer Example` button to navigate to the countdown timer screen.

## Code Highlights

### Counter Logic
The counter uses a `Command<int, NoParams>`:
```dart
incrementCommand = Command<int, NoParams>(_increment);

Future<Result<int>> _increment(NoParams _) async {
  await Future<void>.delayed(const Duration(seconds: 1));
  _counter += 1;
  if (_counter > 3) {
    _counter = 0;
    return FailureResult(
      Failure(message: 'Counter is more than 3!'),
    );
  }
  return Success(_counter);
}
```

### Timer Logic
The timer uses a `StreamCommand<int, NoParams>` with a `Ticker`:
```dart
timerCommand = StreamCommand<int, NoParams>((_) {
  return ticker
      .tick(ticks: 30)
      .map<Result<int>>((value) => Success(value));
});

void start() {
  if (timerCommand.isListening.value) {
    timerCommand.stop();
  }
  timerCommand.start(const NoParams());
}

void stop() {
  timerCommand.stop();
  timeLeft = 30;
  notifyListeners();
}
```

### UI Components
- **Counter**: 
  - Displays the counter value.
  - Uses a floating action button to increment.
  - Shows a failure message when the counter resets.

- **Timer**: 
  - Displays the remaining time.
  - Buttons to start/stop the countdown.
  - Snackbar notification when the timer reaches 0.

## Video Demonstration

Watch the [Commandy Example Video](commandy_example.mp4) to see the features in action!
