extends Area2D

@export var experience = 1 

var spr_green = preload("res://Textures/Items/Gems/green_gem.png")
var spr_red = preload("res://Textures/Items/Gems/red_gem.png")
var spr_yellow = preload("res://Textures/Items/Gems/yellow_gem.png")
var spr_purple = preload("res://Textures/Items/Gems/purple_gem.png")
var spr_blue = preload("res://Textures/Items/Gems/blue_gem.png")

var target = null
var speed = -50

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $sound_collected

func _ready():
	if experience < 5:
		return
	elif experience < 10:
		sprite.texture = spr_blue 
	elif experience < 25:
		sprite.texture = spr_yellow 
	elif experience < 50:
		sprite.texture = spr_red  
	else:
		sprite.texture = spr_purple
 
func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, delta * speed)
		speed += 2

func grab():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false 
	return experience

func _on_sound_collected_finished():
	queue_free()
