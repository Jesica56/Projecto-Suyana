extends Area2D

@export var velocidad = 250

func _process(delta):
	# Se mueve hacia la izquierda (ajusta si el fuego está a la izquierda)
	position.x -= velocidad * delta

func _on_body_entered(body):
	if body.name == "Suyana":
		# Efecto de golpe (puedes reiniciar la escena por ahora para ganar tiempo)
		get_tree().reload_current_scene()
