extends Control

func _ready():
	# Buscamos cualquier botón que sea hijo de este menú
	for hijo in get_children():
		if hijo is Button:
			hijo.pressed.connect(_on_play_pressed)
			print("Botón encontrado y conectado: ", hijo.name)

func _on_play_pressed():
	# CAMBIA esto por el nombre exacto de tu escena de juego
	# Si tu escena se llama Mundo.tscn, déjalo así. 
	# Si se llama Escena1.tscn, cámbialo.
	get_tree().change_scene_to_file("res://Mundo.tscn")
