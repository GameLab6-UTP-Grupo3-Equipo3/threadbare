extends Area2D

# Cargamos el recurso de tus diálogos de trauma
const RECURSO_DIALOGO = preload("res://scenes/quests/story_quests/en_la_prondidad/3_sequence_puzzle/componentes/en_la_prondidad_sequence_puzzle.dialogue")

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		# 1. Desactivamos el objeto inmediatamente para evitar bugs
		set_deferred("monitoring", false)
		visible = false
		
		# 2. CONGELAR AL JUGADOR
		body.take_control(self)
		
		# CORRECCIÓN: Definimos estáticamente el tipo ': AnimatedSprite2D' para evitar el Warning
		var sprite_animado: AnimatedSprite2D = null
		
		if body.has_node("PlayerSprite"):
			sprite_animado = body.get_node("PlayerSprite") as AnimatedSprite2D
		elif body.has_node("%PlayerSprite"):
			sprite_animado = body.get_node("%PlayerSprite") as AnimatedSprite2D
		
		if sprite_animado and sprite_animado.has_method("play"):
			sprite_animado.play(&"idle") # Forzamos que se quede quieto visualmente
		
		# 3. LANZAR EL DIÁLOGO CON EL DISEÑO DEL JUEGO
		if DialogueManager:
			DialogueManager.show_dialogue_balloon(RECURSO_DIALOGO, "objeto_1_recogido", [body])
			# Esperamos a que el jugador termine de leer
			await DialogueManager.dialogue_ended
		
		# 4. DEVOLVER EL CONTROL AL JUGADOR
		body.return_control(self)
		
		# 5. REGISTRAR EL OBJETO EN LA PUERTA Y DESTRUIR
		var nodos_puerta = get_tree().get_nodes_in_group("puerta_principal")
		if nodos_puerta.size() > 0:
			var la_puerta = nodos_puerta[0]
			if la_puerta.has_method("registrar_objeto"):
				la_puerta.registrar_objeto()
		
		queue_free()
