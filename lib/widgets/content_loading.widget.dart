import 'package:flutter/material.dart';



class ContentLoadingWidget extends StatelessWidget {
  String text;

  ContentLoadingWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 120
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20, horizontal: 10,
      ),
      decoration: const BoxDecoration(
        // color: Colors.brown[200],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [

          const CircularProgressIndicator(),
          const SizedBox(height: 12),

          Text(
            text, 
            style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}