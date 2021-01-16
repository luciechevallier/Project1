extends KinematicBody2D

var time = 1
var max_speed = 0.75
var velocity = Vector2()
var direction = []
var isHitting = false

func start(position, scale, name, time, direction):
	self.global_position = position
	self.global_scale = scale
	self.time = time
	self.direction = direction
	if "bush" in name or "rock" in name or "desk" in name:
		$anim.play("bush")
	elif "tree" in name:
		$anim.play("tree")


func randArray(list :Array):
	randomize()
	return list[randi() % list.size()]


func _ready():
	$wait.start(time)
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
	if not isHitting:
		isHitting = true
		$wait.stop()
		set_physics_process(false)
		get_parent().addHit()
		$anim.play("angry")
		yield($anim, "animation_finished")
		queue_free()


func resize(scale):
	velocity =  Vector2(velocity.x * scale.x, velocity.y * scale.y)
