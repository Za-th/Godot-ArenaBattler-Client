extends Controllable

@onready var camera = $"Camera3D"
var level_node:Node3D
var world_node:World3D

var health:int = 3

var selected_action:String
var sprinting:bool = false

var active_creatures:Array
var selected:Node3D
@onready var inventory = get_node("Inventory/Panel/ScrollContainer/GridContainer") 

var creatures:Array = [
	"Rat",
	"Dog",
	"Bird",
	"Cat"
]


func set_up(level:Node3D, world:World3D) -> void:
	
	# set camera current rather than clashing with other players cameras
	camera.current = true
	
	# select self to control player by default
	select(self)
	
	# change to first action
	change_action("1")
	
	# override default speed values
	move_speed = 6.0
	turn_speed = PI
	
	# set up nav_mesh
	_initialise(world, get_parent())
	
	# store current level and world nodes
	level_node = level
	world_node = world
	
	# connect mouse input collision for nav mesh
	level_node.get_node("NavigationRegion3D/ClickArea").connect("input_event", _on_click_area_input_event)


func _process(_delta):
	# TODO fix
	camera.position = Vector3.ZERO
	camera.rotation = Vector3.ZERO
	camera.global_position = global_position + Vector3(0,15,15)
	camera.global_rotation = Vector3(deg_to_rad(-45),0,0)


func _on_click_area_input_event(_camera, e, pos, _normal, _shape_idx) -> void:
	if selected:
		if (e is InputEventMouseButton):
			# left click moves selected
			if (e.button_index == 1 and e.pressed):
				var _path:PackedVector3Array = selected.new_unit_path(pos)
			# TODO change
			if (e.button_index == 2 and e.pressed):
				for player_id in multiplayer.get_peers():
					# server id is 1
					if player_id != 1:
						pass
						#hurt.rpc_id(player_id)


# keyboard input handling
func _input(e) -> void:
	var target:String = ""
	
	if e.is_action_pressed("1"):
		target = get_creature(0)
	
	if e.is_action_pressed("2"):
		target = get_creature(1)
	
	if e.is_action_pressed("3"):
		target = get_creature(2)
	
	if e.is_action_pressed("4"):
		target = get_creature(3)
	
	if e.is_action_pressed("focus player"):
		if (selected.name != "player"):
			select(self)
	
	if e.is_action_pressed("stop player"):
		stop_moving()
	
	if (target != ""):
		if (selected.name != target):
			var exists:bool = false
			for c in active_creatures:
				if str(c.creature_root.name).split(" ")[1] == target:
					select(c)
					exists = true
					break
			if !exists:
				# create creature
				add_creature(target)
		target = ""


func select(new_selected:Node3D) -> void:
	# select creature
	if (selected != null):
		selected.get_node("Outline").hide()
	selected = new_selected
	selected.get_node("Outline").show()


func add_creature(creature:String) -> void:
	get_parent().ask_server_to_add_creature(creature)


func get_creature(i:int) -> String:
	return creatures[i]


func change_action(action:String) -> void:
	selected_action = action


func perform_action() -> Array:
	print("selected action: ", selected_action)
	return ["_"]


func add_item() -> void:
	pass

# hud inputs

func _sprint_toggled(toggled:bool) -> void:
	if toggled:
		move_speed = 10.0
	else:
		move_speed = 6.0
	sprinting = toggled


func _settings_button_pressed() -> void:
	get_node("Settings").show()


func _on_inventory_pressed():
	if get_node("Inventory").is_visible():
		get_node("Inventory").hide()
	else:
		get_node("Inventory").show()


func _quit_game() -> void:
	get_tree().quit(0)


func _close_settings() -> void:
	get_node("Settings").hide()


# player cleanup, spawns finish point on level node so needs to be removed
func _on_tree_exiting():
	finish_point.queue_free.call_deferred()


@rpc("any_peer")
func hurt() -> void:
	health -= 1
	if health <= 0:
		health = 3
		position = Vector3.ZERO
