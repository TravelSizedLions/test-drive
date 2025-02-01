class_name Mock

var klass: String
var guid = randi()

var __analyzer: SourceAnalyzer

var __real_script
var original:
  get: return __real_script
  set(val): pass

var __properties: Dictionary = {}
var properties: Dictionary:
  get: return __properties
  set(_val): pass

var __methods: Dictionary = {}
var methods: Dictionary:
  get: return __methods
  set(_val): pass

var __using_defaults: bool = false

# Start with the default constructor reflection object.
var __constructor: Dictionary = {
  'name'='_init',
  'args'=[],
  'default_args'=[],
  'flags'=1,
  'id'=0,
  'return'={
    'name'='',
    'class_name'=&'',
    'type'=0,
    'hint'=0,
    'hint_string'='',
    'usage'=0
  }
}

var constructor: Dictionary:
  get: return __constructor
  set(_val): pass

func _init(real_script):
  __real_script = ScriptCache.load_script(real_script)
  __analyzer = SourceAnalyzer.new(__real_script)

  var props
  var methods

  if ScriptCache.is_native(real_script):
    __real_script = real_script
    var name = ScriptCache.name_of(__real_script)
    props = ClassDB.class_get_property_list(name)
    methods = ClassDB.class_get_method_list(name)
  else:
    props = (
      __real_script.get_script_property_list()
      if is_instance_of(__real_script, Script)
      else __real_script.get_property_list()
    )

    methods = __real_script.get_script_method_list()

    # use the original class's constructor if it's not defined.
    var _init_method = methods.filter(func(m): return m.name == '_init')
    if _init_method.size() > 0:
      __constructor = _init_method[0]
  
  # Guarantee the mock class definition isn't shadowed.
  var real_class = ScriptCache.name_of(__real_script)
  klass = 'Mock{real_class}{guid}'.format({
    real_class=real_class if real_class != '' else Resource.generate_scene_unique_id(),
    guid=guid
  })

  for p in props:
    p.mock_class_name = klass
    p.static = __analyzer.is_static(p.name)
    var prop = MockedProperty.new(p)
    if prop.is_valid():
      __properties[p.name] = prop

  for m in methods:
    # methods don't know which class they belong to with Godot's reflection system, 
    # so we assign it manually
    m.klass = klass
    m.static = __analyzer.is_static(m.name)
    m.is_constructor = __analyzer.is_constructor(m.name)
    var method = MockedMethod.new(m)
    if method.is_valid():
      __methods[m.name] = method

func _get(property: StringName) -> Variant:
  # gets the member value and does some tracking
  if property in __properties:
    return __properties[property]
  elif property in __methods:
    return __methods[property]
  
  return null

func _set(property: StringName, value: Variant) -> bool:
  if property in __properties:
    if 'value' in __properties[property]:
      __properties[property].value = value
    else:
      __properties[property] = value
    return true
  elif property in __methods:
    __methods[property] = value
    return true
    
  # sets the property value and does some mock tracking
  return false

# Whether or not to use the original implementation for functions of the class. Mocks do not use the
# original implementation by default
func use_defaults(value: bool=true):
  __using_defaults = value

func get_property_list():
  # return every entry in __members, formatted for this BS.
  var props: Array[Dictionary] = []
  for key in __properties:
    props.append(__properties[key].export())
  
  for key in __methods:
    props.append(__methods[key].export_as_property())
    
  return props

func new(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var cloned = self.duplicate()

  var params = cloned.constructor.args
  var args = [arg0, arg1, arg2, arg3, arg4]
  args.append_array(rest)
  var arginfo = Funk.match_args(params, args)
  if __should_apply_original_implementation(arginfo, params, constructor.default_args):
    return __original_class_implementation(cloned, arginfo.matched)
  else:
    return __empty_class_implementation(cloned)

func __original_class_implementation(clone, init_args):
  var real_instance = Callable.create(clone.original, 'new').callv(init_args)

  for fn_name in clone.methods:
    var instance_method = clone.methods[fn_name]
    var class_method = methods[fn_name]
    if not class_method.is_mocked():
      class_method.bind()
      instance_method.use_default(real_instance)
    else:
      instance_method.bind(real_instance)

    instance_method.link(class_method, {instance=real_instance})
    
  for prop_name in properties:
    var copy = clone.properties[prop_name]
    if not copy.is_mocked():
      copy.value = real_instance.get(prop_name)

  var mock_instance = MockScript.create(clone).new()
  mock_instance.set(TD.INSTANCE_INJECTION_VARNAME, real_instance)
  return mock_instance

func __empty_class_implementation(clone):
  for fn_name in clone.methods:
    var class_method = methods[fn_name]
    var instance_method = clone.methods[fn_name]
    if not class_method.is_mocked():
      class_method.bind()
    instance_method.reuse(class_method)
    instance_method.link(class_method)

  var instance = MockScript.create(clone).new()
  instance.set(TD.INSTANCE_INJECTION_VARNAME, null)
  return instance
  
func __should_apply_original_implementation(arginfo, params, defaults):
  if not __using_defaults:
    return false

  if arginfo.unmatched.size():
    TDLogger.warning('Skipping default implementation due to unmatched arguments:', arginfo.unmatched)
    return false

  if arginfo.matched.size() > params.size():
    TDLogger.warning('\n'.join([
      'Skipping default implementation due to too many dang args',
      '- expected {n} arguments'.format({n=params.size()}),
      '- provided {n} arguments: {a}'.format({n=arginfo.matched.size(), a=arginfo.matched})
    ]))
    return false

  # When constructing the call, the matched args take the place of default args
  # if specified. So if there are fewer matched args than params but the combined total of 
  # matched args and default args is greater than the number of
  # parameters, then that'll make for a valid call.
  return arginfo.matched.size() + defaults.size() >= params.size()


func duplicate():
  var cloned = Mock.new(__real_script)

  # Copy over any mocked values
  for prop_name in properties:
    cloned.properties[prop_name].value = properties[prop_name].value

  return cloned
