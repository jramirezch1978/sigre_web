import { Injectable, signal, computed } from '@angular/core';
import { ConsultaCajaBancoEntity } from '../domain/models/consulta-caja-banco.entity';
import {
  ConsultaCajaBancoState,
  initialConsultaCajaBancoState,
} from './consulta-caja-banco.state';

@Injectable()
export class ConsultaCajaBancoStore {
  private readonly _state = signal<ConsultaCajaBancoState>(initialConsultaCajaBancoState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly cuentas = computed(() => this._state().cuentas);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setCuentas(data: ConsultaCajaBancoEntity[]) {
    this._state.update(s => ({ ...s, cuentas: data }));
  }
  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }
  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }
  reset() {
    this._state.set(initialConsultaCajaBancoState);
  }
}
