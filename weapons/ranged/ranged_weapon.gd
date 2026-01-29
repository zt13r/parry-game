class_name RangedWeapon extends Weapon


@export var projectile_scene: PackedScene = null


var projectiles_group: Node2D = null


func _ready() -> void:
	super()
	if projectiles_group == null:
		projectiles_group = get_tree().get_first_node_in_group("ProjectilesGroup")
		if projectiles_group == null:
			print("projectiles_group is null (res://weapons/ranged/ranged_weapon.gd)")


func attack() -> void:
	_shoot()


func _shoot() -> void:
	if projectile_scene == null:
		print("projectile_scene is null (res://weapons/ranged/ranged_weapon.gd)")
		return
	#print("Shooting shots")

	var projectile: Projectile = projectile_scene.instantiate()

	projectile.damage = actor.damage
	projectile.direction = actor.weapon_dir
	projectile.fired_by = actor

	# Copies entity color to projectile color
	projectile.self_modulate = actor.self_modulate

	projectile.global_position = actor.global_position

	if projectiles_group != null:
		projectiles_group.add_child(projectile)
	else:
		get_tree().root.get_child(0).add_child(projectile) # Adds to main scene root node I think
