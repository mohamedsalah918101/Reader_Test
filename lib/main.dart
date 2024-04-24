import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      )
  );
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _fontSize = 16.0;
  String data = '';
  String searchText = '';
  Color textColor = Colors.black;
  double redValue = 0.0;
  double greenValue = 0.0;
  double blueValue = 0.0;

  // ٍPresent the assets file
  fetchFileData()async{
    String responseText;
    responseText = await rootBundle.loadString('assets/story.txt');
    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    fetchFileData();
    super.initState();
  }

  // Zoom in function
  void _zoomIn() {
    setState(() {
      _fontSize += 2.0;
    });
  }

  // Zoom out function
  void _zoomOut() {
    if (_fontSize > 8.0) {
      setState(() {
        _fontSize -= 2.0;
      });
    }
  }

  // Search UI Dialog
  void _search() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: const InputDecoration(
              hintText: 'Enter text to search',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _clearSearch() {
    setState(() {
      searchText = '';
    });
  }

  // Highlight the Searched Text with Red color by using Regular Expression
  List<TextSpan> _highlightFoundedText(String text, String query) {
    List<TextSpan> spans = [];
    RegExp regex = RegExp(query, caseSensitive: false);
    Iterable<Match> matches = regex.allMatches(text);

    int start = 0;
    for (Match match in matches) {
      spans.add(TextSpan(
        text: text.substring(start, match.start),
        style: TextStyle(color: textColor),
      ));
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ));
      start = match.end;
    }

    spans.add(TextSpan(text: text.substring(start), style: TextStyle(color: textColor)));

    return spans;
  }

  // Change the entire Text Color by RGB
  void _updateRed(double value) {
    setState(() {
      redValue = value;
    });
  }

  void _updateGreen(double value) {
    setState(() {
      greenValue = value;
    });
  }

  void _updateBlue(double value) {
    setState(() {
      blueValue = value;
    });
  }

  // apply the Color
  void _applyColor() {
    setState(() {
      textColor = Color.fromARGB(255, redValue.toInt(), greenValue.toInt(), blueValue.toInt());
    });
  }

  // the Slider UI
  Slider _buildSlider(String label, double value, Color activeColor, Color inactiveColor, Function(double) onChanged) {
    return Slider(
      value: value,
      onChanged: (newValue) {
        // Call onChanged to update the state immediately
        onChanged(newValue);
        // Apply color immediately when the slider is dragged
        _applyColor();
      },
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      min: 0,
      max: 255,
      divisions: 255,
      label: value.round().toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The basic building screen UI
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("ReaderTest", style: TextStyle(color: Colors.white),),
      ),
      // for Scrolling
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              // For Select Text
              child: SelectableText.rich(
                TextSpan(
                  style: TextStyle(fontSize: _fontSize, color: Colors.black),
                  children: _highlightFoundedText(data, searchText),
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
              ),
            ),
          ],
        ),
      ),
      // Zoom in, Zoom out, Search, and Change Text Color
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: _zoomIn,
              icon: const Icon(Icons.zoom_in, color: Colors.black,size: 30,),
            ),
            IconButton(
              onPressed: _zoomOut,
              icon: const Icon(Icons.zoom_out, color: Colors.black, size: 30,),
            ),
            // to Show the RGB Sliders
            PopupMenuButton(
              icon: const Icon(Icons.color_lens,color: Colors.deepOrange, size: 35,),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Column(
                      children: [
                        _buildSlider("Red", redValue, Colors.red, Colors.red[100]!, _updateRed),
                        _buildSlider("Green", greenValue, Colors.green, Colors.green[100]!, _updateGreen),
                        _buildSlider("Blue", blueValue, Colors.blue, Colors.blue[100]!, _updateBlue),
                      ],
                    ),
                  ),
                ];
              },
            ),
            IconButton(
              onPressed: _search,
              icon: const Icon(Icons.search, color: Colors.black,size: 30),
            ),
            IconButton(
              onPressed: _clearSearch,
              icon: const Icon(Icons.clear, color: Colors.black,size: 30),
            ),
          ],
        ),
      ),
    );

  }
}
