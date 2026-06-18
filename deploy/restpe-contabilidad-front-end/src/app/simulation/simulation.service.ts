import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class SimulationService {
  private storage$ = new BehaviorSubject<Record<string, any[]>>({});

  constructor() {
    // Cargar todo el localStorage al iniciar
    this.syncFromLocalStorage();
  }

  private syncFromLocalStorage() {
  const allKeys = Object.keys(localStorage);
  const init: Record<string, any[]> = {};

  allKeys.forEach(k => {
    const raw = localStorage.getItem(k);

    if (!raw) {
      init[k] = [];
      return;
    }

    try {
      const parsed = JSON.parse(raw);
      init[k] = Array.isArray(parsed) ? parsed : [];
    } catch {
      // 👈 NO es JSON (countryCode, country, etc.)
      init[k] = [];
    }
  });

  this.storage$.next(init);
}


  save(key: string, value: any) {
    const current = this.list(key);
    current.push(value);
    localStorage.setItem(key, JSON.stringify(current));

    // emitir actualización global
    this.storage$.next({
      ...this.storage$.value,
      [key]: current
    });
  }

  replace(key: string, values: any[]) {
    localStorage.setItem(key, JSON.stringify(values));

    // emitir actualización global
    this.storage$.next({
      ...this.storage$.value,
      [key]: values
    });
  }

  list(key: string) {
    // Leer siempre directo del localStorage para obtener datos frescos
    // El BehaviorSubject cache causaba que no se actualizaran los datos entre pantallas
    const data = localStorage.getItem(key);
    if (data) {
      try {
        return JSON.parse(data);
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  // para que los componentes se actualicen
  storageChanges() {
    return this.storage$.asObservable();
  }
}
