extends Node3D

func _ready():
	Gamestate.generate_mushrooms()
	Gamestate.place_mushrooms(true)
