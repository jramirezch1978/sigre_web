# Branding Hermes

Identidad visual de la app móvil Hermes (mensajero / logística).

## Paleta

| Token | Hex | Uso |
|---|---|---|
| `hermes_ink` | `#0E3336` | Primario, toolbars, botones |
| `hermes_ink_deep` | `#082225` | Status bar / sombras |
| `hermes_teal` | `#1A5C61` | Acentos secundarios, inputs |
| `hermes_copper` | `#C47A3A` | CTA, FAB, barra de marca |
| `hermes_mist` | `#E7F0F1` | Fondo base |
| `hermes_text` / `hermes_text_muted` | `#122628` / `#5A6E70` | Texto |

Los alias `sigre_*` apuntan a estos tokens para no romper layouts legacy.

## Tipografía

- **Sora** (`font_sora`): marca, títulos, toolbar, botones
- **DM Sans** (`font_dm_sans`): cuerpo, captions, formularios

## Superficies

- Fondo: `@drawable/bg_hermes_atmosphere`
- Toolbar: `@drawable/bg_toolbar_hermes`
- Filas de lista: `@drawable/bg_list_item_hermes` + barra cobre
- Tema app: `Theme.Hermes`

## Listados (regla de branding — todas las ventanas)

- Filas **continuas** tipo ListView: **sin margen/espacio vertical entre registros**.
- Fondo de lista: un solo bloque `@color/hermes_surface_elevated`; divisor 1dp inferior por fila.
- No usar cards flotantes ni `layout_marginTop/Bottom` en items de listado.
- Helper: `HermesListUi.aplicarListaContinua(RecyclerView)` (lo aplica `SimpleListAdapter` / `SeleccionOpcionAdapter`).
- `flag_estado`: `1` → **Activo**, `0` → **Inactivo** (`FlagEstadoLabels`), con etiqueta de campo (`Estado: …`).
- Campos de negocio con label (`Sucursal:`, `Centro de costos:`, etc.) cuando el API los envía.
