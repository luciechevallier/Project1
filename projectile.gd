extends KinematicBody2D

var max_speed = 1.75
var velocity = Vector2()
var origin_scale = Vector2()

func start(position_muzzle):
	self.global_position = position_muzzle
	
func _ready():
	origin_scale = self.global_scale
	max_speed *= self.global_position.y
	velocity = Vector2.UP * max_speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision and "trumpouille" in collision.collider.get_name():
		collision.collider.touch()
		set_physics_process(false)
		$anim.play("splash")
		yield($anim, "animation_finished")
		queue_free()
		
	elif collision and "background" in collision.collider.get_name():
		queue_free()
		
	elif collision:
		print(collision.collider.get_name())


func resize(scale):
	self.global_scale = Vector2(origin_scale.x * scale.x, origin_scale.y * scale.y)
	velocity =  Vector2(velocity.x * scale.x, velocity.y * scale.y)
