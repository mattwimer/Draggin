extends Area2D

@onready var shape = $Area.shape as CircleShape2D
@export var color : Color

func _ready():
	
	var texture_size = $VisibleRange.texture.get_size()
	# based on diameter (2 * radius)
	$VisibleRange.scale = Vector2.ONE * (($Area.shape.radius * 2.0) / texture_size.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$VisibleRange.modulate = color
