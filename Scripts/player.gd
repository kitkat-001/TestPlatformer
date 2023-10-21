extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@export_flags_2d_physics var enemy_layer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Process collisions
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.collision_layer == enemy_layer:
			game_over()
	
	if position.y > ProjectSettings.get_setting("display/window/size/viewport_height"):
		game_over()

func game_over():
	#Make player transparent and freeze them in place.
	$"Sprite2D".modulate = Color.TRANSPARENT
	SPEED = 0
	JUMP_VELOCITY = 0
	
	#Reload the scene.
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/level.tscn");
