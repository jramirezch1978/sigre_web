import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, of } from 'rxjs';
import { SimulationService } from 'src/app/simulation/simulation.service';
import {
  Accesorio,
  Adaptacion,
  HistorialActivoFijo,
  Incidencia,
} from './models/activo-fijo.model';

/**
 * Servicio de operaciones de Activos Fijos.
 * Gestiona accesorios, incidencias, adaptaciones e historial
 * usando SimulationService (localStorage) como capa de persistencia temporal.
 */
@Injectable({ providedIn: 'root' })
export class ActivosFijosService {

  private _accesorios$ = new BehaviorSubject<Accesorio[]>([]);
  private _incidencias$ = new BehaviorSubject<Incidencia[]>([]);
  private _adaptaciones$ = new BehaviorSubject<Adaptacion[]>([]);

  /** Stream de accesorios del activo actualmente seleccionado */
  readonly accesorios$: Observable<Accesorio[]> = this._accesorios$.asObservable();

  /** Stream de incidencias del activo actualmente seleccionado */
  readonly incidencias$: Observable<Incidencia[]> = this._incidencias$.asObservable();

  /** Stream de adaptaciones del activo actualmente seleccionado */
  readonly adaptaciones$: Observable<Adaptacion[]> = this._adaptaciones$.asObservable();

  constructor(private simulation: SimulationService) {}

  // ─────────────────────────────────────────────
  // Accesorios
  // ─────────────────────────────────────────────

  cargarAccesorios(activoFijoId: string): void {
    const todos: Accesorio[] = this.simulation.list('accesorio') || [];
    this._accesorios$.next(todos.filter(a => a.activoFijoId === activoFijoId));
  }

  crearAccesorio(accesorio: Accesorio): Observable<Accesorio> {
    const nuevo: Accesorio = {
      ...accesorio,
      id: `acc-${Date.now()}`,
    };
    this.simulation.save('accesorio', nuevo);
    const actualizado: Accesorio[] = this.simulation.list('accesorio') || [];
    this._accesorios$.next(actualizado.filter(a => a.activoFijoId === accesorio.activoFijoId));
    return of(nuevo);
  }

  eliminarAccesorio(id: string): Observable<void> {
    const todos: Accesorio[] = this.simulation.list('accesorio') || [];
    const item = todos.find(a => a.id === id);
    const sinEliminado = todos.filter(a => a.id !== id);
    this.simulation.replace('accesorio', sinEliminado);
    if (item) {
      this._accesorios$.next(sinEliminado.filter(a => a.activoFijoId === item.activoFijoId));
    }
    return of(void 0);
  }

  // ─────────────────────────────────────────────
  // Incidencias
  // ─────────────────────────────────────────────

  cargarIncidencias(activoFijoId: string): void {
    const todas: Incidencia[] = this.simulation.list('incidencia') || [];
    this._incidencias$.next(todas.filter(i => i.activoFijoId === activoFijoId));
  }

  crearIncidencia(incidencia: Incidencia): Observable<Incidencia> {
    const nueva: Incidencia = {
      ...incidencia,
      id: `inc-${Date.now()}`,
    };
    this.simulation.save('incidencia', nueva);
    const actualizado: Incidencia[] = this.simulation.list('incidencia') || [];
    this._incidencias$.next(actualizado.filter(i => i.activoFijoId === incidencia.activoFijoId));
    return of(nueva);
  }

  // ─────────────────────────────────────────────
  // Adaptaciones
  // ─────────────────────────────────────────────

  cargarAdaptaciones(activoFijoId: string): void {
    const todas: Adaptacion[] = this.simulation.list('adaptacion') || [];
    this._adaptaciones$.next(todas.filter(a => a.activoFijoId === activoFijoId));
  }

  crearAdaptacion(adaptacion: Adaptacion): Observable<Adaptacion> {
    const nueva: Adaptacion = {
      ...adaptacion,
      id: `adap-${Date.now()}`,
    };
    this.simulation.save('adaptacion', nueva);
    const actualizado: Adaptacion[] = this.simulation.list('adaptacion') || [];
    this._adaptaciones$.next(actualizado.filter(a => a.activoFijoId === adaptacion.activoFijoId));
    return of(nueva);
  }

  // ─────────────────────────────────────────────
  // Historial
  // ─────────────────────────────────────────────

  obtenerHistorial(activoFijoId: string): Observable<HistorialActivoFijo[]> {
    const todo: HistorialActivoFijo[] = this.simulation.list('historialActivoFijo') || [];
    return of(todo.filter(h => h.activoFijoId === activoFijoId));
  }

  registrarHistorial(entry: Omit<HistorialActivoFijo, 'id'>): void {
    const nuevo: HistorialActivoFijo = {
      ...entry,
      id: `hist-${Date.now()}`,
    };
    this.simulation.save('historialActivoFijo', nuevo);
  }
}
