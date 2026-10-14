extends Node3D

const NEXT_SCENE = "res://home.tscn"  # ← путь к твоей следующей сцене

var player_inside = false

func _on_area_3d_body_entered(body):
	if body.name == "PlayerCharacter":
		player_inside = true

func _on_area_3d_body_exited(body):
	if body.name == "PlayerCharacter":
		player_inside = false

func _input(event):
	if player_inside and event.is_action_pressed("interact"):
		get_tree().change_scene_to_file(NEXT_SCENE)
