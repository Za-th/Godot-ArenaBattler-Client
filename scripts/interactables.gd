extends Node

func _ready():
	# interactables
	var box:StaticBody3D = get_node("npcs/box");
	box.connect("mouse_entered", _interactables_mouse_entered.bind(box))
	box.connect("mouse_exited", func(): Input.set_custom_mouse_cursor(null));
	box.connect("input_event", _input_event.bind(box))
	
	var bob:StaticBody3D = get_node("npcs/bob");
	bob.connect("mouse_entered", _interactables_mouse_entered.bind(bob))
	bob.connect("mouse_exited", func(): Input.set_custom_mouse_cursor(null));
	bob.connect("input_event", _input_event.bind(bob))

func _interactables_mouse_entered(node):
	Input.callv("set_custom_mouse_cursor", node.mouse_params)

func _input_event(_camera, e, _pos, _normal, _shape_idx, node):
	node.callv("clicked_on", [_camera, e, _pos, _normal, _shape_idx])
