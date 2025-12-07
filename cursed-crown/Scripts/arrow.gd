extends Area2D

@export var speed: float = 400.0
@export var damage: int = 40
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	rotation = direction.angle()
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	# 忽略玩家，避免误伤
	if body is Player:
		return

	# 对敌人造成伤害
	if body.has_method("take_damage"):
		body.take_damage(damage)

	# 碰到任何物体（敌人、墙壁等）都销毁箭矢
	queue_free()
