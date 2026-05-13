## Holds deterministic simulation state for gameplay steps.
class_name SimulationState
extends RefCounted

## Queued units awaiting placement.
var waiting_slots: Array = []

## Loads level data into the simulation state.
func load_level(level: Dictionary) -> void:
	waiting_slots.clear()

## Enqueues a unit into the simulation state.
func enqueue_unit(column_id: String, index: int) -> void:
	waiting_slots.append({"column_id": column_id, "index": index})
