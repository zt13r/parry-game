class_name Enemy extends Entity


@export var player: Player:
	get:
		if not player:
			player = get_tree().get_first_node_in_group("Player")
		return player


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	super(delta)
	move_and_slide()


func _handle_movement(delta) -> void:
	direction = -1.0 if player.global_position.x < position.x else 1.0
	velocity.x = direction * move_speed


func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		air_time = 0.0
	else:
		air_time += delta * descent_speed

	# Apply gravity
	velocity.y = lerp(velocity.y, get_gravity().y * min(air_time, max_descent_speed), delta)


func _sprite_face() -> void:
	# Sprite faces player
	sprite.flip_h = player.global_position.x < position.x
