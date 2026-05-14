---
description: >
  Bridge diagnostics command. Verifies mvnd-bugfix-loop skill and mvnd
  tool are available.
---

# mvnd Bugfix Loop — Diagnostics

> **Type:** Extension-native diagnostics command
> **Invocation:** Manual (`/speckit.mvnd-bugfix-loop.check`)

---

## Step 1 — Check mvnd Availability

Run `mvnd --version`.

If found, record version.

If not found, report:

```text
mvnd: NOT FOUND
Install from https://github.com/apache/maven-mvnd
  macOS: brew install mvnd
  Linux: sdk install mvnd
  Windows: choco install mvnd
```

---

## Step 2 — Check Skill Availability

Look for mvnd-bugfix-loop SKILL.md in:

1. `.claude/mvnd-bugfix-loop/SKILL.md`
2. `.cursor/skills/mvnd-bugfix-loop/SKILL.md`

---

## Step 3 — Check Extension Registration

Verify this extension is registered in `.specify/extensions/` or equivalent.

---

## Step 4 — Report

```text
  mvnd-bugfix-loop Status:
  mvnd: [available|not found] — [version if available]
  skill: [found|not found] — [resolved path]
  extension: [registered|not registered]
  hooks:
    after_implement: [ready|not registered]
```

If all checks pass:

```text
  mvnd-bugfix-loop is ready. Available commands:
  /speckit.mvnd-bugfix-loop.fix   — Run mvnd build verification and fix loop
  /speckit.mvnd-bugfix-loop.check — This diagnostics command
```

If any check fails, list the specific issues and remediation steps.
