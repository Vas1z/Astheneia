@tool
extends EditorPlugin

const AUTOLOAD_NAME := "SceneTransition"
const AUTOLOAD_PATH := "res://addons/scene_transitions/scene_transition.gd"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
