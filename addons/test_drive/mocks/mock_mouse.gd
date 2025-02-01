class_name TDMouse

static func click(at: Vector2) -> InputEventMouseButton:
  return __create_mouse_event(
    at,
    MOUSE_BUTTON_LEFT,
    MOUSE_BUTTON_MASK_LEFT
  )

static func right_click(at: Vector2) -> InputEventMouseButton:
  return __create_mouse_event(
    at,
    MOUSE_BUTTON_RIGHT,
    MOUSE_BUTTON_MASK_RIGHT
  )

static func __create_mouse_event(pos: Vector2, btn_index: int, btn_mask: int) -> InputEventMouseButton:
  var event = InputEventMouseButton.new()
  event.global_position = pos
  event.button_index = btn_index
  event.button_mask = btn_mask
  event.pressed = true
  return event
