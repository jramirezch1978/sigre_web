import { Observable, from, of } from 'rxjs';
import { concatMap, toArray } from 'rxjs/operators';

/**
 * Utilidades RxJS para flujos del admin: evitar varios `subscribe` independientes en operaciones
 * que deben comportarse como una unidad lógica.
 *
 * - Cargas en paralelo “todo o nada”: usar {@code forkJoin} de RxJS en el componente (si una falla,
 *   ningún `next` con datos parciales salvo que se gestione explícitamente).
 * - Pasos mutadores encadenados: usar {@link adminSequential} para no lanzar el paso N+1 si N falla.
 */
export function adminSequential<T>(steps: Array<Observable<T>>): Observable<T[]> {
  if (steps.length === 0) {
    return of([]);
  }
  return from(steps).pipe(concatMap((s) => s), toArray());
}
