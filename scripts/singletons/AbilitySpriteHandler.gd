extends Node

var sprite_map:Dictionary = {
	"Player": {
		1: {"Sprite": "res://sprites/heal.png",
			"Cooldown": 10.0,
			"Name": "Heal"},
		2: {"Sprite": "res://sprites/damage.png",
			"Cooldown": 5.0,
			"Name": "DamageBuff"},
		3: {"Sprite": "res://sprites/attack.png",
			"Cooldown": 1.0,
			"Name": "Attack"}
	},
	
	"Rat": {
		1: {"Sprite": "res://sprites/creatures/lightning.png",
			"Cooldown": 3.0,
			"Name": "LightningAOE"},
		2: {"Sprite": "res://sprites/creatures/speed_debuff.png",
			"Cooldown": 5.0,
			"Name": "SpeedDebuff"},
		3: {"Sprite": "res://sprites/creatures/stun.png",
			"Cooldown": 2.0,
			"Name": "Stun"}
	},
	
	"Bird": {
		1: {"Sprite": "res://sprites/creatures/tornado.png",
			"Cooldown": 3.0,
			"Name": "Tornado"},
		2: {"Sprite": "res://sprites/creatures/push.png",
			"Cooldown": 5.0,
			"Name": "Push"},
		3: {"Sprite": "res://sprites/creatures/shield.png",
			"Cooldown": 2.0,
			"Name": "Shield"}
	},
	
	"Cat": {
		1: {"Sprite": "res://sprites/creatures/bleed.png",
			"Cooldown": 3.0,
			"Name": "Bleed"},
		2: {"Sprite": "res://sprites/creatures/multi_attack.png",
			"Cooldown": 5.0,
			"Name": "MultiAttack"},
		3: {"Sprite": "res://sprites/creatures/hiss.png",
			"Cooldown": 2.0,
			"Name": "Hiss"}
	},
	
	"Dog": {
		1: {"Sprite": "res://sprites/creatures/jump.png",
			"Cooldown": 3.0,
			"Name": "JumpAttack"},
		2: {"Sprite": "res://sprites/creatures/tail_whip.png",
			"Cooldown": 5.0,
			"Name": "TailWhip"},
		3: {"Sprite": "res://sprites/creatures/charge.png",
			"Cooldown": 2.0,
			"Name": "Charge"}
	}
}

func get_ability_sprite(_name:String, ability:int) -> String:
	if !sprite_map.has(_name):
		return "res://sprites/error.png"
	return sprite_map[_name][ability]["Sprite"]

func get_ability_cooldown(_name:String, ability:int) -> float:
	if !sprite_map.has(_name):
		return 10.0
	return sprite_map[_name][ability]["Cooldown"]

func get_ability_name(_name:String, ability:String) -> String:
	var ability_map = {"FirstAbility": 1, "SecondAbility": 2, "ThirdAbility": 3}
	return sprite_map[_name][ability_map[ability]]["Name"]
