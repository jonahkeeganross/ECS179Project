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
	
	if not _dialogue_open:
		if _text_queue.size() > 0:
			show_dialogue_box()
			display_next_dialogue()
			
	#else:
		
	if Input.is_action_just_released("dialogue_next"):
		if _dialogue_open:
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
	var _cur_text:String = _text_queue.pop_front()
	text.text = _cur_text
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
