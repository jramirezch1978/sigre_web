import { Injectable, signal, computed } from '@angular/core';
import { FacturacionRegaliasState, initialFacturacionRegaliasState } from './facturacion-regalias.state';
import { FacturacionRegaliasEntity } from '../domain/models/facturacion-regalias.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class FacturacionRegaliasStore {

  private readonly state = signal<FacturacionRegaliasState>(initialFacturacionRegaliasState);

  // Selectores
  readonly facturas = computed(() => this.state().facturas);
  readonly facturaSeleccionada = computed(() => this.state().facturaSeleccionada);

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar = computed(() => this.state().loadingGuardar);
  readonly loadingAnular = computed(() => this.state().loadingAnular);

  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorGuardar = computed(() => this.state().errorGuardar);
  readonly errorAnular = computed(() => this.state().errorAnular);

  readonly resultGuardar = computed(() => this.state().resultGuardar);
  readonly resultAnular = computed(() => this.state().resultAnular);

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingAnular
  );

  readonly hasError = computed(() =>
    !!this.state().errorObtener ||
    !!this.state().errorGuardar ||
    !!this.state().errorAnular
  );

  // Mutadores de loading
  setLoadingObtener(value: boolean) {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setLoadingGuardar(value: boolean) {
    this.state.update(s => ({ ...s, loadingGuardar: value }));
  }

  setLoadingAnular(value: boolean) {
    this.state.update(s => ({ ...s, loadingAnular: value }));
  }

  // Mutadores de datos
  setFacturas(facturas: FacturacionRegaliasEntity[]) {
    this.state.update(s => ({ ...s, facturas, errorObtener: null }));
  }

  setFacturaSeleccionada(factura: FacturacionRegaliasEntity | null) {
    this.state.update(s => ({ ...s, facturaSeleccionada: factura }));
  }

  setGuardarResultado(result: ApiResponse<FacturacionRegaliasEntity> | null) {
    this.state.update(s => ({ ...s, resultGuardar: result, errorGuardar: null }));

    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        facturas: [result.data!, ...s.facturas]
      }));
    }
  }

  setAnularResultado(result: ApiResponse<FacturacionRegaliasEntity> | null) {
    this.state.update(s => ({ ...s, resultAnular: result, errorAnular: null }));

    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        facturas: s.facturas.map(f =>
          f.factura_codigo === result.data!.factura_codigo ? result.data! : f
        )
      }));
    }
  }

  // Mutadores de error
  setErrorObtener(message: string | null) {
    this.state.update(s => ({ ...s, errorObtener: message, loadingObtener: false }));
  }

  setErrorGuardar(message: string | null) {
    this.state.update(s => ({ ...s, errorGuardar: message, loadingGuardar: false }));
  }

  setErrorAnular(message: string | null) {
    this.state.update(s => ({ ...s, errorAnular: message, loadingAnular: false }));
  }

  clearErrors() {
    this.state.update(s => ({
      ...s,
      errorObtener: null,
      errorGuardar: null,
      errorAnular: null,
    }));
  }

  resetState() {
    this.state.set(initialFacturacionRegaliasState);
  }
}
