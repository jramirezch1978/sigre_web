import { Injectable, signal, computed } from '@angular/core';
import { RegistroFacturaEntity } from '../domain/models/registro-factura.entity';
import { RegistroFacturaState, REGISTRO_FACTURA_INITIAL_STATE } from './registro-factura.state';

@Injectable()
export class RegistroFacturaStore {
  private readonly _state = signal<RegistroFacturaState>(REGISTRO_FACTURA_INITIAL_STATE);

  // ── Selectores ─────────────────────────────────────────────────────────────
  readonly facturas = computed(() => this._state().facturas);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly errorActualizar = computed(() => this._state().errorActualizar);

  readonly isLoading = computed(() =>
    this._state().loadingObtener ||
    this._state().loadingGuardar ||
    this._state().loadingActualizar
  );

  // ── Mutaciones ─────────────────────────────────────────────────────────────
  setFacturas(facturas: RegistroFacturaEntity[]): void {
    this._state.update(s => ({ ...s, facturas, loadingObtener: false, errorObtener: null }));
  }

  setLoadingObtener(value: boolean): void {
    this._state.update(s => ({ ...s, loadingObtener: value }));
  }

  setErrorObtener(error: string | null): void {
    this._state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  setLoadingGuardar(value: boolean): void {
    this._state.update(s => ({ ...s, loadingGuardar: value }));
  }

  setErrorGuardar(error: string | null): void {
    this._state.update(s => ({ ...s, errorGuardar: error, loadingGuardar: false }));
  }

  addFactura(factura: RegistroFacturaEntity): void {
    this._state.update(s => ({
      ...s,
      facturas: [factura, ...s.facturas],
      loadingGuardar: false,
      errorGuardar: null,
    }));
  }

  setLoadingActualizar(value: boolean): void {
    this._state.update(s => ({ ...s, loadingActualizar: value }));
  }

  setErrorActualizar(error: string | null): void {
    this._state.update(s => ({ ...s, errorActualizar: error, loadingActualizar: false }));
  }

  updateFactura(factura: RegistroFacturaEntity): void {
    this._state.update(s => ({
      ...s,
      facturas: s.facturas.map(f => f.factura_nro_documento === factura.factura_nro_documento ? factura : f),
      loadingActualizar: false,
      errorActualizar: null,
    }));
  }

  reset(): void {
    this._state.set(REGISTRO_FACTURA_INITIAL_STATE);
  }
}
