# ADR-0002: Deterministic Simulation Core Skeleton

## Status

Accepted

## Date

2026-05-13

## Last Verified

2026-05-13

## Decision Makers

- Design Lead
- Tech Lead

## Summary

Establish a minimal, deterministic simulation core API for gameplay stepping. The initial implementation is a stubbed state container and stepper interface to unblock tests and future data-driven logic.

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Core |
| **Knowledge Risk** | HIGH |
| **References Consulted** | `docs/engine-reference/godot/VERSION.md` |
| **Post-Cutoff APIs Used** | None |
| **Verification Required** | None |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | ADR-0001 |
| **Enables** | Deterministic wave resolution and editor simulation preview |
| **Blocks** | None |
| **Ordering Note** | Define simulation API before adding gameplay formulas |

## Context

### Problem Statement

We need a stable, deterministic simulation entry point to evolve gameplay logic without committing to a full ruleset yet.

### Current State

No shared simulation state or stepper exists; gameplay tests cannot target a consistent API.

### Constraints

- Must be data-driven and avoid hardcoded gameplay values.
- Must be deterministic and testable in isolation.
- Keep implementation minimal until formulas are specified.

### Requirements

- Provide a SimulationState container with load and enqueue hooks.
- Provide a SimulationStepper with a single step entry point.
- Allow unit tests to exercise the API without visuals.

## Decision

Create a minimal simulation core with a state object and a stateless stepper. The stepper mutates state in-place and will later consume data-driven level configuration for gameplay values.

### Architecture

```
SimulationState
  - load_level(level_dict)
  - enqueue_unit(column_id, index)
SimulationStepper.step(state)
```

### Key Interfaces

```
SimulationState.load_level(level: Dictionary) -> void
SimulationState.enqueue_unit(column_id: String, index: int) -> void
SimulationStepper.step(state: SimulationState) -> void
```

### Implementation Guidelines

- Keep state changes minimal until gameplay formulas are defined.
- Store gameplay values in data; avoid hardcoded numbers.
- Favor deterministic, single-step mutations for testing.

## Alternatives Considered

### Alternative 1: Full Simulation Ruleset Now

- **Description**: Implement wave, energy, and slot logic immediately.
- **Pros**: Faster path to playable logic.
- **Cons**: Premature commitment to rules without final design.
- **Estimated Effort**: Medium
- **Rejection Reason**: Out of scope for the skeleton phase.

## Consequences

### Positive

- Establishes a stable API for tests and future gameplay iteration.
- Keeps early implementation small and low risk.

### Negative

- No gameplay behavior yet; tests are limited to structure.

### Neutral

- Additional ADRs will be needed as simulation rules evolve.

## Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|-----------|
| API changes ripple into tests | Medium | Low | Keep interface minimal until rules stabilize |

## Performance Implications

| Metric | Before | Expected After | Budget |
|--------|--------|---------------|--------|
| CPU (frame time) | N/A | N/A | N/A |
| Memory | N/A | N/A | N/A |
| Load Time | N/A | N/A | N/A |
| Network (if applicable) | N/A | N/A | N/A |

## Migration Plan

1. Add state and stepper API stubs.
2. Introduce data-driven formulas once design is finalized.

**Rollback plan**: Remove simulation stubs and gate tests until design is ready.

## Validation Criteria

- [ ] Unit test can instantiate state, enqueue, and step without errors.

## GDD Requirements Addressed

| GDD Document | System | Requirement | How This ADR Satisfies It |
|-------------|--------|-------------|--------------------------|
| Foundational | Core Simulation | Foundational — no GDD requirement. Enables: deterministic gameplay simulation and editor previews | Defines a minimal, testable simulation core API |

## Related

- `docs/architecture/ADR-0001-level-data-schema-validation.md`
- `src/gameplay/sim/simulation_state.gd`
- `src/gameplay/sim/simulation_stepper.gd`
