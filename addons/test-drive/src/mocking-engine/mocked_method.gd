class_name MockedMethod

var __real: Method
var __uses_default: bool = false

var source_code:
  set(val): pass
  get:
    # GDScript doesn't support getting the implementation details of a method dynamically,
    # so we have to store function definitions in a statically defined
    # cache and invoke them with indirection. Fun!
    var invoke = '{ret}MethodCache.invoke("{klass}", "{name}", args, {inst_var})'.format({
      klass=__real.klass_name,
      name=__real.name,
      inst_var=TD.INSTANCE_INJECTION_VARNAME if not __real.is_static else 'null',
      ret='return ' if not __real.is_constructor else ''
    })

    # GDScript also doesn't support getting a dynamic list of arguments to pass into the MethodCache.invoke().
    # So instead, we create a var that defines one based on the parameters of the function signature.
    #
    # We also append '_' to the original parameter name, since some naughty engine devs thought they
    # could shadow gdscript keywords without us noticing. Nice try ;)
    var arglist = 'var args = [{args}]'.format({
      args=','.join(__real.args.map(func(arg): return '{n}_'.format({n=arg.name})))
    })

    # Lastly, we have a convenience array for TestDrive development. It lets us inject additional code into 
    # mock scripts so we can get information about what's being passed through to the method cache
    var debug: Array[String] = []

    # And now we just put all the pieces together. :D
    return '{sig}:\n\t{arglist}\n\t{debug}\n\t{invoke}\n'.format({
      sig=__real.signature,
      arglist=arglist,
      invoke=invoke,
      debug='\n\t'.join(debug)
    })

func _init(func_metadata={}) -> void:
  __real = Method.new(func_metadata)

func pick_random(arr: Array):
  var choice = randi_range(0, arr.size()-1)
  return arr[choice]

func is_mocked():
  # Seems like the __fn_cache in the method cache is storing objects that aren't
  # spies, but that seems like it should be impossible....? 
  return not __uses_default \
    && MethodCache.has(__real.klass_name, __real.name) \
    && MethodCache.get_spy_from_name(__real.klass_name, __real.name).original_fn != null

func use_empty():
  mock(null)

func use_default(klass_instance):
  mock(Callable(klass_instance, __real.name), {instance=klass_instance})
  __uses_default = true

func get_spy() -> TDSpy:
  if not MethodCache.has(__real.klass_name, __real.name):
    use_empty()

  return MethodCache.get_spy_from_name(__real.klass_name, __real.name)

func bind(klass_instance=null):
  var m = MethodCache.get_spy_from_name(__real.klass_name, __real.name, klass_instance)
  MethodCache.register_method(__real.klass_name, __real.name, m.original_fn if m else null, klass_instance)

func link(other: MockedMethod, options={}):
  var instance = Funk.option(options, 'instance', null)
  if MethodCache.has(other.__real.klass_name, __real.name):
    MethodCache.link(other.__real.klass_name, __real.klass_name, __real.name, instance)

func reuse(other: MockedMethod):
  if MethodCache.has(other.__real.klass_name, __real.name):
    MethodCache.reuse(other.__real.klass_name, __real.klass_name, __real.name)

func mock(fn, options={}):
  MethodCache.register_method(__real.klass_name, __real.name, fn, Funk.option(options, 'instance', null))
  __uses_default = false

func returns(value):
  mock(func(): return value)
  __uses_default = false

func export():
  return __real.export()

func export_as_property():
  var real_exp = __real.export()
  return {
    name=real_exp.name,
    'class_name'=__real.klass_name,
    type=TYPE_CALLABLE,
    hint=PROPERTY_HINT_NONE,
    usage=PROPERTY_USAGE_DEFAULT
  }

func is_valid():
  return __real.is_valid()
