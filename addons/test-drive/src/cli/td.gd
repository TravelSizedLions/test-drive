#!/usr/bin/env -S godot.exe --single-threaded-scene --headless -s
class_name TDCommandLineInterface extends SceneTree

var __rng = RandomNumberGenerator.new()

func _init() -> void:
  if not await __initialize_engine():
    quit(1)

  __load_scripts()
  await __add_flavor()
  await __run_cli()

func __initialize_engine() -> bool:
  var seconds_left = 30

  TDLogger.log('Revving the engine...')
  while(Engine.get_main_loop() == null && seconds_left > 0):
    await create_timer(.125).timeout
    seconds_left -= .125
    if seconds_left < 15:
      TDLogger.log('  ...I think the check engine light is on...')

  if(Engine.get_main_loop() == null):
    TDLogger.log('  ...the engine\'s dead. 💀')
    return false

  TDLogger.log('  ...vroom vroom, baby. 🚗\n')
  return true

func __load_scripts():
  TDLogger.log('Warming scripts cache...')
  ScriptCache.initialize()
  TDLogger.log('  ...ah, so toasty... ☕\n')

func __add_flavor():
  TDLogger.log("Alright, let's take this code for a spin!")
  await create_timer(1).timeout

func __run_cli():
  var cli_file = FS.search_dir('res://addons/test-drive', '*__td_cli__.gd', true)[0]
  var script = load(cli_file)
  var cli = script.new()
  get_root().add_child(cli)
  var result = await cli.parse()
  await create_timer(1).timeout

  MethodCache.clear()
  PropertyCache.clear()
  ScriptCache.clear()
  Autofree.free_orphans()
  cli.print_orphan_nodes()
  self.quit(result if result else 0)
