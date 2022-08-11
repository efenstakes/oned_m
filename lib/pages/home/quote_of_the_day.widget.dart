import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oned_m/models/quote.model.dart';



class QuoteOfTheDayWidget extends StatefulWidget {
  const QuoteOfTheDayWidget({Key? key}) : super(key: key);

  @override
  State<QuoteOfTheDayWidget> createState() => _QuoteOfTheDayWidgetState();
}

class _QuoteOfTheDayWidgetState extends State<QuoteOfTheDayWidget> {
  Quote? _quote;
  bool _isLoading = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getQuote();
  }
  
  @override
  Widget build(BuildContext context) {
    if ( _quote == null || _isLoading ) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(
        top: 20, bottom: 40,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20, horizontal: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.black54, // Colors.brown[400],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            _quote?.text ?? "Hola", 
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "~ ${_quote?.author}", 
              style: TextStyle(color: Colors.white60, fontStyle: FontStyle.italic),
            ),
          ),
         
        ],
      ),
    );
  }


  Future<void> getQuote() async {
    setState(()=> _isLoading = true);
    final response = await http
        .get(Uri.parse('https://type.fit/api/quotes'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print("response.body ${response.body}");
      int randomIndex = Random().nextInt(jsonDecode(response.body).length);
      Quote qote = Quote.fromMap(jsonDecode(response.body)[randomIndex]);
            
      print("qote ${qote.text}");
      setState(() {
        _quote = qote;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    setState(()=> _isLoading = false);
  }
}