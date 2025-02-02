class_name TDLogger

enum LogLevel {SILENT=0, ERROR=1, WARNING=2, INFO=3, DEBUG=4}

## The logger's level of verbosity:[br]
## - [SILENT = 0] - Silences all output[br]
## - [ERROR = 1] - Only prints errors[br]
## - [WARNING = 2] - Only prints warnings and errors[br]
## - [INFO = 3] - Prints general log statements, warnings, and errors, but ignores more verbose logging[br]
## - [DEBUG = 4] - The most verbose setting. Includes all logging output.[br]
## [br]
## By default, the log level is set to [member LogLevel.INFO]. [br]
## You can specify custom log levels using [method TDLogger.log(msg, {level=<custom log level>})]. [member level] is specified as an integer, with the [member LogLevel] values reserved as 0-4. Anything above that is left for custom levels.
static var log_level: int = LogLevel.INFO

## Resets the log level to its default setting of INFO.
static func reset_log_level():
  log_level = LogLevel.INFO

## If the log level of the logger is ERROR or higher, pushes an error to stderr.
static func error(msg='', extras=[]):
  if log_level >= LogLevel.ERROR: push_error.bindv(extras).call(msg)

## If the log level is WARNING or higher, pushes a warning to stderr.
static func warning(msg='', extras=[]):
  if log_level >= LogLevel.WARNING: push_warning.bindv(extras).call(msg)

## If the log level is INFO or higher, prints a message to stdout using [method prints]
static func info(msg='', extras=[]):
  if log_level >= LogLevel.INFO: prints.bindv(extras).call(msg)

## If the log level is DEBUG or higher, prints a message to stdout using [method prints]
static func debug(msg='', extras=[]):
  if log_level >= LogLevel.DEBUG: prints.bindv(extras).call(msg)

## If the log level is DEBUG or higher, pretty prints an object to stdout
static func object(obj={}, options={}):
  var level = Funk.option(options, 'level', LogLevel.DEBUG)
  if log_level >= level:
    print(JSON.stringify(obj, '  ', true))

## Prints a message to stdout regardless of the log level. Uses [method prints]
## [br]
## Optional Arguments:[br]
## - [extras: Array = Array()] - An array of extra strings/objects to pass in.[br]
## - [level: int = 0] - The severity of this log. See [member TDLogger.log_level][br]
static func log(msg='', options={}):
  var level = Funk.option(options, 'level', 0)
  var extras = Funk.option(options, 'extras', [])
  if log_level >= level:
    prints.bindv(extras).call(msg)

## The function to print the "all passing" banner on test runs.
static func all_passed():
  TDLogger.log('\n'.join([
    '',
    "-----------------------",
    " All tests passing! ✔️",
    "-----------------------"
  ]))

## The function to print the "remove only" message when the relevant flag is enabled.
static func only_message():
  TDLogger.log('\nFAIL: Remove references to Only, doofus 🤦‍♂️')

## Prints a line of dashes with a desired length
## Optional Arguments:[br]
## - [length: int = 80] - The length of the line in characters.[br]
## - [level: int = 0] - The severity of this log. See [member TDLogger.log_level][br]
static func line(options={}):
  var len = Funk.option(options, 'length', 80)
  var level = Funk.option(options, 'level', 0)
  if log_level >= level:
    TDLogger.log('-'.repeat(len))

## If the log level is DEBUG or above, takes a specific action. Useful for setting up actions like saving out resource data for inspection after a test run.
## This is different from [method TDLogger.with_debug] in that it doesn't change the current log level. Think of it like [method TDLogger.debug], but for taking debug-only actions 
## rather than printing debug-only output.
static func debug_action(fn):
  if log_level >= LogLevel.DEBUG:
    fn.call()

## Set the log level to DEBUG for the scope of the provided function. This is different from [method debug_action] in that this sets the log level and is
## Not intended for debug-specific functionality, rather just increasing the output of part of your test code without having to up the log level for an entire test run.
static func with_debug(fn, args=[]):
  log_level = LogLevel.DEBUG
  fn.callv(args)
  reset_log_level()

## Set the log level to WARNING for the scope of the provided function.
static func warnings_only(fn, args=[]):
  log_level = LogLevel.WARNING
  fn.callv(args)
  reset_log_level()

## Set the log level to ERROR for the scope of the provided function.
static func errors_only(fn, args=[]):
  log_level = LogLevel.ERROR
  fn.callv(args)
  reset_log_level()

## Silence all log output for the scope of the provided function.
static func silence(fn, args=[]):
  log_level = LogLevel.SILENT
  fn.callv(args)
  reset_log_level()

## Logs the object instance ID.
## [br]
## Optional Arguments:[br]
## - [level: int = 0] - The severity of this log. See [member TDLogger.log_level][br]
static func id(obj, options={}):
  var level = Funk.option(options, 'level', 0)
  if log_level >= level:
    TDLogger.log('obj instance: {0}'.format([obj.get_instance_id()]))


## Set the log level to TEST_DRIVE_DEBUG for the scope of the provided function. 
static func __with_td_debug__(fn, args=[]):
  log_level = 999999
  fn.callv(args)
  reset_log_level()


## if the log level is TEST_DRIVE_DEBUG or higher, prints a message to stdout using [method prints]
static func __td_debug__(msg, extras=[]):
  if log_level >= 999999:
    prints.bindv(extras).call(msg)


## If the log level is TEST_DRIVE_DEBUG or higher, pretty prints an object to stdout
static func __td_object__(obj={}):
  if log_level >= 999999:
    print(JSON.stringify(obj, '  ', true))
