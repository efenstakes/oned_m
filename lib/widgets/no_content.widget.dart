import 'package:flutter/material.dart';

class NoContentWidget extends StatelessWidget {
  Function onPressCta;
  bool showCta;

  String title;
  String text;
  String ctaText;

  NoContentWidget({ 
    Key? key, 
    required this.onPressCta,
    required this.showCta,
    required this.title,
    required this.text,
    required this.ctaText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 120
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20, horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.brown[200],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [

          Text(
            title, 
            style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(text, style: const TextStyle(), textAlign: TextAlign.center,),
          const SizedBox(height: 20),

          showCta
            ?
              FloatingActionButton.extended(
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                onPressed: () => onPressCta(), 
                label: Text(ctaText),
                icon: const Icon(Icons.add),
                key: Key(ctaText),
              )
            : 
              const SizedBox.shrink(),

        ],
      ),
    );
  }
}