extends Area2D

export var speed = 10
export var damage = 30
var direction = Vector2()
var parent

func _physics_process(delta):
	position += direction * speed

func _on_Bullet_body_entered(body):
	set_physics_process(false)
	if body.is_in_group('enemies'):
		body.receive_damage(damage, (body.global_position - self.global_position).normalized(), parent)
	$AnimationPlayer.play("explode")