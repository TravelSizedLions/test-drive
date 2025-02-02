class_name TDCLIParser extends Node

func parse(callback: Callable = func(): pass):
  var args: Args = Args.parse()
  if args.option('--file') or args.option('-f'):
    var file = args.option('--file')
    file = file if file else args.option('-f')	
    return await TDSingleRun.new(file, args.args).run_and_report(callback)
  else:
    return await TDFullRun.full_run(callback, args.args)


class Args:
  var __args = {}

  var args:
    get: return __args

  static func parse() -> Args:
    var args = Args.new()
    var cmd = OS.get_cmdline_args()
    while cmd.size():
      var arg = __pop_cmd(cmd)
      match arg:
        '--file', '-f':
          args.__args[arg] = __pop_cmd(cmd)
        '--no-only':
          args.__args[arg] = true
        _: pass

    return args 
  
  func option(flag, default_value=""):
    return Funk.option(__args, flag, default_value)

  static func __pop_cmd(cmdline: PackedStringArray):
    var v = cmdline[0]
    cmdline.remove_at(0)
    return v
