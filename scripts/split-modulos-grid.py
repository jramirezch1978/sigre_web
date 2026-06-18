"""Recorta iconos de módulos desde la grilla version 03 con márgenes seguros."""
from pathlib import Path

from PIL import Image

GRID_PATH = Path(r"e:\Work\sigre_web\imagenes\version 03\_grid.png")
OUT_DIR = Path(r"e:\Work\sigre_web\02. frontend\src\assets\imagenes\modulos")

NAMES = [
    ["almacen", "compras", "ventas", "finanzas", "contabilidad", "activos-fijos"],
    ["rrhh", "produccion", "presupuesto", "flota", "mantenimiento", "auditoria"],
    ["campo", "comedor", "sig", "operaciones", "horeca", "configuracion"],
]

COLS = 6
ROWS = 3
INSET = 0.14  # 14% por lado para evitar sangrado de iconos vecinos
TARGET = 256


def main() -> None:
    img = Image.open(GRID_PATH).convert("RGBA")
    width, height = img.size
    cell_w = width / COLS
    cell_h = height / ROWS

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    for row in range(ROWS):
        for col in range(COLS):
            left = int(col * cell_w + cell_w * INSET)
            top = int(row * cell_h + cell_h * INSET)
            right = int((col + 1) * cell_w - cell_w * INSET)
            bottom = int((row + 1) * cell_h - cell_h * INSET)

            crop = img.crop((left, top, right, bottom))
            crop_w, crop_h = crop.size
            size = max(crop_w, crop_h)
            square = Image.new("RGBA", (size, size), (0, 0, 0, 0))
            square.paste(crop, ((size - crop_w) // 2, (size - crop_h) // 2))
            square = square.resize((TARGET, TARGET), Image.Resampling.LANCZOS)

            out_file = OUT_DIR / f"{NAMES[row][col]}.png"
            square.save(out_file, "PNG", optimize=True)
            print(f"OK {out_file.name} ({TARGET}x{TARGET})")


if __name__ == "__main__":
    main()
