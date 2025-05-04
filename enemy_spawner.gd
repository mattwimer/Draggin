extends Node
@export var basic: PackedScene
@export var pair: PackedScene
@export var cluster: PackedScene
@export var brute: PackedScene
var difficulty

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_difficulty(hardness:int):
	difficulty = hardness

#TODO: above 100% spawn chance for higher wave amounts
func spawn_enemy(wave: int, pos:Vector2, target:Vector2):
	var chance = randi_range(1,100)
	if chance < (wave-1) * 8:
		chance = randi_range(1,3)
		if chance == 1:
			return spawn_pair(pos, target)
		if chance == 2:
			return spawn_cluster(pos, target)
		if chance == 3:
			return [spawn_brute(pos, target)]
	else:
		return [spawn_basic(pos, target)]

func spawn_pair(pos:Vector2, target:Vector2):
	var thing1 = pair.instantiate()
	thing1.health += difficulty
	var thing2 = pair.instantiate()
	thing2.health += difficulty
	thing1.assign_partner(thing2)
	thing2.assign_partner(thing1)
	var displacement = pos.direction_to(target) * 50
	thing1.place(pos + displacement.rotated(-TAU/4))
	thing2.place(pos + displacement.rotated(TAU/4))
	thing1.aim(target)
	thing2.aim(target)
	return [thing1, thing2]

func spawn_cluster(pos:Vector2, target:Vector2):
	var bats = randi_range(7,11)
	var mobs = []
	var displace_factor = pos.direction_to(target) * 8
	for n in bats:
		var bat = cluster.instantiate()
		bat.place(pos + displace_factor.rotated(TAU/n) * randi_range(1,7))
		bat.aim(target)
		mobs.append(bat)
	return mobs

func spawn_brute(pos:Vector2, target:Vector2):
	var mob = brute.instantiate()
	mob.health += difficulty - 1
	mob.place(pos)
	mob.aim(target)
	return mob
	
func spawn_basic(pos:Vector2, target:Vector2):
	var mob = basic.instantiate()
	mob.health += difficulty - 1
	mob.place(pos)
	mob.aim(target)
	return mob
	
