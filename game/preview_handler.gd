extends Node3D

# Onready
@onready var camera : Camera3D = get_parent()
@onready var env : WorldEnvironment = %Env
# Exports
@export var ray_length = 1000
@export var PREVIEW_SCALE_FACTOR = 200
@export var MAX_FOV = 200
@export var MIN_FOV = 10
@export var FOV_SPEED = 5
@export var DEFAULT_FOV = 75
@export var DEFAULT_PREVIEW_FOV = 50

# Local State
var original_preview_transform = Transform3D()
var preview_object : Node3D = null
var is_previewing = false

func _ready():
	is_previewing = false
	show_instructions(false)

func show_instructions(value):
	get_parent().get_node("Instructions").visible = value
		
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
		
		# Scrolling
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
				camera.fov = min(camera.fov + FOV_SPEED, MAX_FOV)
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
				camera.fov = max(camera.fov - FOV_SPEED, MIN_FOV)

	# Handle Mouse Input
	if event is InputEventMouseButton and event.pressed:
		if is_previewing:
			is_previewing = false
			show_instructions(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			preview_object.global_transform = original_preview_transform
			camera.fov = DEFAULT_FOV
			# env.environment.volumetric_fog_density = 0.0347
		else:
			if event.button_index == 1:
				var object = get_clicked_object()
				if object:
					show_instructions(camera.show_instructions_b)
					is_previewing = true
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					preview_object = object.collider.get_parent()
					original_preview_transform = preview_object.global_transform
					print(original_preview_transform)
					preview_object.global_transform = get_preview_transform()
					camera.fov = DEFAULT_PREVIEW_FOV
					# env.environment.volumetric_fog_density = 0.0347 * 2
