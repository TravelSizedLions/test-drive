class_name PropertyCache

static var __cache = {}

static func set_value(mock_name, prop_name, value):
  var key = __property_key(mock_name, prop_name)
  TDLogger.__td_debug__('Mocking {k} = {v}'.format({k=key, v=value}))
  __cache[key] = value

static func get_value(mock_name, prop_name, type=TYPE_NIL):
  var key = __property_key(mock_name, prop_name)
  if not key in __cache:
    var default = default_for_type(type)
    TDLogger.__td_debug__('No mock value for property {k} found. Returning {d}.'.format({k=key, d=default}))
    return default

  return __cache[key]

static func __property_key(mock_name, property_name, instance=null):
  return '{c}::{p}{i}'.format({
    c=mock_name,
    p=property_name,
    i='#{n}'.format({n=instance.get_object_id}) if instance else ''
  })

static func default_for_type(type: Variant.Type):
  match type:
    TYPE_NIL : return null
    TYPE_BOOL : return false
    TYPE_INT : return 0
    TYPE_FLOAT : return 0.0
    TYPE_STRING : return ''
    TYPE_VECTOR2 : return Vector2.ZERO
    TYPE_VECTOR2I : return Vector2i.ZERO
    TYPE_RECT2 : return Rect2()
    TYPE_RECT2I : return Rect2i()
    TYPE_VECTOR3 : return Vector3.ZERO
    TYPE_VECTOR3I : return Vector3i.ZERO
    TYPE_TRANSFORM2D : return Transform2D()
    TYPE_VECTOR4 : return Vector4.ZERO
    TYPE_VECTOR4I : return Vector4i.ZERO
    TYPE_PLANE : return Plane()
    TYPE_QUATERNION : return Quaternion()
    TYPE_AABB : return AABB()
    TYPE_BASIS : return Basis()
    TYPE_TRANSFORM3D : return Transform3D()
    TYPE_PROJECTION : return Projection()
    TYPE_COLOR : return Color()
    TYPE_STRING_NAME : return StringName()
    TYPE_NODE_PATH : return NodePath()
    TYPE_RID : return RID()
    TYPE_OBJECT : return Object.new()
    TYPE_CALLABLE : return Callable()
    TYPE_SIGNAL : return Signal()
    TYPE_DICTIONARY : return {}
    TYPE_ARRAY : return []
    TYPE_PACKED_BYTE_ARRAY : return PackedByteArray()
    TYPE_PACKED_INT32_ARRAY : return PackedInt32Array()
    TYPE_PACKED_INT64_ARRAY : return PackedInt64Array()
    TYPE_PACKED_FLOAT32_ARRAY : return PackedFloat32Array()
    TYPE_PACKED_FLOAT64_ARRAY : return PackedFloat64Array()
    TYPE_PACKED_STRING_ARRAY : return PackedStringArray()
    TYPE_PACKED_VECTOR2_ARRAY : return PackedVector2Array()
    TYPE_PACKED_VECTOR3_ARRAY : return PackedVector3Array()
    TYPE_PACKED_COLOR_ARRAY : return PackedColorArray()
    TYPE_PACKED_VECTOR4_ARRAY : return PackedVector4Array()


static func clear():
  if __cache:
    __cache.clear()
