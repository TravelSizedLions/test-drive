class_name TDTestCase

var __test_file: TDTest
var description: String
var value: Callable = func(): pass

var passing = true
var failure_message = ''
var stack = null

var parent = null

func _init(test_file: TDTest, description: String, fn: Callable = func(): pass, parent_node=null):
  __test_file = test_file
  self.description = description
  self.value = fn
  if parent_node:
    link_parent(parent_node)

func evaluate(depth: int=0):
  __test_file.attach(self)
  await value.call()
  self.print(depth)
  __test_file.detach(self)

func link_parent(group):
  parent = group
  group.value.append(self)

func mark_failed(message=''):
  passing = false
  failure_message = message
  parent.mark_failed()

  stack = get_stack()

  # removes failure plumbing from the top of the stack to
  # point the tester to the failed assertion.
  stack.pop_front()
  stack.pop_front()

func print(indent_level: int):
  TDLogger.log('{padding}{pass_fail} {desc}'.format({
    'padding': "∙  ".repeat(indent_level),
    'desc': description,
    'pass_fail': '✔️' if passing else '❌',
  }))

func report_result(indent_level: int = 0):
  if passing:
    return

  var stack_to_string = func(stack, level):
    var lines = []
    for call in stack:
      lines.push_back('   '.repeat(level) + '{source}, func {function} (line {line})'.format(call))
    
    return '\n'.join(lines)

  TDLogger.log('{padding}○ {desc}: FAIL - {message}\n{stack}\n'.format({
    'padding': "   ".repeat(indent_level),
    'desc': description,
    'message': failure_message,
    'stack': stack_to_string.call(stack, indent_level+1)
  }))


func cleanup():
  __test_file = null
