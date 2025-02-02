class_name TestClass

class NoArgs:
  var name = "Test!"

  var __thing: String
  var thing: String:
    get: return __thing
    set(val): __thing = val

  var __other_thing: String = 'hi'
  var other_thing: String:
    get: return __other_thing

  func _init() -> void:
    pass

  func returns_true():
    return true

  func returns_false():
    return false

  func returns_string(str_to_return):
    return str_to_return

class OneRequiredArg:
  var num_a: int
  func _init(num: int):
    self.num_a = num

  func a():
    return num_a
  
class TwoRequiredArgs:
  var num_a: int
  var num_b: int
  func _init(num_a: int, num_b: int):
    self.num_a = num_a
    self.num_b = num_b

  func a(): return num_a
  func b(): return num_b

class OnlyOptionalArgs:
  var __num_a: int
  var __num_b: int
  func _init(num_a: int = 1, num_b: int = 1):
    self.__num_a = num_a
    self.__num_b = num_b

  func a():
    return __num_a
  
  func b():
    return __num_b

class MixedArgs:
  var num_a: int
  var num_b: int
  func _init(num_a: int, num_b: int = 1):
    self.num_a = num_a
    self.num_b = num_b

  func a():
    return num_a
  
  func b():
    return num_b


class BadlyMadeClass:
  var __num_a: int
  var __num_b: int
  var __num_c: int
  var __num_d: int
  var __num_e: int
  var __num_f: int
  var __num_g: int
  func _init(a: int, b: int, c: int, d: int, e: int, f: int, g: int):
    __num_a = a
    __num_b = b
    __num_c = c
    __num_d = d
    __num_e = e
    __num_f = f
    __num_g = g

  func a():
    return __num_a

  func b():
    return __num_b
    
  func c():
    return __num_c
    
  func d():
    return __num_d
    
  func e():
    return __num_e
    
  func f():
    return __num_f
    
  func g():
    return __num_g
