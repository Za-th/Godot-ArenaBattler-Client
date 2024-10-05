extends Node

var effect_icon_size = Vector2(50,50)

# Player abilities
@rpc("authority", "call_remote")
func heal():
	get_node("Heal").show()
	await get_tree().create_timer(0.5).timeout
	get_node("Heal").hide()

@rpc("authority", "call_remote")
func damage_buff():
	get_node("DamageBuff").show()
	await get_tree().create_timer(0.5).timeout
	get_node("DamageBuff").hide()

@rpc("authority", "call_remote")
func attack():
	get_node("Sword").show()
	await get_tree().create_timer(0.5).timeout
	get_node("Sword").hide()


# Rat abilities
@rpc("authority", "call_remote")
func lightning():
	get_node("Lightning").show()
	await get_tree().create_timer(0.5).timeout
	get_node("Lightning").hide()

@rpc("authority", "call_remote")
func speed_debuff():
	get_node("SpeedDebuff").show()
	await get_tree().create_timer(0.5).timeout
	get_node("SpeedDebuff").hide()

@rpc("authority", "call_remote")
func stun():
	get_node("Stun").show()
	await get_tree().create_timer(0.5).timeout
	get_node("Stun").hide()


# Bird abilities
@rpc("authority", "call_remote")
func tornado():
	get_node("Tornado").show()
	get_node("Tornado/AnimationPlayer").play("tornado")
	await get_tree().create_timer(1).timeout
	get_node("Tornado").hide()

@rpc("authority", "call_remote")
func push():
	get_node("Push").emitting = true

@rpc("authority", "call_remote")
func shield():
	get_node("Shield").show()
	await get_tree().create_timer(0.5).timeout
	get_node("Shield").hide()


# Cat abilities
@rpc("authority", "call_remote")
func bleed():
	get_node("Bleed").show()
	await get_tree().create_timer(0.3).timeout
	get_node("Bleed").hide()

@rpc("authority", "call_remote")
func multi_attack():
	get_node("MultiAttack/Slash1").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash1").hide()
	
	get_node("MultiAttack/Slash2").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash2").hide()
	
	get_node("MultiAttack/Slash3").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash3").hide()
	
	get_node("MultiAttack/Slash1").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash1").hide()
	
	get_node("MultiAttack/Slash2").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash2").hide()
	
	get_node("MultiAttack/Slash3").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash3").hide()
	
	get_node("MultiAttack/Slash1").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash1").hide()
	
	get_node("MultiAttack/Slash2").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash2").hide()
	
	get_node("MultiAttack/Slash3").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash3").hide()
	
	get_node("MultiAttack/Slash1").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash1").hide()
	
	get_node("MultiAttack/Slash2").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash2").hide()
	
	get_node("MultiAttack/Slash3").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash3").hide()
	
	get_node("MultiAttack/Slash1").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash1").hide()
	
	get_node("MultiAttack/Slash2").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash2").hide()
	
	get_node("MultiAttack/Slash3").show()
	await get_tree().create_timer(0.2).timeout
	get_node("MultiAttack/Slash3").hide()

@rpc("authority", "call_remote")
func hiss():
	get_node("Hiss").show()
	await get_tree().create_timer(0.5).timeout
	get_node("Hiss").hide()


# Dog abilities
@rpc("authority", "call_remote")
func tail_whip():
	# TODO
	pass

@rpc("authority", "call_remote")
func charge():
	get_node("Charge").show()
	await get_tree().create_timer(0.7).timeout
	get_node("Charge").hide()


# effects
@rpc("authority", "call_remote")
func damage_buffed(duration:float):
	var effect = TextureRect.new()
	effect.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	effect.set_custom_minimum_size(effect_icon_size)
	effect.texture = load("res://sprites/damage.png")
	get_node("Effects/SubViewport/HBoxContainer").add_child(effect)
	await get_tree().create_timer(duration).timeout
	effect.queue_free.call_deferred()

@rpc("authority", "call_remote")
func speed_debuffed(duration:float):
	var effect = TextureRect.new()
	effect.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	effect.set_custom_minimum_size(effect_icon_size)
	effect.texture = load("res://sprites/creatures/speed_debuff.png")
	get_node("Effects/SubViewport/HBoxContainer").add_child(effect)
	await get_tree().create_timer(duration).timeout
	effect.queue_free.call_deferred()

@rpc("authority", "call_remote")
func stunned(duration:float):
	var effect = TextureRect.new()
	effect.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	effect.set_custom_minimum_size(effect_icon_size)
	effect.texture = load("res://sprites/creatures/stun.png")
	get_node("Effects/SubViewport/HBoxContainer").add_child(effect)
	await get_tree().create_timer(duration).timeout
	effect.queue_free.call_deferred()

@rpc("authority", "call_remote")
func knocked_up(duration:float):
	var effect = TextureRect.new()
	effect.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	effect.set_custom_minimum_size(effect_icon_size)
	effect.texture = load("res://sprites/creatures/tornado.png")
	get_node("Effects/SubViewport/HBoxContainer").add_child(effect)
	await get_tree().create_timer(duration).timeout
	effect.queue_free.call_deferred()

@rpc("authority", "call_remote")
func shielded(duration:float):
	var effect = TextureRect.new()
	effect.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	effect.set_custom_minimum_size(effect_icon_size)
	effect.texture = load("res://sprites/creatures/shield.png")
	get_node("Effects/SubViewport/HBoxContainer").add_child(effect)
	await get_tree().create_timer(duration).timeout
	effect.queue_free.call_deferred()

@rpc("authority", "call_remote")
func bleeding(duration:float):
	var effect = TextureRect.new()
	effect.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	effect.set_custom_minimum_size(effect_icon_size)
	effect.texture = load("res://sprites/creatures/bleed.png")
	get_node("Effects/SubViewport/HBoxContainer").add_child(effect)
	await get_tree().create_timer(duration).timeout
	effect.queue_free.call_deferred()

@rpc("authority", "call_remote")
func disarmed(duration:float):
	var effect = TextureRect.new()
	effect.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	effect.set_custom_minimum_size(effect_icon_size)
	effect.texture = load("res://sprites/creatures/hiss.png")
	get_node("Effects/SubViewport/HBoxContainer").add_child(effect)
	await get_tree().create_timer(duration).timeout
	effect.queue_free.call_deferred()
