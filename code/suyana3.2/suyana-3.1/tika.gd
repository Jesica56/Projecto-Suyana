extends Sprite2D

@export var objetivo: CharacterBody2D
@export var suavizado: float = 0.05
@export var distancia_seguimiento: Vector2 = Vector2(40, -40)

var puede_seguir: bool = false 

func _ready():
	global_position = Vector2(824, 317)

func _physics_process(_delta):
	if puede_seguir and objetivo:
		var posicion_deseada = objetivo.global_position + distancia_seguimiento
		global_position = global_position.lerp(posicion_deseada, suavizado)
		
		# LÓGICA DE GIRO PROFESIONAL:
		# Si la distancia en X es positiva, Suyana está a la derecha.
		# Ajustamos el flip_h según la posición relativa.
		if global_position.x < objetivo.global_position.x:
			flip_h = false # Mira a la derecha
		else:
			flip_h = true  # Mira a la izquierda
			
func animacion_rocio():
	var tween = create_tween()
	# Tika vuela a la grieta (ajusta estas coordenadas a tu mapa)
	tween.tween_property(self, "global_position", Vector2(400, 200), 1.0).set_trans(Tween.TRANS_SINE)
	
	# Al llegar, aparece el cuenco
	tween.tween_callback(func(): $Cuenco.show())
	
	# Vuelve con Suyana
	tween.tween_property(self, "global_position", objetivo.global_position + distancia_seguimiento, 1.0)
	
	# Al llegar a Suyana, se lo entrega (desaparece el cuenco de Tika)
	tween.tween_callback(func(): $Cuenco.hide())


func _on_trigger_fuego_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
