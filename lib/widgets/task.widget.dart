import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';
import 'package:oned_m/pages/task_details/task_details.screen.dart';


class TaskWidget extends StatefulWidget {
  final Task task;
  final Function onDelete;
  final Function onDone;
  final Function onProgress;

  const TaskWidget({Key? key, required this.task, required this.onDone, required this.onProgress, required this.onDelete }) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    Color? color = _getCompletionState();

    return InkWell(
      onTap: ()=> Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctxt)=> TaskDetailsScreen(task: widget.task,)
        )
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            maxHeight: 240,
            minWidth: 240,
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
                    widget.task.title ?? "",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 6),
                  

              // description
              Text(
                widget.task.description ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),

              const Spacer(),

              // actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: ()=> widget.onDelete(),
                    child: const Icon(Icons.delete_outline_outlined),
                    mini: true,
                    elevation: 0,
                    key: const Key("SCW:delete"),
                    backgroundColor: Colors.red[600],
                  ),
                  FloatingActionButton(
                    onPressed: ()=> widget.onProgress(),
                    child: const Icon(Icons.stacked_bar_chart_rounded),
                    mini: true,
                    elevation: 0,
                    key: const Key("SCW:set status"),
                    backgroundColor: Colors.greenAccent[800],
                  ),
                  FloatingActionButton(
                    onPressed: ()=> widget.onDone(),
                    child: const Icon(Icons.done_all),
                    mini: true,
                    elevation: 0,
                    key: const Key("SCW:done"),
                    backgroundColor: Colors.green[800],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }


  Color? _getCompletionState() {
    // print("_getCompletionState");
    
    String today = DAYS[(DateTime.now().weekday - 1)];
    String dateString = Jiffy(DateTime.now()).format("yyyy-MM-d");

    // print("today $today widget.task.repeats ${widget.task.repeats.join(", ")}");

    if( widget.task.repeats.contains(today) ) {
      return _getCompletionColor(
        widget.task.completion?['progress'] ?? 0.0, 
        Jiffy(DateTime.now()).add(years: 1).dateTime
      );
    } else {
      return _getCompletionColor(widget.task.progress, widget.task.deadline ?? DateTime.now());
    }
  }

  Color? _getCompletionColor(double progress, DateTime deadline) {
    Color? color = Colors.green[900];

    if( progress == 0 ) {
      color = Colors.brown;
    } 
    if( progress > 0 && progress < 100 ) {
      color = Colors.blue[400];
    } 
    if( progress != 100 && Jiffy(deadline).isBefore(Jiffy()) ) {
      color = Colors.orange[300];
    }

    return color;
  }
}
