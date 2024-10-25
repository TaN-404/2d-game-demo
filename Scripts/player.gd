extends Area2D

signal hit

@export var speed = 400
var screen_size
var joystick

func _ready() -> void:
	screen_size = get_viewport_rect().size
	var hud = get_node("/root/Main/HUD")  # Adjust this path to match your scene structure
	if hud:
		joystick = hud.get_node("Joystick")
	if not joystick:
		print("Joystick not found!")

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if DisplayServer.is_touchscreen_available() and joystick:
		velocity = joystick.get_value() * speed
	else:
		# Use keyboard input on non-touch devices
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		velocity = velocity.normalized() * speed

	if velocity.length() > 0:
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
	
	print("Player position: ", position)  # Debug print

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	set_process(true)  # Enable processing when the game starts

func _on_body_entered(body: Node2D) -> void:
	hide()  # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	set_process(false)  # Disable processing when the game ends
