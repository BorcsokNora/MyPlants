import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen.shade50),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the MyApp widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}


// -- HERE IS THE LOGIC AND UI OF OUR APP --

class MyHomePageState extends State<MyHomePage> {

  // -- LOCAL FIELDS TO STORE INFORMATION USED FOR OUR LOGIC

  DateTime? lastWateringDate = null;
  String lastWateringDateString = "No saved watering yet";

  String happyPlantUrl = "https://cdn-icons-png.flaticon.com/512/1892/1892751.png";
  String sadPlantUrl = "https://cdn-icons-png.flaticon.com/512/4147/4147924.png";

  // -- HELPER METHODS FOR THE PLANT WATERING LOGIC

  getSavedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateString = (prefs.getString('date'));
    if (dateString != null) {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.
      setState(() {
        // Transform the text format (that we used to store the date info)
        // into DateTime format, so we can access parts of it (year, month, etc.)
        lastWateringDate = DateTime.tryParse(dateString);
        print("getSavedDate: lastWateringDate = $lastWateringDate");
      });
    }
  }

  saveCurrentDate() async {
    var now = DateTime.now().toLocal();
    // Save the date in the local storage of the application
    // (it's called "SharedPreferences" because usually it's used to store the user's preference settings)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('date', now.toString());
    getSavedDate();
  }

  String getDateTextToShow(DateTime? date) {
    var textToShow = "";
    if (date == null) {
      // Show this text if there is no date to be shown
      textToShow = "No saved watering yet";
    } else {
      // Otherwise use the date to create the text:
      var year = date.year;
      var month = date.month;
      var day = date.day;
      // TODO: show watering time (hour and minute) too
      textToShow = "Last watering: $day/$month/$year";
    }
    return textToShow;
  }

  String getImageUrl(DateTime? lastWateringDate) {
    if (lastWateringDate == null) {
      // Return the black & white image if there is no date saved yet
      return sadPlantUrl;
    } else {
      // TODO: change watering time frequency to 10 seconds for testing
      // Calculate the next time when watering is due
      var nextWateringDate = lastWateringDate.add(Duration(days: 5));
      print("nextWateringDate = $nextWateringDate");
      // Return the colored image if we haven't reached the next watering date,
      // or the black & white image if plant needs watering
      if (DateTime.now().isBefore(nextWateringDate)) {
        return happyPlantUrl;
      } else {
        return sadPlantUrl;
      }
    }
  }

  // Get the saved date when the UI is initialized
  @override
  initState() {
    super.initState();
    getSavedDate();
  }

  // Define the UI to be shown on the screen
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the getSavedDate method above.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              getDateTextToShow(lastWateringDate),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 24),
            Image.network(
              getImageUrl(lastWateringDate),
              width: 120,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                elevation: 0,
              ),
              onPressed: () {
                saveCurrentDate();
              },
              child:
              Text("Water my plant", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}