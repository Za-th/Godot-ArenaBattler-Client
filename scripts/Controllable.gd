# TODO this whole thing needs to be changed for creature/player movement
# TODO this whole thing needs to be redone lol
# TODO err handling

extends Node3D

class_name Controllable

# default values
var move_speed:float = 3.0
var turn_speed:float = PI*2

var nav_map:RID
var pathing:bool = false
var index:int = 0
var path:PackedVector3Array
var finish_point:MeshInstance3D = preload("res://resource_scenes/finish_point.tscn").instantiate()

# root node is the node that is moved
var root_node:Node3D

func _initialise(world:World3D, root:Node3D) -> void:
	root_node = root
	
	nav_map = world.navigation_map
	
	# add finish point for visualising movement
	finish_point.name = name + "finish_point"
	root_node.level_node.add_child.call_deferred(finish_point)

func new_unit_path(pos:Vector3) -> PackedVector3Array:
	if (!nav_map.is_valid()):
		print("no nav mesh")
		return PackedVector3Array();
	
	# reset path
	index = 0
	
	# get target point on navmesh and generate path points
	var target:Vector3 = NavigationServer3D.map_get_closest_point(nav_map, pos)
	path = NavigationServer3D.map_get_path(nav_map, root_node.global_position, target, true)
	pathing = true
	
	# move finish point
	finish_point.global_position = path[path.size()-1]
	
	finish_point.show();
	
	return path;

func stop_moving() -> void:
	pathing = false
	index = 0
	finish_point.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if (pathing):
		if (index < path.size()):
			# how far the player will move
			var step:float = delta * move_speed
			
			# get direction of next path point
			var direction:Vector3 = path[index] - root_node.global_position
		
			# if the next step would go over path point move to point and start on next one
			if (step > direction.length()):
				step = direction.length()
				index += 1
			
			# change the position of the player
			var diff:Vector3 = direction.normalized() * step
			root_node.global_position += diff
			
			# rotate player towards next path point
			root_node.rotation.y = lerp_angle(root_node.rotation.y, atan2(-direction.x,-direction.z), turn_speed*delta)
			
		else:
			# pathing finished
			stop_moving()
