extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var kick_hit_box_shape = $KickHitBox/CollisionShape2D
@onready var punch_hit_box_shape = $PunchHitBox/CollisionShape2D
@onready var hitbox_shape = $Area2D/CollisionShape2D
@onready var hitboxes_timer = $HitboxesTimer
# Called when the node enters the scene tree for the first time.
var player_number = -1

func set_blocking(tf: bool):
	hitbox_shape.disabled = tf


signal hit(type:String, player)

func _ready():
	animation_player.play("Stand")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kick():
	animation_player.play("Kick")
	kick_hit_box_shape.disabled = false
	hitboxes_timer.start()
	
	
func punch():
	animation_player.play("Punch")
	punch_hit_box_shape.disabled = false
	hitboxes_timer.start()

func _on_hitboxes_timer_timeout():
	kick_hit_box_shape.disabled = true
	punch_hit_box_shape.disabled = true


func _on_punch_hit_box_area_entered(area):
	if area.is_in_group("HurtBox"):
		hit.emit("Punch", player_number)

func play_animation(anim:String):
	if anim != animation_player.current_animation:
		animation_player.play(anim)


func _on_kick_hit_box_area_entered(area):
	if area.is_in_group("HurtBox"):
		hit.emit("Kick", player_number)
