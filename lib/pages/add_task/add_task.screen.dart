import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';
import 'package:oned_m/widgets/selectable_chip.widget.dart';
import 'package:time_pickerr/time_pickerr.dart';


class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({ Key? key, }) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();


  var _tagsfocusNode = FocusNode();


  final TextEditingController _titleInputController = TextEditingController();
  final TextEditingController _descriptionInputController = TextEditingController();
  final TextEditingController _projectInputController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _tagInputController = TextEditingController();



  Task _task = Task( title: "", description: "", repeats: [], tags: [], project: "Learner" );


  bool _isLoading = false;

  String _error = "";





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tagsfocusNode.addListener(() {
      
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tagsfocusNode.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: (screenSize.width/10)),
      child: Form(
        key: _formKey,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 100),
          child: ListView(
            children: [

              const SizedBox(height: 80),

              // title
              Text(
                "Add Habit",
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 40),

              // task title
              TextFormField(
                controller: _titleInputController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter title',
                  prefixIcon: Icon(Icons.task)
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
                onSaved: (val)=> setState(() {
                  _task.title = val;
                }),
              ),
              const SizedBox(height: 40),

              // description
              TextFormField(
                controller: _descriptionInputController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter description',
                  prefixIcon: Icon(Icons.description)
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return 'Please enter description';
                  }
                  return null;
                },
                onSaved: (val)=> setState(() {
                  _task.description = val;
                }),
                maxLines: 6,
                minLines: 4,
              ),
              const SizedBox(height: 40),


              // task project
              TextFormField(
                controller: _projectInputController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter project',
                  prefixIcon: Icon(Icons.info),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 2) {
                    return 'Please enter project';
                  }
                  return null;
                },
                onSaved: (val)=> setState(() {
                  _task.project = val!;
                }),
              ),
              const SizedBox(height: 40),


              // start date
              Text(
                "Start Date",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime.now(),
                lastDate: Jiffy(DateTime.now()).add(years: 2).dateTime,
                icon: const Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  // if (date.weekday == 6 || date.weekday == 7) {
                  //   return false;
                  // }

                  return true;
                },
                onChanged: (val) => print(val),
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) {
                  // print("on save start date value ${val.toString()}");
                  // print("on save start date value ${val.toString()}");
                  // print("on save start date value ${Jiffy(val, "dd-MM-yyyy").dateTime.millisecondsSinceEpoch/1000}");
                  // print("on save start date value ${DateTime.fromMillisecondsSinceEpoch((DateTime.parse(val!).millisecondsSinceEpoch/1000).toInt())}");
                  setState(() {
                    _task.startDate = Jiffy(val).dateTime;
                  });
                },
              ),
              const SizedBox(height: 40),


              // deadline
              Text(
                "Deadline",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime.now(),
                lastDate: Jiffy(DateTime.now()).add(years: 5).dateTime,
                icon: const Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  // if (date.weekday == 6 || date.weekday == 7) {
                  //   return false;
                  // }

                  return true;
                },
                onChanged: (val) => print(val),
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) {
                  print("on save deadline value ${val.toString()}");
                  setState(() {
                    _task.deadline = Jiffy(val).dateTime;
                  });
                },
              ),
              const SizedBox(height: 40),

              // tags added
              _task.tags.isEmpty 
                ? 
                  Container() 
                : 
                  Text(
                  "Tags",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              const SizedBox(height: 20),
              _task.tags.isEmpty 
                ? 
                  Container(
                    child: Column(
                      children: [
                          const Text("No Tags Selected"),
                          const Text("Enter a tag below and click enter to add one."),
                      ],
                    ),
                  )
                : 
                  Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    ..._task.tags.map((e) {
                      return InkWell(
                        onTap: () => setState(() {
                          _task.tags.removeWhere((tsk) => tsk == e);
                        }),
                        child: Chip(
                          label: Text(e),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 9,
                            horizontal: 16,
                          ),
                          backgroundColor:  Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              const SizedBox(height: 40),


              // tags form
              RawKeyboardListener(
                focusNode: _tagsfocusNode, 
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    if( value.isEmpty ) return;
                    _task.tags.add(_tagInputController.text);
                    _tagInputController.clear();
                    _tagsfocusNode.requestFocus();
                  },
                  controller: _tagInputController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter tag',
                    prefixIcon: Icon(Icons.tag),
                  ),
                ),
                onKey: (event) {
                  if( _tagInputController.text.isEmpty ) return;
                  if( event.isKeyPressed(LogicalKeyboardKey.enter) ) {
                    setState(() {
                      _task.tags.add(_tagInputController.text);
                    });
                    print("add tag ${_tagInputController.text}");
                    _tagInputController.clear();
                  }
                },
              ),
              const SizedBox(height: 60),

    
              // repeats on?
              Text(
                "Repeats On",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 10,
                spacing: 10,
                children: [
                  ...DAYS.map((e) {

                    return SelectableChipWidget(
                      text: e[0], 
                      isSelected: _task.repeats.contains(e), 
                      onSelect: ()=> _addDayToRepeats(e)
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 40),


              // Set Alart At Time
              Text(
                "Set Alert At Time",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomHourPicker(
                        elevation: 2,
                        onPositivePressed: (context, time) {
                          print('onPositive ${time}');
                          setState(()=> _task.repeatTime = "${time.hour}:${time.minute}" );
                          Navigator.of(context).pop();
                        },
                        onNegativePressed: (context) {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: Text(
                    _task.repeatTime ?? "Select Time",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // priority
              Text(
                "Priority",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 10,
                spacing: 10,
                children: [
                  ...PROPRITIES.map((e) {
                    
                    return SelectableChipWidget(
                      text: e, 
                      isSelected: _task.priority == e, 
                      onSelect: ()=> setState(()=> _task.priority = e),
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 40),


              (_error == "" )
                ? Container()
                : 
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 20
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(_error),
                  ),


              // add button
              FloatingActionButton.extended(
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                onPressed: ()=> _addTask(context),
                label: Text(
                  _isLoading ? "Adding Habit" : "Add Habit"
                ),
                icon: _isLoading ? const CircularProgressIndicator(color: Colors.white,) : null,
                key: const Key("HP:Add Habit"),
              ),
              const SizedBox(height: 80),

            ],
          ),
        ),
      ),
    );
  }
  

  _addDayToRepeats(String e) {
    print("add day => ${e}");

    setState(() {
      if( _task.repeats.contains(e) ) {
        _task.repeats.removeWhere((d)=> e == d);
        _task.repeats.toSet().toList();
      } else {
        _task.repeats.add(e);
        _task.repeats.toSet().toList();
      }
    });
    _task.repeats.forEach((d)=> print("day => ${d}"));
  }


  _addTask(BuildContext context) async {
    _formKey.currentState!.save();


    if( !_formKey.currentState!.validate() ) {
      print("form error ");
      print("_task.title is ${_task.title}");  
      print("_titleInputController.title is ${_titleInputController.text}");    
      print("_task.toMap( ) ${_task.toMap()}");
      return;
    }

    print("form can submit");
    print("_task start ${_task.startDate.toString()}");
    print("_task.toMap( ) ${_task.toMap()}");

    print("_task.title is ${_task.title}");  
    print("_titleInputController.title is ${_titleInputController.text}");    
    
    print("_task.description is ${_task.description}");  
    print("_titleInputController.description is ${_descriptionInputController.text}");    
    

    // setState(() {
    //   _isLoading = true;
    //   _error = "";
    // });

    try {
      var taskRef = FirebaseFirestore.instance.collection("tasks").doc();


      String title = _titleInputController.text;
      String description = _descriptionInputController.text;


      taskRef.set({
        ..._task.toMap(),
        "title": title,
        "description": description,
        "id": taskRef.id,
        'user': FirebaseAuth.instance.currentUser?.uid,
      }).then((value) {

        if( _task.repeatTime != null ) {

          try {
            // Create an alarm for the time given
            int hr = int.parse( _task.repeatTime!.split(":")[0] );
            int min = int.parse( _task.repeatTime!.split(":")[1] );
            FlutterAlarmClock.createAlarm(hr, min, title: _task.title!);
          } catch (e) {
            print("ERROR FlutterAlarmClock.createAlarm(23, 59); ${e.toString()}");
          }

        }
        
        Fluttertoast.showToast(
          msg: "Habit Added Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green[700],
          textColor: Colors.white,
          fontSize: 16.0
        );
        Future.delayed(
          const Duration(milliseconds: 5500),
          ()=> Navigator.of(context).pop(),
        );

      });
      
    } catch(e) {
      setState(() {
        _error = "Error adding task";
        _isLoading = false;
      });
    }
  }
}