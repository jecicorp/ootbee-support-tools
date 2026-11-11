# Upstream sync

This module is a Jeci-maintained fork of
[OrderOfTheBee/ootbee-support-tools](https://github.com/OrderOfTheBee/ootbee-support-tools).
Relevant upstream changes are cherry-picked one by one (`git cherry-pick -x`), one decision
per upstream commit. `upstream/master` is never merged nor rebased onto: `develop` is
published and released as `1.2.3.2-PY.x`.

## State

| Item              | Value                                                              |
| ----------------- | ------------------------------------------------------------------ |
| Remote `upstream` | `https://github.com/OrderOfTheBee/ootbee-support-tools`, `master`  |
| Fork point        | `d380a61`                                                          |
| Reviewed up to    | `a182455` (2026-09-18, upstream 1.2.3.1)                           |

## Review procedure

```bash
git fetch upstream --no-tags
git log --no-merges --date=short --format='%h %ad %s' a182455..upstream/master
git log --no-merges --stat a182455..upstream/master
```

For each upstream commit, add a row to the log below, then move "Reviewed up to" to the
last reviewed commit.

Maven coordinates and versions differ from upstream (`fr.jeci.alfresco`, `-PY.x`), so
`pom.xml` hunks are applied by hand.

## Never ported

- Release bookkeeping: version-only `pom.xml` commits.
- Travis and GitHub tooling, except removals: the fork builds on GitLab CI.

Pristy does not deploy the Share AMP. Share-only commits are skipped unless they also
touch the repository; Share hunks of a mixed commit are kept to stay close to upstream.

## Log

| Upstream  | Date       | Subject                               | Decision                    |
| --------- | ---------- | ------------------------------------- | --------------------------- |
| `add14a6` | 2026-07-02 | (#275) Fix Share log tailing          | Ported (`ae77537`)          |
| `2b4d397` | 2026-07-02 | (#275) Return UUID of appender        | Ported (`2298604`)          |
| `6655c03` | 2026-07-17 | (#280) Fix for-loop set handling      | Ported (`74a0fab`)          |
| `d792a81` | 2026-09-18 | (#283) Remove Travis remnant files    | Ported (`af8d577`)          |
| `a182455` | 2026-09-18 | (#283) Prepare release                | Skipped: never ported       |
