extends "res://enemy.gd"

@export var lightning: PackedScene
@export var float_distance: float = 30.0
@export var float_speed: float = 1
var float_tween:Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health *= 20
	$HP.max_value = health
	$HP.value = health
	gold_value = health
	#flip()
	start_float()
	linear_velocity = Vector2.ZERO
	$ZapTimer.start()

signal boss_health_changed(new_value:int)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.flip_h = position.x > Vector2.ZERO.x

func flip():
	$Sprite2D.flip_h = !$Sprite2D.flip_h

func start_float():
	#Squash towers
	for tower in $DestructionZone.get_overlapping_bodies():
		tower.queue_free()
	#Start tween
	float_tween = create_tween()
	float_tween.set_loops()  # Infinite loop
	float_tween.tween_property(self, "position", position + Vector2(0, -float_distance), float_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	float_tween.tween_property(self, "position", position, float_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
func stop_float():
	float_tween.kill()
	
func reposition(pos:Vector2):
	stop_float()
	var move_tween = create_tween()
	move_tween.tween_property(self, "position", pos, 0.4)
	move_tween.tween_callback(start_float)
	
func find_new_position():
	var new_pos:Vector2 = position
	while new_pos == position:
		var c_x = randi_range(1,2) == 1
		var c_y = randi_range(1,2) == 1
		if c_x:
			new_pos.x *= -1
		if c_y:
			new_pos.y *= -1
	return new_pos

func targeted(rect: Rect2):
	if rect.has_point(global_position):
		$HP.value -= 1
		health -= 1
		boss_health_changed.emit(health)
		if $HP.value <= 0:
			died.emit()
			queue_free()
		elif health % 10 == 0:
			reposition(find_new_position())
			
func damage(amount: int):
	if float_tween.is_running():
		$HP.value -= amount
		health -= amount
		boss_health_changed.emit(health)
		if $HP.value <= 0:
				died.emit()
				queue_free()
		else:
			reposition(find_new_position())

signal zap(lightning, target)

func _on_zap_timer_timeout() -> void:
	var towers = get_tree().get_nodes_in_group("towers")
	if towers.size() >= 1:
		var tower = towers[randi_range(0,towers.size()-1)]
		if is_instance_valid(tower):
			var bolt = lightning.instantiate()
			#print("I placed a bolt at (%d, %d)" % [tower.position.x, tower.position.y])
			zap.emit(bolt, tower)
			#tower.queue_free()
