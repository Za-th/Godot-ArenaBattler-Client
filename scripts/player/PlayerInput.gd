extends Node

@onready var camera:Camera3D = $Camera3D
@onready var player_visual:Node3D
@onready var outline_scene:PackedScene = preload("res://resource_scenes/outline.tscn")
@onready var finish_point:Node3D = preload("res://resource_scenes/finish_point.tscn").instantiate()

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
	
	player_visual = get_parent().get_node("Characters").get_node(str(name.split(" ")[0]) + " Visual")
	
	# create outline for player
	player_visual.add_child(outline_scene.instantiate())
	
	# create finish_point
	get_parent().add_child(finish_point)
	
	select(player_visual)


func _process(_delta) -> void:
	# if any of the creatures have been freed then remove them # TODO and reset hud
	for c in active_creatures:
		if !is_instance_valid(c):
			active_creatures.erase(c)
	
	# if selected has been freed switch to player
	if !is_instance_valid(selected):
		for hud in abilities_hud_map:
			abilities_hud_map[hud].hide()
		select(player_visual)
	
	# camera follows character visual
	camera.global_position = selected.global_position + Vector3(0,10,10)
	camera.global_rotation = Vector3(deg_to_rad(-45),0,0)


# mouse handling
func _on_click_area_input_event(_camera, e, pos, _normal, _shape_idx) -> void:
	if (e is InputEventMouseButton):
		# left click moves selected
		if (e.button_index == 2 and e.pressed):
			ask_server_to_path(PathingController.new_path(pos, selected), selected.name)
			
			# finish point handling
			var finish_point_animation_player:AnimationPlayer = finish_point.get_node("AnimationPlayer")
			if finish_point_animation_player.current_animation == "finish_point_animation":
				finish_point.hide()
				finish_point_animation_player.stop()
			finish_point.global_position = pos
			finish_point.show()
			finish_point_animation_player.play("finish_point_animation")


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
				if is_instance_valid(c):
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
	
	if e.is_action_pressed("stop player"):
		finish_point.hide()
		ask_to_stop_moving(selected.name)
	
	if e.is_action_pressed("first ability"):
		player_used_ability(selected.name, "FirstAbility")
	
	if e.is_action_pressed("second ability"):
		player_used_ability(selected.name, "SecondAbility")
	
	if e.is_action_pressed("third ability"):
		player_used_ability(selected.name, "ThirdAbility")


func select(new_selected:Node3D) -> void:
	var selected_name:String = new_selected.name.split(" ")[1]
	
	if (selected != null):
		var prev_selected_name:String = selected.name.split(" ")[1]
		abilities_hud_map[prev_selected_name].hide()
	
	selected = new_selected
	abilities_hud_map[selected_name].show()


@rpc("authority", "call_remote")
func ask_server_to_add_creature(creature:String) -> void:
	rpc_id(1, "ask_server_to_add_creature", creature)


@rpc("authority", "call_remote")
func server_added_creature(creature_name:String) -> void:
	var creature_node:Node3D = get_parent().get_node("Characters").get_node(creature_name)
	
	# create outline for creature
	creature_node.add_child(outline_scene.instantiate())
	
	# set up ability hud
	abilities_hud_map[creature_name.split(" ")[1]].set_up(creature_name.split(" ")[1])
	
	active_creatures.append(creature_node)


func get_creature(i:int) -> String:
	return creatures[i]


@rpc("authority", "call_remote")
func player_used_ability(selected_name:String, ability:String):
	rpc_id(1, "player_used_ability", selected_name, ability)


@rpc("authority", "call_remote")
func server_used_ability(character_name:String, ability:String):
	abilities_hud_map[character_name.split(" ")[1]].get_node("HFlowContainer").get_node(ability).pressed()

@rpc("authority", "call_remote")
func ask_to_stop_moving(character_name:String):
	rpc_id(1, "ask_to_stop_moving", character_name)
