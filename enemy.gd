extends RigidBody2D

@export var health = 3

#TODO:
#Enemies that jump around when damaged
#Enemies that spawn in pairs and can't be damaged together
#Enemies with more health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite.play("walk")
	$HP.max_value = health
	$HP.value = health

signal died(gold: int)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func targeted(rect: Rect2):
	if rect.has_point(global_position):
		$HP.value -= 1
		if $HP.value <= 0:
			died.emit($HP.max_value)
			queue_free()
			
func damage(amount: int):
	$HP.value -= amount
	if $HP.value <= 0:
			died.emit($HP.max_value)
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func flip():
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
