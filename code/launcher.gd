extends Area2D

onready var projectile = preload("res://prefab/projectile.tscn")


func launch():
	var project = projectile.instance()
	project.start($muzzle.global_position)
	project.global_scale = global_scale * 2
	get_parent().add_child(project)
	$anim.play("launch")
