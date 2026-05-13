# Reverse TD Editor + Core Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the core reverse-TD loop (queue-locked conveyor combat) and a minimal level editor with simulation playback for tuning.

**Architecture:** Data-driven gameplay with immutable level configs and a deterministic simulation core. The editor is a tool UI that edits level data and calls the same simulation layer used by gameplay. Queue visibility and building layer rules live in shared gameplay logic to avoid editor/game divergence.

**Tech Stack:** Godot 4.6, GDScript

---

## Task 1: Create level data schema and fixtures

**Files:**
- Create: `assets/data/levels/level_schema.json`
- Create: `assets/data/levels/example_level.json`
- Create: `src/core/data/level_data.gd`
- Test: `tests/unit/level_data_schema_test.gd`

**Step 1: Write the failing test**

```gdscript
extends RefCounted

func test_level_schema_validates_example():
    var schema_path := "res://assets/data/levels/level_schema.json"
    var level_path := "res://assets/data/levels/example_level.json"
    var result := LevelData.validate_schema(schema_path, level_path)
    assert(result.is_valid)
```

**Step 2: Run test to verify it fails**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: FAIL with "LevelData not found" or schema validation missing.

**Step 3: Write minimal implementation**

```gdscript
class_name LevelData
extends RefCounted

static func validate_schema(schema_path: String, level_path: String) -> Dictionary:
    return {"is_valid": false, "errors": ["not implemented"]}
```

**Step 4: Run test to verify it passes**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: PASS after adding simple schema validation or stubbing with a valid example.

**Step 5: Commit**

```bash
git add assets/data/levels/level_schema.json assets/data/levels/example_level.json src/core/data/level_data.gd tests/unit/level_data_schema_test.gd
git commit -m "feat: add level data schema and fixtures"
```

---

## Task 2: Implement deterministic simulation core (no visuals)

**Files:**
- Create: `src/gameplay/sim/simulation_state.gd`
- Create: `src/gameplay/sim/simulation_stepper.gd`
- Test: `tests/unit/simulation_stepper_basic_test.gd`

**Step 1: Write the failing test**

```gdscript
extends RefCounted

func test_simulation_step_consumes_energy_and_updates_waiting_slots():
    var state := SimulationState.new()
    state.load_level(LevelData.load("res://assets/data/levels/example_level.json"))
    state.enqueue_unit("A", 0)
    SimulationStepper.step(state)
    assert(state.waiting_slots.size() <= 5)
```

**Step 2: Run test to verify it fails**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: FAIL with missing classes.

**Step 3: Write minimal implementation**

```gdscript
class_name SimulationState
extends RefCounted

var waiting_slots: Array = []

func load_level(level: Dictionary) -> void:
    pass

func enqueue_unit(column_id: String, index: int) -> void:
    pass
```

**Step 4: Run test to verify it passes**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: PASS after stubbing or simple logic.

**Step 5: Commit**

```bash
git add src/gameplay/sim/simulation_state.gd src/gameplay/sim/simulation_stepper.gd tests/unit/simulation_stepper_basic_test.gd
git commit -m "feat: add deterministic simulation core skeleton"
```

---

## Task 3: Implement queue lock and front-3 visibility rules

**Files:**
- Modify: `src/gameplay/sim/simulation_state.gd`
- Test: `tests/unit/queue_locking_test.gd`

**Step 1: Write the failing test**

```gdscript
extends RefCounted

func test_queue_lock_blocks_next_row_if_front_not_consumed():
    var state := SimulationState.new()
    state.load_level(LevelData.load("res://assets/data/levels/example_level.json"))
    var available := state.get_available_units()
    assert(available.size() == state.front_rows_visible * state.columns.size())
```

**Step 2: Run test to verify it fails**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: FAIL with missing method.

**Step 3: Write minimal implementation**

```gdscript
func get_available_units() -> Array:
    return []
```

**Step 4: Run test to verify it passes**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: PASS after implementing front-3 filtering and lock rule.

**Step 5: Commit**

```bash
git add src/gameplay/sim/simulation_state.gd tests/unit/queue_locking_test.gd
git commit -m "feat: enforce queue lock and front-3 visibility"
```

---

## Task 4: Implement building layer blocking and color matching

**Files:**
- Modify: `src/gameplay/sim/simulation_stepper.gd`
- Test: `tests/unit/building_layer_blocking_test.gd`

**Note:** The attackable-building selection logic is implemented in
`src/gameplay/sim/simulation_state.gd` to keep it data-driven and accessible
to both gameplay and editor tooling.

**Step 1: Write the failing test**

```gdscript
extends RefCounted

func test_inner_building_not_attackable_if_outer_exists():
    var state := SimulationState.new()
    state.load_level(LevelData.load("res://assets/data/levels/example_level.json"))
    var targets := state.get_attackable_buildings("B")
    assert(targets.all(func(t): return t.layer_depth == 1))
```

**Step 2: Run test to verify it fails**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: FAIL with missing method.

**Step 3: Write minimal implementation**

```gdscript
func get_attackable_buildings(color: String) -> Array:
    return []
```

**Step 4: Run test to verify it passes**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: PASS after applying blocking logic.

**Step 5: Commit**

```bash
git add src/gameplay/sim/simulation_stepper.gd tests/unit/building_layer_blocking_test.gd
git commit -m "feat: add building layer blocking and color targeting"
```

---

## Task 5: Implement waiting slot behavior and failure condition

**Files:**
- Modify: `src/gameplay/sim/simulation_state.gd`
- Test: `tests/unit/waiting_slots_failure_test.gd`

**Step 1: Write the failing test**

```gdscript
extends RefCounted

func test_waiting_slots_overflow_triggers_failure():
    var state := SimulationState.new()
    state.waiting_slots = [1,2,3,4,5]
    assert(state.is_failed())
```

**Step 2: Run test to verify it fails**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: FAIL with missing method.

**Step 3: Write minimal implementation**

```gdscript
func is_failed() -> bool:
    return waiting_slots.size() >= max_waiting_slots
```

**Step 4: Run test to verify it passes**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: PASS after implementing logic.

**Step 5: Commit**

```bash
git add src/gameplay/sim/simulation_state.gd tests/unit/waiting_slots_failure_test.gd
git commit -m "feat: enforce waiting slot failure rule"
```

---

## Task 6: Build minimal gameplay UI for queue, grid, and waiting slots

**Files:**
- Create: `src/ui/gameplay/main_gameplay.tscn`
- Create: `src/ui/gameplay/main_gameplay.gd`
- Create: `src/ui/gameplay/components/queue_panel.tscn`
- Create: `src/ui/gameplay/components/waiting_slots_panel.tscn`
- Test: `production/qa/evidence/gameplay_ui_walkthrough.md`

**Step 1: Write the failing test (manual evidence)**

```markdown
# Gameplay UI Walkthrough
- [ ] Queue panel shows front 3 rows
- [ ] Waiting slots show 5 slots
- [ ] Clicking available unit enqueues to conveyor
```

**Step 2: Run manual verification**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: PASS for unit tests, then manual playtest updates the walkthrough.

**Step 3: Write minimal implementation**

```gdscript
extends Control

func _ready() -> void:
    pass
```

**Step 4: Run manual verification**

Run: `godot` and open the main scene.
Expected: UI panels render and respond to clicks.

**Step 5: Commit**

```bash
git add src/ui/gameplay/main_gameplay.tscn src/ui/gameplay/main_gameplay.gd src/ui/gameplay/components/queue_panel.tscn src/ui/gameplay/components/waiting_slots_panel.tscn production/qa/evidence/gameplay_ui_walkthrough.md
git commit -m "feat: add minimal gameplay UI for queue and waiting slots"
```

---

## Task 7: Build level editor UI with grid, queue editor, and simulation controls

**Files:**
- Create: `src/tools/level_editor/level_editor.tscn`
- Create: `src/tools/level_editor/level_editor.gd`
- Create: `src/tools/level_editor/components/level_grid.tscn`
- Create: `src/tools/level_editor/components/queue_editor.tscn`
- Create: `src/tools/level_editor/components/sim_controls.tscn`
- Test: `production/qa/evidence/level_editor_walkthrough.md`

**Step 1: Write the failing test (manual evidence)**

```markdown
# Level Editor Walkthrough
- [ ] Place building with color + layer
- [ ] Edit queue columns
- [ ] Run simulation step and see waiting slots
- [ ] Tooltip shows: "Units shift forward when tapped"
```

**Step 2: Run manual verification**

Run: `godot` and open the editor scene.
Expected: UI renders; interactions log updates.

**Step 3: Write minimal implementation**

```gdscript
extends Control

func _ready() -> void:
    pass
```

**Step 4: Run manual verification**

Run: `godot` and step simulation.
Expected: Grid + queue + waiting slot state updates.

**Step 5: Commit**

```bash
git add src/tools/level_editor/level_editor.tscn src/tools/level_editor/level_editor.gd src/tools/level_editor/components/level_grid.tscn src/tools/level_editor/components/queue_editor.tscn src/tools/level_editor/components/sim_controls.tscn production/qa/evidence/level_editor_walkthrough.md
git commit -m "feat: add level editor UI and sim controls"
```

---

## Task 8: Wire editor save/load to level data

**Files:**
- Modify: `src/tools/level_editor/level_editor.gd`
- Modify: `src/core/data/level_data.gd`
- Test: `tests/unit/level_save_load_test.gd`

**Step 1: Write the failing test**

```gdscript
extends RefCounted

func test_level_roundtrip_save_load():
    var level := LevelData.load("res://assets/data/levels/example_level.json")
    LevelData.save("user://levels/tmp.json", level)
    var loaded := LevelData.load("user://levels/tmp.json")
    assert(level == loaded)
```

**Step 2: Run test to verify it fails**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: FAIL with missing save/load or file I/O stubs.

**Step 3: Write minimal implementation**

```gdscript
static func save(path: String, level: Dictionary) -> void:
    pass
```

**Step 4: Run test to verify it passes**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: PASS after implementing JSON I/O.

**Step 5: Commit**

```bash
git add src/tools/level_editor/level_editor.gd src/core/data/level_data.gd tests/unit/level_save_load_test.gd
git commit -m "feat: add editor save/load for level data"
```

---

## Task 9: Add visual states for attackable vs locked buildings

**Files:**
- Modify: `src/ui/gameplay/components/grid_view.gd`
- Modify: `src/tools/level_editor/components/level_grid.gd`
- Test: `production/qa/evidence/visual_states_screenshots.md`

**Step 1: Write the failing test (manual evidence)**

```markdown
# Visual State Evidence
- [ ] Locked building shows lock overlay but retains color
- [ ] Attackable building highlights on selection
```

**Step 2: Run manual verification**

Run: `godot` and capture screenshots.
Expected: Visual states are clear and consistent.

**Step 3: Write minimal implementation**

```gdscript
func set_locked(is_locked: bool) -> void:
    pass
```

**Step 4: Run manual verification**

Run: `godot` and verify overlays.
Expected: Pass criteria in evidence file.

**Step 5: Commit**

```bash
git add src/ui/gameplay/components/grid_view.gd src/tools/level_editor/components/level_grid.gd production/qa/evidence/visual_states_screenshots.md
git commit -m "feat: add locked/attackable building visuals"
```

---

## Task 10: Provide test harness and baseline playtest script

**Files:**
- Create: `tests/gdunit4_runner.gd`
- Create: `production/qa/evidence/playtest_script.md`

**Step 1: Write the failing test (runner missing)**

```gdscript
extends SceneTree

func _init():
    get_tree().quit(0)
```

**Step 2: Run test to verify it fails**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: FAIL if runner missing, then PASS after added.

**Step 3: Write minimal implementation**

```gdscript
extends SceneTree

func _init():
    get_tree().quit(0)
```

**Step 4: Run test to verify it passes**

Run: `godot --headless --script tests/gdunit4_runner.gd`
Expected: PASS.

**Step 5: Commit**

```bash
git add tests/gdunit4_runner.gd production/qa/evidence/playtest_script.md
git commit -m "chore: add test runner and playtest script"
```

---

## Notes

- All gameplay values are data-driven; avoid hardcoding constants outside level data.
- Use shared simulation logic in both gameplay and editor.
- Keep deterministic simulation to support reproducible playtests.

---

Plan complete and saved to `docs/plans/2026-05-13-reverse-td-editor-core-implementation-plan.md`. Two execution options:

1. Subagent-Driven (this session) - I dispatch fresh subagent per task, review between tasks, fast iteration
2. Parallel Session (separate) - Open new session with executing-plans, batch execution with checkpoints

Which approach?
