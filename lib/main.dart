import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DateTime? lastWateringDate = null;
  String lastWateringDateString = "No saved watering yet";

  String happyPlantUrl = "https://cdn-icons-png.flaticon.com/512/1892/1892751.png";
  String sadPlantUrl = "https://cdn-icons-png.flaticon.com/512/4147/4147924.png";

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

  void saveCurrentDate() async {
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
      textToShow = "Last watering: $day/$month/$year";
    }

    return textToShow;
  }

  String getImageUrl(DateTime? lastWateringDate) {
    if (lastWateringDate == null) {
      // Return the black & white image if there is no date saved yet
      return sadPlantUrl;
    } else {
      // Calculate the next time when watering is due
      var nextWateringDate = lastWateringDate.add(Duration(seconds: 10));
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

  @override
  void initState() {
    super.initState();
    getSavedDate();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
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