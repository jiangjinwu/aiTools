---
description: >
  Bridges mvnd-bugfix-loop into Spec Kit. Runs mvnd verification,
  enters fix loop if failures found, generates bug report in
  specs/{feature}/bugs/.
scripts:
  sh: scripts/bash/sync-spec-status.sh
---

# SpecKit mvnd Bugfix Loop — Build Fix

> **Type:** Extension command
> **Skill origin:** mvnd-bugfix-loop (Claude Code Skill)
> **Invocation:** Optional post-hook for `speckit.implement`

---

## Step 1 — Resolve Installed Skill

Look for mvnd-bugfix-loop SKILL.md in this order:

1. `.claude/mvnd-bugfix-loop/SKILL.md`
2. `.cursor/skills/mvnd-bugfix-loop/SKILL.md`

If not found, **STOP**:

```text
ERROR: mvnd-bugfix-loop skill not found.
Ensure the skill is installed in .claude/mvnd-bugfix-loop/ or .cursor/skills/mvnd-bugfix-loop/.
```

Report the source you resolved before continuing:

```text
Using skill: mvnd-bugfix-loop
Source: [claude|cursor]
Path: [resolved path]
```

---

## Step 2 — Resolve Active Feature Spec

Resolve active feature spec path using Spec Kit prerequisite scripts:

- Prefer `FEATURE_SPEC` when present
- Otherwise use `FEATURE_DIR/spec.md`

Do not infer the feature path from the current branch name manually.

If the active feature spec cannot be resolved, **STOP** and report the failure.

---

## Step 3 — Execute mvnd Verification

Run `mvnd verify` (or appropriate scoped command with `-pl` if needed) to check build health.

If build passes:

- Sync status to `Verified` via `{SCRIPT} --status "Verified"`
- Output success report
- Done

If build fails → proceed to Step 4.

---

## Step 4 — Enter Fix Loop

Follow mvnd-bugfix-loop's three-phase workflow (loaded from the resolved SKILL.md):

1. **Phase 1 — Diagnostic**: Analyze error output, produce structured diagnostic report
2. **Phase 2 — Fix**: Apply minimal fixes in **auto** mode (SpecKit context implies auto)
3. **Phase 3 — Final Verification**: Full `mvnd verify` without `-o`

Loop until success or user intervention needed.

During the fix loop, sync status:

```bash
{SCRIPT} --status "Implementing"
```

---

## Step 5 — Generate Bug Report

After successful fix, generate bug report at:
`specs/{feature}/bugs/BUG-{NNN}.md`

Sequence number `NNN`: list existing `BUG-*.md` files in the bugs directory, take the max + 1.

Report format:

```markdown
# Bug Report: [Brief Description]

## Metadata

| Field | Content |
|-------|---------|
| Bug ID | BUG-{NNN} |
| Date | [YYYY-MM-DD] |
| Type | [SpecKit bug type from mapping] |
| Severity | [High/Medium/Low] |
| Feature | [feature name] |
| mvnd Error Type | [compile/test/startup/dependency] |

## Symptom

[Error output from mvnd]

## Root Cause

[Analysis from diagnostic phase]

## Fix

[Files changed and what was modified]

## Verification

[Command run and result]
```

### Bug Type Mapping

| mvnd error | SpecKit type | Rationale |
|-----------|-------------|-----------|
| 编译失败 | Implementation drift | Code deviates from spec definition |
| 测试失败 | Untested flow / Spec gap | Edge case not covered or requirement missing |
| 启动失败 | Dependency issue | Configuration/environment dependency problem |
| 依赖错误 | Dependency issue | External dependency behavior differs from assumption |

---

## Step 6 — Update Spec Artifacts

1. **Update spec.md**: Add bugfix note under the relevant user story:

   ```markdown
   **Bugfix**: [DATE] — BUG-{NNN} [Brief description]
   ```

2. **Update tasks.md**: If the fix relates to an existing task, mark completion status. If it's a new task, append it.

---

## Step 7 — Status Synchronization

Sync feature spec status:

```bash
{SCRIPT} --status "Verified"
```

Status sync rules:

- Use the script output as the source of truth for resolved spec path
- If verification fails, leave the previous status unchanged
- Do not overwrite `Abandoned`

---

## Step 8 — Completion Report

Output:

```markdown
## Build Fix Complete

**Verification**: mvnd verify passed
**Files changed**: [list]
**Root cause**: [summary]
**Bug report**: specs/{feature}/bugs/BUG-{NNN}.md
**Status**: Verified

Suggested next steps:
- Run `/speckit.superb.critique` for spec-aligned code review
- Run `/speckit-bugfix-verify` to confirm consistency
- Or proceed to PR creation
```
