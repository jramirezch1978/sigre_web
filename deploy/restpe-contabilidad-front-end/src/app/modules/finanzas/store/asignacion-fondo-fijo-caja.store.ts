import { Injectable, signal, computed } from '@angular/core';
import { AsignacionFondoFijoCajaEntity } from '../domain/models/asignacion-fondo-fijo-caja.entity';
import { AsignacionFondoFijoCajaState, initialAsignacionFondoFijoCajaState } from './asignacion-fondo-fijo-caja.state';

@Injectable()
export class AsignacionFondoFijoCajaStore {
  private readonly _state = signal<AsignacionFondoFijoCajaState>(initialAsignacionFondoFijoCajaState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly asignaciones = computed(() => this._state().asignaciones);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setAsignaciones(asignaciones: AsignacionFondoFijoCajaEntity[]) {
    this._state.update(s => ({ ...s, asignaciones }));
  }

  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }

  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }

  reset() {
    this._state.set(initialAsignacionFondoFijoCajaState);
  }
}
