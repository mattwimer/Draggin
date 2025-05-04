extends "res://enemy.gd"

var partner: Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func aim(pos:Vector2, min_speed:int = 75, max_speed:int = 125):
	super.aim(pos, 100,100)

func assign_partner(pal:Enemy):
	self.partner = pal
	
 
func targeted(rect: Rect2):
	var pair_condition = !rect.has_point(partner.global_position) if is_instance_valid(self.partner) else true
	if rect.has_point(global_position) and pair_condition:
		$HP.value -= 1
		if $HP.value <= 0:
			died.emit(gold_value)
			queue_free()
