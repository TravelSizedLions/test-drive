class_name Method

static var EXCLUDED = []
static var EXCLUDED_CHARS = ['@']

var klass_name: String
var name: String
var args: Array
var default_args: Array
var flags: MethodFlags
var id: int
var return_type: Property
var is_static: bool
var is_constructor: bool

static func _static_init() -> void:
  EXCLUDED.append_array(['new', '_init'])
  EXCLUDED.append_array(
    ClassDB.class_get_method_list('Resource').map(func (def): return def.name)
  )

var signature: String:
  get:
    return '{stat}func {name}({params})'.format({
      name=name,
      # Some parameters in native functions shadow keywords like 'class', so appending an
      # underscore guarantees a safe script compile
      params=','.join(args.map(func (arg_info): return (arg_info.name + '_' + '=null'))),
      stat='static ' if is_static else ''
    })

var source_code: String:
  get: return '\n{sig}: pass'.format({sig=signature})
  set(val): pass

func _init(def = {}):
  klass_name = Funk.option(def, 'klass', 'Object')
  name = Funk.option(def, 'name', '')
  args = Funk.option(def, 'args', []).map(func (arg): return Property.new(arg))
  default_args = Funk.option(def, 'default_args', [])
  flags = Funk.option(def, 'flags', METHOD_FLAGS_DEFAULT)
  id = Funk.option(def, 'id', Resource.generate_scene_unique_id())
  return_type = Property.new(Funk.option(def, 'return', {}))
  is_static = Funk.option(def, 'static', false)
  is_constructor = Funk.option(def, 'is_constructor', false)

func export() -> Dictionary:
  return {
    name=name,
    args=args.map(func (arg): return arg.export()),
    default_args=default_args,
    flags=flags,
    id=id,
    'return'=return_type.export(),
    'static'=is_static,
    'is_constructor'=is_constructor
  }


func is_valid():
  return not (
    name in EXCLUDED ||
    EXCLUDED_CHARS.any(func (ch): return ch in name)
  )
