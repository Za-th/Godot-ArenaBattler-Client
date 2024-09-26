extends AbilityBase

func _ready():
	cooldown = 5.0
	$Sweep.value = 0
	$Sweep.texture_progress = texture_normal
	$Timer.wait_time = cooldown
	set_process(false)

func _on_timer_timeout():
	$Sweep.value = 0
	disabled = false
	set_process(false)
