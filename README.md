# rosepine-moon

A [Rosé Pine Moon](https://rosepinetheme.com/) theme pack for
[cordanui](https://github.com/). Soho vibes, but moody.

## Install

Clone this repo and install it with the cordanui plugin manager. On install,
the host inserts the theme into its `themes` table; select it via
`settings.theme_mode = 'explicit'` and `settings.selected_theme_id =
'rosepine-moon'` to see it.

## Palette mapping

| Token           | Hex       | Rosé Pine role      |
| --------------- | --------- | ------------------- |
| `bg`            | `#232136` | base                |
| `surface`       | `#2a273f` | surface             |
| `border`        | `#393552` | overlay             |
| `treeLine`      | `#403d52` | highlightMed        |
| `text`          | `#e0def4` | text                |
| `textDim`       | `#908caa` | muted               |
| `textFaint`     | `#6e6a86` | subtle              |
| `accent`        | `#c4a7e7` | iris                |
| `onAccent`      | `#232136` | base (contrast)     |
| `danger`        | `#eb6f92` | love                |
| `statusPending` | `#6e6a86` | subtle              |
| `statusWip`     | `#9ccfd8` | foam                |
| `statusDone`    | `#31748f` | pine                |
| `statusAgent`   | `#c4a7e7` | iris                |

All 14 tokens are specified, so nothing falls back to the builtin dark palette.
