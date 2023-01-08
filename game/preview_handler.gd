extends Node3D

# Onready
@onready var camera : Camera3D = get_parent()
@onready var env : WorldEnvironment = %Env
# Exports
@export var ray_length = 1000
@export var PREVIEW_SCALE_FACTOR = 200

# Local State
var original_preview_transform = Transform3D()
var preview_object : Node3D = null
var is_previewing = false

func _ready():
	is_previewing = false
	%MoveInstructions.visible = true
	%Tut0.visible = true
	show_instructions(false)

func show_instructions(is_previewing):
	if is_previewing:
		if camera.is_main_world:
			%Tut0.visible = true
			%Tut1.visible = false
			%Tut2.visible = false
		else:
			%Tut0.visible = false
			%Tut1.visible = false
			%Tut2.visible = true
	else:
		if camera.is_main_world:
			%Tut0.visible = false
			%Tut1.visible = false
			%Tut2.visible = false
		else:
			%Tut0.visible = false
			%Tut1.visible = true
			%Tut2.visible = false
	
		
	
func _process(delta):
	pass

func get_preview_transform():
	return self.get_global_transform()

func get_clicked_object():
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	return space.intersect_ray(ray_query)

func _input(event):
	# Handle Mouse Scrolling and other preview effects
	if is_previewing:
		
		# Moving
		if event is InputEventMouseMotion:
			preview_object.rotate_z(-event.relative.y / PREVIEW_SCALE_FACTOR)
			preview_object.rotate_y(event.relative.x / PREVIEW_SCALE_FACTOR)

	# Handle Mouse Input
	if event is InputEventMouseButton and event.pressed:
		if is_previewing:
			# Collection Results:
			if event.button_index == 1: # Left Click
				preview_object.global_transform = original_preview_transform
				
			elif event.button_index == 2 and camera.is_main_world: # Right Click
				Gamestate.attempt_collect_mushroom(preview_object)
				preview_object.queue_free()
			
			# Reset Data
			if preview_object:
				preview_object.global_transform = original_preview_transform
				
			is_previewing = false
			show_instructions(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		else:
			if event.button_index == 1:
				var object = get_clicked_object()
				if object:
					Gamestate.play_sound_button()
					show_instructions(true)
					is_previewing = true
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					preview_object = object.collider.get_parent()
					original_preview_transform = preview_object.global_transform
					print(original_preview_transform)
					preview_object.global_transform = get_preview_transform()
