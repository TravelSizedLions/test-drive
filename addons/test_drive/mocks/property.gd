class_name Property

static var EXCLUDED_CHARACTERS = ['-', '.', ' ']
static var NATIVE_CLASSES = ClassDB.get_class_list()
static var EXCLUDED_PROPERTIES = []

var name: StringName
var class_name_: StringName
var type: Variant.Type
var hint: PropertyHint
var hint_string: String
var usage: PropertyUsageFlags
var is_static: bool

static func _static_init() -> void:
  EXCLUDED_PROPERTIES.append_array(
    ClassDB.class_get_property_list('Resource').map(func (prop): return prop.name)
  )

var source_code: String:
  get: 
    return '{stat}var {name}{type}'.format({
      name=name,
      type=str(': '+type_string(type)) if type != TYPE_NIL else '',
      stat='static ' if is_static else ''
    })
  set(val): pass

func _init(options={}):
  name = Funk.option(options, 'name', '')
  class_name_ = Funk.option(options, 'class_name', '')
  type = Funk.option(options, 'type', TYPE_NIL)
  hint = Funk.option(options, 'hint', PROPERTY_HINT_NONE)
  hint_string = Funk.option(options, 'hint_string', '')
  usage = Funk.option(options, 'usage', PROPERTY_USAGE_STORAGE)
  is_static = Funk.option(options, 'static', false)

func export() -> Dictionary:
  return {
    name=name,
    'class_name'=class_name_,
    type=type,
    hint=hint,
    hint_string=hint_string,
    usage=usage,
    'static'=is_static
  }

func is_valid():
  # get_property_list() can return property info that
  # shadows native classes or just straight up doesn't have a valid name.
  # This filters them out so the mock script can actually reload.
  return not (
    name in NATIVE_CLASSES || 
    name in EXCLUDED_PROPERTIES ||
    EXCLUDED_CHARACTERS.any(func (char): return char in name)
  )
