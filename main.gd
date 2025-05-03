extends Node

@export var mob_manager: PackedScene
@export var tower_scene: PackedScene
@export var text_maker: PackedScene
@onready var s_box: Control = $TargetingSystem
var screen
var difficulty
var wave_number



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport()
	$MobPath.position = Vector2(-screen.size.x/2, -screen.size.y/2)
	wave_number = 0
	# Create Mob Spawn Path based on screen size
	var curve = $MobPath.get_curve()
	curve.clear_points()
	curve.add_point(Vector2(0,0))
	curve.add_point(Vector2(screen.size.x,0))
	curve.add_point(Vector2(screen.size.x,screen.size.y))
	curve.add_point(Vector2(0,screen.size.y))
	curve.add_point(Vector2(0,0))


func _new_game() -> void:
	$castle.visible = true
	$TitleScreen.hide()
	$WaveDelay.start()
	wave_number = 1
	difficulty = $TitleScreen/DifficultySelector.selected #0:Easy/1:Normal/2:Hard

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#print(get_viewport().get_mouse_position())

func _on_start_delay_timeout() -> void:
	$MobTimer.start()
	$WaveTimer.start()
	wave_number += 1

func _on_wave_timer_timeout() -> void:
	$MobTimer.stop()
	$UserInterface.wave_finished()

func _on_mob_timer_timeout() -> void:
	#print("Castle is at: ", $castle.global_position)
	#print("Mouse is at: ", get_viewport().get_mouse_position())
	# Create a new instance of the Mob scene.
	var mob = mob_manager.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	#mob.position = mob_spawn_location.position
	mob_spawn_location.position.x -= screen.size.x/2
	if mob_spawn_location.position.x > 0:
		mob.flip()
	mob_spawn_location.position.y -= screen.size.y/2
	mob.place(mob_spawn_location.position)
	mob.health = 2 + difficulty
	mob.aim(Vector2.ZERO)
	
	#var direction = (mob.position.direction_to($castle.global_position)).angle()
	#var velocity = Vector2(randf_range(75.0, 125.0), 0.0)
	#mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)
	move_child(s_box,-1)
	mob.died.connect(_on_gold_change)
	
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
