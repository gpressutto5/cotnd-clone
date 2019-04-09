extends "../entity.gd"

onready var Grid = get_parent()

func _process(delta):
	handle_input()

func handle_input():
	var input_direction = get_input_direction()
	if not input_direction:
		return

	var target_position = Grid.request_move(self, input_direction)
	if not target_position:
		return

	move_to(target_position)


func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func move_to(target_position):
	set_process(false)
	$AnimationPlayer.play("walk")

	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	var move_direction = (target_position - position).normalized()
	$Tween.interpolate_property($Position2D, "position", - move_direction * 32, Vector2(), $AnimationPlayer.current_animation_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	position = target_position

	$Tween.start()

	# Stop the function execution when the animation finished
	yield($AnimationPlayer, "animation_finished")

	set_process(true)
