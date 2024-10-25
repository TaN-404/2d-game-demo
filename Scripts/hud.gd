extends CanvasLayer

signal start_game

@onready var joystick = $Joystick

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_joystick()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	hide_joystick()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	show_joystick()
	start_game.emit()

# Add these new functions to manage joystick visibility
func show_joystick():
	if joystick:
		joystick.show()

func hide_joystick():
	if joystick:
		joystick.hide()

func _on_message_timer_timeout() -> void:
	$Message.hide()
