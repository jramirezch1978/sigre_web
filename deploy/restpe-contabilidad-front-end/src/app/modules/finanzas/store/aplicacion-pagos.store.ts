import { Injectable, signal, computed } from '@angular/core';
import { AplicacionPagosEntity } from '../domain/models/aplicacion-pagos.entity';
import { AplicacionPagosPlanillaEntity } from '../domain/models/aplicacion-pagos-planilla.entity';
import { AplicacionPagosTrabajadorEntity } from '../domain/models/aplicacion-pagos-trabajador.entity';
import { AplicacionPagosState, initialAplicacionPagosState } from './aplicacion-pagos.state';

@Injectable()
export class AplicacionPagosStore {
  private readonly _state = signal<AplicacionPagosState>(initialAplicacionPagosState);

  // ── Selectores ────────────────────────────────────────────────────────────
  readonly registros = computed(() => this._state().registros);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly isLoading = computed(
    () => this._state().loadingObtener || this._state().loadingGuardar || this._state().loadingActualizar
      || this._state().loadingPlanillas || this._state().loadingTrabajadores
  );
  readonly planillas = computed(() => this._state().planillas);
  readonly trabajadores = computed(() => this._state().trabajadores);
  readonly loadingPlanillas = computed(() => this._state().loadingPlanillas);
  readonly loadingTrabajadores = computed(() => this._state().loadingTrabajadores);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly errorActualizar = computed(() => this._state().errorActualizar);
  readonly errorPlanillas = computed(() => this._state().errorPlanillas);
  readonly errorTrabajadores = computed(() => this._state().errorTrabajadores);
  readonly guardadoOk = computed(() => this._state().guardadoOk);
  readonly actualizadoOk = computed(() => this._state().actualizadoOk);

  // ── Mutadores ─────────────────────────────────────────────────────────────
  setRegistros(data: AplicacionPagosEntity[]) {
    this._state.update(s => ({ ...s, registros: data }));
  }

  addRegistro(entity: AplicacionPagosEntity) {
    this._state.update(s => ({ ...s, registros: [entity, ...s.registros] }));
  }

  updateRegistro(entity: AplicacionPagosEntity) {
    this._state.update(s => ({
      ...s,
      registros: s.registros.map(r =>
        r.ap_serieNumDoc === entity.ap_serieNumDoc && r.ap_tipoDoc === entity.ap_tipoDoc ? entity : r
      ),
    }));
  }

  setPlanillas(data: AplicacionPagosPlanillaEntity[]) { this._state.update(s => ({ ...s, planillas: data })); }
  setTrabajadores(data: AplicacionPagosTrabajadorEntity[]) { this._state.update(s => ({ ...s, trabajadores: data })); }
  setLoadingObtener(v: boolean) { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setLoadingGuardar(v: boolean) { this._state.update(s => ({ ...s, loadingGuardar: v })); }
  setLoadingActualizar(v: boolean) { this._state.update(s => ({ ...s, loadingActualizar: v })); }
  setLoadingPlanillas(v: boolean) { this._state.update(s => ({ ...s, loadingPlanillas: v })); }
  setLoadingTrabajadores(v: boolean) { this._state.update(s => ({ ...s, loadingTrabajadores: v })); }
  setErrorObtener(e: string | null) { this._state.update(s => ({ ...s, errorObtener: e })); }
  setErrorGuardar(e: string | null) { this._state.update(s => ({ ...s, errorGuardar: e })); }
  setErrorActualizar(e: string | null) { this._state.update(s => ({ ...s, errorActualizar: e })); }
  setErrorPlanillas(e: string | null) { this._state.update(s => ({ ...s, errorPlanillas: e })); }
  setErrorTrabajadores(e: string | null) { this._state.update(s => ({ ...s, errorTrabajadores: e })); }
  setGuardadoOk(v: boolean) { this._state.update(s => ({ ...s, guardadoOk: v })); }
  setActualizadoOk(v: boolean) { this._state.update(s => ({ ...s, actualizadoOk: v })); }

  reset() { this._state.set(initialAplicacionPagosState); }
}
