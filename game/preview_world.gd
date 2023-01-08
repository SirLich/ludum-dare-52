extends Node3D

@export var playScene : PackedScene

func _ready():
	Gamestate.generate_mushrooms()
	Gamestate.place_mushrooms(false)


func _on_button_pressed():
	get_tree().change_scene_to_packed(playScene)
