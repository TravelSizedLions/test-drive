class_name MockedProperty

var __real: Property
var __mock_class_name: String
var value:
  get: return PropertyCache.get_value(__mock_class_name, __real.name, __real.type)
  set(val): PropertyCache.set_value(__mock_class_name, __real.name, val)

var source_code:
  get: 
    var src = __real.source_code
    return __real.source_code + ' = PropertyCache.get_value("{k}", "{p}", {t})'.format({k=__mock_class_name, p=__real.name, t=__real.type})
  set(val): pass

func _init(real_member={}) -> void:
  __mock_class_name = Funk.option(real_member, 'mock_class_name')
  __real = Property.new(real_member)

func export():
  var exp = __real.export()
  exp.value = value
  return exp

func is_mocked():
  return value != PropertyCache.default_for_type(__real.type)

func is_valid():
  return __real.is_valid()
