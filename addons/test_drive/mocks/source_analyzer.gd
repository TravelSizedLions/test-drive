class_name SourceAnalyzer

var __source_code: Array

func _init(script) -> void:
  __source_code = [] if not 'source_code' in script else script.source_code.split('\n')

func is_static(name):
  var line = find_by_name(name).strip_edges()
  return line.begins_with('static')

func is_constructor(name):
  var line = find_by_name(name)
  var regex = RegEx.new()
  regex.compile('^(static)?[ ]*func[ ]*(_static)_init\\(')
  return regex.search(line) != null

func find_by_name(member_name) -> String:
  var regex = RegEx.new()
  regex.compile('.*{n}.*'.format({n=member_name}))
  return search(regex.search)

func search(condition: Callable) -> String:
  for line in __source_code:
    if condition.call(line):
      return line
  
  return ''
