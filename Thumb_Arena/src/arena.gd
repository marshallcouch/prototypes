extends Node2D

var player_preload = preload("res://scenes/player.tscn")
@onready var players_node = $Controls/Players
var test = "testing"
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 2:
		var player = player_preload.instantiate()
		players_node.add_child(player)
		player.position.x = 300*(i+1)
		player.position.y = 300


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass