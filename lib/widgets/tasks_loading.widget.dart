import 'package:flutter/material.dart';



class TasksLoadingWidget extends StatelessWidget {
  const TasksLoadingWidget({Key? key}) : super(key: key);

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
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [

          const CircularProgressIndicator(),
          const SizedBox(height: 12),

          Text(
            "Loading Tasks", 
            style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}