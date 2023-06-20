extends Node2D

@export var spawns: Array[SpawnInfo] = []
@export var time = 0
@onready var player = get_tree().get_first_node_in_group("player")

var enemy_cap = 250
var enemies_to_spawn = []

signal changeTime(time)

func _ready():
	connect("changeTime", Callable(player, "change_time"))

func delete_children():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()

func _on_timer_timeout():
	time += 1
	var enemy_spawns = spawns
	var my_children = get_children()
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy #load(str(i.enemy.resource_path))
				var counter = 0
				while counter < i.enemy_num:
					if my_children.size() <= enemy_cap:
						var enemy_spawn = new_enemy.instantiate()
						enemy_spawn.global_position = get_random_position()
						add_child(enemy_spawn)
					else:
						enemies_to_spawn.append(new_enemy)
					counter += 1
	if my_children.size() <= enemy_cap and enemies_to_spawn.size() > 0:
		var spawn_number = clamp(enemies_to_spawn.size(), 1, 50) - 1
		var counter = 0
		while counter < spawn_number: 
				var new_enemy = enemies_to_spawn[0].instantiate()
				new_enemy.global_position = get_random_position()
				add_child(new_enemy)
				enemies_to_spawn.remove_at(0)
				counter += 1
	emit_signal("changeTime", time)

func get_random_position():
	var view_port_rect = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2(player.global_position.x - view_port_rect.x/2, player.global_position.y - view_port_rect.y/2)
	var top_right = Vector2(player.global_position.x + view_port_rect.x/2, player.global_position.y - view_port_rect.y/2)
	var bottom_left = Vector2(player.global_position.x - view_port_rect.x/2, player.global_position.y + view_port_rect.y/2)
	var bottom_right = Vector2(player.global_position.x + view_port_rect.x/2, player.global_position.y + view_port_rect.y/2)
	
	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up": 
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)


func _on_player_player_death():
	delete_children()
