extends CharacterBody2D

@export var movement_speed = 20.0
@export var health = 10
@export var experience = 1
@export var knockback_recovery = 3.5
@export var enemy_damage = 1

var knockback = Vector2.ZERO
var screen_size

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var sound_hit = $sound_hit
@onready var hitbox = $HitBox
@onready var collision = $CollisionShape2D

@onready var loot_base = get_tree().get_first_node_in_group("loot")

var death_anim = preload("res://Enemy/explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn") 

signal remove_from_array(object)

func _ready():
	anim.play("walk")
	hitbox.damage = enemy_damage
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()
	
	
	if direction.x > 0.1 && visible == true:
		sprite.flip_h = false
	elif direction.x < -0.1 && visible == true:
		sprite.flip_h = true
		
func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	#spawn gem after death but before removing with queue_free
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	
	queue_free()

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	health -= damage
	knockback = angle * knockback_amount
	if health <= 0:
		death()
		queue_free()  
	else: 
		sound_hit.play()


func _on_hide_timer_timeout():
	var location_dif = global_position - player.global_position
	if abs(location_dif.x) > (screen_size.x / 2) * 1.4 || abs(location_dif.y) > (screen_size.y / 2) * 1.4:
		visible = false
		collision.call_deferred("set", "disabled", true)
	else:
		visible = true
		collision.call_deferred("set", "disabled", false)
