extends RigidBody2D

@export var health = 3
var target

#TODO:
#Enemies that jump around when damaged
#Enemies that spawn in pairs and can't be damaged together
#Enemies with more health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite.play("walk")
	$HP.max_value = health
	$HP.value = health
	#self.linear_velocity *= 2

signal died(gold: int)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func place(pos: Vector2):
	self.position = pos

func aim(pos: Vector2, min_speed:int = 75, max_speed:int = 125):
	target = pos
	var direction = (self.position.direction_to(pos)).angle()
	var velocity = Vector2(randf_range(min_speed, max_speed), 0.0)

	self.linear_velocity = velocity.rotated(direction)

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
