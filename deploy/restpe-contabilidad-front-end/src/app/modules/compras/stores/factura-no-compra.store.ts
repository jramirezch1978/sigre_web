import { Injectable, signal, computed } from '@angular/core';
import { FacturaNoCompraEntity } from '../domain/models/factura-no-compra.entity';
import { FacturaNoCompraState, initialFacturaNoCompraState } from './factura-no-compra.state';

/**
 * Store de Factura No Compra usando Angular Signals
 * Gestiona el estado reactivo de las facturas no compras
 */
@Injectable()
export class FacturaNoCompraStore {
  private readonly state = signal<FacturaNoCompraState>(initialFacturaNoCompraState);

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
  setFacturas(facturas: FacturaNoCompraEntity[]): void {
    this.state.update((state) => ({ ...state, facturas }));
  }

  setFacturaSeleccionada(factura: FacturaNoCompraEntity | null): void {
    this.state.update((state) => ({ ...state, facturaSeleccionada: factura }));
  }

  agregarFactura(factura: FacturaNoCompraEntity): void {
    this.state.update((state) => ({
      ...state,
      facturas: [...state.facturas, factura],
    }));
  }

  actualizarFacturaEnStore(facturaActualizada: FacturaNoCompraEntity): void {
    this.state.update((state) => ({
      ...state,
      facturas: state.facturas.map((f) =>
        f.factura_no_compra_codigo === facturaActualizada.factura_no_compra_codigo ? facturaActualizada : f
      ),
    }));
  }

  eliminarFacturaDelStore(codigo: string): void {
    this.state.update((state) => ({
      ...state,
      facturas: state.facturas.filter((f) => f.factura_no_compra_codigo !== codigo),
    }));
  }

  // ============ Setters para Loading ============
  setLoading(loading: boolean): void {
    this.state.update((state) => ({ ...state, loading }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingObtener: loading }));
  }

  setLoadingGuardar(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingGuardar: loading }));
  }

  setLoadingActualizar(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingActualizar: loading }));
  }

  setLoadingEliminar(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingEliminar: loading }));
  }

  // ============ Setters para Errores ============
  setError(error: string | null): void {
    this.state.update((state) => ({ ...state, error }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update((state) => ({ ...state, errorObtener: error }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update((state) => ({ ...state, errorGuardar: error }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update((state) => ({ ...state, errorActualizar: error }));
  }

  setErrorEliminar(error: string | null): void {
    this.state.update((state) => ({ ...state, errorEliminar: error }));
  }

  resetState(): void {
    this.state.set(initialFacturaNoCompraState);
  }
}
