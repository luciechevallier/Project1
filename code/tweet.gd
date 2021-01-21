extends Sprite

func run(position):
	$Tween.interpolate_property(
		self, 
		"position", 
		position,
		Vector2(position.x, position.y - 300), 
		1,
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT)

	$Tween.interpolate_property(
		self, 
		"scale", 
		Vector2(0.3, 0.3),
		Vector2(0.15, 0.15), 
		1,
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT)
			
	$Tween.interpolate_property(
		self, 
		"modulate", 
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0), 
		0.5,
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT,
		0.5)
		
	$Tween.start()
	yield($Tween, "tween_completed")
	
	queue_free()
