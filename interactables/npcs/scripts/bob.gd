extends StaticBody3D

var mouse_params = [ResourceLoader.load("res://sprites/attack.png"), 0, Vector2(0, 5)]

var health:int = 100

func clicked_on(_camera, e, _pos, _normal, _shape_idx):
	if (e is InputEventMouseButton):
		if (e.button_index == 1 and e.pressed):
			health -= 10
			if (health == 0):
				mouse_exited.emit()
				queue_free()
			get_node("healthbar/SubViewport/Node2D").value = health
