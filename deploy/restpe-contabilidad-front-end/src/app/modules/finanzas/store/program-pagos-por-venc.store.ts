import { Injectable, signal, computed } from '@angular/core';
import { ProgramPagosPorVencEntity } from '../domain/models/program-pagos-por-venc.entity';
import { ProgramPagosPorVencState, initialProgramPagosPorVencState } from './program-pagos-por-venc.state';

@Injectable()
export class ProgramPagosPorVencStore {
  private readonly _state = signal<ProgramPagosPorVencState>(initialProgramPagosPorVencState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly pagos = computed(() => this._state().pagos);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setPagos(pagos: ProgramPagosPorVencEntity[]) {
    this._state.update(s => ({ ...s, pagos }));
  }

  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }

  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }

  reset() {
    this._state.set(initialProgramPagosPorVencState);
  }
}
