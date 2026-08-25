# rosepine-moon

[Rosé Pine](https://rosepinetheme.com/) for
[cordanui](https://github.com/) — all three variants, previewed live and
committed with a keypress.

| Theme id         | File                  | Vibe                             |
| ---------------- | --------------------- | -------------------------------- |
| `rosepine`       | `rosepine.json`       | main — all natural, low contrast |
| `rosepine-moon`  | `rosepine-moon.json`  | moon — Soho vibes, but moody     |
| `rosepine-dawn`  | `rosepine-dawn.json`  | dawn — for when the sun is up    |

## Picking a variant

On activation the picker opens (configurable):

```
Pick a variant
  Rosé Pine (main)
> Rosé Pine Moon
  Rosé Pine Dawn

tab commit · esc cancel · j/k or ↑/↓ browse
```

- **Browse** (`↑`/`↓` or `j`/`k`) — each variant is applied instantly as a
  *session* override (`cord["local"]`). Nothing is persisted; quit at any
  point and it's gone.
- **Commit** (`tab` by default) — writes the highlighted palette to
  `cord.g`, so it persists in settings, syncs to every client, and wins
  over themes until cleared. The session preview layer is dropped on
  commit so what you see is exactly what was stored.
- **Cancel** (`esc`) — reverts the preview; previously committed styles
  or the active theme show through again.

All keys are configurable via *Configure*:

| Field                 | Values                              | Default        |
| --------------------- | ----------------------------------- | -------------- |
| `variant`             | `rosepine` / `rosepine-moon` / `rosepine-dawn` (aliases `main`/`moon`/`dawn`) | `rosepine-moon` |
| `commit_key`          | `tab` / `s` / `enter` / `space`     | `tab`          |
| `open_picker_on_start`| bool                                | `true`         |
| `reset_overrides`     | bool — wipes everything committed   | `false`        |

## How it works

- `runtime = "lua"`: no build step; `main.lua` runs in-process.
- The `<id>.json` files are canonical (`capabilities.theme = true`) and
  imported into the host's `themes` table. The picker reads palettes from
  the same files — one source of truth.
- Precedence in play (§11): builtin → theme → **committed** (`cord.g`) →
  **preview** (`cord["local"]`). Browsing only ever touches the top,
  non-persisted layer.

## Palette mapping (moon)

Canonical Material 3 style-variable vocabulary throughout.

| Token              | Hex       | Rosé Pine role      |
| ------------------ | --------- | ------------------- |
| `background`       | `#232136` | base                |
| `onBackground`     | `#e0def4` | text                |
| `surface`          | `#2a273f` | surface             |
| `onSurface`        | `#e0def4` | text                |
| `surfaceVariant`   | `#393552` | overlay             |
| `onSurfaceVariant` | `#908caa` | muted               |
| `primary`          | `#c4a7e7` | iris                |
| `onPrimary`        | `#232136` | base (contrast)     |
| `secondary`        | `#9ccfd8` | foam                |
| `onSecondary`      | `#232136` | base (contrast)     |
| `tertiary`         | `#ebbcba` | rose                |
| `onTertiary`       | `#232136` | base (contrast)     |
| `success`          | `#31748f` | pine                |
| `onSuccess`        | `#232136` | base (contrast)     |
| `error`            | `#eb6f92` | love                |
| `onError`          | `#232136` | base (contrast)     |
| `outline`          | `#393552` | overlay             |
| `outlineVariant`   | `#403d52` | highlightMed        |

The main and dawn variants follow the same mapping against their own
base palettes. All 18 roles are specified, so nothing falls back to the
builtin dark palette.
