import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';


class TaskWidget extends StatefulWidget {
  final Task task;

  const TaskWidget({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    Color? color = Colors.green[900];

    if( widget.task.progress > 0 ) {
      color = Colors.blue[400];
    } 
    if( widget.task.progress != 100 && Jiffy(widget.task.deadline).isBefore(Jiffy()) ) {
      color = Colors.orange[300];
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          maxHeight: 200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title and done status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.task.title!,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                )
              ],
            ),

            // description
            Text(
              widget.task.description!,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),

            const Spacer(),

            // actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.delete_outline_outlined),
                  mini: true,
                  elevation: 0,
                  key: Key("delete"),
                  backgroundColor: Colors.red[600],
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.edit_attributes_outlined),
                  mini: true,
                  elevation: 0,
                  key: Key("edit"),
                  backgroundColor: Colors.black54,
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.query_stats),
                  mini: true,
                  elevation: 0,
                  key: Key("set status"),
                  backgroundColor: Colors.greenAccent[800],
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.done_all),
                  mini: true,
                  elevation: 0,
                  key: Key("done"),
                  backgroundColor: Colors.green[800],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
