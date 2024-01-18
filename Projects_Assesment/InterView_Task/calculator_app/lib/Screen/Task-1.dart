import 'dart:convert';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Addition extends StatefulWidget {
  const Addition({super.key});

  @override
  State<Addition> createState() => _AdditionState();
}

class _AdditionState extends State<Addition> {
  TextEditingController num1Controller = TextEditingController();
  TextEditingController num2Controller = TextEditingController();
  String result = '';
  List<String> history = [];
  String randomQuote = '';

  @override
  void initState() {
    super.initState();
    fetchRandomQuote();
  }

  void fetchRandomQuote() async {
    final response =
        await http.get(Uri.parse("https://zenquotes.io/api/random"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      Map<String, dynamic> quoteData =
          data[0]; // Access the first quote in the array

      setState(() {
        randomQuote = '${quoteData['q']} - ${quoteData['a']}';
      });
    } else {
      // Handle error
      print('Failed to fetch random quote: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "enter a number 1"),
            ),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter number 2'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                calculateSum();
              },
              child: Text("Add"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Result: $result',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Random Quote:' + ' ' + randomQuote!.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'History:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(history[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateSum() {
    double num1 = double.tryParse(num1Controller.text) ?? 0.0;
    double num2 = double.tryParse(num2Controller.text) ?? 0.0;

    double sum = num1 + num2;

    setState(() {
      result = sum.toString();
      addToHistory(num1, num2, sum);
    });
    fetchRandomQuote(); // Fetch a new random quote after each calculation
  }

  void addToHistory(double num1, double num2, double result) {
    String historyEntry = '$num1 + $num2 = $result';
    history.insert(0, historyEntry);
  }
}
