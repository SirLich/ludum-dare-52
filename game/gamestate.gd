extends Node

@export var mushroom_models : Array[PackedScene] = []
@export var cap_materials : Array[BaseMaterial3D] = []

var mushrooms = []
var level = 0


var mushrooms_by_level = [
	3,
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

func generate_random_mushroom():
	var proto : PackedScene = mushroom_models.pick_random()
	var instance = proto.instantiate()
	
	var mesh : MeshInstance3D = instance.find_child("Plane")
	mesh.set_surface_override_material(0, cap_materials.pick_random())
	return instance
	
func generate_mushrooms():
	mushrooms = []
	for i in range(mushrooms_by_level[level]):
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
		
	