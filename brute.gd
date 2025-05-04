extends "res://enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.health *= 2
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func aim(pos: Vector2, min_speed:int = 75, max_speed:int = 125):
	super.aim(pos, 75, 75)
