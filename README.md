## AppBar Auto Hide

A Flutter package that provides a customizable AppBarAutoHide widget, 
allowing automatic hiding and showing of the AppBar based on scroll events. This is perfect for enhancing the user experience by maximizing screen space when content is scrolled.



## Features

- Automatically hides and shows the AppBar based on scroll direction.

- Smooth animations using fade and size transitions.

- Fully customizable to match the design of your app.

![20250113_235040](https://github.com/user-attachments/assets/d04f9e90-ff62-43a6-9ec7-f73936fec97f)


## Getting started

Add the following dependency to your pubspec.yaml file:
    
```yaml
    dependencies:
    app_bar_auto_hide: ^0.0.1 # Replace with the actual version
```
Then, run:
```bash
    flutter pub get
```



## Usage

Wrap your AppBar with AppBarAutoHide and provide a ValueNotifier<ScrollNotification?> to listen to scroll events.

```dart
class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final ValueNotifier<ScrollNotification?> _notifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAutoHide(
        notifier: _notifier,
        title: Text('Auto Hide AppBar'),
        autoHideThreshold: 100.0,
        animationDuration: Duration(milliseconds: 200),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _notifier.value = notification;
          return true;
        },
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Card(
                  color: Colors.primaries[index % Colors.primaries.length],
                  child: ListTile(
                    title: Text('Item $index'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }
}
```

## Customization Options

- isAutoHide: Enables or disables auto-hide functionality.

- autoHideThreshold: Specifies the scroll distance before hiding the AppBar.

- animationDuration: Sets the duration for hide/show animations.

Supports all standard AppBar properties like title, actions, backgroundColor, etc.


## Additional information

If you have any issues, questions, or suggestions related to this package, please feel free to contact us at [swan.dev1993@gmail.com](mailto:swan.dev1993@gmail.com). We welcome your feedback and will do our best to address any problems or provide assistance.
For more information about this package, you can also visit our [GitHub repository](https://github.com/SwanFlutter/avatar_better) where you can find additional resources, contribute to the package's development, and file issues or bug reports. We appreciate your contributions and feedback, and we aim to make this package as useful as possible for our users.
Thank you for using our package, and we look forward to hearing from you!
