import { TablaColumna } from '../models/api-page.model';
import { ErpMetoxiFiltroTab } from '../erp-metoxi-list-page/erp-metoxi-list-page.component';

export function contarRegistrosPorEstado(filas: Record<string, unknown>[]): {
  total: number;
  activos: number;
  inactivos: number;
} {
  let activos = 0;
  let inactivos = 0;

  for (const fila of filas) {
    if (estaActivoFila(fila)) {
      activos += 1;
    } else {
      inactivos += 1;
    }
  }

  return { total: filas.length, activos, inactivos };
}

export function filtrarFilasListado(
  filas: Record<string, unknown>[],
  columnas: TablaColumna[],
  busqueda: string,
  filtroTab: ErpMetoxiFiltroTab
): Record<string, unknown>[] {
  const q = busqueda.trim().toLowerCase();

  return filas.filter(fila => {
    if (filtroTab === 'activos' && !estaActivoFila(fila)) return false;
    if (filtroTab === 'inactivos' && estaActivoFila(fila)) return false;

    if (!q) return true;

    return columnas.some(col => {
      const raw = fila[col.key];
      if (raw == null) return false;
      return String(raw).toLowerCase().includes(q);
    });
  });
}

function estaActivoFila(fila: Record<string, unknown>): boolean {
  const estado = fila['flagEstado'];
  if (estado == null) return true;
  return estado === '1' || estado === 1 || estado === true;
}
