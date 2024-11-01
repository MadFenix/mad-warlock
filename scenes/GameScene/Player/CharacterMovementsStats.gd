extends Resource
class_name CharacterMovementStats

@export var running_speed:float = 500.0
@export var running_acceleration:float = 2000.0
@export var running_decceleration:float = 4000.0
@export var jump_speed:float = -500
@export var drop_jump_speed:float = -600
@export var in_air_speed:float = 400
@export var in_air_acceleration:float = 4000.0
@export var jump_small_speed:float =-300.0
@export var jumping_decceleration:float = 2000.0 #como running decceleration pero cuando se mueve horizontalmente por el aire
@export var can_climbing:bool = true
@export var climbing_speed:float = 400.0
@export var automove_ledge_climb:Vector2 = Vector2(500, -150)

@export var player_scale:float = 0.5

@export var MAX_VELOCITY_Y_TO_GRAB_WALLS:float = 600*2.5 #si va mas rapido que esto, no se podrá agarrar a las paredes
@export var MOVEMENT_REDUCTION_AFTER_AUTOMOVE:float = 0.5
