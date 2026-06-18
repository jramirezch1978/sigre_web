import { Injectable, signal, computed } from '@angular/core';
import { CondicionPagoState, initialCondicionPagoState } from './condicion-pago.state';
import { CondicionPagoEntity } from '../domain/models/condicion-pago.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class CondicionPagoStore {

  private readonly state = signal<CondicionPagoState>(initialCondicionPagoState);

  readonly condicionesPago = computed(() => this.state().condicionesPago);
  readonly condicionSeleccionada = computed(() => this.state().condicionSeleccionada);

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar = computed(() => this.state().loadingGuardar);
  readonly loadingEliminar = computed(() => this.state().loadingEliminar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);

  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorGuardar = computed(() => this.state().errorGuardar);
  readonly errorEliminar = computed(() => this.state().errorEliminar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);

  readonly resultGuardar = computed(() => this.state().resultGuardar);
  readonly resultEliminar = computed(() => this.state().resultEliminar);
  readonly resultActualizar = computed(() => this.state().resultActualizar);

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingEliminar ||
    this.state().loadingActualizar
  );

  readonly hasError = computed(() =>
    !!this.state().errorObtener ||
    !!this.state().errorGuardar ||
    !!this.state().errorEliminar ||
    !!this.state().errorActualizar
  );

  setCondicionesPago(condiciones: CondicionPagoEntity[]): void {
    this.state.update(s => ({ ...s, condicionesPago: condiciones, errorObtener: null }));
  }

  setCondicionSeleccionada(condicion: CondicionPagoEntity | null): void {
    this.state.update(s => ({ ...s, condicionSeleccionada: condicion }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: loading }));
  }

  setLoadingGuardar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingGuardar: loading }));
  }

  setLoadingEliminar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingEliminar: loading }));
  }

  setLoadingActualizar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingActualizar: loading }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update(s => ({ ...s, errorGuardar: error, loadingGuardar: false }));
  }

  setErrorEliminar(error: string | null): void {
    this.state.update(s => ({ ...s, errorEliminar: error, loadingEliminar: false }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update(s => ({ ...s, errorActualizar: error, loadingActualizar: false }));
  }

  setGuardarResultado(result: ApiResponse<CondicionPagoEntity>): void {
    this.state.update(s => ({ ...s, resultGuardar: result, errorGuardar: null }));
    if (result?.success && result.data) {
      this.state.update(s => ({ ...s, condicionesPago: [...s.condicionesPago, result.data!] }));
    }
  }

  setEliminarResultado(result: ApiResponse<boolean>): void {
    this.state.update(s => ({ ...s, resultEliminar: result, errorEliminar: null }));
  }

  setActualizarResultado(result: ApiResponse<CondicionPagoEntity>): void {
    this.state.update(s => ({ ...s, resultActualizar: result, errorActualizar: null }));
    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        condicionesPago: s.condicionesPago.map(c =>
          c.condicion_pago_codigo === result.data!.condicion_pago_codigo ? result.data! : c
        )
      }));
    }
  }

  resetErrors(): void {
    this.state.update(s => ({
      ...s,
      errorObtener: null,
      errorGuardar: null,
      errorEliminar: null,
      errorActualizar: null
    }));
  }

  resetResults(): void {
    this.state.update(s => ({
      ...s,
      resultGuardar: null,
      resultEliminar: null,
      resultActualizar: null
    }));
  }

  reset(): void {
    this.state.set(initialCondicionPagoState);
  }
}
