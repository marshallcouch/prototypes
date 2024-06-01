extends Node2D

@onready var minigames = $Minigames
@onready var game_select = $StartPanel/VBoxContainer/GameSelect
@onready var start_panel = $StartPanel

var tennis = preload("res://scenes/tennis.tscn")
var tails = preload("res://scenes/tails.tscn")
var falling_blocks = preload("res://scenes/falling_blocks.tscn")
var middle_defense = preload("res://scenes/middle_defense.tscn")
var box_fighters = preload("res://scenes/fighting_game.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_released("start"):
		_on_start_button_up()
var currently_playing = ""

func _on_start_button_up():
	if !start_panel.visible:
		for child in minigames.get_children():
			child.process_mode = Node.PROCESS_MODE_DISABLED
		start_panel.show()
		return
	else:
		start_panel.hide()
		var game = game_select.get_item_text(game_select.selected)
		if game == currently_playing:
			for child in minigames.get_children():
				child.process_mode = Node.PROCESS_MODE_INHERIT
			return
		
		for minigame in minigames.get_children():
			minigame.queue_free()
		if "Tennis" == game:
			minigames.add_child(tennis.instantiate())
			currently_playing = "Tennis"
		if "Tails" == game:
			minigames.add_child(tails.instantiate())
			currently_playing = "Tails"
		if "Falling Blocks" == game:
			minigames.add_child(falling_blocks.instantiate())
			currently_playing = "Falling Blocks"
		if "Middle Defense" == game:
			minigames.add_child(middle_defense.instantiate())
			currently_playing = "Middle Defense"
		if "Box Fighters" == game:
			minigames.add_child(box_fighters.instantiate())
			currently_playing = "Box Fighters"



func _on_reset_button_up():
	for child in minigames.get_children():
		child.reset()


func _on_quit_button_up():
	get_tree().quit()

