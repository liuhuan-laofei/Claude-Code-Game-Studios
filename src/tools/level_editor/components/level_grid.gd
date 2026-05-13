## Level editor grid view for visual state toggles.
extends PanelContainer

@onready var lock_overlay: Label = $LockOverlay
@onready var highlight_overlay: ColorRect = $HighlightOverlay

## Toggles the locked visual state.
func set_locked(is_locked: bool) -> void:
	lock_overlay.visible = is_locked

## Toggles the attackable visual state.
func set_attackable(is_attackable: bool) -> void:
	highlight_overlay.visible = is_attackable
