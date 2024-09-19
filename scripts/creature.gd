extends Node3D

var level_node:Node3D
var player_node:Node3D
var controller_scene:Resource = preload("res://creatures/creature_controls.tscn")
var controller_node:Node3D

func _enter_tree():
	# name created by server is "id creaturename"
	set_multiplayer_authority(str(name).split(" ")[0].to_int())

func _ready():
	if not is_multiplayer_authority(): return
	# get current level root node
	level_node = get_parent()
	
	# create controller
	var instantiated_controller_scene = controller_scene.instantiate()
	add_child(instantiated_controller_scene)
	
	# get controller node and assign multiplayer authority to it
	controller_node = get_node("CreatureController")
	controller_node.set_multiplayer_authority(str(name).split(" ")[0].to_int())
	
	# adjust position of creature graphics to account for floating navmesh
	var graphics:Node3D = controller_node
	global_position.y = 0.5
	graphics.position.y -= 0.5
	
	# get player node that controls this creature and add creature to active creatures
	player_node = level_node.get_node(str(name).split(" ")[0])
	player_node.get_node("Controller").active_creatures.append(controller_node) 
	
	# set up controller
	controller_node.set_up(level_node, get_tree().root.get_world_3d())
