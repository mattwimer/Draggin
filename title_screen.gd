extends CanvasLayer

# Notifies Root node that the button has been pressed
signal start_game

var descriptions: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_difficulty_selected(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_difficulty_selected(index: int) -> void:
	pass
	#var textbox = $DifficultyDescription
	#match index:
		#0:
			#textbox.text = "Slower enemies, less precision required. 0.5x Score multiplier."
		#1:
			#textbox.text = "The intended way to play Draggin. 1x Score multiplier."
		#2:
			#textbox.text = "A true challenge. Tougher enemies, and no delay between waves. 2x Score multiplier"


func _on_play_button_pressed() -> void:
	#$PlayButton.hide()
	start_game.emit()
