extends KinematicBody2D

var max_speed = 0.75
var wait_time = 3.2
var velocity = Vector2()
var direction = []
var isHitting = false

func start(position, scale, name, pDirection):
	self.global_position = position
	self.global_scale = scale
	self.direction = pDirection
	if "bush" in name or "rock" in name or "desk" in name:
		$anim.play("bush")
	elif "tree" in name:
		$anim.play("tree")


func randArray(list :Array):
	randomize()
	return list[randi() % list.size()]


func _ready():
	$wait.start(wait_time)
	max_speed *= self.global_position.x


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision and  "border" in collision.collider.get_name():
		velocity *= -1


func _on_timer_timeout():
	set_physics_process(false)
	get_parent().addTweet()
	$anim.play("tweet")
	yield($anim, "animation_finished")
	queue_free()


func _on_walk_timeout():
	velocity = Vector2.LEFT * randArray(direction) * max_speed


func touch():
	get_parent().addHit()
	if not isHitting:
		isHitting = true
		$wait.stop()
		set_physics_process(false)
		$anim.play("angry")
		yield($anim, "animation_finished")
		queue_free()


func resize(scale):
	velocity =  Vector2(velocity.x * scale.x, velocity.y * scale.y)


func get_start_anim_postion():
	return $posStartAnim.global_position
