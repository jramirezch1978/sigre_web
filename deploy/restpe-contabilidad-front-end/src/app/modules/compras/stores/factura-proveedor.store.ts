import { Injectable, signal, computed } from '@angular/core';
import { FacturaProveedorEntity } from '../domain/models/factura-proveedor.entity';
import { FacturaProveedorState, initialFacturaProveedorState } from './factura-proveedor.state';

/**
 * Store de Facturas de Proveedor usando Angular Signals - Application Layer
 */
@Injectable()
export class FacturaProveedorStore {
  private readonly state = signal<FacturaProveedorState>(initialFacturaProveedorState);

  // Selectores computados (solo lectura)
  readonly facturas = computed(() => this.state().facturas);
  readonly facturaSeleccionada = computed(() => this.state().facturaSeleccionada);
  readonly loading = computed(() => this.state().loading);
  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar = computed(() => this.state().loadingGuardar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);
  readonly loadingEliminar = computed(() => this.state().loadingEliminar);
  readonly error = computed(() => this.state().error);
  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorGuardar = computed(() => this.state().errorGuardar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);
  readonly errorEliminar = computed(() => this.state().errorEliminar);

  // ============ Setters para Facturas ============
  setFacturas(facturas: FacturaProveedorEntity[]): void {
    this.state.update(s => ({ ...s, facturas }));
  }

  setFacturaSeleccionada(factura: FacturaProveedorEntity | null): void {
    this.state.update(s => ({ ...s, facturaSeleccionada: factura }));
  }

  agregarFactura(factura: FacturaProveedorEntity): void {
    this.state.update(s => ({ ...s, facturas: [factura, ...s.facturas] }));
  }

  actualizarFacturaEnStore(facturaActualizada: FacturaProveedorEntity): void {
    this.state.update(s => ({
      ...s,
      facturas: s.facturas.map(f =>
        f.factura_proveedor_codigo === facturaActualizada.factura_proveedor_codigo ? facturaActualizada : f
      ),
    }));
  }

  eliminarFacturaDelStore(codigo: string): void {
    this.state.update(s => ({
      ...s,
      facturas: s.facturas.filter(f => f.factura_proveedor_codigo !== codigo),
    }));
  }

  // ============ Setters para Loading ============
  setLoading(loading: boolean): void {
    this.state.update(s => ({ ...s, loading }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: loading }));
  }

  setLoadingGuardar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingGuardar: loading }));
  }

  setLoadingActualizar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingActualizar: loading }));
  }

  setLoadingEliminar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingEliminar: loading }));
  }

  // ============ Setters para Errores ============
  setError(error: string | null): void {
    this.state.update(s => ({ ...s, error }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update(s => ({ ...s, errorGuardar: error }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update(s => ({ ...s, errorActualizar: error }));
  }

  setErrorEliminar(error: string | null): void {
    this.state.update(s => ({ ...s, errorEliminar: error }));
  }
}
