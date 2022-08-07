import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:oned_m/widgets/stat_card.widget.dart';

class StatsWidget extends StatelessWidget {
  int done;
  int onGoing;
  int close;
  int later;

  StatsWidget({
    Key? key,
    required this.done,
    required this.onGoing,
    required this.close,
    required this.later,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          "Stats",
          style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          runSpacing: 10,
          spacing: 10,
          children: [
            StatCardWidget(
              stat: done,
              title: "Done",
              backgroundColor: Colors.lightGreen[600]!,
            ),
            StatCardWidget(
              stat: onGoing,
              title: "On Going",
              backgroundColor: Colors.blue[300]!,
            ),
            StatCardWidget(
              stat: close,
              title: "Close",
              backgroundColor: Colors.yellow[700]!,
            ),
            StatCardWidget(
              stat: later,
              title: "Late",
              backgroundColor: Colors.pink[300]!,
            ),
          ],
        ),

      ],
    );
  }
}