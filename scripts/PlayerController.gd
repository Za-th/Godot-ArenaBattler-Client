extends Node

@onready var camera:Camera3D = $Camera3D
@onready var player_visual:Node3D
@onready var outline_scene:PackedScene = preload("res://resource_scenes/outline.tscn")

var active_creatures:Array
var selected:Node3D
@onready var creature_hud = get_node("Hud/ActiveCreatures/HBoxContainer")
@onready var abilities_hud_map:Dictionary = {
	"Visual": get_node("Hud/PlayerHud"),
	creatures[0]: get_node("Hud/FirstCreatureHud"),
	creatures[1]: get_node("Hud/SecondCreatureHud"),
	creatures[2]: get_node("Hud/ThirdCreatureHud"),
	creatures[3]: get_node("Hud/FourthCreatureHud"),
}

# TODO change
var ability_map:Dictionary = {"FirstAbility": "Heal", "SecondAbility": "DamageBuff", "ThirdAbility": "Attack"}

var active_creature_hud_node_map:Dictionary = {"1": "FirstCreature", "2": "SecondCreature", "3": "ThirdCreature", "4": "FourthCreature"}
var active_creature_hud_sprite_map:Dictionary = {
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


func _ready() -> void:
	# set up player ability hud
	get_node("Hud/PlayerHud").set_up("Player")
	
	# TODO handle if visual doesnt exist
	
	player_visual = get_parent().get_node(str(name.split(" ")[0]) + " Visual")
	
	# create outline for player
	player_visual.add_child(outline_scene.instantiate())
	player_visual.get_node("Outline").hide()
	
	select(player_visual)


func _process(_delta) -> void:
	# camera follows player visual
	camera.global_position = player_visual.global_position + Vector3(0,15,15)
	camera.global_rotation = Vector3(deg_to_rad(-45),0,0)


# mouse handling
func _on_click_area_input_event(_camera, e, pos, _normal, _shape_idx) -> void:
	if (e is InputEventMouseButton):
		# left click moves selected
		if (e.button_index == 1 and e.pressed):
			ask_server_to_path(PathingController.new_path(pos, selected), selected.name)


@rpc("authority", "call_remote")
func ask_server_to_path(path:PackedVector3Array, to_move_name:String) -> void:
	rpc_id(1, "ask_server_to_path", path, to_move_name)


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
				if str(c.name).split(" ")[1] == target:
					select(c)
					exists = true
					break
			if !exists:
				# create creature and add to creature hud
				creature_hud.get_node(active_creature_hud_node_map[action_pressed]).set_texture(load(active_creature_hud_sprite_map[action_pressed]))
				ask_server_to_add_creature(target)
		action_pressed = ""
		target = ""
	
	if e.is_action_pressed("focus player"):
		if (selected.name != "player"):
			select(player_visual)
	
	#if e.is_action_pressed("stop player"):
		#stop_moving()
	
	if e.is_action_pressed("first ability"):
		perform_ability("FirstAbility", selected.name)
	
	if e.is_action_pressed("second ability"):
		perform_ability("SecondAbility", selected.name)
	
	if e.is_action_pressed("third ability"):
		perform_ability("ThirdAbility", selected.name)


func select(new_selected:Node3D) -> void:
	var selected_name:String = new_selected.name.split(" ")[1]
	
	if (selected != null):
		var prev_selected_name:String = selected.name.split(" ")[1]
		selected.get_node("Outline").hide()
		abilities_hud_map[prev_selected_name].hide()
	
	selected = new_selected
	selected.get_node("Outline").show()
	abilities_hud_map[selected_name].show()


@rpc("authority", "call_remote")
func ask_server_to_add_creature(creature:String) -> void:
	rpc_id(1, "ask_server_to_add_creature", creature)


@rpc("authority", "call_remote")
func server_added_creature(creature_name:String) -> void:
	var creature_node:Node3D = get_parent().get_node(creature_name)
	
	# create outline for creature
	creature_node.add_child(outline_scene.instantiate())
	creature_node.get_node("Outline").hide()
	
	# set up ability hud
	abilities_hud_map[creature_name.split(" ")[1]].set_up(creature_name.split(" ")[1])
	
	active_creatures.append(creature_node)


func get_creature(i:int) -> String:
	return creatures[i]


func perform_ability(ability:String, selected_name:String):
	abilities_hud_map[selected_name.split(" ")[1]].get_node("HFlowContainer").get_node(ability).pressed()
	#AbilityHandler.used_ability(get_parent().name, ability_map[ability], selected_enemy)
