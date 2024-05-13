extends Node2D

@onready var minigames = $Minigames
@onready var game_select = $StartPanel/VBoxContainer/GameSelect
@onready var start_panel = $StartPanel

var pong = preload("res://scenes/pong.tscn")
var light_cycles = preload("res://scenes/light_cycles.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in minigames.get_children():
		child.process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
		if "Pong" == game:
			minigames.add_child(pong.instantiate())
			currently_playing = "Pong"
		if "Light Cycles" == game:
			minigames.add_child(light_cycles.instantiate())
			currently_playing = "Light Cycles"


			
			

func _on_reset_button_up():
	for child in minigames.get_children():
		child.reset()


func _on_quit_button_up():
	get_tree().quit()
