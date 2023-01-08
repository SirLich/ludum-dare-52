extends Node3D

@export var previewScene : PackedScene

func _ready():
	Gamestate.level = 0
	%Credits.visible = false
	%Instructions.visible = true
		
func _on_button_pressed():
	get_tree().change_scene_to_packed(previewScene)


var credits_shown = false
func _on_credits_button_pressed():

	var credits = %Credits
	var instructions = %Instructions
	var butt = %CreditsButton
	
	if credits_shown:
		credits_shown = false
		butt.text = "View Credits"
		instructions.visible = true
		credits.visible = false
	else:
		credits_shown = true
		butt.text = "View Instructions"
		instructions.visible = false
		credits.visible = true
	
