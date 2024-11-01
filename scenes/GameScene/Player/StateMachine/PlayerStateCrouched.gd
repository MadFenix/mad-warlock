extends PlayerStateGravityBase

func start():
	player.play_animation(player.animations.crouch)

func on_physics_process(delta):
	player.velocity = Vector2.ZERO
	
	handle_gravity(delta)
	player.move_and_slide()
	
func on_input(_event):
	# seria mejor usar el parametro _event para obtener la información del evento
	if Input.is_action_just_released("ui_down"): 
		state_machine.change_to(player.states.Idle)
