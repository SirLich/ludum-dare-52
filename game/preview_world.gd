extends Node3D

@export var playScene : PackedScene

func _ready():
	Gamestate.generate_mushrooms()
	Gamestate.place_mushrooms(false)
	%LevelsToPlay.text = str(Gamestate.level) + "/" + str(Gamestate.total_levels)

func _on_button_pressed():
	get_tree().change_scene_to_packed(playScene)
