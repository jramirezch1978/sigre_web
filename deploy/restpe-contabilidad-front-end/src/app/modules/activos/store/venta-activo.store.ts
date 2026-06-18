import { Injectable, computed, signal } from '@angular/core';
import { VentaActivoState, initialVentaActivoState } from './venta-activo.state';
import { VentaActivoEntity } from '../domain/models/venta-activo.entity';

@Injectable()
export class VentaActivoStore {
  private readonly _state = signal<VentaActivoState>(initialVentaActivoState);

  // ── Selectores ──────────────────────────────────────────────────────────────
  readonly ventasActivos  = computed(() => this._state().ventasActivos);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly isLoading      = computed(() => this._state().loadingObtener);
  readonly errorObtener   = computed(() => this._state().errorObtener);

  // ── Setters ─────────────────────────────────────────────────────────────────
  setVentasActivos(items: VentaActivoEntity[]) { this._state.update(s => ({ ...s, ventasActivos: items })); }
  setLoadingObtener(v: boolean)                { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setErrorObtener(e: string | null)            { this._state.update(s => ({ ...s, errorObtener: e })); }

  reset() { this._state.set(initialVentaActivoState); }
}
