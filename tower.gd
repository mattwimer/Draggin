extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $AttackPause.is_stopped(): #Ready to fire
		if $Range.has_overlapping_bodies():
			var targets = $Range.get_overlapping_bodies()
			targets[0].damage(1)
			$AttackPause.start()
			$Range.color = Color(1,0,0,0.4)
		else:
			$Range.color = Color(1,1,1,0.4)
	else:
		$Range.color = Color(1,0,0,0.4)
