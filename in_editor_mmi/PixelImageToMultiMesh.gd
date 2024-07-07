@tool
extends MultiMeshInstance3D
class_name PixelImageToMultiMesh
## How to use
## 1. Drag and drop a PixelImageToMultiMesh node into the scene tree
## 2. Add an image. Make sure to re-import as Image, not as Texture2D!
## 3. Set the pixel color to place on
## 4. Add a blank Multimesh resource to the node by using the inspector 
## 5. Set the "Transform Format" flag to 3D
## 6. Add a mesh to the multimesh resource
## 7. Click on "Regenerate Blueprint" and done!

@onready var static_body: StaticBody3D = $StaticBody3D

@export var regenerate_blueprint: bool = false:
	set(value):
		regenerate_blueprint = false
		create_blueprint(blueprint)
@export var blueprint: Image
## Color to place blueprint's meshes on.
@export var color_to_place_on: Color = Color8(0, 0, 0)
## Amount of layers to replicate this blueprint on.
@export var height: int = 1: 
	set(value):
		height = value
		create_blueprint(blueprint)

@export_group("Transforms")
@export_subgroup("Positioning")
## The transform vector to offset the multimeshinstance placement.
@export var local_transform_offset: Vector3 = Vector3(0, 0, 0):
	set(value):
		local_transform_offset = value
		create_blueprint(blueprint)
## The random range to add to the local transform in the x axis.
## Useful to provide a random positional offset to the mesh.
@export var local_x_transform_random_range: Vector2 = Vector2(0, 0):
	set(value):
		local_x_transform_random_range = value
		create_blueprint(blueprint)
## The random range to add to the local transform in the z axis.
## Useful to provide a random positional offset to the mesh.
@export var local_z_transform_random_range: Vector2 = Vector2(0, 0):
	set(value):
		local_z_transform_random_range = value
		create_blueprint(blueprint)
## The random range to add to the local transform in the y axis (height).
## Useful to provide a random positional offset to the mesh.
@export var local_y_transform_random_range: Vector2 = Vector2(0, 0):
	set(value):
		local_y_transform_random_range = value
		create_blueprint(blueprint)
@export_subgroup("Scaling")
## The number to scale the transform vectors by.
## This is useful when your mesh is not a standard 1m cube.
@export var transform_scale: float = 1.0: 
	set(value):
		transform_scale = value
		create_blueprint(blueprint)
## The random range to scale the mesh by.
@export var local_scale_random_range: Vector2 = Vector2(1, 1):
	set(value):
		local_scale_random_range = value
		create_blueprint(blueprint)
## This value is the length of the line on a given axis that crosses the center
## of the mesh, as well as crossing opposite-facing ends of a mesh. 
## In the case of a 1m cube to be scaled on the y-axis, 
## this is a vertical 1m line through the cube's center.
## What this value allows us to do is scale the mesh without crossing the
## 'invisible' end of a line that acts like an origin point or center.
## When 0, no adjustment is done.
@export var local_scale_transform_adjustment: float = 0.0:
	set(value):
		local_scale_transform_adjustment = value
		create_blueprint(blueprint)

@export var local_scale_transform_adjustment_axis: Vector3 = Vector3(0, 1, 0):
	set(value):
		local_scale_transform_adjustment_axis = value
		create_blueprint(blueprint)



@export_group("Local Rotation")
## The random range which to locally rotate a mesh by.
@export var local_rotation_random_range: Vector2 = Vector2(0, 0):
	set(value):
		local_rotation_random_range = value
		create_blueprint(blueprint)
## The axis on which the local rotation occurs on. 
## Vector3(0, 0, 0) is not allowed.
## By default, this is the Y axis (vertical line).
@export var local_rotation_axis: Vector3 = Vector3(0, 1, 0):
	set(value):
		local_rotation_axis = value
		create_blueprint(blueprint)

@export_group("Axis Rotation")
## The random range which to rotate the multimesh around the axis by.
@export var axis_rotation_random_range: Vector2 = Vector2(0, 0):
	set(value):
		axis_rotation_random_range = value
		create_blueprint(blueprint)
## The axis on which the axis rotation occurs on.
## Vector3(0, 0, 0) is not allowed.
## By default, this is the Y axis (vertical line).
@export var axis_rotation_axis: Vector3 = Vector3(0, 1, 0):
	set(value):
		axis_rotation_axis = value
		create_blueprint(blueprint)

@export_group("Collision")
## Clears the collision shapes from the multimesh's static body.
@export var clear_collision_shapes: bool = false:
	set(value):
		clear_collision_shapes = false
		clear_collisions()
## If enabled, adds a collision shape to each mesh.
@export var add_collision: bool = false
## The collision shape to add to each mesh.
@export var shape: Shape3D

func _ready():
	## Only uncomment the below lines if regenerating in game for some reason.
	#print("Generating blueprint...")
	#regenerate_blueprint = true
	pass

func create_blueprint(value: Image) -> void:
	if not perform_checks():
		return
	clear_collisions()
	blueprint = value
	
	var transform_array: Array = Array()
	var blueprint_size: Vector2 = blueprint.get_size()
	
	for py in range(blueprint_size[1]):
		for px in range(blueprint_size[0]):
			var pixel: Color = blueprint.get_pixel(px, py)
			if (pixel == color_to_place_on):
				place_mesh(px, py, transform_array)
	
	multimesh.instance_count = transform_array.size()
	for i in range(multimesh.instance_count):
		multimesh.set_instance_transform(i, transform_array[i])
	
	print("Collision shape count: " + str(static_body.get_child_count()))

## Place a single mesh for each height layer.
## Since the image pixel coords are tracked using px and py, and adding layers is h,
## A little clarification is added here.
## In this function, px is x-axis, py is z-axis, and h is y-axis.
func place_mesh(px, py, transform_array):
	for h in range(height):
		var new_transform: Transform3D = Transform3D()
		new_transform = new_transform.translated(
			Vector3(
				px + randf_range(
					local_x_transform_random_range.x, 
					local_x_transform_random_range.y
					) + local_transform_offset.x, 
				h + randf_range(
					local_y_transform_random_range.x, 
					local_y_transform_random_range.y
					) + local_transform_offset.y , 
				py + randf_range(
					local_z_transform_random_range.x, 
					local_z_transform_random_range.y
					) + local_transform_offset.z 
				) * transform_scale)
		var local_scale_value: float = randf_range(local_scale_random_range.x, local_scale_random_range.y)
		new_transform = new_transform.scaled_local(
			Vector3(local_scale_value, local_scale_value, local_scale_value)
			)
		var normalized_local_scale_transform_adjustment_axis: Vector3 = local_scale_transform_adjustment_axis.normalized()
		#new_transform = new_transform.translated_local(Vector3(
			#(local_scale_transform_adjustment_axis.x * local_scale_transform_adjustment * local_scale_value) - (local_scale_transform_adjustment_axis.x * local_scale_transform_adjustment * local_scale_value),
			#(local_scale_transform_adjustment_axis.y * local_scale_transform_adjustment * local_scale_value) - (local_scale_transform_adjustment_axis.y * local_scale_transform_adjustment * local_scale_value), 
			#(local_scale_transform_adjustment_axis.z * local_scale_transform_adjustment * local_scale_value) - (local_scale_transform_adjustment_axis.z * local_scale_transform_adjustment * local_scale_value)
			#))
		new_transform = new_transform.translated_local(Vector3(
			local_scale_transform_adjustment_axis.x * local_scale_transform_adjustment * (local_scale_value - 1) / local_scale_value,
			local_scale_transform_adjustment_axis.y * local_scale_transform_adjustment * (local_scale_value - 1) / local_scale_value,
			local_scale_transform_adjustment_axis.z * local_scale_transform_adjustment * (local_scale_value - 1) / local_scale_value
		))
		
		#local_scale_transform_adjustment_axis.y * (new_transform.origin.y - (new_transform.origin.y * local_scale_value) - (local_scale_transform_adjustment * (local_scale_value - 1)))
		
		new_transform = new_transform.rotated(
			axis_rotation_axis.normalized(), 
			deg_to_rad(randf_range(
				axis_rotation_random_range.x, 
				axis_rotation_random_range.y
				)))
		new_transform = new_transform.rotated_local(
			local_rotation_axis.normalized(), 
			deg_to_rad(randf_range(
				local_rotation_random_range.x, 
				local_rotation_random_range.y
				)))
		# Based on the above, the transform is a combination of
		# translation + axis rotation + local rotation
		transform_array.append(new_transform)
		
		if not add_collision:
			continue
		
		# Add collision shape for this mesh
		var new_collision_shape: CollisionShape3D = CollisionShape3D.new()
		new_collision_shape.transform = new_transform
		new_collision_shape.shape = shape
		static_body.add_child(new_collision_shape)
		new_collision_shape.owner = owner # or get_parent, depends... maybe?

# These checks prevent re-creation of the blueprint in cretain cases.
func perform_checks() -> bool:
	if not Engine.is_editor_hint():
		print("The Engine is not in editor mode. NOT AN ERROR")
		return false
	if not is_inside_tree():
		printerr("Multimeshinstance node is not in tree! Most likely an
			editor startup issue. If this appears anywhere else, please fix.")
		return false
	if not static_body:
		printerr("Static body node does not exist!")
		return false
	if axis_rotation_axis == Vector3(0, 0, 0):
		printerr("Axis of rotation cannot be (0, 0, 0)!")
		return false
	if local_rotation_axis == Vector3(0, 0, 0):
		printerr("Axis of rotation cannot be (0, 0, 0)!")
		return false
	
	return true

func clear_collisions() -> void:
	if not static_body:
		return
	for collision_shape in static_body.get_children():
		collision_shape.free()
