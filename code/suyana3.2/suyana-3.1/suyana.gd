extends CharacterBody2D

# --- AJUSTES DE MOVIMIENTO ---
var puede_moverse : bool = true
const SPEED = 250.0 
const JUMP_VELOCITY = -400.0

# Obtenemos la gravedad del sistema
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Usamos @onready para conectar con el nodo. 
# IMPORTANTE: Asegúrate de que el nodo se llame AnimatedSprite2D en tu escena.
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	# 1. APLICAR GRAVEDAD (Siempre ocurre para que no flote)
	if not is_on_floor():
		velocity.y += gravity * delta

	# REVISAR SI PUEDE ACTUAR
	if puede_moverse:
		# 2. MANEJAR EL SALTO
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# 3. OBTENER DIRECCIÓN
		var direction = Input.get_axis("ui_left", "ui_right")
		
		# 4. LÓGICA DE MOVIMIENTO Y ANIMACIÓN
		if direction != 0:
			velocity.x = direction * SPEED
			if anim:
				anim.play("caminar")
				anim.flip_h = direction < 0 # Simplificado: true si va a la izquierda
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if anim:
				anim.play("quieto")
	else:
		# SI NO PUEDE MOVERSE: Frenamos en seco y ponemos animación quieta
		velocity.x = 0
		if anim:
			anim.play("quieto")

	# 5. EJECUTAR EL MOVIMIENTO FÍSICO (Siempre al final)
	move_and_slide()
