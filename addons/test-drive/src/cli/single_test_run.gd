class_name TDSingleRun

var file_path: String

var no_only: bool = false

func _init(path: String, options={}) -> void:
  file_path = path
  no_only = Funk.option(options, '--no-only', false)

func run() -> TDTest:
  var TestFile = load(file_path) as GDScript
  var test = TestFile.new()
  if not test or not is_instance_of(test, TDTest):
    TDLogger.log('no tests found at "{path}"'.format({path=file_path}))
    return

  TestFile = null
  return test

func is_tdtest(thing):
  return thing && '__test_tree' in thing

func run_and_report(callback: Callable = func(): pass):
  var test = await run()

  if Only.contains_tests():
    if no_only:
      TDLogger.only_message()
      return 1

    test = Only
    await test.evaluate()
  else:
    TDLogger.log()
    await test.evaluate()

  if not test:
    callback.call()
    return 0
  
  if test.passed():
    TDLogger.all_passed()
    callback.call()
    test.cleanup()
    return 0
  else:
    test.report_result()
    callback.call()
    test.cleanup()
    return 1
