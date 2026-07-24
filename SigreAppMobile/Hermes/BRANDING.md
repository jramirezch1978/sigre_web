# Branding Hermes

Identidad visual de la app móvil Hermes (mensajero / logística).

## Dónde cambiar (patrón centralizado)

| Qué quieres cambiar | Archivo(s) único(s) |
|---|---|
| Colores / tipografía | `res/values/colors.xml`, `styles.xml`, fuentes |
| Aspecto de fila (gaps, barra, fondo) | `item_simple_texto.xml`, `bg_list_item_hermes.xml`, `HermesListUi` |
| Formato de subtítulo (multilínea vs `·`, labels) | **`ListItemBuilder`** (constantes `SEP_*`) |
| Textos Activo / Inactivo | **`FlagEstadoLabels`** |
| Datos de una fila concreta | Solo el mapper del repositorio (`.campo(...)` / `.estado(...)`) |

**No** tocar Activities ni layouts de cada ventana para un cambio de branding de listados.

## Patrones usados

1. **Facade + Adapter** — `SimpleListAdapter` / `SeleccionOpcionAdapter` aplican `HermesListUi` al engancharse al `RecyclerView` (estilo visual global).
2. **Builder** — `ListItemBuilder` arma título/subtítulo; repositorios declaran campos, no formatean.
3. **Strategy** — `FlagEstadoLabels` traduce `flag_estado` (listado vs formulario).

Ejemplo en repositorio:

```java
ListItemBuilder.of(a.id)
    .tituloCodigoNombre(a.codigo, a.nombre)
    .campo("Sucursal", a.sucursalNombre)
    .campo("Centro de costos", ListItemBuilder.codigoNombre(a.centrosCostoCodigo, a.centrosCostoNombre))
    .estado(a.flagEstado)
    .build();
```

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

## Listados

- Filas **continuas** (sin margen vertical entre registros).
- `flag_estado` (DDL `00-convenciones-generales.sql` / `FlagEstadoLabels`):
  - `0` Anulado · `1` Activo · `2` Cerrado · `3` Pendiente
  - `4` Pagado parcial · `5` Pagado total · `6` En proceso
  - `7` Devuelto · `8` Suspendido · `9` Observado
- Campos con etiqueta vía `ListItemBuilder.campo(...)`.
