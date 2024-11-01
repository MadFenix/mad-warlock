class_name Player
extends CharacterBody2D

@export var movement_stats:CharacterMovementStats

@onready var body: Node2D = $AnimatedSprite2D
@onready var animation_player = $AnimatedSprite2D

var states:PlayerStateNames = PlayerStateNames.new()
var animations:PlayerAnimations = PlayerAnimations.new()

func set_facing_direction(x:float) -> void:
	if abs(x) > 0:
		body.scale.x = -movement_stats.player_scale if (x < 0) else movement_stats.player_scale

func is_facing_right() -> bool:
	return body.scale.x > 0
	
func _process(_delta):
	set_facing_direction(velocity.x)
	
func play_animation(animation_name:String):
	animation_player.play(animation_name)
