extends CharacterBody2D

@export var movement_speed = 40.0
@export var health = 100
var maxhp = 100
var last_movement = Vector2.UP

#attacks
var arcaneSpear = preload("res://Player/attack/arcane_spear.tscn")
var tornado = preload("res://Player/attack/tornado.tscn")
var javelin = preload("res://Player/attack/javelin.tscn")
var nova = preload("res://Player/attack/nova.tscn")
var blast = preload("res://Player/attack/blast.tscn")

#attack nodes
@onready var arcaneSpearTimer = get_node("%arcaneSpearTimer")
@onready var arcaneSpearAttackTimer = get_node("%arcaneSpearAttackTimer")
@onready var tornadoTimer = get_node("%tornadoTimer")
@onready var tornadoAttackTimer = get_node("%tornadoAttackTimer")
@onready var javelinBase = get_node("%JavelinBase")
@onready var novaTimer = get_node("%novaTimer")
@onready var novaAttackTimer = get_node("%novaAttackTimer")
@onready var blastTimer = get_node("%blastTimer")
@onready var blastAttackTimer = get_node("%blastAttackTimer")

@onready var menu = "res://TitleScreen/menu.tscn"

#experience
var experience = 0
var experience_level = 1
var collected_experience = 0 #Vector2.UP
 
#arcanespear
var arcaneSpear_ammo = 0
var arcaneSpear_baseammo = 0
var arcaneSpear_attack_speed = 1.5
var arcaneSpear_level = 1

#tornado
var tornado_ammo = 0
var tornado_baseammo = 0
var tornado_attack_speed = 3
var tornado_level = 0

#javelin
var javelin_ammo = 0
var javelin_level = 0

#blast
var blast_ammo = 0
var blast_level = 0
var blast_baseammo = 0
var blast_attack_speed = 3

#nova
var nova_ammo = 0
var nova_baseammo = 0
var nova_attack_speed = 5
var nova_level = 0


#enemy related
var enemy_close = []

#===========================================================
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")
@onready var grabBase = $Grab/CollisionShape2D
#GUI
@onready var expbar = get_node("%ExpBar")
@onready var lvl_label = get_node("%lvl_label")
#GUI - level UP
@onready var lvlPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%upgradeOptions")
@onready var snd_levelUp = get_node("%sound_levelUp")
# GUI - item options
@onready var itemOptions = preload("res://Utils/item_option.tscn")
#healthbar
@onready var healthBar = get_node("%HealthBar")
#timer
@onready var lblTimer = get_node("%labelTimer")
var time = 0
#collected items
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")

#Win/Lose Panel
@onready var gameOverPanel = get_node("%GameOver")  
@onready var lblResult = get_node("%lbl_result")  
@onready var sound_victory = get_node("%sound_win")  
@onready var sound_lose = get_node("%sound_lose")

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 1
var additional_attacks = 0

#signal
signal playerDeath()

func _ready():
	attack()
	set_expbar(experience, calculate_experience_cap())
	upgrade_character("arcanespear1")
	_on_hurt_box_hurt(0, 0, 0)
			
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left") 
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up") 
	var mov = Vector2(x_mov, y_mov)
	
	#flip sprite
	if mov.x > 0:
		sprite.flip_h = false
	elif mov.x < 0:
		sprite.flip_h = true
		
	#animation
	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = mov.normalized() * movement_speed
	move_and_slide()
	
func attack():
	if arcaneSpear_level > 0:
		arcaneSpearTimer.wait_time = arcaneSpear_attack_speed * (1 - spell_cooldown)
		if arcaneSpearTimer.is_stopped():
			arcaneSpearTimer.start()
			
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attack_speed * (1 - spell_cooldown)
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
			
	if blast_level > 0:
		blastTimer.wait_time = blast_attack_speed * (1 - spell_cooldown)
		if blastTimer.is_stopped():
			blastTimer.start()
			
	if nova_level > 0:
		novaTimer.wait_time = nova_attack_speed * (1 - spell_cooldown)
		if novaTimer.is_stopped():
			novaTimer.start()
			
	if javelin_level > 0:
		spawn_javelin()

func _physics_process(delta):
	movement()
	if time >= 600 || Input.is_action_just_pressed("leave"):
		death()

func death():
	gameOverPanel.visible = true
	emit_signal("playerDeath")
	get_tree().paused = true
	var tween = gameOverPanel.create_tween()
	tween.tween_property(gameOverPanel, "position", Vector2(220, 50), 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 600:
		lblResult.text = "You Win"
		sound_victory.play()
	else:
		lblResult.text = "You Lose"
		sound_lose.play()

func _on_hurt_box_hurt(damage, _angle, _knockback):
	health -= clamp(damage - armor, 1.0, 999.0)
	healthBar.max_value = maxhp
	healthBar.value = health
	if health <= 0:
		death()
		
func _on_arcane_spear_timer_timeout():
	arcaneSpear_ammo += arcaneSpear_baseammo + additional_attacks
	arcaneSpearAttackTimer.start()

func _on_arcane_spear_attack_timer_timeout():
	if arcaneSpear_ammo > 0:
		var arcaneSpear_attack = arcaneSpear.instantiate()
		arcaneSpear_attack.position = position
		arcaneSpear_attack.target = get_random_target()
		arcaneSpear_attack.level = arcaneSpear_level
		add_child(arcaneSpear_attack) 
		arcaneSpear_ammo -= 1
		if arcaneSpear_ammo > 0:
			arcaneSpearAttackTimer.start()
		else:
			arcaneSpearAttackTimer.stop()

func _on_tornado_timer_timeout():
	tornado_ammo += tornado_baseammo + additional_attacks
	tornadoAttackTimer.start()

func _on_tornado_attack_timer_timeout():
		if tornado_ammo > 0:
			var tornado_attack = tornado.instantiate()
			tornado_attack.position = position
			tornado_attack.last_movement = last_movement
			tornado_attack.level = tornado_level
			add_child(tornado_attack) 
			tornado_ammo -= 1
			if tornado_ammo > 0:
				tornadoAttackTimer.start()
			else:
				tornadoAttackTimer.stop()

func _on_blast_timer_timeout():
	blast_ammo += blast_baseammo 
	blastAttackTimer.start()

func _on_blast_attack_timer_timeout():
		if blast_ammo > 0:
			var blast_attack = blast.instantiate()
			blast_attack.position = position
			blast_attack.last_movement = last_movement
			blast_attack.level = blast_level
			add_child(blast_attack) 
			blast_ammo -= 1
			if blast_ammo > 0:
				blastAttackTimer.start()
			else:
				blastAttackTimer.stop()
				
func _on_nova_timer_timeout():
	nova_ammo = nova_baseammo
	novaAttackTimer.start()

func _on_nova_attack_timer_timeout():
	if nova_ammo > 0:
		var nova_attack = nova.instantiate()
		nova_attack.position = position 
		nova_attack.level = nova_level
		add_child(nova_attack) 
		nova_ammo -= 1
		if nova_ammo > 0:
			novaAttackTimer.start()
		else:
			novaAttackTimer.stop()
		
func spawn_javelin():
	var get_javelin_total = javelinBase.get_child_count()
	var calc_spawns = (javelin_ammo + additional_attacks) - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelinBase.add_child(javelin_spawn)
		calc_spawns -= 1
	#upgrade javelin
	var get_javelin = javelinBase.get_children()
	for i in get_javelin:
		if i.has_method("update_javelin"):
			i.update_javelin()
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP
		
func _on_enemy_detection_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)

func _on_grab_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.grab() 
		calculate_experience(gem_exp)
			
func calculate_experience(gem_exp):
	var exp_required = calculate_experience_cap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required:
		collected_experience -= exp_required - experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experience_cap()
		level_up()
	else:
		experience += collected_experience
		collected_experience = 0
		
	set_expbar(experience, exp_required)

func calculate_experience_cap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap = 65 * (experience_level - 19) * 8
	else:
		exp_cap = 255 * (experience_level - 39) * 12
	return exp_cap

func set_expbar(set_value=1, set_max_value=100):
	expbar.value = set_value
	expbar.max_value = set_max_value

func level_up():
	snd_levelUp.play()
	lvl_label.text = str("Level: ", experience_level)
	var tween = lvlPanel.create_tween()
	tween.tween_property(lvlPanel, "position", Vector2(220, 60), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	lvlPanel.visible = true
	
	var options = 0
	var options_max = 3
	while options < options_max:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_items()
		upgradeOptions.add_child(option_choice)
		options += 1
	
	get_tree().paused = true
	
func upgrade_character(upgrade):
	match upgrade:
		"arcanespear1":
			arcaneSpear_level = 1
			arcaneSpear_baseammo += 1
		"arcanespear2":
			arcaneSpear_level = 2
			arcaneSpear_baseammo += 1
		"arcanespear3":
			arcaneSpear_level = 3
		"arcanespear4":
			arcaneSpear_level = 4
			arcaneSpear_baseammo += 2
		"tornado1":
			tornado_level = 1
			tornado_baseammo += 1
		"tornado2":
			tornado_level = 2
			tornado_baseammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attack_speed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_baseammo += 1
		"blast1":
			blast_level = 1
			blast_baseammo += 1
		"blast2":
			blast_level = 2
		"blast3":
			blast_level = 3
		"blast4":
			blast_level = 4
		"javelin1":
			javelin_level = 1
			javelin_ammo = 1
		"javelin2":
			javelin_level = 2
		"javelin3":
			javelin_level = 3
		"javelin4":
			javelin_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed *= 1.2
		"focus1","focus2","focus3","focus4":
			grabBase.shape.radius *= 1.5
		"tome1","tome2","tome3","tome4":
			spell_size *= 1.1
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.1
		"ring1","ring2":
			additional_attacks += 1
		"nova1":
			nova_level = 1
			nova_baseammo += 1
		"nova2":
			nova_level = 2
		"balm":
			health += 25
			health = clamp(health, 0, maxhp)
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	
	lvlPanel.visible = false
	lvlPanel.position = Vector2(800, 60)
	get_tree().paused = false 
	calculate_experience(0)

func get_random_items():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: 
			pass
		elif i in upgrade_options:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0:
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null
			
func change_time(argtime = 0):
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
	lblTimer.text = str(get_m, ":", get_s)

func adjust_gui_collection(upgrade):
	var get_display_names =  UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type =  UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_display_name = []
		for i in collected_upgrades:
			get_collected_display_name.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_display_names in get_collected_display_name:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon": collectedWeapons.add_child(new_item)
				"upgrade": collectedUpgrades.add_child(new_item)


func _on_button_click_end():
	get_tree().paused = false
	get_tree().change_scene_to_file(menu)
