# mvnd Bugfix Loop

Bridges [mvnd-bugfix-loop](../../.claude/mvnd-bugfix-loop/SKILL.md) into the Spec Kit workflow for automatic build verification and fix reporting after implementation.

## Bridge Model

```text
  [ Spec Kit Main Flow ]                         [ Extension Enhancement ]

 ┌───────────────────┐
 │ /speckit implement│ ─────> 1. Spec Kit executes implementation
 └─────────┬─────────┘
           │                  (after_implement hook, optional)
           │
           ▼
 ┌───────────────────────────┐
 │ /speckit.mvnd-bugfix-loop.fix │ > 1. Run mvnd verify
 └─────────┬─────────────────┘    2. If fail → enter fix loop (auto mode)
           │                      3. Generate bug report in specs/{feature}/bugs/
           │                      4. Sync **Status**: Verified in spec.md
           │
 ┌─────────────────────────────┐
 │ /speckit.mvnd-bugfix-loop.check │ > Diagnostics: verify mvnd + skill availability
 └─────────────────────────────┘
```

## Features

- Post-implementation build verification via `mvnd verify`
- Automatic fix loop when build fails (diagnose → fix → verify cycle)
- Bug report generation in SpecKit-compatible format
- Status synchronization in `spec.md` (`Implementing` → `Verified`)
- Diagnostics command for extension readiness check

## Installation

### Install from source (Development)

```bash
cd source/spec-kit-extensions
specify extension add --dev ./mvnd-bugfix-loop
```

### Prerequisites

1. **mvnd** installed and on PATH ([installation guide](https://github.com/apache/maven-mvnd))
2. **mvnd-bugfix-loop skill** installed in `.claude/mvnd-bugfix-loop/` or `.cursor/skills/mvnd-bugfix-loop/`
3. **Spec Kit** >= 0.4.3

### Verify installation

Run `/speckit.mvnd-bugfix-loop.check` after installation.

## Commands

| Command | Type | Purpose |
|---------|------|---------|
| `/speckit.mvnd-bugfix-loop.fix` | Hookable | Run mvnd verification, fix loop if failures, generate bug report |
| `/speckit.mvnd-bugfix-loop.check` | Standalone | Verify mvnd and skill availability |

## Hook Integration

| Hook | Command | Optional | Description |
|------|---------|----------|-------------|
| `after_implement` | `mvnd-bugfix-loop.fix` | Yes | Post-implementation build verification |

## Bug Type Mapping

| mvnd Error | SpecKit Bug Type | Rationale |
|-----------|-----------------|-----------|
| Compile failure | Implementation drift | Code deviates from spec |
| Test failure | Untested flow / Spec gap | Edge case not covered |
| Startup failure | Dependency issue | Config/environment problem |
| Dependency error | Dependency issue | External dependency mismatch |

## Responsibility Boundaries

| Responsibility | Owner |
|---------------|-------|
| Build verification and fix loop | mvnd-bugfix-loop |
| Bug report generation | mvnd-bugfix-loop |
| spec.md status sync | mvnd-bugfix-loop |
| Specification creation and mutation | Spec Kit |
| Task generation | Spec Kit |
| TDD enforcement | Superpowers Bridge |

## License

MIT
