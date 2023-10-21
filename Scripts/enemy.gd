extends CharacterBody2D


@export var SPEED = 100.0
@export var MIN_DISTANCE = .25

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var player = get_node_or_null("../Player")
	var direction = 0
	if player:
		var distance = player.position.x - position.x
		if abs(distance) > MIN_DISTANCE:
			direction = sign(player.position.x - position.x)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
