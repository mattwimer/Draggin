extends Node2D

signal hit
@export var oscillation_distance = 10
var sphere_pos
var screen_size # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	#global_position = screen_size * 0.5
	sphere_pos = $MagicSource.position
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var oscillation = Vector2.ZERO
	$MagicSource.rotate(TAU*delta)
	oscillation.x += oscillation_distance * cos($MagicSource.rotation)
	oscillation.y += oscillation_distance * sin($MagicSource.rotation)
	$MagicSource.position = sphere_pos + oscillation
	


func _on_body_entered(_body: Node) -> void:
	print(_body.name)
	hide()
	hit.emit()
	#print("ayo?")
