extends ColorRect


var default = load("res://img/Tartouille.png")
var local_default = load("res://img/angry.png")
var recycling = load("res://img/recycling.png")
var door = load("res://img/door_handle.png")

var action_possible = true

func run():
	self.visible = true
	get_tree().paused = true


func end_game(nb_tweet, nb_splash):
	run()
	$Timer.start()
	action_possible = false
	$vb/Score.visible = true
	$vb/Score.text = "Tweet send : " + str(nb_tweet) + "\nSplash in face : " + str(nb_splash)


func _on_Start_pressed():
	if action_possible:
		self.visible = false
		get_tree().paused = false
		Input.set_custom_mouse_cursor(default)
		var error = get_tree().reload_current_scene()
		if error != OK: print("Failure code=" + str(error))


func _on_Quit_pressed():
	get_tree().quit()


func _on_Start_mouse_entered():
	Input.set_custom_mouse_cursor(recycling)


func _on_Start_mouse_exited():
	Input.set_custom_mouse_cursor(local_default)


func _on_Quit_mouse_entered():
	Input.set_custom_mouse_cursor(door)


func _on_Quit_mouse_exited():
	Input.set_custom_mouse_cursor(local_default)


func _on_Timer_timeout():
	action_possible = true
