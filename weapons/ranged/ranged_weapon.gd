class_name RangedWeapon extends Weapon


@export var projectile_scene: PackedScene = null


func attack() -> void:
	if projectile_scene == null:
		print("projectile_scene is null (res://weapons/ranged/ranged_weapon.gd)")
		return

	var projectile: Projectile = projectile_scene.instantiate()

	projectile.damage = actor.damage
	projectile.direction = actor.weapon_dir
	projectile.fired_by = actor

	projectile.global_position = actor.global_position

	add_sibling(projectile)
