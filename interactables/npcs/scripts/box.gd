extends StaticBody3D

var mouse_params = [ResourceLoader.load("res://sprites/speak.png"), 0, Vector2(10, 40)]

func clicked_on(_camera, e, _pos, _normal, _shape_idx):
	if (e is InputEventMouseButton):
		if (e.button_index == 1 and e.pressed):
			var speech:MeshInstance3D = get_node("speech")
			speech.show()
			await get_tree().create_timer(2).timeout
			speech.hide()
