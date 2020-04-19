extends Area2D

var center = 0
var rotation_speed = 3
var radius = 10
var angle = 0
var time_left = 4
var is_blood_soul = false

func _ready():
	center = self.position

func _physics_process(delta):
	angle += rotation_speed * delta
	position = center + Vector2(sin(angle), cos(angle)) * radius
	time_left -= delta
	if !is_blood_soul:
		$Sprite.scale -= Vector2(delta/5.0, delta/5.0)
		$Sprite2.scale = $Sprite.scale
		if time_left <= 0:
			queue_free()

func _on_Soul_body_entered(body):
	if body == get_tree().get_nodes_in_group('player')[0] and body.souls < body.max_souls:
		body.get_soul()
		if is_blood_soul:
			body.has_golden_soul = true
		queue_free()
