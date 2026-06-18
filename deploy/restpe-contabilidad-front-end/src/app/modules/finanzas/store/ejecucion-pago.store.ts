import { Injectable, signal, computed } from '@angular/core';
import { EjecucionPagoEntity } from '../domain/models/ejecucion-pago.entity';
import { EjecucionPagoState, initialEjecucionPagoState } from './ejecucion-pago.state';

@Injectable()
export class EjecucionPagoStore {
  private readonly _state = signal<EjecucionPagoState>(initialEjecucionPagoState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly pagos = computed(() => this._state().pagos);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly loadingAnular = computed(() => this._state().loadingAnular);
  readonly isLoading = computed(
    () => this._state().loadingObtener || this._state().loadingGuardar || this._state().loadingAnular
  );
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly errorAnular = computed(() => this._state().errorAnular);
  readonly guardadoOk = computed(() => this._state().guardadoOk);
  readonly anuladoOk = computed(() => this._state().anuladoOk);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setPagos(pagos: EjecucionPagoEntity[]) {
    this._state.update(s => ({ ...s, pagos }));
  }

  addPago(entity: EjecucionPagoEntity) {
    this._state.update(s => ({ ...s, pagos: [entity, ...s.pagos] }));
  }

  updatePago(entity: EjecucionPagoEntity) {
    this._state.update(s => ({
      ...s,
      pagos: s.pagos.map(p => p.ep_codigo === entity.ep_codigo ? entity : p),
    }));
  }

  anularPago(ep_codigo: string) {
    this._state.update(s => ({
      ...s,
      pagos: s.pagos.map(p => p.ep_codigo === ep_codigo ? { ...p, ep_estado: 'Anulado' } : p),
    }));
  }

  setLoadingObtener(v: boolean) { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setLoadingGuardar(v: boolean) { this._state.update(s => ({ ...s, loadingGuardar: v })); }
  setLoadingAnular(v: boolean) { this._state.update(s => ({ ...s, loadingAnular: v })); }
  setErrorObtener(e: string | null) { this._state.update(s => ({ ...s, errorObtener: e })); }
  setErrorGuardar(e: string | null) { this._state.update(s => ({ ...s, errorGuardar: e })); }
  setErrorAnular(e: string | null) { this._state.update(s => ({ ...s, errorAnular: e })); }
  setGuardadoOk(v: boolean) { this._state.update(s => ({ ...s, guardadoOk: v })); }
  setAnuladoOk(v: boolean) { this._state.update(s => ({ ...s, anuladoOk: v })); }

  reset() {
    this._state.set(initialEjecucionPagoState);
  }
}
