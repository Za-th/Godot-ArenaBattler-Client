extends AbilityBase

func set_up(sprite_path:String, _cooldown:float):
	cooldown = cooldown
	$Sweep.value = 0
	set_texture_normal(load(sprite_path))
	$Sweep.texture_progress = texture_normal
	$Timer.wait_time = cooldown
	set_process(false)

func _on_timer_timeout():
	$Sweep.value = 0
	disabled = false
	set_process(false)
