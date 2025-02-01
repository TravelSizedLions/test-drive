class_name TDSpy

var fully_qualified_name: String = 'func'
var original_fn = null
var calls: Array[TDCall] = []
var __linked_class_spy: TDSpy

var last_call: TDCall:
  get: return calls.back() if calls.size() else null

var first_call: TDCall:
  get: return calls.front() if calls.size() else null

var num_calls: int:
  get: return calls.size()

var called: bool:
  get: return calls.size() > 0

func _init(fn = null, fq_name = 'func') -> void:
  original_fn = fn
  fully_qualified_name = fq_name

func invoke(args = []):
  args = args if args else []
  var result = null
  
  if original_fn:
    result = Funk.invoke(original_fn, args)
    TDLogger.__td_debug__('{fn}({args}) => {ret}\nmethod info: {info}'.format({
      fn = fully_qualified_name,
      args = args,
      ret = result,
      info = S.pretty({
        name = original_fn.get_method(),
        arg_count = original_fn.get_argument_count(),
        bound_args = original_fn.get_bound_arguments(),
        bound_args_count = original_fn.get_bound_arguments_count(),
        obj = original_fn.get_object(),
        obj_id = original_fn.get_object_id(),
        is_custom = original_fn.is_custom(),
        is_null = original_fn.is_null(),
        is_standard = original_fn.is_standard(),
        is_valid = original_fn.is_valid()
      })
    }))

    if __linked_class_spy:
      __linked_class_spy.calls.append(TDCall.new(args, result))

  elif __linked_class_spy:
    result = __linked_class_spy.invoke(args)
  else:
    TDLogger.__td_debug__('{fn}({args}) => null (stub)'.format({
      fn=fully_qualified_name,
      args=args
    }))

  calls.append(TDCall.new(args, result))

  return result

func link_class_spy(spy: TDSpy):
  __linked_class_spy = spy

func ever_called_with(arg0 = Funk.UNDEFINED, arg1 = Funk.UNDEFINED, arg2 = Funk.UNDEFINED, arg3 = Funk.UNDEFINED, arg4 = Funk.UNDEFINED, rest = []) -> bool:
  var expected_args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)

  if num_calls == 0:
    return false

  if expected_args.size() > first_call.args.size():
    return false

  for call in calls:
    var actual_args = call.args
    var matching = true

    for i in range(expected_args.size()):
      if typeof(actual_args[i]) != typeof(expected_args[i]):
        matching = false
        break

      if actual_args[i] != expected_args[i]:
        matching = false
        break

    if matching:
      return true

  return false


func ever_called_with_exactly(arg0 = Funk.UNDEFINED, arg1 = Funk.UNDEFINED, arg2 = Funk.UNDEFINED, arg3 = Funk.UNDEFINED, arg4 = Funk.UNDEFINED, rest = []) -> bool:
  var expected_args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)

  if num_calls == 0:
    return false

  if expected_args.size() != first_call.args.size():
    return false

  for call in calls:
    var actual_args = call.args
    var matching = true

    for i in range(expected_args.size()):
      if typeof(actual_args[i]) != typeof(expected_args[i]):
        matching = false
        break

      if actual_args[i] != expected_args[i]:
        matching = false
        break

    if matching:
      return true

  return false

func last_called_with(arg0 = Funk.UNDEFINED, arg1 = Funk.UNDEFINED, arg2 = Funk.UNDEFINED, arg3 = Funk.UNDEFINED, arg4 = Funk.UNDEFINED, rest = []) -> bool:
  if num_calls == 0:
    return false

  var expected_args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  if expected_args.size() > first_call.args.size():
    return false

  var matching = true
  for i in range(expected_args.size()):
    if typeof(last_call.args[i]) != typeof(expected_args[i]):
      matching = false
      break

    if last_call.args[i] != expected_args[i]:
      matching = false
      break

  return matching

func last_called_with_exactly(arg0 = Funk.UNDEFINED, arg1 = Funk.UNDEFINED, arg2 = Funk.UNDEFINED, arg3 = Funk.UNDEFINED, arg4 = Funk.UNDEFINED, rest = []) -> bool:
  if num_calls == 0:
    return false

  var expected_args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  if expected_args.size() != first_call.args.size():
    return false

  var matching = true
  for i in range(expected_args.size()):
    if typeof(last_call.args[i]) != typeof(expected_args[i]):
      return false

    if last_call.args[i] != expected_args[i]:
      return false

  return true

func called_times(num) -> bool:
  return calls.size() == num

func duplicate():
  return TDSpy.new(original_fn, fully_qualified_name)
