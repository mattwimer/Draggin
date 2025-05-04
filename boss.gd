extends "res://enemy.gd"

@export var float_distance: float = 30.0
@export var float_speed: float = 1
var float_tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#health *= 20
	$HP.max_value = health
	$HP.value = health
	gold_value = health
	flip()
	#start_float()
	linear_velocity = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func flip():
	$Sprite2D.flip_h = !$Sprite2D.flip_h

func start_float():
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
	
