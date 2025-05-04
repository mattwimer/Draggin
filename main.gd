extends Node

@export var mob_manager: PackedScene
@export var tower_scene: PackedScene
@export var text_maker: PackedScene
@export var boss_mob: PackedScene
@onready var s_box: Control = $TargetingSystem
var screen
var difficulty
var wave_number
var mom


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport()
	$MobPath.position = Vector2(-screen.size.x/2, -screen.size.y/2)
	wave_number = 0
	# Create Mob Spawn Path based on screen size
	var curve = $MobPath.get_curve()
	#$Boss.place(Vector2(screen.size.x/2 - 200, -screen.size.y/2 + 200))
	#$Boss.start_float()
	curve.clear_points()
	curve.add_point(Vector2(0,0))
	curve.add_point(Vector2(screen.size.x,0))
	curve.add_point(Vector2(screen.size.x,screen.size.y))
	curve.add_point(Vector2(0,screen.size.y))
	curve.add_point(Vector2(0,0))
	mom = mob_manager.instantiate()


func _new_game() -> void:
	$castle.visible = true
	$TitleScreen.hide()
	$WaveDelay.start()
	wave_number = 1
	difficulty = $TitleScreen/DifficultySelector.selected #0:Easy/1:Normal/2:Hard
	mom.set_difficulty(difficulty)
	
func castle_hit():
	var new_text = text_maker.instantiate()
	add_child(new_text)
	new_text.position = Vector2.ZERO
	new_text.show_value("Game Over", Vector2(0,-160), 4)
	var tree = get_tree()
	$WaveDelay.stop()
	$WaveTimer.stop()
	$MobTimer.stop()
	$BossBar.hide()
	$UserInterface.change_gold(-$UserInterface.gold)
	for enemy in tree.get_nodes_in_group("enemies"):
		enemy.queue_free()
	for tower in tree.get_nodes_in_group("towers"):
		tower.queue_free()
	$RestartTimer.start()
	
func game_over() -> void:
	$TitleScreen.show()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#print($Boss.health)
	#print(get_viewport().get_mouse_position())

func _on_start_delay_timeout() -> void:
	wave_number += 1
	if wave_number % 5 == 0:
		boss_wave()
	else:
		$MobTimer.start()
		$WaveTimer.start()

func boss_wave() -> void:
	var boss = boss_mob.instantiate()
	boss.place(Vector2(screen.size.x/2 - 200, -screen.size.y/2 + 200))
	$MobTimer.start()
	add_child(boss)
	move_child(boss, -1)
	boss.died.connect(_on_wave_timer_timeout)
	boss.boss_health_changed.connect(_on_update_boss_bar)
	boss.zap.connect(_on_zap)
	$BossBar.max_value = boss.health
	$BossBar.value = boss.health
	$BossBar.show()

func _on_update_boss_bar(new_val:int):
	$BossBar.value = new_val

func _on_zap(lightning, t):
	lightning.target(Vector2(t.position.x,-screen.size.y/2), t)
	add_child(lightning)
	print("Added the lightning bolt. Position was (%d, %d)" % [lightning.position.x, lightning.position.y])

func _on_wave_timer_timeout() -> void:
	$MobTimer.stop()
	$UserInterface.wave_finished()
	$BossBar.hide()

func _on_mob_timer_timeout() -> void:
	#print("Castle is at: ", $castle.global_position)
	#print("Mouse is at: ", get_viewport().get_mouse_position())
	# Create a new instance of the Mob scene.
	#var mom = mob_manager.instantiate()
	var overflow_chance = 1 if randi_range(1,10) < (wave_number-5) % 10 else 0
	var overflow:int = (wave_number-5) / 10
	var n = 1 + overflow_chance + overflow
	for a in n:
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		#mob.position = mob_spawn_location.position
		mob_spawn_location.position.x -= screen.size.x/2
		mob_spawn_location.position.y -= screen.size.y/2
			#mob.health = 2 + difficulty
		#mob.place(mob_spawn_location.position)
		#mob.aim(Vector2.ZERO)
		var mobs = mom.spawn_enemy(wave_number, mob_spawn_location.position, Vector2.ZERO)
		
		for mob in mobs:
			if mob.position.x > 0:
				mob.flip()
			add_child(mob)
			move_child(s_box,-1)
			mob.died.connect(_on_gold_change)
		
	#var direction = (mob.position.direction_to($castle.global_position)).angle()
	#var velocity = Vector2(randf_range(75.0, 125.0), 0.0)
	#mob.linear_velocity = velocity.rotated(direction)
	
func _on_gold_change(gold: int):
	$UserInterface.change_gold(gold)

func _on_targeting_system_selection_made(rect: Rect2, mod: String) -> void:
	#print(get_tree().get_nodes_in_group("enemies"))
	var tree = get_tree()
	if $WaveDelay.is_stopped() and tree.get_nodes_in_group("enemies").is_empty():
		if rect.has_point(Vector2(screen.size.x/2, screen.size.y/2)):
			$UserInterface.wave_active = true
			$WaveDelay.start()
	tree.call_group("enemies","targeted", rect)
	#print(mod)
	var ui = $UserInterface
	#print(rect)
	if mod == "CTRL":
		var pos = rect.get_center()
		pos.x -= screen.size.x/2
		pos.y -= screen.size.y/2
		if ui.gold >= ui.tower_cost:
			#Spawn the tower
			var tower = tower_scene.instantiate()
			tower.position = pos
			add_child(tower)
			ui.change_gold(-ui.tower_cost)
		else:
			#Error Message
			var new_text = text_maker.instantiate()
			add_child(new_text)
			new_text.position = pos
			new_text.show_value("Not enough gold", Vector2(0,-80), 2)
			
	elif mod == "SHIFT":
		pass #Do something else maybe
