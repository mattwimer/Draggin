extends Control

#signal pause
signal selection_made(rect: Rect2, mod: String)
@onready var s_box: ColorRect = $SelectionBox
var screen : Viewport
var drag_origin : Vector2
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport()
	global_position = Vector2(0,0)
	


func pause():
	var tree = get_tree()
	paused = !paused
	tree.paused = !tree.paused
	if tree.paused:
		$Fade.color = "6f6f6f"
	else:
		$Fade.color = "white"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()
		#pause.emit()
	
	if event is InputEventMouseButton and not paused:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var rect = Rect2(s_box.global_position,s_box.size)
			if event.is_pressed():
				drag_origin = screen.get_mouse_position()
				s_box.global_position = drag_origin
				s_box.size = Vector2.ZERO
				s_box.visible = true
			else: 
				if !Input.is_action_pressed("ctrl") and !Input.is_action_pressed("shift"):
					selection_made.emit(rect, "NONE")  # Emit the selected area
				elif Input.is_action_pressed("ctrl"):
					selection_made.emit(rect, "CTRL")  # Emit the selected area
				else:
					selection_made.emit(rect, "SHIFT")  # Emit the selected area
				s_box.visible = false
				$TowerHover.visible = false
			
	if event is InputEventMouseMotion and s_box.visible:
		var mouse_pos = screen.get_mouse_position()
		var size = mouse_pos - drag_origin
		s_box.global_position = Vector2(min(drag_origin.x, mouse_pos.x), min(drag_origin.y, mouse_pos.y))
		s_box.size = abs(size)
		$TowerHover.visible = Input.is_action_pressed("ctrl")
		$TowerHover.position = Rect2(s_box.global_position,s_box.size).get_center()
