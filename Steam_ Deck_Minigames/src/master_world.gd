extends Node2D

@onready var minigames = $Minigames
@onready var pong = $Minigames/Pong
@onready var game_select = $StartPanel/VBoxContainer/GameSelect
@onready var start_panel = $StartPanel
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
	


func _on_start_button_up():
	if !start_panel.visible:
		for child in minigames.get_children():
			child.process_mode = Node.PROCESS_MODE_DISABLED
		start_panel.show()
		return
	for child in minigames.get_children():
		if child.name == game_select.get_item_text(game_select.selected):
			start_panel.hide()
			#child.reset()
			child.process_mode = PROCESS_MODE_INHERIT

			


func _on_reset_button_up():
	for child in minigames.get_children():
		child.reset()


func _on_quit_button_up():
	get_tree().quit()
