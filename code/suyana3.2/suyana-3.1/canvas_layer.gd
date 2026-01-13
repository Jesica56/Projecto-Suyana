extends CanvasLayer

@onready var label = $Panel/RichTextLabel
@onready var panel = $Panel
@onready var flecha_indicador = $Panel/FlechaIndicador

# Referencias a los personajes
@onready var tika = get_parent().get_node_or_null("Tika")
@onready var suyana = get_parent().get_node_or_null("Suyana")

var dialogo_index = 0
var guion = [
	"SUYANA: (Débil) El aire... pesa. Mis raíces no encuentran el agua. ¿Dónde está el latido?",
	"TIKA: ¡Se lo llevaron! ¡Volaron las cenizas y se llevaron el brillo! El Silencio tiene el Ámbar, Suyana.",
	"TIKA: ¡El bosque se queda mudo!",
	"SUYANA: No hay tiempo para el miedo, Tika. Si el corazón del bosque no regresa, la tierra se volverá piedra para siempre."
]

func _ready():
	panel.hide()
	flecha_indicador.hide()
	
	# 1. Tika entra volando a la posición exacta que pediste (824, 317)
	if tika:
		tika.modulate.a = 0 # Empieza invisible
		var posicion_final = Vector2(824, 317) 
		
		var tween_tika = create_tween().set_parallel(true)
		tween_tika.tween_property(tika, "position", posicion_final, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween_tika.tween_property(tika, "modulate:a", 1.0, 1.0)
		
		await tween_tika.finished
		
		# Efecto de flotado infinito para Tika en esa posición inicial
		var tween_float = create_tween().set_loops()
		tween_float.tween_property(tika, "position:y", posicion_final.y - 5, 0.8)
		tween_float.tween_property(tika, "position:y", posicion_final.y + 5, 0.8)
	
	# 2. Iniciar el diálogo
	iniciar_dialogo()

func iniciar_dialogo():
	panel.show()
	dialogo_index = 0
	mostrar_texto()

func mostrar_texto():
	if dialogo_index < guion.size():
		flecha_indicador.hide()
		label.text = guion[dialogo_index]
		label.visible_ratio = 0
		
		var tween = create_tween()
		var duracion = 2.0 if "SUYANA" in guion[dialogo_index] else 1.0
		tween.tween_property(label, "visible_ratio", 1.0, duracion)
		
		tween.finished.connect(func():
			flecha_indicador.show()
			parpadear_flecha()
		)
	else:
		panel.hide()
		flecha_indicador.hide()
		
		# Activar movimiento de Suyana
		if suyana:
			suyana.set_physics_process(true)
		
		# ¡CLAVE!: Aquí activamos que Tika empiece a seguirla
		if tika and "puede_seguir" in tika:
			tika.puede_seguir = true
		
		# Si tienes la Escena 2, descomenta la línea de abajo
		# get_tree().change_scene_to_file("res://Escena2.tscn")

func parpadear_flecha():
	var tween_p = create_tween().set_loops()
	tween_p.tween_property(flecha_indicador, "modulate:a", 0.0, 0.6)
	tween_p.tween_property(flecha_indicador, "modulate:a", 1.0, 0.6)
	
func _input(event):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or event.is_action_pressed("ui_accept"):
		if panel.visible:
			if label.visible_ratio < 1.0:
				label.visible_ratio = 1.0
			else:
				dialogo_index += 1
				mostrar_texto()
