@tool
class_name MockScript

static func create(mock: Mock):
  var generator = SourceGenerator.new()
  var source = generator.generate(mock)
  var dynamic_script = from_source(source)
  return dynamic_script

static func from_source(src: String):
  var script = GDScript.new()
  script.source_code = src
  script.resource_path = 'res://addons/test_drive/mock_classes/{rid}.gd'.format({
    # Not actually in a scene, just need a guaranteed unique 
    # file name to prevent errors. I might have shamelessly pulled this bit from GUT...
    rid=Resource.generate_scene_unique_id()
  })

  TDLogger.debug_action(func(): ResourceSaver.save(script, script.resource_path))
  TDLogger.__td_debug__(script.source_code)
  var err = script.reload()
  if err:
    TDLogger.error('Error: {e}'.format({e=error_string(err)}))

  return script

class SourceGenerator:
  static var EXCLUDED_CHARACTERS = ['-', '.', ' ']
  static var NATIVE_CLASSES = ClassDB.get_class_list()

  static func generate(mock: Mock):
    var source = []
    source.append(__class_def(mock.klass, mock.original))

    # if (ScriptCache.is_engine_singleton(mock.original)):
    source.append(__real_instance_var())
    source.append_array(__properties(mock.properties))
    
    source.append(__initializer())
    source.append_array(__methods(mock.methods))
    return '\n'.join(source)

  static func __class_def(mock_klass_name, original_script):
    if ScriptCache.is_engine_singleton(original_script):
      return 'class_name {name}\n'.format({
        name=mock_klass_name
      })
    else:
      return 'class_name {mock_name}\n'.format({
        mock_name=mock_klass_name,
      })

  static func __real_instance_var():
    return 'var {inst_var} = null'.format({inst_var=TD.INSTANCE_INJECTION_VARNAME})

  static func __initializer():
    return 'func _init(args=[]): pass'

  static func __properties(props: Dictionary):
    var lines = []
    for name in props:
      if (not 'is_valid' in props[name] or props[name].is_valid()) and 'source_code' in props[name]:
        lines.append(props[name].source_code)
    return lines

  static func __methods(methods: Dictionary):
    var lines = []
    for name in methods:
      lines.append(methods[name].source_code)
    return lines
