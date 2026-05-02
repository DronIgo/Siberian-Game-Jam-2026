class_name SelectableObject
extends Area2D

@export var generated_collider_roughness : float = 2
@export var exclusive : bool = false
@export var save_selected_state: bool = false

var selected : bool = false

signal on_selected(state : bool)

func set_selected(value : bool) -> void:
	if save_selected_state:
		selected = value
	on_selected.emit(value)
	print(self.name, ' ', value)

func _ready() -> void:
	_parent_sprite = get_parent() as Sprite2D
	if !_parent_sprite:
		print("SelectableObjectComponent must be a child of a Sprite2D Node")
		return
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true
	_genenrate_sprite_polygon()
	input_event.connect(_input_event)

func _input_event(viewport : Viewport, event : InputEvent, shape_idx : int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print(viewport, " ", event, " ", shape_idx)
			set_selected(save_selected_state && !selected)

var _polygons : Array
var _collision_polygon : CollisionPolygon2D
var _parent_sprite : Sprite2D

func _genenrate_sprite_polygon() -> void:
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(_parent_sprite.get_texture().get_image())
	_polygons = bitmap.opaque_to_polygons(\
		Rect2(Vector2.ZERO, _parent_sprite.get_texture().get_size()), generated_collider_roughness)
	
	for poly in _polygons:
		_collision_polygon = CollisionPolygon2D.new()
		_collision_polygon.polygon = poly
		add_child(_collision_polygon)
		
	_adjust_to_sprite(bitmap)
		
func _adjust_to_sprite(bitmap: BitMap) -> void:
	if _parent_sprite.centered:
		_collision_polygon.position -= Vector2(bitmap.get_size() / 2.0)
		_collision_polygon.position += get_parent().offset
	_collision_polygon.scale = Vector2(\
		-1.0 if _parent_sprite.flip_h else 1.0,\
		-1.0 if _parent_sprite.flip_v else 1.0)
