class_name EditorInspectorWrapper

static var __wrapper = EditorInspector

var horizontal_scroll_mode:
  get: return __wrapper.horizontal_scroll_mode
  set(value): __wrapper.horizontal_scroll_mode = value

static func get_edited_object(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_edited_object, args)

static func get_selected_path(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_selected_path, args)

