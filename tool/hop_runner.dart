library hop_runner;

import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'package:args/args.dart';
import 'dart:async';
import '../web/source/test/vmtest.dart' as vmtest;



Map<String,Task> tasks = new Map<String,Task>();
const String sourcePath = 'web/source';
const String testPath = 'web/source/test';
const String toBeCopiedPath = 'web';
const List<String> sourceFiles = const ['main.dart'];
const List<String> webTestPaths = const ['main_webtest.html'];
const List<String> toBeCopiedPaths = const ['index.html', 'assets', 'docs', 'source'];

void main(List<String> args) {
  List<String> inputPaths = createPaths(sourcePath, sourceFiles);
  List<String> testPaths = createPaths(testPath, webTestPaths);
  List<String> toBeCopied = createPaths(toBeCopiedPath, toBeCopiedPaths);
  // vmTestNames can be used in the creation of the testTask if we don't wan't to run every test
  List<String> vmTestNames = const ['mainTest'];
  
  tasks['copy_packages'] = createCopyTask(['tool/include/browser'], 'built/web/packages');
  tasks['copy_files'] = createCopyTask(toBeCopied, 'built/web');
  
  //TODO finish wrapper copy and test
  tasks['copy'] = new Task((TaskContext ctx) { });
  tasks['compile'] = createDartCompilerTask(inputPaths, outputMapper: (String input) => 'built/' + input + '.js');
  tasks['analyze'] = createAnalyzerTask(inputPaths);
  /*TODO gen_doc: Working tree is dirty. Cannot generate docs.
  Try using the --allow-dirty flag.*/
  tasks['gen_doc'] = createDartDocTask(inputPaths);
  
  tasks['test_web_drone'] = createWebTestTaskDroneIo(testPaths);
  tasks['test_vm'] = createVmTestTask(vmtest.tests.keys);
  
  addTasks(tasks);
  
  runHop(args);
}

/// Returns the paths (relative to the root of the project) of files in the form basePath + '/' + filepath
List<String> createPaths(String basePath, Iterable<String> filePaths) {
  List<String> paths = new List<String>();
  
  for (String filePath in filePaths)
    paths.add('$basePath/$filePath');
  
  return paths;
}

/// Add the tasks to the hop_runner
addTasks(Map<String,Task> tasks) =>
  tasks.forEach((name, task) => addTask(name, task));

runSequentialProcesses(List<Command> commands, TaskContext ctx) =>
    commands.forEach((command) => ctx.info(Process.runSync(command.name, command.args).stdout));

class Command {
  String name;
  List<String> args;
  Command(this.name,this.args);
}

Task createCopyTask(Iterable<String> inputPaths, String targetPath) {
  return new Task((TaskContext ctx)
  {
    List<Command> commands = new List<Command>();
    
    commands.add(new Command('mkdir', ['-p', targetPath]));
    
    inputPaths.forEach((path) => commands.add(new Command('cp', ['-R', path, targetPath])));
    
    ctx.info('Please ignore mkdir file exists messages.');
    ctx.info('Copying files....');
    runSequentialProcesses(commands, ctx);
  });
}

/// Create the web test task from the [testpaths] for drone.io
//TODO createWebTestTaskLocal using process.run('/opt/dart-editor/chromium/chrome' ...
//TODO test this on drone.io (kind of hard to install content_shell on local machines)
Task createWebTestTaskDroneIo(Iterable<String> testpaths) {
  return new Task((TaskContext ctx)
  {
    ctx.info("Running Web Unit Tests....");
    List<Future> futures = [];
    
    testpaths.forEach((path) => futures.add(
      Process.run('content_shell', ['--dump-render-tree', '$path'])
        .then((ProcessResult process) => ctx.info(process.stdout))
    ));
    
    return Future.wait(futures);
  });
}

Task createVmTestTask(Iterable<String> testnames)
{
  return new Task((TaskContext ctx)
  {
    ctx.info("Running VM Unit Tests....");
    //TODO make that the test output appears on the terminal
    testnames.forEach((name) => vmtest.tests[name]());  
    return;
  });
}