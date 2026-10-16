extends Node3D

const NEXT_SCENE = "res://home.tscn"

# Ссылка на Label с текстом
@onready var prompt_label: Label = $"../CanvasLayer/open_door_ntf"

var player_inside = false

func _ready():
	# Скрываем текст при старте
	prompt_label.visible = false

func _on_area_3d_body_entered(body):
	if body.name == "PlayerCharacter":
		player_inside = true
		prompt_label.visible = true 

func _on_area_3d_body_exited(body):
	if body.name == "PlayerCharacter":
		player_inside = false
		prompt_label.visible = false

func _input(event):
	if player_inside and event.is_action_pressed("interact"):
		SceneTransition.change_scene(NEXT_SCENE)
