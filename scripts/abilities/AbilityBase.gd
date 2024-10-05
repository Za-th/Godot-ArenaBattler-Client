extends TextureButton

class_name AbilityBase

# default value
@export var cooldown:float = 10.0

func _process(_delta):
	$Sweep.value = int(($Timer.time_left / cooldown) * 100)

func pressed():
	if !disabled:
		disabled = true
		set_process(true)
		$Timer.start()
