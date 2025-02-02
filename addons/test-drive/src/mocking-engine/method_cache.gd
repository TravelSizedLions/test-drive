class_name MethodCache

static var __fn_cache: Dictionary = {}

# Because apparently the engine isn't smart enough keep around instances
# that Callables are bound to between when a method is registered and when it's used,
# we have to manually add references to those objects even though they aren't ever pulled back out
# from this dictionary.
static var __bound_object_cache: Dictionary = {}

## Registers a callable to the method cache for reuse later.
## [br]
## parameters:[br]
## - [klass: String] - The name of the class the method belongs to[br]
## - [fn_name: String] - The name of the method (NOTE: this is NOT the same thing as Callable.get_method())[br]
## - [fn: Callable] - The method to register[br]
## - [instance: Object = null] - A specific instance of the class. For the purposes of mocking, the implementation details of one instance can differ from another based on how they were instantiated
static func register_method(klass: String, fn_name: String, fn=null, instance=null):
  if instance:
    var obj_id = instance.to_string()
    if obj_id not in __bound_object_cache:
      __bound_object_cache[obj_id] = instance
  # elif fn:
  #   var bound_obj = fn.get_object()
  #   if bound_obj:
  #     var obj_id = bound_obj.to_string()
  #     if obj_id not in __bound_object_cache:
  #       __bound_object_cache[obj_id] = bound_obj

  var fully_qualified_name = __fully_qualified(klass, fn_name, instance)
  if fully_qualified_name in __fn_cache and __fn_cache[fully_qualified_name].original_fn == null:
    __fn_cache[fully_qualified_name].original_fn = fn
  else:
    var spy = TDSpy.new(fn, fully_qualified_name)    
    __fn_cache[fully_qualified_name] = spy
    TDLogger.__td_debug__('Registered new method {0}'.format([fully_qualified_name]))

static func link(parent_klass: String, child_klass: String, fn_name: String, instance=null):
  var from = __fully_qualified(parent_klass, fn_name)
  var to = __fully_qualified(child_klass, fn_name, instance)
  __fn_cache[to].link_class_spy(__fn_cache[from])
  TDLogger.__td_debug__('Linking spy {0} to {1}'.format([from, to]))

static func reuse(from_klass: String, to_klass: String, fn_name: String):
  var from = __fully_qualified(from_klass, fn_name)
  var to = __fully_qualified(to_klass, fn_name)
  __fn_cache[to] = __fn_cache[from].duplicate()
  TDLogger.__td_debug__('Reusing spy {0} for {1}'.format([from, to]))

## Gets the spy associated with a registered method.
## [br]
## parameters:[br]
## - [klass: String] - The name of the class the method belongs to[br]
## - [fn_name: String] - The name of the method (NOTE: this is NOT the same thing as Callable.get_method())[br]
## - [instance: Object = null] - A specific instance of the class. For the purposes of mocking, the implementation details of one instance can differ from another based on how they were instantiated
static func get_spy(fn: Callable) -> TDSpy:
  var mock_instance = fn.get_object()
  var injected_instance = mock_instance.get(TD.INSTANCE_INJECTION_VARNAME) \
    if TD.INSTANCE_INJECTION_VARNAME in mock_instance else null

  var script = mock_instance.get_script() if 'get_script' in mock_instance else null
  var klass = script.get_global_name() if 'get_global_name' in script else ''
  var fn_name = fn.get_method()

  return get_spy_from_name(klass, fn_name, injected_instance)

static func get_spy_from_name(klass: String, fn_name: String, instance=null) -> TDSpy:
  var fully_qualified_name = __fully_qualified(klass, fn_name, instance)
  if not fully_qualified_name in __fn_cache:
    TDLogger.__td_debug__('No spy for {0} found. Returning null.'.format([fully_qualified_name]))
    return null

  var result: TDSpy = __fn_cache[fully_qualified_name]
  return result

## Whether or not a given method is cached
##
## returns: true if the method has already been registered, false otherwise
## 
## parameters:[br]
## - [klass: String] - The name of the class the method belongs to[br]
## - [fn_name: String] - The name of the method (NOTE: this is NOT the same thing as Callable.get_method())[br]
## - [instance: Object = null] - A specific instance of the class. For the purposes of mocking, the implementation details of one instance can differ from another based on how they were instantiated
static func has(klass: String, fn_name: String, instance=null) -> bool:
  return __fully_qualified(klass, fn_name, instance) in __fn_cache

## Invokes a method in the cache[br]
## [br]
## returns:[br]
## - Whatever value is returned by the invocation of the cached method[br]
## - If the method is does not exist in the cache, [code]null[/code] is returned[br]
## [br]
## parameters:[br]
## - [klass: String] the class the method belongs to[br]
## - [fn_name: String] the name of the method[br]
## - [args: Array = Array()] the list of arguments to pass to the method[br]
## - [instance: Object = null] The specific instance of the class the desired method is bound to.[br]
static func invoke(klass: String, fn_name: String, args: Array, obj=null):
  var fully_qualified_name = __fully_qualified(klass, fn_name, obj)
  if not fully_qualified_name in __fn_cache:
    TDLogger.warning('No implementation for {k} has been registered. Returning null'.format({k=fully_qualified_name}))
    return null

  return __fn_cache[fully_qualified_name].invoke(args)

## Gets the fully qualified identifier for a function. 
## [br]
## returns:[br]
## - A string of the format "Class::method#instance"[br]
## [br]
## parameters:[br]
## - [klass: String] the class the method belongs to[br]
## - [fn_name: String] the name of the method[br]
## - [instance: Object = null] The specific instance of the class the desired method is bound to.
static func __fully_qualified(klass: String, fn_name: String, instance=null):
  var fully_qualified_name = '{scope}::{fn}'.format({
    scope=klass,
    fn=fn_name
  })

  # because instances of a mock can have different behavior based on whether or
  # not they're using the default implementation and/or used the same init arguments,
  # we also need function identifiers to be unique down to the object instance.
  if instance:
    fully_qualified_name += '#{obj_id}'.format({obj_id=instance.to_string()})

  return fully_qualified_name

static func clear():
  __fn_cache.clear()
  __bound_object_cache.clear()
