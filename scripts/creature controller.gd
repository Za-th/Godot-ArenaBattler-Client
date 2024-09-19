extends Controllable

var level_node:Node3D
var creature_root:Node3D

# initialise nav mesh for controllable class
func set_up(level:Node3D, world:World3D):
	# adjust position of graphics to account for floating navmesh
	global_position.y = 0.5
	
	level_node = level
	creature_root = get_parent()
	_initialise(world, creature_root)
	
	self.tree_exited.connect(_on_tree_exiting)

func _on_tree_exiting():
	finish_point.queue_free.call_deferred()
	creature_root.queue_free.call_deferred()
