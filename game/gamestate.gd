extends Node

@export var mushroom_models : Array[PackedScene] = []
@export var cap_materials : Array[BaseMaterial3D] = []
@export var rim_materials : Array[BaseMaterial3D] = []
@export var gill_materials : Array[BaseMaterial3D] = []
@export var stem_materials : Array[BaseMaterial3D] = []

@onready var mushrooms = []
@onready var level = 0
@onready var found_mushrooms = 0

var mushrooms_by_level = [
	1,
	2,
	3,
	3,
	4,
	4,
	5,
	5,
	5,
	5
]

var extra_by_level = [
	3,
	3,
	3,
	3,
	3,
	3
]

func attempt_collect_mushroom(collected_mushroom):
	if collected_mushroom in mushrooms:
		print("YES")
	else:
		print("NO")
	
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
		
	
