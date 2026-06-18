import { Injectable, signal, computed } from '@angular/core';
import { AsignacionCajaChicaEntity } from '../domain/models/asignacion-caja-chica.entity';
import { AsignacionCajaChicaState, initialAsignacionCajaChicaState } from './asignacion-caja-chica.state';

@Injectable()
export class AsignacionCajaChicaStore {
  private readonly _state = signal<AsignacionCajaChicaState>(initialAsignacionCajaChicaState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly asignaciones = computed(() => this._state().asignaciones);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setAsignaciones(asignaciones: AsignacionCajaChicaEntity[]) {
    this._state.update(s => ({ ...s, asignaciones }));
  }

  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }

  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }

  reset() {
    this._state.set(initialAsignacionCajaChicaState);
  }
}
