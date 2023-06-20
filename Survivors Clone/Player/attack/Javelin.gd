extends Area2D

var level = 1
var health = 999
var speed = 200.0
var damage = 10
var knockback_amount = 100
var paths = 1
var attack_speed = 5.0
var attack_size = 1.0

var target = Vector2.ZERO
var target_array = []

var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

var bolt_sprite = preload("res://Textures/Items/Weapons/energyball.png")
var charged_bolt_sprite = preload("res://Textures/Items/Weapons/energybolt.png")

@onready var player = get_tree().get_first_node_in_group('player') 
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

@onready var attackTimer = get_node("%AttackTimer")
@onready var changeDirectionTimer = get_node("%ChangeDirection")
@onready var resetPostTimer = get_node("%ResetPostTimer")
@onready var sound_attack = $sound_attack

signal remove_from_array(object)

func update_javelin():
	level = player.javelin_level
	match level:
		1:
			health = 999
			speed = 200
			damage = 10
			knockback_amount = 100
			paths = 1
			attack_size = 1.0 * (player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
		2:
			health = 999
			speed = 200
			damage = 10
			knockback_amount = 100
			paths = 2
			attack_size = 1.0 * (player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
		3:
			health = 999
			speed = 200
			damage = 10
			knockback_amount = 100
			paths = 3
			attack_size = 1.0 * (player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
		4:
			health = 999
			speed = 200
			damage = 15
			knockback_amount = 120
			paths = 3
			attack_size = 1.0 * (player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
	
	scale = Vector2(1.0, 1.0) * attack_size
	attackTimer.wait_time = attack_speed

func _ready():
	update_javelin() 
	_on_reset_post_timer_timeout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target_array.size() > 0:
		position += angle * speed * delta
	else:
		var player_angle = global_position.direction_to(reset_pos)
		var distance_dif = global_position - player.global_position
		var return_speed = 20
		if abs(distance_dif.x) > 500 or abs(distance_dif.y) > 500:
			return_speed = 100
		position += player_angle * return_speed * delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(135)

func add_paths():
	sound_attack.play()
	emit_signal("remove_from_array", self)
	target_array.clear()
	var counter = 0
	while counter < paths:
		var new_path = player.get_random_target()
		target_array.append(new_path)
		counter += 1
		enable_attack(true)
	target = target_array[0]
	process_path()

func process_path():
	angle = global_position.direction_to(target)
	changeDirectionTimer.start()
	var tween = create_tween()
	var new_rotation_deg = angle.angle() + deg_to_rad(135)
	tween.tween_property(self, "rotation", new_rotation_deg, 0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _on_attack_timer_timeout():
	add_paths()

func enable_attack(atk = true):
	if atk:
		collision.call_deferred("set", "disabled", false)
		sprite.texture = charged_bolt_sprite
	else:
		collision.call_deferred("set", "disabled", true)
		sprite.texture = bolt_sprite  

func _on_change_direction_timeout():
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			sound_attack.play()
			emit_signal("remove_from_array", self)
		else: 
			changeDirectionTimer.stop()
			attackTimer.start()
			enable_attack(false)
	else: 
		changeDirectionTimer.stop()
		attackTimer.start()
		enable_attack(false)

func _on_reset_post_timer_timeout():
	var choose_direction = randi() % 4
	reset_pos = player.global_position
	match choose_direction:
		0:
			reset_pos.x += 50
		1: 
			reset_pos.x -= 50
		2:
			reset_pos.y += 50
		3:
			reset_pos.y -= 50 
