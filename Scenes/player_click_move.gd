extends CharacterBody3D

@onready var agent = $NavigationAgent3D
var target_position: Vector3 = Vector3.ZERO
var path_markers: Array[Node3D] = []

func _ready():
	print("Player ready. Agent = ", agent)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		print("Right click detected at screen pos: ", event.position)

		var camera = get_viewport().get_camera_3d()
		if camera == null:
			print("ERROR: No camera found!")
			return

		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))

		if result:
			target_position = result.position
			print("Ray hit at: ", target_position)

			agent.target_position = target_position
			print("Agent target set. Path points: ", agent.get_current_navigation_path().size())

			_show_path(agent.get_current_navigation_path())
		else:
			print("Ray missed - nothing hit.")

func _physics_process(delta):
	if agent.is_navigation_finished():
		if velocity.length() > 0:
			print("Reached destination, stopping.")
		velocity = Vector3.ZERO
		move_and_slide()
		return

	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	velocity = direction * 5.0
	move_and_slide()
	print("Moving towards: ", next_point, " | Velocity: ", velocity)

func _show_path(path: PackedVector3Array):
	print("Drawing path with ", path.size(), " points.")

	# Clear old markers
	for m in path_markers:
		m.queue_free()
	path_markers.clear()

	# Draw new markers
	for p in path:
		var marker = MeshInstance3D.new()
		marker.mesh = SphereMesh.new()
		marker.scale = Vector3(0.1, 0.1, 0.1)
		marker.translation = p
		get_tree().current_scene.add_child(marker)
		path_markers.append(marker)
		print("Marker placed at: ", p)
