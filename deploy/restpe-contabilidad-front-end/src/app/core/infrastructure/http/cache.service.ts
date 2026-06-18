import { Injectable } from '@angular/core';
import { Observable, of, tap } from 'rxjs';

interface CacheEntry<T> {
  data: T;
  timestamp: number;
  ttl: number;
}

/**
 * Servicio de caché en memoria para respuestas HTTP.
 * Ideal para datos que cambian poco (catálogos, parámetros, maestros).
 *
 * Ejemplo:
 *   const cached = this.cache.get<Moneda[]>('monedas');
 *   if (cached) return of(cached);
 *   return this.http.get<Moneda[]>(url).pipe(
 *     tap(data => this.cache.set('monedas', data, 300_000))
 *   );
 */
@Injectable({ providedIn: 'root' })
export class CacheService {
  private readonly store = new Map<string, CacheEntry<unknown>>();

  get<T>(key: string): T | null {
    const entry = this.store.get(key) as CacheEntry<T> | undefined;
    if (!entry) return null;

    const isExpired = Date.now() - entry.timestamp > entry.ttl;
    if (isExpired) {
      this.store.delete(key);
      return null;
    }

    return entry.data;
  }

  set<T>(key: string, data: T, ttl = 300_000): void {
    this.store.set(key, { data, timestamp: Date.now(), ttl });
  }

  invalidate(key: string): void {
    this.store.delete(key);
  }

  invalidateByPrefix(prefix: string): void {
    for (const key of this.store.keys()) {
      if (key.startsWith(prefix)) {
        this.store.delete(key);
      }
    }
  }

  clear(): void {
    this.store.clear();
  }

  /**
   * Operador RxJS: obtiene del caché o ejecuta el observable y almacena.
   */
  getOrFetch<T>(key: string, source$: Observable<T>, ttl = 300_000): Observable<T> {
    const cached = this.get<T>(key);
    if (cached) return of(cached);
    return source$.pipe(tap(data => this.set(key, data, ttl)));
  }
}
