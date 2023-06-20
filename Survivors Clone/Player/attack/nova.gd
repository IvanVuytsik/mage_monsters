extends Node2D

var level = 1 
var speed = 100
var damage = 3
var knockback_amount = 150
var target = Vector2.ZERO
var angle = Vector2.ZERO
var attack_size = 1.5

@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer

signal remove_from_array(object)
 
func _ready():
	level = player.nova_level
	angle = global_position.direction_to(target)
	match level:
		1:  
			speed = 100
			damage = 3
			knockback_amount = 150
			attack_size = 1.5 * (player.spell_size)
		2:  
			speed = 100
			damage = 6
			knockback_amount = 200 
			attack_size = 1.5 * (player.spell_size)
			
	var tween = create_tween()  
	tween.tween_property(self, "scale", Vector2(attack_size, attack_size), 2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)	
	tween.play()

func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
