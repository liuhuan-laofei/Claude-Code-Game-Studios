@tool
extends Control

@onready var lock_overlay: Label = $LockOverlay
@onready var highlight_overlay: ColorRect = $HighlightOverlay

func set_locked(is_locked: bool) -> void:
	lock_overlay.visible = is_locked

func set_attackable(is_attackable: bool) -> void:
	highlight_overlay.visible = is_attackable

@export_tool_button("Test: Set Locked True")
var test_set_locked_true = set_locked_true

@export_tool_button("Test: Set Attackable True")
var test_set_attackable_true = set_attackable_true

func set_locked_true() -> void:
	set_locked(true)

func set_attackable_true() -> void:
	set_attackable(true)
