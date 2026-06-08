# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
extends StaticBody2D

@export var tile_size := 64

var moving := false

@warning_ignore("untyped_declaration")
func push(direction: Vector2):

	if moving:
		return

	$RayCast2D.target_position = direction * tile_size
	$RayCast2D.force_raycast_update()

	if $RayCast2D.is_colliding():
		return

	moving = true

	@warning_ignore("untyped_declaration")
	var tween = create_tween()

	tween.tween_property(
		self,
		"global_position",
		global_position + direction * tile_size,
		0.15
	)

	await tween.finished

	moving = false
