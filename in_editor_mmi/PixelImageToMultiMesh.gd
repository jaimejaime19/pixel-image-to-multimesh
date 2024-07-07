@tool
extends MultiMeshInstance3D
class_name PixelImageToMultiMesh

@onready var static_body: StaticBody3D = $StaticBody3D

@export var regenerate_blueprint: bool = false:
	set(value):
		print("path testing regen")
		regenerate_blueprint = false
		attempt_blueprint(blueprint)
@export var blueprint: Image
@export var color_to_place_on: Color = Color8(0, 0, 0)
## Amount of layers to replicate this blueprint on.
@export var height: int = 1: set = set_height
@export var transform_vector_multiplier: float = 1.0: 
	set = set_transform_vector_multiplier

@export_group("Local Rotation")
@export var local_random_rotate_range: Vector2 = Vector2(0, 0):
	set(value):
		print("path testing local rrr")
		local_random_rotate_range = value
		attempt_blueprint(blueprint)
@export var local_rotation_axis: Vector3 = Vector3(0, 1, 0)

@export_group("Axis Rotation")
@export var axis_random_rotate_range: Vector2 = Vector2(0, 0):
	set(value):
		print("path testing axis rrr")
		axis_random_rotate_range = value
		attempt_blueprint(blueprint)
@export var axis_rotation_axis: Vector3 = Vector3(0, 1, 0)

@export_group("Collision")
@export var clear_collision_shapes: bool = false:
	set(value):
		print("path testing clear button")
		clear_collision_shapes = false
		clear_collisions()
@export var add_collision: bool = false
@export var shape: Shape3D

func _enter_tree():
	print("I ENTERED: IAMAGE IS " + str(blueprint))

func _ready():
	print("Generating blueprint...")
	regenerate_blueprint = true

func set_height(value: int) -> void:
	print("path testing h")
	if not Engine.is_editor_hint():
		return
	height = value
	attempt_blueprint(blueprint)

func set_transform_vector_multiplier(value: float) -> void:
	print("path testing tvm")
	print("BLUEPRINT IN TVM IS: " + str(blueprint))
	if not Engine.is_editor_hint():
		return
	transform_vector_multiplier = value
	attempt_blueprint(blueprint)

func attempt_blueprint(value: Image) -> void:
	if not is_inside_tree():
		print("NOT IN TREE image = " + str(value))
		return
	set_blueprint(value)

func set_blueprint(value: Image) -> void:
	if not is_inside_tree():
		print("NOT IN TREE image = " + str(value))
		return
	print("path testing: image = " + str(value))
	if value == null:
		print("WOOPSIE VALLUE IS NULL")
	else:
		print("OKAY IMAGE IS REALLL")
	print("IMAGE SIZE = " + str(value.get_size()))
	if not Engine.is_editor_hint():
		print("NOT ENGIE HINT")
		return
	if not perform_checks():
		print("FAILED CHECK: image is " + str(value))
		return
	clear_collisions()
	if (is_instance_valid(value)):
		#print("CANCELLED OPERATION OF BLUEPRINT")
		#return
		pass
	print("IMAGE SIZE = " + str(value.get_size()))
	blueprint = value
	
	print("the value of blueprint will be: " + str(value))
	
	var transforms: Array = Array()
	var blueprint_size: Vector2 = blueprint.get_size()
	
	for py in range(blueprint_size[1]):
		for px in range(blueprint_size[0]):
			var pixel: Color = blueprint.get_pixel(px, py)
			if (pixel == color_to_place_on):
				place_mesh(px, py, transforms)
	
	multimesh.instance_count = transforms.size()
	for i in range(multimesh.instance_count):
		multimesh.set_instance_transform(i, transforms[i])
	
	print("Collision shape count: " + str(static_body.get_child_count()))

func place_mesh(px, py, tfs):
	for h in range(height):
		var new_transform: Transform3D = Transform3D()
		new_transform = new_transform.translated(
			Vector3(px, h, py) * transform_vector_multiplier)
		new_transform = new_transform.rotated(
			axis_rotation_axis.normalized(), 
			deg_to_rad(randf_range(
				axis_random_rotate_range.x, 
				axis_random_rotate_range.y
				)))
		new_transform = new_transform.rotated_local(
			local_rotation_axis.normalized(), 
			deg_to_rad(randf_range(
				local_random_rotate_range.x, 
				local_random_rotate_range.y
				)))
		tfs.append(new_transform)
		
		# Add static body here
		var new_collision_shape: CollisionShape3D = CollisionShape3D.new()
		new_collision_shape.transform = new_transform
		new_collision_shape.shape = shape
		static_body.add_child(new_collision_shape)
		new_collision_shape.owner = static_body

func perform_checks() -> bool:
	print("path testing perform checks")
	if not static_body:
		print("STATIC BODY FAILED")
		return false
	if axis_rotation_axis == Vector3(0, 0, 0):
		printerr("Axis of rotation cannot be (0, 0, 0)!")
		return false
	if local_rotation_axis == Vector3(0, 0, 0):
		printerr("Axis of rotation cannot be (0, 0, 0)!")
		return false
	
	return true

func clear_collisions() -> void:
	print("path testing clear func")
	if not static_body:
		return
	for collision_shape in static_body.get_children():
		collision_shape.free()
