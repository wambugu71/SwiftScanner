import 'dart:isolate';
import 'dart:math';

void main() async {
  print('Running on the main thread!');

  // Start multiple isolates in parallel
  final futures = <Future<String>>[];

  // Run in 2 parallel isolates
  for (int i = 0; i < 2; i++) {
    final isolateId = i + 1;
    // Each isolate processes half the workload
    futures.add(Isolate.run(() => runCPUBoundTask(isolateId, 500000000)));
  }

  // Wait for all isolates to complete
  final results = await Future.wait(futures);

  // Print results from each isolate
  for (int i = 0; i < results.length; i++) {
    print('Isolate ${i + 1} computed in: ${results[i]}');
  }

  print('All parallel computations done!');
}

Future<String> runCPUBoundTask(int isolateId, int iterations) async {
  var startTime = DateTime.now();
  print('Starting isolate $isolateId...');

  for (var i = 0; i < iterations; i++) {
    sin(cos(tan(sin(cos(tan(sin(cos(tan(sin(123456789.123456789))))))))));
  }

  final duration = DateTime.now().difference(startTime);
  print('Isolate $isolateId finished in $duration');
  return duration.toString();
}

// The original function isn't needed anymore but you can keep it
void _runIsolateForCPUBoundTask() async {
  print('running in another thread!');
  var result = await Isolate.run(() => runCPUBoundTask(0, 1000000000));
  print("isolate_run result: $result");
}
