@tool
class_name WrapperGenerator extends SceneTree

const config_file_path = &'res://addons/test_drive/wrapper_generation/wrappers.json'
const wrapper_folder = &'res://addons/test_drive/editor_wrappers/'

func _init() -> void:
  call_deferred('generate')


func generate():
  var config = load_config()
  for singleton in config.keys():
    gen_file(singleton, config[singleton])
  
  print('generated {num} wrappers!'.format({num=config.keys().size()}))
  self.quit()

func load_config(cb: Callable=func(c): pass):
  var config = FileAccess.open(config_file_path, FileAccess.READ).get_as_text()
  var obj = JSON.parse_string(config)
  cb.call(obj)
  return obj

func gen_file(wrapper, settings):
  var wrapper_name = '{0}{1}'.format([wrapper, 'Wrapper'])
  var file_path = '{0}{1}.gd'.format([wrapper_folder, wrapper.to_snake_case()])

  var file = GDScriptFile.new(file_path, {name=wrapper_name})
  file.property('__wrapper', {
    is_static=true,
    default_value=wrapper
  })

  if 'properties' in settings:
    for prop in settings['properties']:
      file.property(prop, {
        get='return __wrapper.{prop}'.format({prop=prop}),
        set='__wrapper.{prop} = value'.format({prop=prop})
      })

  if 'methods' in settings:
    var params = 'arg0={u},arg1={u},arg2={u},arg3={u},arg4={u},rest=[]'.format({u='Funk.UNDEFINED'})
    for method in settings['methods']:
      file.method(method, {
        is_static=true,
        parameters=params.split(','),
        implementation=[
          'var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)',
          'return Funk.invoke(__wrapper.{name}, args)'.format({name=method})
        ]
      })
    
  file.save()
