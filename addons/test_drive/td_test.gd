@tool
class_name TDTest extends Node

# The tree of test cases used to actually evaluate and report 
# On the tests. TDTestGroup instances are branches, TDTestCase instances are
# leaf nodes.
var test_tree = null

# The pointer to the current node in the test tree. This can be
# a TDTestCase or a TDTestGroup depending on where your are in the
# process.
var __pointer = null

var __TD_TEST__ = true

###################################################################################################
# PUBLIC API                                                                                      #
###################################################################################################

# HOOKS ###########################################################################################

## The main hook for writing your tests.
## [br]
## Every class inheriting from [code]TDTest[/code] should override this function to put tests in.
## [br]
## Example:[br]
## [codeblock]
## class_name ExampleTest extends TDTest
## 
## func test_drive():
##     group('my tests', func():
##         test('a single test', func():
##             assert_true(true)
##         )
##
##         test('another test', func():
##             assert_false(false)
##         )
##      )
## [/codeblock]
func test_drive():
  pass

## Specifies a set of actions that will happen before every test in the same group.
## [br]
## If specified at the top level of the [code]test_drive()[/code] function, the action will performed for every test
## in the file. If it's specified within a group, only tests in that group and its subgroups will perform the action.
## Multiple `before_each()` hooks may be specified at each level if needed.
## [br]
## `before_each()` definitions on higher groups are executed before `before_each()` calls lower down.
## [br]
## In other words, if you have the following:[br]
## [codeblock]
## group('my group', func():
##     before_each(func():
##         print('A')
##     )
##     
##     group('my subgroup', func():
##         before_each(func():
##             print('B')
##         )
##         
##         test('my test', func():
##             print('C')
##         )
##     )
## )
## [/codeblock]
## Then "A" will always print before "B", which will always print before "C". This would be true even if the [code]before_each[/code] hook
## in [code]my group[/code] is defined [i]after[/i] [code]my subgroup[/code].
func before_each(fn: Callable = func(): pass):
  __pointer.before_each(fn)

## Specifies a set of actions that will happen after every test in the same group.
## [br]
## If specified at the top level of the [code]test_drive()[/code] function, the action will performed after each test
## in the file. If it's specified within a group, only tests in that group and its subgroups will perform the action.
## Multiple `after_each()` hooks may be specified at each level if needed.
## [br]
## `after_each()` definitions on higher groups are executed after `after_each()` calls lower down.
## [br]
## In other words, if you have the following:[br]
## [codeblock]
## group('my group', func():
##     after_each(func():
##         print('D')
##     )
##     
##     group('my subgroup', func():
##         after_each(func():
##             print('C')
##         )
##         
##         test('Test A', func():
##             print('A')
##         )
##         
##         test('Test B', func():
##             print('B')
##         )
##     )
## )
## [/codeblock]
## Then the printing order would look like: A, C, D, B, C, D
## [br]
## Test A will run, then the [method after_each] calls will run for that test. Then, B will run, and each of the [method after_each] calls will be called again.
func after_each(fn: Callable = func(): pass):
  __pointer.after_each(fn)

## Not recommended. Prefer using [method before_each] where possible.
## [br]
## This hook will perform a set of actions once before all tests within a group. Calls to [method before_all] in an outer group will happen before calls in an inner group.
## [br]
## For example:
## [codeblock]
## test_drive():
##     before_all(func():
##         print('A')
##     )
##
##     group('my group', func():
##         before_all(func():
##             print('B')
##         )
##
##         test('Test C', func():
##             print('C')
##         )
##
##         test('Test D', func():
##             print('D')
##         )
##     )
## [/codeblock]
## The order of prints would be: A, B, C, D.
## [br]
## In other words, the outer [method before_all] will be called before the inner one,
## and both will be called only once before running the two tests.
func before_all(fn: Callable = func(): pass):
  __pointer.before_all(fn)

## Not recommended. Prefer using [method after_each] where possible, since it's not recommended to share state between states.
## [br]
## This hook will perform a set of actions once after all tests within a group. Calls to [method after_all] in an outer group will happen after calls in an inner group.
## [br]
## For example:
## [codeblock]
## test_drive():
##     after_all(func():
##         print('D')
##     )
##
##     group('my group', func():
##         after_all(func():
##             print('C')
##         )
##
##         test('Test A', func():
##             print('A')
##         )
##
##         test('Test B', func():
##             print('B')
##         )
##     )
## [/codeblock]
## The order of prints would be: A, B, C, D.
## [br]
## In other words, the outer [method after_all] will be called [i]after[/i] the inner one,
## and both will be called only once after running the two tests.
func after_all(fn: Callable = func(): pass):
  __pointer.after_all(fn)

## Waits a period of time before continuing test execution.
## [br]
## Not recommended. If you do choose to use it, then use it sparingly, as it's unlikely to actually fix flaky tests you might be tempted to apply this to.
## [br]
## [b]Parameters:[/b][br]
## - [seconds: float] the number of seconds to wait.
## [br]
## [b]Example:[/b]
## [codeblock]
## test('example test', func():
##   print('A')
##   await wait(10) # waits 10 seconds before continuing
##   print('B')
## )
## [/codeblock]
func wait(seconds):
  var t = N.create_native(Timer)
  t.one_shot = true
  t.start(seconds)
  return t.timeout

## A convenience hook for grouping related tests together.
## [br]
## [b]Parameters[/b][br]
## - [description: String] the group's description.[br]
## - [fn: Callable] the content of the group; an anonymous function containing calls into other groups, hooks, and tests
## [br]
## Example: [br]
## [codeblock]
## func test_drive():
##     group('tests for subfeature A', func():
##         test('subfeature A prints A', func():
##             print('A')
##         )
## 
##         test('subfeature A is not a potato', func():
##             print('checking potato-hood...')
##         )
##     )
##
##     group('tests for subfeature B', func():
##         test('etc...', func():
##             print('etc...')
##         )
##     )
## [/codeblock]
## Groups generally don't affect how tests are run aside from interactions with [method before_each], [method before_all], [method after_each], and [method after_all]
func group(description: String, fn: Callable = func(): pass):
  var group_node = TDTestGroup.new(self, description, __pointer)
  __pointer = group_node
  fn.call()
  __pointer = __pointer.parent
  return group_node

## Defines the content of a specific test.
## [br]
## [b]Parameters:[/b][br]
## - [description: String] The test's description. Good test descriptions are grammatically correct complete sentences that accurately describe the specific behavior of the feature under test.[br]
## - [fn: Callable = Callable()] The test definition. A function containing a combination of actions on the feature and one or more assertions. Typically individual tests should be small, 20-25 lines or shorter.
## [br]
## [b]Example:[/b][br]
## [codeblock]
## func test_drive():
##     test('The truth is still true', func():
##         assert_true(true)
##         assert_equal(true, true)
##         assert_false(!true)
##     )
## [/codeblock]
func test(description: String, fn: Callable = func(): pass):
  return TDTestCase.new(self, description, fn, __pointer)

# MOCKING #########################################################################################

## Creates a mock of the provided script.
## [br]
## Mocks are one of the most important concepts to understand in unit testing. 
## They are fake versions of classes you've written and classes defined by Godot, whose behavior you can modify directly for the needs of your specific test case.
## They allow you to isolate individual classes from their dependencies by controlling how those dependencies behave.
## [br]
## To learn the ins and outs of mocking, see [#TODO create a page on mocking]
func mock(script) -> Mock:
  return Mock.new(script)

## Creates a spy for a given method.
## [br]
## This is intended to be used with Mocks.
## [br]
## [b]Parameters[/b][br]
## - [fn: Callable] The mocked method to spy on.
## [br]
## [b]Example & Explanation[/b]
## [br]
## [codeblock]
## test('example spy usage', func(): 
##     # spy() Works on mocked classes, whether using a mock implementation or not.
##     var MockMyClass = mock(MyClass)
##     MockMyClass.my_other_method.returns('mocked return value')
##     var class_spy1 = spy(MockMyClass.my_method) 
##     var class_spy2 = spy(MockMyClass.my_other_method)
##
##     # It works on specific instances of the mocked class, too!
##     var instance = MockMyClass.new()
##     var instance_spy1 = spy(instance.my_method) 
##     var instance_spy2 = spy(instance.my_other_method)
##
##     # If there's no difference in implementation between the function bound to an instance and the 
##     # class definition of that function, the spies will refer to the same TDSpy.
##     instance.my_method()
##     assert_true(class_spy1.called)
##     assert_true(instance_spy1.called)
##     
##     # The same is true for methods with mock implementations. Same implementation = Same spy
##     assert_equal(instance.my_other_method(), 'mocked return value')
##     assert_true(class_spy2.called)
##     assert_true(instance_spy2.called)
##     
##
##     # HOWEVER...
##     # ...if there IS a difference in implementation from one instance to another, 
##     # you'll receive separate spies depending on which instance the function was bound to.
##     # Spying on the function's definition on the class won't know which instance of the function you care about, 
##     # and so will receive its own spy as well.
##     var MockOtherClass = mock(OtherClass)
##     MockOtherClass.use_defaults()
##
##     var instanceA = MockOtherClass.new('return_init_string() now returns this string')
##     var instanceB = MockOtherClass.new('return_init_string() returns this string instead!')
##     
##     var useless_class_spy = spy(MockOtherClass.return_init_string)
##     var spyA = spy(instance2.return_init_string)
##     var spyB = spy(instance3.return_init_string)
##
##     # Note here that spyA was called, but spyB and useless_class_spy weren't!
##     assert_equal(instanceA.return_init_string(), 'return_init_string() now returns this string')
##     assert_true(spyA.called)
##     assert_false(spyB.called)
##     assert_false(useless_class_spy.called)
##
##     # That's because they're tracking entirely different versions of the same function, and both are different from the class definition:
##     assert_equal(instanceB.return_init_string(), 'return_init_string() returns this string instead!')
##     assert_true(spyB.called)
##     assert_false(useless_class_spy.called)
##
##     # So be careful to pick the right spy when multiple instances of a mock are involved!
##     # Remember: same implementation = same spy
## )
## [/codeblock]
func spy(fn) -> TDSpy:
  if is_instance_of(fn, TYPE_CALLABLE):
    return MethodCache.get_spy(fn)
  elif is_instance_of(fn, MockedMethod):
    return fn.get_spy()
  else:
    TDLogger.warning('Function {fn} is not a mocked method'.format({
      fn=fn.get_method()
    }))
    return null

# ASSERTIONS ######################################################################################

## Asserts that two variants are considered equal.
## [br]
## [b]Parameters:[/b][br]
## - [actual] The actual value[br]
## - [expected] The expected value[br]
## - [message: String = 'expected {actual} to equal {expected}'] The message to display when the assertion fails.
func assert_equal(actual, expected, message='expected {0} to equal {1}'.format([actual, expected])):
  if not __pointer.passing:
    return
  elif expected != actual:
    __pointer.mark_failed(message)

## Asserts that a value or expression is considered true.
## [br]
## [b]Parameters:[/b][br]
## - [actual] The actual value[br]
## - [message: String = 'expected {actual} to be true'] The message to display when the assertion fails.
func assert_true(actual, message='expected {0} to be true'.format([actual])):
  if not __pointer.passing:
    return
  elif actual != true:
    __pointer.mark_failed(message)

## Asserts that a value or expression is considered false.
## [br]
## [b]Parameters:[/b][br]
## - [actual] The actual value[br]
## - [message: String = 'expected {actual} to be false'] The message to display when the assertion fails.
func assert_false(actual, message='expected {0} to be false'.format([actual])):
  if not __pointer.passing:
    return
  elif actual != false:
    __pointer.mark_failed(message)

## Asserts that a value or expression is not null.
## [br]
## [b]Parameters:[/b][br]
## - [actual] The actual value[br]
## - [message: String = 'expected {actual} not to be null'] The message to display when the assertion fails.
func assert_exists(actual, message='expected {0} not to be null'.format([actual])):
  if not __pointer.passing:
    return
  elif actual == null:
    __pointer.mark_failed(message)

## Asserts that a value or expression is null.
## [br]
## [b]Parameters:[/b][br]
## - [actual] The actual value[br]
## - [message: String = 'expected {actual} to be null'] The message to display when the assertion fails.
func assert_null(actual, message='expected {0} to be null'.format([actual])):
  if not __pointer.passing:
    return
  elif actual != null:
    __pointer.mark_failed(message)

## Asserts that the given array is empty.
## [br]
## [b]Parameters:[/b][br]
## - [arr: Array] The array to test[br]
## - [message: String = 'expected array to be empty; actual size: <size>'] The message to display when the assertion fails.
func assert_empty(arr: Array, message='expected array to be empty; actual size: {0}'.format([arr.size()])):
  if not __pointer.passing:
    return
  elif arr.size() > 0:
    __pointer.mark_failed(message)

# MEMORY MANAGEMENT ###############################################################################

func autofree(thing):
  if is_instance_of(thing, Node):
    Autofree.add(thing)
  
  return thing

###################################################################################################
# TEST DRIVER API                                                                                 #
###################################################################################################

func _init() -> void:
  Only.watch(self)
  test_tree = TDTestGroup.new(self, self.get_script().get_global_name())
  __pointer = test_tree
  test_drive()

func attach(node):
  __pointer = node

func detach(node):
  __pointer = null

func evaluate():
  if test_tree.is_empty():
    return

  TDLogger.log()
  await test_tree.evaluate()

func report_result():
  TDLogger.log()
  test_tree.report_result()

func cleanup():
  test_tree.cleanup()
  test_tree = null
  __pointer = null

func passed():
  return test_tree != null && test_tree.passing
