extends Area2D

export var speed = 7
export var damage = 30
var direction = Vector2()
var parent = null

func _physics_process(delta):
	position += direction * speed

func _on_EnemyBullet_body_entered(body):
	if body != parent:
		if body.is_in_group('player') or body.is_in_group('enemies'):
			body.receive_damage(damage, (body.global_position - self.global_position).normalized(), parent)
		queue_free()
