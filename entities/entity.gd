class_name Entity extends CharacterBody2D
# Putting here for no reason at all:
# To get root node: node.get_tree().root.get_child(0)


@export_group("Stats")
@export var health: float = 100.0 ## Entity health

# Still unsure whether or not to have enemies carry set or semi-randomized weapons (excluding bosses)
@export var weapon: Weapon = null ## Equipped weapon

@export_group("Speed Parameters")
@export var move_speed: float = 400.0 ## Directional (x) movement speed
@export var attack_speed: float = 1.0 ## Attack speed in seconds (player: affected by weapon and class)

# Still unsure whether or not to have enemies be able to parry
@export var parry_speed: float = 0.0 ## Speed at which player can parry attacks

@export_group("Strength Parameters")
@export var attack_damage: float = 0.0 ## Attack strength (player: affected by weapon and class)

@export_group("Jump Parameters")
@export var jump_height: float = 500.0 ## Directional (y) jump velocity
@export var descent_speed: float = 2.5 ## Used for "realism"
@export var max_descent_speed: float = 10.0 ## Max descent speed, also used for "realism"


var direction: float = 0.0 ## Movement variable
var air_time: float = 0.0 ## Gravity/descent helper

var can_attack: bool = true


func _ready() -> void:
	if not is_in_group("Entities"):
		add_to_group("Entities")


func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_apply_gravity(delta)


func _handle_movement(delta) -> void:
	pass


func _apply_gravity(delta: float) -> void:
	pass


func damage(points: float) -> void:
	health -= points
	if health < 0.0:
		die()


func die() -> void:
	#queue_free()
	pass
