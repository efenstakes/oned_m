import 'dart:ffi';

import 'package:jiffy/jiffy.dart';

class Task {
  String? id;
  String? title;
  String? description;
  List<String> tags;
  String project;
  DateTime? startDate;
  DateTime? deadline;
  double progress;

  Task({
    this.id, 
    this.description, 
    this.title, 
    required this.tags, 
    required this.project, 
    this.startDate, 
    this.deadline,
    this.progress = 0
  }) { }


  static Task fromMap(Map<String, dynamic> _task) {
    print("_task:startDate ${_task["startDate"]}");
    return Task(
      id: _task["id"],
      title: _task["title"],
      description: _task["description"],
      project: _task["project"],
      tags: [ ..._task["tags"] ],
      progress: _task["progress"],
      startDate: new DateTime(2022), // DateTime.tryParse(_task["startDate"]),
      deadline: new DateTime(2022) // DateTime.tryParse(_task["deadline"])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "title": this.title,
      "description": this.description,
      "project": this.project,
      "tags": this.tags,
      "progress": this.progress,
      "startDate": this.startDate.toString(),
      "deadline": this.deadline.toString(),
    };
  }


  @override
  String toString() {
    return """
            description ${this.description} title ${this.title} 
            project ${this.project} tags ${this.tags}
            startDate ${this.startDate.toString()} deadline ${this.deadline.toString()}
    """;
  }
}

List<Task> testTasks = [
  new Task(
    id: "1",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Maven"
  ),
  new Task(
    id: "2",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Bright NFT"
  ),
  new Task(
    id: "3",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Maven"
  ),
  new Task(
    id: "4",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Bright NFT"
  ),
  new Task(
    id: "5",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Volken"
  ),
  new Task(
    id: "6",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Maven"
  ),
];
