extends Node

@onready var prompt_label: Label = $"../CanvasLayer/talk_ntf"

var player_inside = false

func _ready() -> void:
	prompt_label.visible = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "PlayerCharacter":
		player_inside = true
		prompt_label.visible = true 

func _on_area_3d_body_exited(body):
	if body.name == "PlayerCharacter":
		player_inside = false
		prompt_label.visible = false

func _input(event):
	if player_inside and event.is_action_pressed("interact"):
		var resource = load("res://1.dialogue")
		DialogueManager.show_dialogue_balloon(resource, "start")
