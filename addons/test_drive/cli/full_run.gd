class_name TDFullRun extends EditorScript

static var no_only: bool = false

func _run() -> void:
  full_run()

static func full_run(on_finished: Callable = func(): pass, options={}):
  no_only = Funk.option(options, '--no-only', false)

  var exclude = ['/td_test.gd', '/example_test.test.gd']
  var test_files = FS.get_scripts_with_property('__TD_TEST__', {return_loaded = false}).filter(
    func(file): return exclude.all(func(e): return not file.ends_with(e))
  )

  var tests = []
  for file in test_files:
    tests.append(await TDSingleRun.new(file).run())

  if Only.contains_tests():
    return await __handle_only(on_finished)
  
  for test in tests:
    TDLogger.log()
    await test.evaluate()

  if tests.filter(func(eval): return eval.passed()).size() == tests.size():
    TDLogger.all_passed()
    on_finished.call()
    free_tests(tests)
    return 0
  else:
    for test in tests:
      test.report_result()
    on_finished.call()
    free_tests(tests)
    return 1

static func free_tests(tests):
  while tests.size():
    var test = tests.pop_front()
    test.cleanup()
    test.free()

static func __handle_only(on_finished: Callable = func(): pass):
    if no_only:
      TDLogger.only_message()
      return 1

    await Only.evaluate()
    if Only.passed():
      TDLogger.all_passed()
      on_finished.call()
      return 0
    else:
      Only.report_results()
      on_finished.call()
      return 1
