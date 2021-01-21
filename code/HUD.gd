extends GridContainer


func start():
	$score/bg/nb_splatch.text = "0"
	$score/bg/nb_tweet.text = "0"
	$time/bg/txt.text = "10"


func _on_Timer_timeout():
	$time/bg/txt.text = str(int($time/bg/txt.text) - 1)


func add_tweet():
	$score/bg/nb_tweet.text = str(int($score/bg/nb_tweet.text) + 1)


func add_splatch():
	$score/bg/nb_splatch.text = str(int($score/bg/nb_splatch.text) + 1)


func get_tweet():
	return int($score/bg/nb_tweet.text)


func get_splatch():
	return int($score/bg/nb_splatch.text)


func is_time_out():
	return int($time/bg/txt.text) <= 1
