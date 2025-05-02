extends CanvasLayer

@export var gold = 0
@export var tower_cost = 30
var wave_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_gold(0)
	change_tower_cost(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !wave_active:
		var new_alpha = cycle_alpha(delta)
		var color = $WaveTip.modulate
		color.a = new_alpha / 255.0  # Convert 0–255 to 0.0–1.0
		$WaveTip.modulate = color
		$TowerTip.visible = gold >= tower_cost 
	else:
		$Announcements.visible = false
		$WaveTip.visible = false
		$TowerTip.visible = false

var alpha: float = 255
var fading_out: bool = true  # True when decreasing alpha

func cycle_alpha(delta: float, speed: float = 175.0) -> float:
	var min_alpha = 90.0
	var max_alpha = 255.0

	if fading_out:
		alpha -= delta * speed
		if alpha <= min_alpha:
			alpha = min_alpha
			fading_out = false
	else:
		alpha += delta * speed
		if alpha >= max_alpha:
			alpha = max_alpha
			fading_out = true
	return alpha


func wave_finished():
	wave_active = false
	$Announcements.visible = true
	$WaveTip.visible = true

func change_gold(gold: int):
	self.gold += gold
	$Gold.text = "Gold: %d" % self.gold

func change_tower_cost(inc: int):
	self.tower_cost += inc
	$TowerCost.text = "Tower: %d" % self.tower_cost
