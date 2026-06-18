import { Injectable, signal, computed } from '@angular/core';
import { ConsultaFlujoCajaEntity } from '../domain/models/consulta-flujo-caja.entity';
import {
  ConsultaFlujoCajaState,
  initialConsultaFlujoCajaState,
} from './consulta-flujo-caja.state';

@Injectable()
export class ConsultaFlujoCajaStore {
  private readonly _state = signal<ConsultaFlujoCajaState>(initialConsultaFlujoCajaState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly registros = computed(() => this._state().registros);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setRegistros(data: ConsultaFlujoCajaEntity[]) {
    this._state.update(s => ({ ...s, registros: data }));
  }
  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }
  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }
  reset() {
    this._state.set(initialConsultaFlujoCajaState);
  }
}
