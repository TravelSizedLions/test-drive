class_name EditorInterfaceWrapper

static var __wrapper = EditorInterface

var distraction_free_mode:
  get: return __wrapper.distraction_free_mode
  set(value): __wrapper.distraction_free_mode = value

var movie_maker_enabled:
  get: return __wrapper.movie_maker_enabled
  set(value): __wrapper.movie_maker_enabled = value

static func edit_node(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.edit_node, args)

static func edit_resource(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.edit_resource, args)

static func edit_script(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.edit_script, args)

static func get_base_control(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_base_control, args)

static func get_command_palette(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_command_palette, args)

static func get_current_directory(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_current_directory, args)

static func get_current_feature_profile(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_current_feature_profile, args)

static func get_current_path(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_current_path, args)

static func get_edited_scene_root(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_edited_scene_root, args)

static func get_editor_main_screen(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_editor_main_screen, args)

static func get_editor_paths(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_editor_paths, args)

static func get_editor_scale(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_editor_scale, args)

static func get_editor_settings(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_editor_settings, args)

static func get_editor_theme(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_editor_theme, args)

static func get_editor_viewport_2d(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_editor_viewport_2d, args)

static func get_editor_viewport_3d(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_editor_viewport_3d, args)

static func get_file_system_dock(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_file_system_dock, args)

static func get_inspector(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_inspector, args)

static func get_open_scenes(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_open_scenes, args)

static func get_playing_scene(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_playing_scene, args)

static func get_resource_filesystem(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_resource_filesystem, args)

static func get_resource_previewer(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_resource_previewer, args)

static func get_script_editor(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_script_editor, args)

static func get_selected_paths(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_selected_paths, args)

static func get_selection(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.get_selection, args)

static func inspect_object(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.inspect_object, args)

static func is_multi_window_enabled(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.is_multi_window_enabled, args)

static func is_playing_scene(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.is_playing_scene, args)

static func is_plugin_enabled(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.is_plugin_enabled, args)

static func make_mesh_previews(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.make_mesh_previews, args)

static func mark_scene_as_unsaved(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.mark_scene_as_unsaved, args)

static func open_scene_from_path(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.open_scene_from_path, args)

static func play_current_scene(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.play_current_scene, args)

static func play_custom_scene(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.play_custom_scene, args)

static func play_main_scene(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.play_main_scene, args)

static func popup_dialog(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.popup_dialog, args)

static func popup_dialog_centered(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.popup_dialog_centered, args)

static func popup_dialog_centered_clamped(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.popup_dialog_centered_clamped, args)

static func popup_dialog_centered_ratio(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.popup_dialog_centered_ratio, args)

static func popup_node_selector(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.popup_node_selector, args)

static func popup_property_selector(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.popup_property_selector, args)

static func reload_scene_from_path(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.reload_scene_from_path, args)

static func restart_editor(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.restart_editor, args)

static func save_all_scenes(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.save_all_scenes, args)

static func save_scene(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.save_scene, args)

static func save_scene_as(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.save_scene_as, args)

static func select_file(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.select_file, args)

static func set_current_feature_profile(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.set_current_feature_profile, args)

static func set_main_screen_editor(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.set_main_screen_editor, args)

static func set_plugin_enabled(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.set_plugin_enabled, args)

static func stop_playing_scene(arg0=Funk.UNDEFINED, arg1=Funk.UNDEFINED, arg2=Funk.UNDEFINED, arg3=Funk.UNDEFINED, arg4=Funk.UNDEFINED, rest=[]):
  var args = Funk.merge_array(arg0, arg1, arg2, arg3, arg4, rest)
  return Funk.invoke(__wrapper.stop_playing_scene, args)

