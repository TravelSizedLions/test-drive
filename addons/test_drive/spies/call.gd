class_name TDCall

var args = []
var return_value

func _init(args, returned) -> void:
  for a in args:
    self.args.append(a)
  self.return_value = returned
