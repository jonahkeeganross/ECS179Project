extends  Control


@onready var arrow_next = $Background/MarginContainer/Panel/ArrowNext
@onready var text = $Background/MarginContainer/Panel/MarginContainer/Panel/Text
@onready var background = $Background

@export var start_pos:Vector2
@export var shown_pos:Vector2

var pos:Vector2
var time_elapsed:float = 0
var mult = 6
var slow_modif =  0.3 # How slow it should be
var _dialogue_open:bool = false
var _text_queue: Array[String]

# Typewriter effect variables
var _current_text: String = ""
var _display_text: String = ""
var _text_index: int = 0
var _is_typing: bool = false
var _typewriter_speed: float = 0.001 # Time between each character
var _typewriter_timer: float = 0.0

func  _ready() -> void:
	pos = arrow_next.position
	process_mode = Node.PROCESS_MODE_ALWAYS
	background.visible = true
	print("ready_dialgoue")
	#background
	_dialogue_open = false
	BUS.connect("queue_dialogue", Callable(self, "_add_text"))
	background.position = start_pos


func _process(delta: float) -> void:
	time_elapsed += delta
	arrow_next.position.y = pos.y + sin(time_elapsed / slow_modif) * mult

	# Handle typewriter effect
	if _is_typing:
		_typewriter_timer += delta
		if _typewriter_timer >= _typewriter_speed:
			_typewriter_timer = 0.0
			_text_index += 1
			if _text_index <= _current_text.length():
				text.text = _current_text.substr(0, _text_index)
			else:
				_is_typing = false
				arrow_next.visible = true

	if not _dialogue_open:
		if _text_queue.size() > 0:
			show_dialogue_box()
			display_next_dialogue()

	if Input.is_action_just_released("dialogue_next"):
		if _dialogue_open:
			# If still typing, skip to full text
			if _is_typing:
				_is_typing = false
				_text_index = _current_text.length()
				text.text = _current_text
				arrow_next.visible = true
			else:
				# Otherwise, move to next dialogue
				display_next_dialogue()
			print("skipping")
		#display_dialogue()
		


func	 _add_text(queued_text: Array[String]):
	print("adding lines")
	_text_queue.append_array(queued_text)
	



func display_next_dialogue() -> void:
	if _text_queue.size() == 0:
		hide_dialogue_box()
		return

	# Start typewriter effect
	_current_text = _text_queue.pop_front()
	_text_index = 0
	_typewriter_timer = 0.0
	_is_typing = true
	arrow_next.visible = false
	text.text = ""
	print("kk")



	
	
func show_dialogue_box():
	var tween = background.create_tween()
	tween.tween_property(
		background,
		"position",
		shown_pos,
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_dialogue_open = true
	get_tree().paused = true	
	
func hide_dialogue_box():
	print("HIDING")
	var tween = background.create_tween()
	tween.tween_property(
		background,
		"position",
		start_pos,
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_dialogue_open = false
	get_tree().paused = false
