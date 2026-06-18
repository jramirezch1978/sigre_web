import { Injectable, signal, computed } from '@angular/core';
import { ProveedorActivoState, initialProveedorActivoState } from './proveedor-activo.state';
import { ProveedorActivoEntity } from '../domain/models/proveedor-activo.entity';

@Injectable()
export class ProveedorActivoStore {
  private readonly state = signal<ProveedorActivoState>(initialProveedorActivoState);

  readonly proveedores     = computed(() => this.state().proveedores);
  readonly loadingObtener  = computed(() => this.state().loadingObtener);
  readonly isLoading       = computed(() => this.state().loadingObtener);
  readonly errorObtener    = computed(() => this.state().errorObtener);

  setProveedores(proveedores: ProveedorActivoEntity[]): void {
    this.state.update(s => ({ ...s, proveedores }));
  }

  setLoadingObtener(value: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error }));
  }
}
