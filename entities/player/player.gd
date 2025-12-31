class_name Player extends Entity


enum State {
	IDLE,
	MOVING,
	JUMPED,
	ATTACKED,
	PARRY,
}


@export var parry_strength: float = 0.0 ## Damage reflected after a successful parry
@export var weapon_pos_distance: float = 50.0 ## How far weapon is placed from the player


var current_state: State = State.IDLE ## Used for player processing and transition

var direction: float = 0.0 ## Movement variable
var air_time: float = 0.0 ## Gravity/descent helper

var mouse_pos: Vector2 = Vector2.ZERO ## Keeps track of global mouse position
var weapon_dir: Vector2

var can_attack: bool = true


@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var attack_timer: Timer = $AttackTimer


func _ready() -> void:
	super()
	_initialize_weapon()


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_weapon_stuff()

	# Process states
	match current_state:
		State.IDLE: _process_idle()
		State.MOVING: _process_moving()
		State.JUMPED: _process_jumped()
		State.ATTACKED: _process_attacked()
		State.PARRY: _process_parry()

	# Get player left and right movement
	direction = Input.get_axis("move_left", "move_right")

	# Transition states
	if Input.is_action_just_pressed("attack") and can_attack:
		current_state = State.ATTACKED
	if Input.is_action_just_pressed("jump") and is_on_floor():
		current_state = State.JUMPED
	elif direction != 0.0:
		current_state = State.MOVING
	else:
		current_state = State.IDLE

	move_and_slide()

	if current_state == State.ATTACKED:
		print("atack")


func _initialize_weapon() -> void:
	attack_timer.wait_time = attack_speed
	weapon_sprite.texture = weapon.sprite
	attack_damage += weapon.base_damage


func _process_idle() -> void:
	if velocity.x != 0.0:
		velocity.x = 0.0


func _process_moving() -> void:
	velocity.x = direction * move_speed


func _process_jumped() -> void:
	velocity.y -= jump_height


func _process_attacked() -> void:
	can_attack = false
	attack_timer.start()
	weapon.attack(weapon_dir)
	weapon.node_ref = self


func _process_parry() -> void:
	pass


func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		air_time = 0.0
	else:
		air_time += delta * descent_speed

	# Heavier gravity if pressing down
	if Input.is_action_pressed("move_down"):
		air_time = max_descent_speed
	air_time = min(air_time, max_descent_speed)

	# Apply gravity
	velocity.y = lerp(velocity.y, get_gravity().y * air_time, delta)


func _weapon_stuff() -> void:
	mouse_pos = get_global_mouse_position()

	# Sets weapon_sprite position to be around the player at weapon_pos_distance
	weapon_dir = to_local(mouse_pos).normalized() * weapon_pos_distance
	weapon_sprite.position = weapon_dir


func _on_attack_timer_timeout() -> void:
	can_attack = true
