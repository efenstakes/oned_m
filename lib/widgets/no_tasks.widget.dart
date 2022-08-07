import 'package:flutter/material.dart';

class NoTasksWidget extends StatelessWidget {
  Function addTask;

  NoTasksWidget({ Key? key, required this.addTask }) : super(key: key);

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
            "No Tasks", 
            style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Click the add button to add a task", style: TextStyle(), textAlign: TextAlign.center,),
          SizedBox(height: 20),

          FloatingActionButton.extended(
            elevation: 0,
            focusElevation: 0,
            hoverElevation: 0,
            onPressed: () => addTask(), 
            label: const Text("Add Task"),
            icon: const Icon(Icons.add),
            key: const Key("HP:Add Task"),
          ),
        ],
      ),
    );
  }
}