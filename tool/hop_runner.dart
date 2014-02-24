library hop_runner;

import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'package:args/args.dart';
import 'dart:async';



Map<String,Task> tasks = new Map<String,Task>();


void main(List<String> args) {
  List<String> inputPaths = createPaths();
  
  tasks['dart2js'] = createDartCompilerTask(inputPaths, outputMapper: _dart2jsOutputMapper);//singleOutput: 'built/game.dart.js');
  
  addTasks(['dart2js']);
  
  runHop(args);
}

/// Returns the paths (relative to the root of the project) of dart files to be built
List<String> createPaths() {
  List<String> paths = new List<String>();
  String sourcePath = 'web/source';
  paths.add('$sourcePath/main.dart');
  return paths;
}

String _dart2jsOutputMapper(String input) => 'built/' + input + '.js';

/// Add the tasks specified by [tasksToAdd] to the hop_runner from the global list of tasks [tasks]
void addTasks(List<String> tasksToAdd) {
  for (var task in tasksToAdd) {
    addTask(task, tasks[task]);
  }
}