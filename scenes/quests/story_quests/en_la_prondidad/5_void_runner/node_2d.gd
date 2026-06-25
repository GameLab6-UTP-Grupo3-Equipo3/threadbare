extends Node2D

@export var animacion: AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animacion.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
