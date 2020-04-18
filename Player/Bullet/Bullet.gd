extends Area2D

export var speed = 10
export var damage = 10
var direction = Vector2()

func _physics_process(delta):
	position += direction * speed

func _on_Bullet_body_entered(body):
	if body.is_in_group('enemies'):
		pass
		#body.recieve_damage(damage, linear_velocity.normalized())
	queue_free()