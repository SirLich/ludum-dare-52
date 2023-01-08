extends Node3D

func _ready():
	Gamestate.generate_mushrooms()
	Gamestate.place_mushrooms(true)
	Gamestate.start_new_round()
