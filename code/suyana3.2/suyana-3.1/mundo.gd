extends Node2D

# Asegúrate de que la ruta a tu escena de bola de fuego sea la correcta
var bola_escena = preload("res://BolaFuego.tscn")

func _on_trigger_fuego_body_entered(body):
	if body.name == "Suyana":
		# Solo disparamos si el FuegoErrante todavía existe
		if has_node("FuegoErrante"):
			lanzar_ataque_fuego()

func lanzar_ataque_fuego():
	for i in range(3): 
		if not has_node("FuegoErrante"): return # Si el fuego ya se apagó, deja de disparar
		
		var bola = bola_escena.instantiate()
		# Usamos $FuegoErrante si es hijo directo de Mundo
		bola.global_position = $FuegoErrante.global_position
		add_child(bola)
		
		# Espera medio segundo antes de la siguiente bola
		await get_tree().create_timer(0.5).timeout
