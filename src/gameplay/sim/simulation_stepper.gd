## Steps the simulation forward by one tick.
class_name SimulationStepper
extends RefCounted

## Advances simulation by one step.
static func step(state: SimulationState) -> void:
	if state.max_waiting_slots <= 0:
		return
	if state.pending_units.is_empty():
		return
	if state.waiting_slots.size() >= state.max_waiting_slots:
		return
	state.waiting_slots.append(state.pending_units.pop_front())
