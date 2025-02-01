class_name GDScriptFile

var __lines: Array = []
var __path: String = ''

func _init(path, options={}):
  var is_tool = Funk.option(options, 'is_tool')
  var klass = Funk.option(options, 'name')
  var parent = Funk.option(options, 'parent')

  __path = path
  if is_tool:
    newline()
    add('@tool')
  
  newline()
  if klass:
    add('class_name {klass}'.format({klass=klass}))
    if parent:
      add(' ')

  if parent:
    add('extends {parent}'.format({parent=parent}))
  newline()
  newline()


func newline():
  __lines.append('')
  return self

func add(v):
  __lines[__lines.size()-1] += v
  return self

func add_lines(lines: Array, options={}):
  var tabs = Funk.option(options, 'tabs', 0)
  var tab_size = Funk.option(options, 'tab_size', 2)

  for line in lines:
    add(' '.repeat(tabs*tab_size) + line)
    newline()

  newline()
  return self

func tab():
  return add('  ')

func property(name: String, options = {}):
  var is_static = Funk.option(options, 'is_static', false)
  var type = Funk.option(options, 'type')
  var default_value = Funk.option(options, 'default_value', Funk.UNDEFINED)
  var getter = Funk.option(options, 'get')
  var setter = Funk.option(options, 'set')

  var signature = 'static ' if is_static else ''
  signature += 'var {name}'.format({name=name})
  if type:
    signature += ': {type}'.format({type=type})

  if not Funk.is_undefined(default_value):
    signature += ' = {val}'.format({val=default_value})

  var lines = []
  if getter or setter:
    signature += ':'
    if getter:
      lines.append('get: {getter}'.format({getter=getter}))
    if setter:
      lines.append('set(value): {setter}'.format({setter=setter}))
  
  add(signature)
  newline()
  return add_lines(lines, {tabs=1})


func method(name: String, options = {}):
  var is_static = Funk.option(options, 'is_static', false)
  var parameters = Funk.option(options, 'parameters', [])
  var return_type = Funk.option(options, 'return_type')
  var implementation = Funk.option(options, 'implementation')

  var signature = 'static ' if is_static else ''
  signature += 'func {name}'.format({name=name})
  
  signature += '('
  for i in range(parameters.size()):
    signature += parameters[i]
    if i != parameters.size()-1:
      signature += ', '
  signature += ')'

  if return_type:
    signature += ' -> {type}'.format({type=return_type})
  
  signature += ':'

  add(signature)
  newline()
  if implementation:
    add_lines(implementation, {tabs=1})
  
  return self

func save():
  var script = GDScript.new()
  script.source_code = '\n'.join(__lines)
  script.resource_path = __path
  ResourceSaver.save(script, script.resource_path)

func _to_string() -> String:
  return '{path}:\n{lines}'.format({
    path=__path,
    lines='\n'.join(__lines)
  })
