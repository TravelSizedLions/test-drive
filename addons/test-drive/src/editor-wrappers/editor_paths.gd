class_name EditorPathsWrapper

static var __wrapper = EditorPaths

static func get_cache_dir(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_cache_dir, args)

static func get_config_dir(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_config_dir, args)

static func get_data_dir(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_data_dir, args)

static func get_project_settings_dir(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_project_settings_dir, args)

static func get_self_contained_file(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_self_contained_file, args)

static func is_self_contained(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.is_self_contained, args)

