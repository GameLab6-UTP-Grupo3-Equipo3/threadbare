extends Area2D

# Referencia a la puerta para sumarle el punto al recogerlo
@onready var gate: Area2D = $"../Gate"

# Cargamos el recurso de tus diálogos de trauma
const RECURSO_DIALOGO = preload("res://scenes/quests/story_quests/en_la_prondidad/3_sequence_puzzle/componentes/en_la_prondidad_sequence_puzzle.dialogue")

# Propiedades nativas que venían en tu archivo .tscn original
@export var revealed: bool = false
@export var next_scene: String = "uid://bsrxki3uvqybt"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# Al inicio el objeto no es visible ni interactuable hasta que se resuelva el puzzle
	visible = revealed
	monitoring = revealed

# Esta función la llama automáticamente la señal de tu SequencePuzzle cuando se resuelve la melodía
func reveal() -> void:
	revealed = true
	visible = true
	monitoring = true
	print("¡Puzzle musical resuelto! El objeto 2 ha aparecido.")

func _on_body_entered(body: Node) -> void:
	if body is Player and revealed:
		# 1. Desactivamos el objeto inmediatamente para evitar bugs de repetición
		set_deferred("monitoring", false)
		visible = false
		
		# 2. CONGELAR AL JUGADOR
		body.take_control(self)
		
		# Forzamos la animación estática (Idle)
		var sprite_animado: AnimatedSprite2D = null
		if body.has_node("PlayerSprite"):
			sprite_animado = body.get_node("PlayerSprite") as AnimatedSprite2D
		elif body.has_node("%PlayerSprite"):
			sprite_animado = body.get_node("%PlayerSprite") as AnimatedSprite2D
			
		if sprite_animado and sprite_animado.has_method("play"):
			sprite_animado.play(&"idle")
		
		# 3. LANZAR EL DIÁLOGO DEL LORE (FOTO FAMILIAR ROTA)
		if DialogueManager:
			DialogueManager.show_dialogue_balloon(RECURSO_DIALOGO, "objeto_2_recogido", [body])
			# Esperamos a que el jugador termine de leer
			await DialogueManager.dialogue_ended
		
		# 4. DEVOLVER EL CONTROL AL JUGADOR
		body.return_control(self)
		
		# 5. REGISTRAR EL OBJETO EN LA PUERTA Y DESTRUIR
		if gate and gate.has_method("registrar_objeto"):
			gate.registrar_objeto()
		
		queue_free()
