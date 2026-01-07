class_name Weapon extends Resource


@export var name: String = ""
@export var sprite: Texture = null

@export_group("Stat Multipliers")
@export var damage: float = 0.0 ## Higher = stronger
@export_range(0.0, 1.0, 0.01) var attack_speed: float = 0.0 ## Less = faster
# ^^^ Should very much change how this works ^^^


func apply_stats(entity: Entity) -> void:
	entity.damage *= damage
	entity.attack_speed *= attack_speed
	print(attack_speed)


func attack(source: Entity) -> void:
	pass
