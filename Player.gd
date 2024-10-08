extends CharacterBody3D
class_name Player

@onready var head: Node3D = $Head
@onready var player_camera: Camera3D = $Head/PlayerCamera

static var sensitivity = 0.004
static var SPEED = 6.0
#const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var footstep_counter: int = 40

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# Grabbed from horror tutorial
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * sensitivity)
		head.rotate_x(-event.relative.y * sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-75), deg_to_rad(80))
	
	if event.is_action_pressed("dev_quit"):
		get_tree().quit(777)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# NO JUMPING
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		footstep_counter -= 1
		if footstep_counter <= 0:
			footstep_counter = 40
			#$Footsteps.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
