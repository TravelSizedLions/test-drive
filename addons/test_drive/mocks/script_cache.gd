class_name ScriptCache

static var __initialized = false
static var __cache = {
  ref_to_path={

  },
  path_to_ref={

  },
  ref_to_name={

  },
  native_classes=ClassDB.get_class_list()
}

# GDScripts referenced directly (i.e. MyClass as opposed to load('res://path/to/my_class.gd'))
# Don't provide the same info as those that are load()'ed, which is BS, but 
# them's the breaks if I want to provide a good mocking API.
# 
# This load()s and registers all scripts and inner classes in the project and caches them
# so that I can actually get the info needed for proper reflection.
static func load_script(script):
  if not __initialized: 
    __initialize()

  if script in __cache.ref_to_path:
    var path = __cache.ref_to_path[script]
    var script_info = __cache.path_to_ref[path]
    if script == script_info.main_class:
      return script_info.main_class
    else:
      var inner = script_info.inner_classes
      return inner[inner.find(script)]

  return null

static func is_native(script):
  return __cache.ref_to_name[script] in __cache.native_classes

static func is_engine_singleton(script):
  return is_native(script) && is_instance_valid(script)

static func name_of(script):
  if not __initialized:
    __initialize()
  
  if script in __cache.ref_to_name:
    return __cache.ref_to_name[script]
  
  return script.get_class()

static func is_inner_class(script):
  if not __initialized:
    __initialize()

  if script in __cache.ref_to_path:
    var info = __cache.path_to_ref[__cache.ref_to_path[script]];
    return is_instance_of(script, info.main_class)
  
  return true

static func initialize():
  __initialize()

static func __initialize():
  var script_paths = FS.search_dir('res://', '*.gd', true)
  for path in script_paths:
    var script = load(path) as GDScript
    __cache.path_to_ref[path] = {
      main_class=script,
      inner_classes=[]
    }
    __cache.ref_to_path[script] = path
    var name = script.get_global_name()
    __cache.ref_to_name[script] = name if name != '' else script.get_class() 
    __cache_inner_classes(script, path)
  
  __cache_native_classes()
  __initialized = true

static func __cache_native_classes():
  var native_map = NativeMap.load()
  var refs = native_map.name_to_ref
  for key in refs:
    __cache.ref_to_name[refs[key]] = key
    __cache.ref_to_path[refs[key]] = key
    __cache.path_to_ref[key] = {
      main_class=refs[key]
    }

static func __cache_inner_classes(loaded_script, path):
  var constants = loaded_script.get_script_constant_map()
  for key in constants:
    var val = constants[key]
    if is_instance_of(val, GDScript):
      __cache.ref_to_path[val] = path
      __cache.path_to_ref[path].inner_classes.append(val)
      __cache.ref_to_name[val] = key

static func clear():
  __cache.ref_to_path.clear()
  __cache.path_to_ref.clear()
  __cache.ref_to_name.clear()
  __cache.native_classes.clear()
  __cache.clear()
  
class NativeMap:
  static var static_classes = [
    'EditorInterface',
    'EditorSettings'
  ]

  static func load():
    var script = GDScript.new()
    script.source_code = ""
    script.source_code += 'var name_to_ref = {\n'
    script.source_code += ',\n'.join(
      Array(ClassDB.get_class_list())
      .filter(func(name): return (
        ClassDB.can_instantiate(name) or name in static_classes
      ))
      .map(func(name): return '\t"{0}"={1}'.format([name, name]))
    )
    script.source_code += '\n}'

    var err = script.reload()
    if err:
      print('Error: ', error_string(err))
    return script.new()
