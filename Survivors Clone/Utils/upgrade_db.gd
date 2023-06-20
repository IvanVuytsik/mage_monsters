extends Node


const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"
  
const UPGRADES = {
	"arcanespear1" : {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Arcane Spear",
		"details": "A magic spear is thrown at enemies",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"arcanespear2" : {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Arcane Spear",
		"details": "Adds another spear",
		"level": "Level: 2",
		"prerequisite": ["arcanespear1"],
		"type": "weapon"
	},
	"arcanespear3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Arcane Spear",
		"details": "Arcane Spears now pass through another enemy and do + 3 damage",
		"level": "Level: 3",
		"prerequisite": ["arcanespear2"],
		"type": "weapon"
	},
	"arcanespear4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "Additional 2 Arcane Spears are thrown",
		"level": "Level: 4",
		"prerequisite": ["arcanespear3"],
		"type": "weapon"
	},
	"javelin1": {
		"icon": WEAPON_PATH + "energybolt.png",
		"displayname": "Javelin",
		"details": "A magical javelin will follow you attacking enemies in a straight line",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"javelin2": {
		"icon": WEAPON_PATH + "energybolt.png",
		"displayname": "Javelin",
		"details": "The javelin will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prerequisite": ["javelin1"],
		"type": "weapon"
	},
	"javelin3": {
		"icon": WEAPON_PATH + "energybolt.png",
		"displayname": "Javelin",
		"details": "The javelin will attack another additional enemy per attack",
		"level": "Level: 3",
		"prerequisite": ["javelin2"],
		"type": "weapon"
	},
	"javelin4": {
		"icon": WEAPON_PATH + "energybolt.png",
		"displayname": "Javelin",
		"details": "The javelin now does + 5 damage per attack and causes 20% additional knockback",
		"level": "Level: 4",
		"prerequisite": ["javelin3"],
		"type": "weapon"
	},
	"tornado1": {
		"icon": WEAPON_PATH + "crimsonwind.png",
		"displayname": "Tornado",
		"details": "A tornado is created and random heads somewhere in the players direction",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"tornado2": {
		"icon": WEAPON_PATH + "crimsonwind.png",
		"displayname": "Tornado",
		"details": "An additional Tornado is created",
		"level": "Level: 2",
		"prerequisite": ["tornado1"],
		"type": "weapon"
	},
	"tornado3": {
		"icon": WEAPON_PATH + "crimsonwind.png",
		"displayname": "Tornado",
		"details": "The Tornado cooldown is reduced by 0.5 seconds",
		"level": "Level: 3",
		"prerequisite": ["tornado2"],
		"type": "weapon"
	},
	"tornado4": {
		"icon": WEAPON_PATH + "crimsonwind.png",
		"displayname": "Tornado",
		"details": "An additional tornado is created and the knockback is increased by 25%",
		"level": "Level: 4",
		"prerequisite": ["tornado3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "fortitude.png",
		"displayname": "Armor",
		"details": "Reduces Damage by 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "fortitude.png",
		"displayname": "Armor",
		"details": "Reduces Damage by 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "fortitude.png",
		"displayname": "Armor",
		"details": "Reduces Damage by 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "fortitude.png",
		"displayname": "Armor",
		"details": "Reduces Damage by 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "reflex.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 20%",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "reflex.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 20%",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "reflex.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 20%",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "reflex.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 20%",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "educated.png",
		"displayname": "Tome",
		"details": "Increases the size of spells by 10%",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "educated.png",
		"displayname": "Tome",
		"details": "Increases the size of spells by 10%",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "educated.png",
		"displayname": "Tome",
		"details": "Increases the size of spells by 10%",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "educated.png",
		"displayname": "Tome",
		"details": "Increases the size of spells by 10%",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "lore.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by 10%",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "lore.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by 10%",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "lore.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by 10%",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "lore.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by 10%",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "arcanedefence.png",
		"displayname": "Ring",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "arcanedefence.png",
		"displayname": "Ring",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"focus1": {
		"icon": ICON_PATH + "focus.png",
		"displayname": "Focus",
		"details": "Increases collection radius by 50%",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"focus2": {
		"icon": ICON_PATH + "focus.png",
		"displayname": "Focus",
		"details": "Increases collection radius by 50%",
		"level": "Level: 2",
		"prerequisite": ["focus1"],
		"type": "upgrade"
	},
	"focus3": {
		"icon": ICON_PATH + "focus.png",
		"displayname": "Focus",
		"details": "Increases collection radius by 50%",
		"level": "Level: 3",
		"prerequisite": ["focus2"],
		"type": "upgrade"
	},
	"focus4": {
		"icon": ICON_PATH + "focus.png",
		"displayname": "Focus",
		"details": "Increases collection radius by 50%",
		"level": "Level: 4",
		"prerequisite": ["focus3"],
		"type": "upgrade"
	},
	"nova1": {
		"icon": WEAPON_PATH + "frostnova.png",
		"displayname": "Nova",
		"details": "Frost nova dealing light damage and knockback",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"nova2": {
		"icon": WEAPON_PATH + "frostnova.png",
		"displayname": "Nova",
		"details": "Increases damage by 100% and knockback by 50%",
		"level": "Level: 2",
		"prerequisite": ["nova1"],
		"type": "weapon"
	},
	"blast1": {
		"icon": WEAPON_PATH + "fireblast.png",
		"displayname": "Blast",
		"details": "Creates a blast of fire",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"blast2": {
		"icon": WEAPON_PATH + "fireblast.png",
		"displayname": "Blast",
		"details": "Adds 5 to damage and 25% to knockback",
		"level": "Level: 2",
		"prerequisite": ["blast1"],
		"type": "weapon"
	},
	"blast3": {
		"icon": WEAPON_PATH + "fireblast.png",
		"displayname": "Blast",
		"details": "Adds 5 to damage, 25% to knockback and increases size",
		"level": "Level: 3",
		"prerequisite": ["blast2"],
		"type": "weapon"
	},
	"blast4": {
		"icon": WEAPON_PATH + "fireblast.png",
		"displayname": "Blast",
		"details": "Adds 5 to damage, 25% to knockback and increases size",
		"level": "Level: 4",
		"prerequisite": ["blast3"],
		"type": "weapon"
	},
	"balm" : {
		"icon": ICON_PATH + "health1.png",
		"displayname": "Healing balm",
		"details": "Heals 25 health points",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}

func _ready():
	pass  
	
func _process(delta):
	pass
