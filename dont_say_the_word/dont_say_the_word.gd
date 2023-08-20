extends Node2D



var team1_score:int
var team2_score:int
var lists: Dictionary
var used_items: Dictionary
var is_playing: bool = false
var list_selected:int = -1
var game_timer:Timer
var speed_up:float = 0
var last_beep_time:float = 0
var duration
var selected_list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	team1_score = 0
	team2_score = 0
	load_lists()
	next_category()
	game_timer = Timer.new()
	game_timer.one_shot = true
	$".".add_child(game_timer)
	


func _on_team_one_up_button_down() -> void:
	team1_score += 1
	update_team1label()

func _on_team_one_down_button_down() -> void:
	team1_score -= 1
	update_team1label()

func _on_team_two_up_button_down() -> void:
	team2_score += 1
	update_team2label()

func _on_team_two_down_button_down() -> void:
	team2_score -= 1
	update_team2label()

func load_lists() -> void:
	var file = File.new()
	file.open("res://gamelists.tres",File.READ)
	var gamelists = file.get_as_text()
	gamelists = gamelists.replace("[gd_resource type=\"Resource\" format=2]","").replace("[resource]","")
	lists = JSON.parse(gamelists).result


func next_category() -> void: 
	if is_playing:
		return
	if list_selected == lists["Lists_Count"]-1:
		list_selected = 0
	else:
		list_selected += 1
	
	$category_label.text = "Category: " + lists["Lists"][list_selected]
	
func update_team1label():
	$team_one_score.text = "Team 1 Score: " + str(team1_score)

func update_team2label():
	$team_two_score.text = "Team 2 Score: " + str(team2_score)





func _on_next_category_button_button_down() -> void:
	next_category()


func _on_start_stop_round_button_down() -> void:
	if is_playing:
		game_timer.stop()
		$word_label.text = "Word or Phrase: " 
	else: 
		duration = rand_range(45,90)
		speed_up = duration * 0.2 
		last_beep_time = duration 
		game_timer.start(duration)
		selected_list = lists[lists["Lists"][list_selected]]
		randomize()
		selected_list.shuffle()
		get_next_word_or_phrase()
	is_playing = !is_playing

func _process(delta: float) -> void:
	if is_playing:
		if last_beep_time - 1 > game_timer.time_left:
			last_beep_time = game_timer.time_left
			beep()
		elif speed_up > game_timer.time_left and last_beep_time - 0.25 > game_timer.time_left:
			last_beep_time = game_timer.time_left
			beep()
		if game_timer.time_left < .1:
			buzz()
			is_playing = false
			
		
func beep() -> void:
	$beep.play()
	
func buzz() -> void:
	$buzz.play()


func _on_next_word_button_button_down() -> void:
	if is_playing:
		get_next_word_or_phrase()


func get_next_word_or_phrase() -> void:
	if selected_list.size() == 0:
		selected_list = lists["Random"]
		if selected_list.size() == 0:
			$word_label.text = "Restart the app to refresh words or choose another category"
		else:
			$word_label.text = "Word or Phrase: " + selected_list.pop_front()
	else:
		$word_label.text = "Word or Phrase: " + selected_list.pop_front()
