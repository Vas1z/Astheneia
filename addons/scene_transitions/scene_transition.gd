extends CanvasLayer
## SceneTransition LITE — animated fade scene changes for Godot 4.
##
##   SceneTransition.change_scene("res://levels/level_2.tscn")
##   SceneTransition.change_scene("res://boss.tscn", 0.6, Color.BLACK)
##
## Fades out, swaps the scene, fades back in. Runs even while paused.
##
## ─────────────────────────────────────────────────────────────────────────
## Scene Transitions LITE: fade in/out with a synchronous scene swap.
## Scene Transitions PRO adds: ASYNC background loading (no freeze on big
## scenes), extra transition types (slide, circle wipe), and a midpoint hook.
## Same autoload API, drop-in upgrade:
##   https://godot-forge.itch.io/scene-transitions-godot
## ─────────────────────────────────────────────────────────────────────────

signal scene_changed(path: String)
signal transition_finished

const DEFAULT_DURATION := 0.4

var _overlay: ColorRect
var _busy := false


func _ready() -> void:
	layer = 128
	process_mode = Node.PROCESS_MODE_ALWAYS

	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0)
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_overlay)


## Change to a scene by path with a fade transition.
func change_scene(path: String, duration: float = DEFAULT_DURATION, color: Color = Color.BLACK) -> void:
	if _busy:
		push_warning("SceneTransition: a transition is already running")
		return
	_busy = true
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP  # block input during the change
	_overlay.color = Color(color.r, color.g, color.b, 0.0)

	await _cover(color, duration)

	var err := get_tree().change_scene_to_file(path)
	if err != OK:
		push_error("SceneTransition: failed to change to '%s' (error %d)" % [path, err])
	else:
		scene_changed.emit(path)

	await _reveal(duration)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_busy = false
	transition_finished.emit()


## Reload the scene that is currently running.
func reload_current(duration: float = DEFAULT_DURATION, color: Color = Color.BLACK) -> void:
	var current := get_tree().current_scene
	if current == null:
		return
	change_scene(current.scene_file_path, duration, color)


func is_transitioning() -> bool:
	return _busy


func _cover(color: Color, duration: float) -> void:
	var tween := create_tween()
	tween.tween_property(_overlay, "color", Color(color.r, color.g, color.b, 1.0), maxf(0.01, duration))
	await tween.finished


func _reveal(duration: float) -> void:
	var c := _overlay.color
	var tween := create_tween()
	tween.tween_property(_overlay, "color", Color(c.r, c.g, c.b, 0.0), maxf(0.01, duration))
	await tween.finished
