extends Node2D

var target_y: float = 8000 # Y-position to reach (tower position)
var duration: float = 0.2
var enemy

func _ready():
	scale.y = 0.0  # start invisible
	var tween = create_tween()
	print("I'm at (%d, %d), aiming for (y: %d). Max scale = %f" % [position.x, position.y, target_y, abs(position.y - target_y) / $Sprite2D.texture.get_size().y])
	tween.tween_property(self, "scale:y", abs(position.y - target_y) / $Sprite2D.texture.get_size().y, duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_callback(_on_finished)
	print("I existed")

func target(from:Vector2, to):
	position = from
	target_y = to.position.y
	enemy = to
	
func _on_finished():
	enemy.queue_free()
	queue_free()
