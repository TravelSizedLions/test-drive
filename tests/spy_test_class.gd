class_name SpyTestClass

var __init_string: String = ''

func _init(val=''):
  __init_string = val

func returns_init_string():
  return __init_string

func returns_a():
  return 'A'

func returns_b():
  return 'B'

func returns_string(val):
  return val

func takes_multiple_args(arg1, arg2, arg3):
  pass
