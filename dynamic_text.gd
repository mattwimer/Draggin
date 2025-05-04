extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_value(text: String, travel: Vector2, duration):
	self.text = text
	var tween = create_tween()
	tween.tween_property(self, "position", position + travel, duration)
	tween.parallel().tween_property(self, "modulate:a8", 0, duration)
	tween.tween_callback(queue_free)
