## Holds deterministic simulation state for gameplay steps.
class_name SimulationState
extends RefCounted

## Units that have returned to waiting slots.
var waiting_slots: Array = []

## Units queued for the next simulation step.
var pending_units: Array = []

## Maximum waiting slots allowed for this level.
var max_waiting_slots: int = 0

## Loads level data into the simulation state.
func load_level(level: Dictionary) -> void:
	waiting_slots.clear()
	pending_units.clear()
	max_waiting_slots = int(level.get("waiting_slots", 0))

## Enqueues a unit into the simulation state.
func enqueue_unit(column_id: String, index: int) -> void:
	pending_units.append({"column_id": column_id, "index": index})
