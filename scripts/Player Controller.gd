extends Controllable

@onready var camera = $"Camera3D"
var level_node:Node3D
var world_node:World3D

var health:int = 3

var sprinting:bool = false

var active_creatures:Array
var selected:Node3D
@onready var inventory = get_node("Inventory/Panel/ScrollContainer/GridContainer") 
@onready var creature_hud = get_node("Hud/Creatures/HBoxContainer")
@onready var abilities_hud = get_node("Hud/Abilities/HFlowContainer")

var creature_hud_node_map:Dictionary = {"1": "FirstCreature", "2": "SecondCreature", "3": "ThirdCreature", "4": "FourthCreature"}
var creature_hud_sprite_map:Dictionary = {
	"1": "res://sprites/creatures/rat_icon.png",
	"2": "res://sprites/creatures/dog_icon.png",
	"3": "res://sprites/creatures/bird_icon.png",
	"4": "res://sprites/creatures/cat_icon.png"
}

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


# keyboard input handling
func _input(e) -> void:
	var target:String = ""
	var action_pressed:String = ""
	
	if e.is_action_pressed("1"):
		action_pressed = "1"
		target = get_creature(0)
	
	if e.is_action_pressed("2"):
		action_pressed = "2"
		target = get_creature(1)
	
	if e.is_action_pressed("3"):
		action_pressed = "3"
		target = get_creature(2)
	
	if e.is_action_pressed("4"):
		action_pressed = "4"
		target = get_creature(3)
	
	if (target != ""):
		if (selected.name != target):
			var exists:bool = false
			for c in active_creatures:
				if str(c.creature_root.name).split(" ")[1] == target:
					select(c)
					exists = true
					break
			if !exists:
				# create creature and add to creature hud
				creature_hud.get_node(creature_hud_node_map[action_pressed]).set_texture(load(creature_hud_sprite_map[action_pressed]))
				add_creature(target)
		action_pressed = ""
		target = ""
	
	if e.is_action_pressed("focus player"):
		if (selected.name != "player"):
			select(self)
	
	if e.is_action_pressed("stop player"):
		stop_moving()
	
	if e.is_action_pressed("first ability"):
		selected.perform_action(0)
	
	if e.is_action_pressed("second ability"):
		selected.perform_action(2)
	
	if e.is_action_pressed("third ability"):
		selected.perform_action(4)


func select(new_selected:Node3D) -> void:
	if (selected != null):
		selected.get_node("Outline").hide()
		selected.get_node("Hud/Abilities").hide()
	selected = new_selected
	selected.get_node("Outline").show()
	selected.get_node("Hud/Abilities").show()


func add_creature(creature:String) -> void:
	get_parent().ask_server_to_add_creature(creature)


func get_creature(i:int) -> String:
	return creatures[i]


func perform_action(i:int):
	abilities_hud.get_child(i).pressed()


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
