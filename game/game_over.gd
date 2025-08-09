extends Node3D

@export var main_menu_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	%CollectScoreLabel.text = str(Gamestate.total_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Gamestate.restart_everything()
	get_tree().change_scene_to_packed(main_menu_scene)
