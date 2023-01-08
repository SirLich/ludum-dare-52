extends Node3D

func _ready():
	Gamestate.place_mushrooms(true)
	%ScoreAsText.text = str(Gamestate.found_mushrooms)  + "/" + str(Gamestate.num_mushrooms_to_find())
