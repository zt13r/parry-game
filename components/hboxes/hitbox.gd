class_name Hitbox extends Area2D
# SHOULD HAVE COLLISION CHILD OUT OF SCENE !!! or it won't work, obviously


@export var actor: Node2D:
	get:
		if not actor:
			actor = get_parent()
		return actor


var damage: float = 0.0 ## Inherited from weapon/entity parent, probably


func _ready() -> void:
	damage = actor.damage

	if not area_entered.is_connected(Callable(self, "_on_hitbox_entered")):
		area_entered.connect(Callable(self, "_on_hitbox_entered"))


func _on_hitbox_entered(hurtbox: Hurtbox) -> void:
	# No friendly fire
	if hurtbox.actor.weapon is RangedWeapon

	hurtbox.apply_damage(damage)
	actor.queue_free() # Delete from scene for projectiles and stuff, idk
