extends Control

@onready var joystick_background = $JoystickBackground
@onready var joystick_stick = $JoystickBackground/JoystickStick

var joystick_active = false
var joystick_center = Vector2.ZERO
var joystick_vector = Vector2.ZERO
var max_distance = 50  # Maximum distance the stick can move from the center

func _ready():
	joystick_center = joystick_background.position + joystick_background.size / 2

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if joystick_background.get_global_rect().has_point(event.position):
				joystick_active = true
		else:
			joystick_active = false
			joystick_stick.position = joystick_background.size / 2
			joystick_vector = Vector2.ZERO

	if event is InputEventScreenDrag and joystick_active:
		var distance = event.position - joystick_center
		if distance.length() <= max_distance:
			joystick_stick.position = distance + joystick_background.size / 2
		else:
			joystick_stick.position = distance.normalized() * max_distance + joystick_background.size / 2
		
		joystick_vector = (joystick_stick.position - joystick_background.size / 2) / max_distance

func get_value():
	return joystick_vector
