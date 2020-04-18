extends Area2D

export var speed = 10
export var damage = 30
var direction = Vector2()

func _physics_process(delta):
	position += direction * speed

func _on_Bullet_body_entered(body):
	if body.is_in_group('enemies'):
		body.recieve_damage(damage, (body.global_position - self.global_position).normalized())
	queue_free()