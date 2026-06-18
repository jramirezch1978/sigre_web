import { Injectable, signal, computed } from '@angular/core';
import { LiqRendicionEntity } from '../domain/models/liq-rendicion.entity';
import { LiqRendicionState, initialLiqRendicionState } from './liq-rendicion.state';

@Injectable()
export class LiqRendicionStore {
  private readonly _state = signal<LiqRendicionState>(initialLiqRendicionState);

  // ── Selectores ────────────────────────────────────────────────────────────
  readonly liquidaciones = computed(() => this._state().liquidaciones);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly isLoading = computed(
    () => this._state().loadingObtener || this._state().loadingGuardar || this._state().loadingActualizar
  );
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly errorActualizar = computed(() => this._state().errorActualizar);
  readonly guardadoOk = computed(() => this._state().guardadoOk);
  readonly actualizadoOk = computed(() => this._state().actualizadoOk);

  // ── Mutadores ─────────────────────────────────────────────────────────────
  setLiquidaciones(data: LiqRendicionEntity[]) {
    this._state.update(s => ({ ...s, liquidaciones: data }));
  }

  addLiquidacion(entity: LiqRendicionEntity) {
    this._state.update(s => ({ ...s, liquidaciones: [entity, ...s.liquidaciones] }));
  }

  updateLiquidacion(entity: LiqRendicionEntity) {
    this._state.update(s => ({
      ...s,
      liquidaciones: s.liquidaciones.map(l =>
        l.lr_num_liquidacion === entity.lr_num_liquidacion ? entity : l
      ),
    }));
  }

  setLoadingObtener(v: boolean) { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setLoadingGuardar(v: boolean) { this._state.update(s => ({ ...s, loadingGuardar: v })); }
  setLoadingActualizar(v: boolean) { this._state.update(s => ({ ...s, loadingActualizar: v })); }
  setErrorObtener(e: string | null) { this._state.update(s => ({ ...s, errorObtener: e })); }
  setErrorGuardar(e: string | null) { this._state.update(s => ({ ...s, errorGuardar: e })); }
  setErrorActualizar(e: string | null) { this._state.update(s => ({ ...s, errorActualizar: e })); }
  setGuardadoOk(v: boolean) { this._state.update(s => ({ ...s, guardadoOk: v })); }
  setActualizadoOk(v: boolean) { this._state.update(s => ({ ...s, actualizadoOk: v })); }

  reset() { this._state.set(initialLiqRendicionState); }
}
