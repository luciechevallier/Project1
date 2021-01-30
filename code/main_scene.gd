extends Node

const cursor_width = 48

onready var trumpouille = preload("res://prefab/trumpouille.tscn")
onready var viewport = get_viewport()
onready var content_width = ProjectSettings.get("display/window/size/width")
onready var content_height = ProjectSettings.get("display/window/size/height")

enum {BACKGROUND, LAUNCHER, BUSH, BUSH2, BUSH3, TREE, TREE2, ROCK, DESK, TRUMPOUILLE, FLAG}
enum {OBJECT, SCALE, POSITION, DIRECTION}
var allNode = {}
var trumpouille_inst = null
var scale_trumpouille = 0.5
var tweet = load("res://prefab/tweet.tscn")


func _ready():
	viewport.connect("size_changed", self, "window_resize")
	allNode[BACKGROUND] = { OBJECT:$background, SCALE:$background.global_scale, POSITION:$background.global_position, DIRECTION:[1, -1] }
	allNode[LAUNCHER] = { OBJECT:$launcher, SCALE:$launcher.global_scale, POSITION:$launcher.global_position, DIRECTION:[1, -1] }
	allNode[BUSH] = { OBJECT:$bush, SCALE:$bush.global_scale, POSITION:$bush.global_position, DIRECTION:[1, -1] }
	allNode[BUSH2] = { OBJECT:$bush2, SCALE:$bush2.global_scale, POSITION:$bush2.global_position, DIRECTION:[1, -1] }
	allNode[BUSH3] = { OBJECT:$bush3, SCALE:$bush3.global_scale, POSITION:$bush3.global_position, DIRECTION:[1, -1] }
	allNode[TREE] = { OBJECT:$tree, SCALE:$tree.global_scale, POSITION:$tree.global_position, DIRECTION:[1, -1] }
	allNode[TREE2] = { OBJECT:$tree2, SCALE:$tree2.global_scale, POSITION:$tree2.global_position, DIRECTION:[1, -1] }
	allNode[ROCK] = { OBJECT:$rock, SCALE:$rock.global_scale, POSITION:$rock.global_position, DIRECTION:[1, -1] }
	allNode[DESK] = { OBJECT:$desk, SCALE:$desk.global_scale, POSITION:$desk.global_position, DIRECTION:[1, -1] }
	allNode[FLAG] = { OBJECT:$flag, SCALE:$flag.global_scale, POSITION:$flag.global_position, DIRECTION:[1, -1] }
	
	spawn_trumpouille()
	ready_resize()
	$launcher.global_position = Vector2(content_width / 2, $launcher.global_position.y)
	
	$HUD.start()
	

func ready_resize():
	var window_size = OS.get_window_size()
	$HUD.rect_size = Vector2(window_size.x, $HUD.rect_size.y)
	$menu.rect_size = Vector2(window_size.x + 4, window_size.y + 4)
	window_resize()
	


func window_resize():
	if not get_tree().paused:
		get_tree().paused = true
	
	var window_size = OS.get_window_size()
	var x_multiple = window_size.x / content_width
	var y_multiple = window_size.y / content_height
	
	allNode[BACKGROUND][OBJECT].global_scale = Vector2(allNode[BACKGROUND][SCALE].x * x_multiple, allNode[BACKGROUND][SCALE].y * y_multiple)
	
	$launcher.global_scale = Vector2(allNode[BACKGROUND][SCALE].x * x_multiple, allNode[BACKGROUND][SCALE].y * y_multiple)
	var laun_heigth = $launcher.get_child(0).get_rect().size.y * $launcher.get_global_transform().get_scale().y
	$launcher.global_position = Vector2(window_size.x / 2, window_size.y - (laun_heigth + 10) / 2)
	
	resize_allNode([LAUNCHER, BUSH, BUSH2, BUSH3, TREE, TREE2, ROCK, DESK, TRUMPOUILLE, FLAG], x_multiple, y_multiple)
	
	$background/collider_bg.global_scale = Vector2(x_multiple, y_multiple)
	$left_border/CollisionShape2D.global_scale = Vector2(1, y_multiple * 2)
	$right_border/CollisionShape2D.global_scale = Vector2(1, y_multiple * 2)
	$right_border/CollisionShape2D.global_position.x = window_size.x - 10
	$HUD.rect_size = Vector2(window_size.x, $HUD.rect_size.y)
	$menu.rect_size = Vector2(window_size.x + 4, window_size.y + 4)
	
	for childNode in get_children():
		if childNode.has_method("resize"):
			childNode.resize(Vector2(x_multiple, y_multiple))
			
	if get_tree().paused:
		get_tree().paused = false


func resize_allNode(allNodeEnum, x_multiple, y_multiple):
	for nodeEnum in allNodeEnum:
		if allNode[nodeEnum][OBJECT] != null:
			allNode[nodeEnum][OBJECT].global_scale = Vector2(allNode[nodeEnum][SCALE].x * x_multiple, allNode[nodeEnum][SCALE].y * y_multiple)
			allNode[nodeEnum][OBJECT].global_position = Vector2(allNode[nodeEnum][POSITION].x * x_multiple, allNode[nodeEnum][POSITION].y * y_multiple)


func randArray(list :Array):
	randomize()
	return list[randi() % list.size()]


func _process(_delta):
	if Input.is_action_just_pressed("launch"):
		$launcher.launch()
	if Input.is_action_just_pressed("ui_cancel"):
		free_all_projetile()
		$menu.run()


func _input(event):
	if event is InputEventMouseMotion:
		var window_size = OS.get_window_size()
		var laun_width = $launcher.get_child(0).get_rect().size.x * $launcher.get_global_transform().get_scale().x
		$launcher.global_position = Vector2(max(laun_width / 2.0, min(window_size.x - (laun_width / 2.0), event.position.x + cursor_width / 2.0)), $launcher.global_position.y)


func _on_Timer_timeout():
	if $HUD.is_time_out():
		free_all_projetile()
		$menu.end_game($HUD.get_tweet(), $HUD.get_splatch())
	if not is_instance_valid(trumpouille_inst):
		spawn_trumpouille()


func spawn_trumpouille():
	var nodeSpawn = randArray([BUSH, BUSH2, BUSH3, TREE, TREE2, ROCK, DESK])
	trumpouille_inst = trumpouille.instance()
	trumpouille_inst.start(allNode[nodeSpawn][POSITION], Vector2(1, 1) * scale_trumpouille, allNode[nodeSpawn][OBJECT].get_name(), allNode[nodeSpawn][DIRECTION])
	add_child(trumpouille_inst)
	move_child(trumpouille_inst, $tree.get_index())
	allNode[TRUMPOUILLE] = { OBJECT:trumpouille_inst, SCALE:trumpouille_inst.global_scale, POSITION:trumpouille_inst.global_position }
	
	var window_size = OS.get_window_size()
	var x_multiple = window_size.x / content_width
	var y_multiple = window_size.y / content_height
	allNode[TRUMPOUILLE][OBJECT].global_scale = Vector2(allNode[TRUMPOUILLE][SCALE].x * x_multiple, allNode[TRUMPOUILLE][SCALE].y * y_multiple)
	allNode[TRUMPOUILLE][OBJECT].global_position = Vector2(allNode[TRUMPOUILLE][POSITION].x * x_multiple, allNode[TRUMPOUILLE][POSITION].y * y_multiple)
	trumpouille_inst.resize(Vector2(x_multiple, y_multiple))


func addTweet():
	$HUD.add_tweet()
	var tweet_inst = tweet.instance()
	add_child(tweet_inst)
	tweet_inst.run(trumpouille_inst.get_start_anim_postion())


func addHit():
	$HUD.add_splatch()


func free_all_projetile():
	for child in get_tree().get_nodes_in_group("projectile"):
		child.queue_free()
