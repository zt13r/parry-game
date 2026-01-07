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


func _on_hurtbox_entered(hurtbox: Hurtbox) -> void:
	hurtbox.apply_damage(damage)
