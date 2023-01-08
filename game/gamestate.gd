extends Node

@export var mushroom_models : Array[PackedScene] = []
@export var cap_materials : Array[BaseMaterial3D] = []
@export var rim_materials : Array[BaseMaterial3D] = []
@export var gill_materials : Array[BaseMaterial3D] = []
@export var stem_materials : Array[BaseMaterial3D] = []
@export var lose_scene : PackedScene
@export var previewScene : PackedScene

@onready var mushrooms = []
@onready var level = 0
@onready var found_mushrooms = 0
@onready var health = 3
@onready var total_score = 0

var random_seed = randi_range(0, 100000)

var mushrooms_by_level = [
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10
]

var total_levels = len(mushrooms_by_level)

var extra_by_level = [
	3,
	4,
	5,
	6,
	7,
	7,
	7,
	10,
	10
]

func start_new_round():
	$HUD.visible = true
	%ScoreAsText.text = str(Gamestate.found_mushrooms)  + "/" + str(Gamestate.num_mushrooms_to_find())
	%LifeAsText.text = str(Gamestate.health)
	
func attempt_collect_mushroom(collected_mushroom):
	if collected_mushroom in mushrooms:
		play_sound_collect()
		found_mushrooms += 1
		total_score += 1
	else:
		play_sound_lose()
		health -= 1
		
	%ScoreAsText.text = str(Gamestate.found_mushrooms)  + "/" + str(Gamestate.num_mushrooms_to_find())
	%LifeAsText.text = str(Gamestate.health)
		
	if health == 0:
		$HUD.visible = false
		health = 3
		get_tree().change_scene_to_packed(lose_scene)
	
	# Win
	if found_mushrooms == num_mushrooms_to_find():
		$HUD.visible = false
		mushrooms = []
		found_mushrooms = 0
		found_mushrooms = 0
		level += 1
		random_seed = randi_range(0, 100000)
		get_tree().change_scene_to_packed(previewScene)
	

func num_mushrooms_to_find():
	return mushrooms_by_level[level]
	
func generate_random_mushroom():
	var proto : PackedScene = mushroom_models.pick_random()
	var instance = proto.instantiate()
	
	var mesh : MeshInstance3D = instance.find_child("Plane")
	mesh.set_surface_override_material(0, cap_materials.pick_random())
	mesh.set_surface_override_material(1, rim_materials.pick_random())
	mesh.set_surface_override_material(2, gill_materials.pick_random())
	mesh.set_surface_override_material(3, stem_materials.pick_random())
		
		
	return instance
	
func generate_mushrooms():
	seed(random_seed) # Reproducable mushroom making xD
	
	mushrooms = []
	for i in range(num_mushrooms_to_find()):
		mushrooms.append(generate_random_mushroom())
	
func place_mushrooms(place_extra):
	var mushroom_locations = get_tree().get_nodes_in_group("mushroom_pos")
	mushroom_locations.shuffle()
	
	var loc_index = 0
	for shroom in mushrooms:
		mushroom_locations[loc_index].add_child(shroom)
		loc_index += 1
		
	if place_extra:
		for i in range(extra_by_level[level]):
			var shroom = generate_random_mushroom()
			mushroom_locations[loc_index].add_child(shroom)
			loc_index += 1
		
	
func play_sound_collect():
	$CollectSound.play()
	
func play_sound_button():
	$ButtonSound.play()
	
func play_sound_lose():
	$LoseSound.play()

func play_sound_win():
	$WinSound.play()
