extends Node3D

var portals:Array[ShapeCast3D]
var level_node:Node3D
var controller_scene:Resource = preload("res://resource_scenes/player_controls.tscn")
var controller_node:StaticBody3D

# set multiplayer authority when node (root node of player scene) enters tree so clients cannot run other players scripts
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	# TODO 
	#Warning: This does not automatically replicate the new authority to other peers.
	#It is the developer's responsibility to do so. 
	#You may replicate the new authority's information using MultiplayerSpawner.spawn_function, an RPC, or a MultiplayerSynchronizer.
	#Furthermore, the parent's authority does not propagate to newly added children.


func _ready():
	if not is_multiplayer_authority(): return
	
	# get current level root node
	level_node = get_parent()
	
	# create controller
	var instantiated_controller_scene = controller_scene.instantiate()
	add_child(instantiated_controller_scene)
	
	# get controller node and assign multiplayer authority to it
	controller_node = get_node("Controller")
	controller_node.set_multiplayer_authority(str(name).to_int())
	
	# set up controller
	controller_node.set_up(level_node, get_tree().root.get_world_3d())
	
	# adjust position of player graphics to account for floating navmesh
	var graphics:StaticBody3D = controller_node
	global_position.y = 0.5
	graphics.position.y -= 0.5
	
	# get teleporters in level
	get_portals()


func _process(_delta):
	if not is_multiplayer_authority(): return
	# TODO fix
	# portal handling to send player to another level
	for level_switch in portals:
		var collision_result:Array = level_switch.collision_result
		if !collision_result.is_empty():
			if (collision_result[0]["collider"].name == controller_node.name):
				# send server rpc asking for level change
				ask_server_for_level_change.rpc_id(
					1, get_parent().name, level_switch.level_name
				)


func get_portals():
	# TODO fix
	#level switches for teleporting to other levels
	var level_switch_node = get_node("../Interactables/level_switches")
	if level_switch_node != null:
		for level_switch in level_switch_node.get_children():
			# add exception to floor collision
			level_switch.add_exception(get_node("../NavigationRegion3D/ClickArea"))
			portals.append(level_switch)
	else:
		print("Error: no level_switches node")


@rpc("authority", "call_remote")
func ask_server_to_add_creature(creature:String):
	rpc_id(1, "ask_server_to_add_creature", creature, level_node.name)


@rpc
func ask_server_for_level_change(_level_path:String, _id:int):
	pass
