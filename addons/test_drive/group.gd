class_name TDTestGroup

# test processing
var description: String
var __test_file: TDTest
var __before_each_hooks = []
var __after_each_hooks = []
var __before_all_hooks = []
var __after_all_hooks = []
var value = []

# results processing
var passing = true

# tree structuring
var parent = null

func _init(test_file: TDTest, description: String, parent_node=null) -> void:
  __test_file = test_file
  self.description = description
  if parent_node:
    link_parent(parent_node)

func evaluate(depth: int = 0):
  self.print(depth)
  __dispatch(__before_all_hooks)
  for node in value:
    var is_test_case = is_instance_of(node, TDTestCase)
    if is_test_case:
      MethodCache.clear()
      PropertyCache.clear()
      __dispatch(__before_each_hooks)
    
    await node.evaluate(depth+1)

    if is_test_case:
      __dispatch(__after_each_hooks)
  __dispatch(__after_all_hooks)  


func print(indent_level: int):
  TDLogger.log('{0}{1}{2}/'.format([
    "∙  ".repeat(indent_level),
    "∟ " if indent_level > 0 else "",
    description
  ]))

func report_result(indent_level: int = 0):
  if passing:
    return
  
  self.print(indent_level)
  for child in value:
    child.report_result(indent_level+1)

func link_parent(parent_node):
  parent = parent_node
  parent.value.append(self)
  __before_each_hooks.append_array(parent.__before_each_hooks)
  __after_each_hooks.append_array(parent.__after_each_hooks)

func mark_failed():
  passing = false
  if parent && parent.passing:
    parent.mark_failed()

func before_each(fn: Callable=func(): pass):
  __before_each_hooks.append(fn)

func after_each(fn: Callable=func(): pass):
  __after_each_hooks.append(fn)

func before_all(fn: Callable=func(): pass):
  __before_all_hooks.append(fn)

func after_all(fn: Callable=func(): pass):
  __after_all_hooks.append(fn)

func __dispatch(hooks):
  for hook in hooks: hook.call()

func is_empty():
  return value.size() == 0;

static func empty_from(group):
  return TDTestGroup.new(group.__test_file, group.description)

static func from(group):
  var clone = TDTestGroup.new(group.__test_file, group.description)
  clone.__before_each_hooks.append_array(group.__before_each_hooks.duplicate(true))
  clone.__after_each_hooks.append_array(group.__after_each_hooks.duplicate(true))
  clone.__before_all_hooks.append_array(group.__before_all_hooks.duplicate(true))
  clone.__after_all_hooks.append_array(group.__after_all_hooks.duplicate(true))
  return clone


func cleanup() -> void:
  __before_each_hooks.clear()
  __after_each_hooks.clear()
  __before_all_hooks.clear()
  __after_each_hooks.clear()
  for v in value: v.cleanup()
  while value.size(): value.pop_back()
  __test_file = null
