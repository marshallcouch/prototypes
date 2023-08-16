extends Node2D



var team1_score:int
var team2_score:int
var lists: Dictionary
var used_items: Dictionary
var is_playing: bool = false
var list_selected:int = -1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	team1_score = 0
	team2_score = 0
	load_lists()
	next_category()
	


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
