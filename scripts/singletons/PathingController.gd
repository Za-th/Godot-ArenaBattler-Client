extends Node

var nav_map:RID

func new_path(pos:Vector3, to_move:Node3D) -> PackedVector3Array:
	if (!nav_map.is_valid()):
		print("no nav mesh")
		return PackedVector3Array()
	
	# get target point on navmesh and generate path points
	var target:Vector3 = NavigationServer3D.map_get_closest_point(nav_map, pos)
	var path:PackedVector3Array = NavigationServer3D.map_get_path(nav_map, to_move.global_position, target, true)
	
	return path
