import 'dart:async';

import 'package:ai_progress/ai_progress.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';

class TaskOngoingScreen extends StatefulWidget {
  final Task? task;
  TaskOngoingScreen({Key? key, required this.task}) : super(key: key);


  @override
  State<TaskOngoingScreen> createState() => _TaskOngoingScreenState();
}

class _TaskOngoingScreenState extends State<TaskOngoingScreen> {
  ValueNotifier<double> _progressNofier = ValueNotifier<double>(0.0);

  bool _isProgressPaused = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(
      const Duration(seconds: 1), 
      (Timer t){
        // if( _progressNofier.value >= widget.task.progress ) {
        //   t.cancel();
        // }
        if( _isProgressPaused ) return;
  
        _progressNofier.value += 1;
      }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _progressNofier.dispose();
  }

  // given x seconds->, minutes and hours from it
  // minutes -> x/60
  // hours -> x/60
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    Task? task = widget.task;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.black87,
        ),
        child: ListView(
          children: [

            SizedBox(height: screenSize.height/10),
            // title
            Center(
              child: Text(
                task?.title ?? "Concentrate",
                style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),

            // project 
            Chip(
              label: Text(task?.project ?? Jiffy().EEEE),
              labelStyle: const TextStyle(
                color: Colors.white54,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 16,
              ),
              backgroundColor:  Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.5)
                )
              ),
            ),
            SizedBox(height: screenSize.height/6),
            
            ValueListenableBuilder(
              valueListenable: _progressNofier, 
              builder: (ctx, value, _) {
                String hourVal = (_progressNofier.value / 3600).toInt().toString();
                String minuteVal = (_progressNofier.value / 60).toInt().toString();
                String secondVal = (_progressNofier.value % 60).toInt().toString();

                String hours = hourVal.length == 1 ? "0${hourVal}" : hourVal;
                String minutes = minuteVal.length == 1 ? "0${minuteVal}" : minuteVal;
                String seconds = secondVal.length == 1 ? "0${secondVal}" : secondVal;
                
                return Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    ((_progressNofier.value / 3600).toInt() > 0 )
                      ?
                        Text(
                          "${hours} : ${minutes}",
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                                fontSize: 132,
                              ),
                        )
                      :
                        Text(
                          "${minutes} : ${seconds}",
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                                fontSize: 132,
                              ),
                        )

                  ],
                );
              }
            ),
            

            const SizedBox(height: 40),

      
            // AirCircularStateProgressIndicator(
            //   size: Size(150, 150),
            //   value: 10 / 10 * 100, //1~100
            //   pathColor: Colors.white,
            //   valueColor:
            //       ColorTween(begin: Colors.grey, end: Colors.blue)
            //           .transform(20 / 10)!,
            //   pathStrokeWidth: 10.0,
            //   valueStrokeWidth: 10.0,
            //   useCenter: true,
            //   filled: true,
            // ),
            const SizedBox(height: 120),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                // start                
                // pause
                _isProgressPaused 
                  ? 
                    InkWell(
                      onTap: () {
                        setState(()=> _isProgressPaused = false);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.play_arrow_rounded),
                      ),
                    )
                  :
                    InkWell(
                      onTap: () {
                        setState(()=> _isProgressPaused = true);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.pause_rounded),
                      ),
                    ),
                                    

                // stop
                InkWell(
                  onTap: () {
                    setState(()=> _isProgressPaused = true);
                    _progressNofier.value = 0;
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.stop_rounded),
                  ),
                ),

              ],              
            ),
              
          ],
        ),
      ),
    );
  }
}