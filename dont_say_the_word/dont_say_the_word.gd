extends Node2D



var team1_score:int
var team2_score:int
var lists: Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	team1_score = 0
	team2_score = 0


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
	file.open("res://assets/gamelists.tres",File.READ)
	var gamelists = file.get_as_text()
	gamelists = gamelists.replace("[gd_resource type=\"Resource\" format=2]","").replace("[resource]","")
	lists = JSON.parse(gamelists).result
	

	
func update_team1label():
	$team_one_score.text = "Team 1 Score: " + str(team1_score)

func update_team2label():
	$team_two_score.text = "Team 2 Score: " + str(team2_score)



