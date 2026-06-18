import { Injectable, signal, computed } from '@angular/core';
import { ReporteTributarioState, initialReporteTributarioState } from './reporte-tributario.state';
import { ReporteTributarioDetalleEntity, ReporteTributarioConsolidadoEntity } from '../domain/models/reporte-tributario.entity';

@Injectable()
export class ReporteTributarioStore {

  private readonly state = signal<ReporteTributarioState>(initialReporteTributarioState);

  // Selectores
  readonly ventas = computed(() => this.state().ventas);
  readonly compras = computed(() => this.state().compras);
  readonly consolidado = computed(() => this.state().consolidado);

  readonly loadingVentas = computed(() => this.state().loadingVentas);
  readonly loadingCompras = computed(() => this.state().loadingCompras);
  readonly loadingConsolidado = computed(() => this.state().loadingConsolidado);

  readonly errorVentas = computed(() => this.state().errorVentas);
  readonly errorCompras = computed(() => this.state().errorCompras);
  readonly errorConsolidado = computed(() => this.state().errorConsolidado);

  readonly isLoading = computed(() =>
    this.state().loadingVentas ||
    this.state().loadingCompras ||
    this.state().loadingConsolidado
  );

  readonly hasError = computed(() =>
    !!this.state().errorVentas ||
    !!this.state().errorCompras ||
    !!this.state().errorConsolidado
  );

  // Mutadores de loading
  setLoadingVentas(value: boolean) {
    this.state.update(s => ({ ...s, loadingVentas: value }));
  }

  setLoadingCompras(value: boolean) {
    this.state.update(s => ({ ...s, loadingCompras: value }));
  }

  setLoadingConsolidado(value: boolean) {
    this.state.update(s => ({ ...s, loadingConsolidado: value }));
  }

  // Mutadores de datos
  setVentas(ventas: ReporteTributarioDetalleEntity[]) {
    this.state.update(s => ({ ...s, ventas, errorVentas: null }));
  }

  setCompras(compras: ReporteTributarioDetalleEntity[]) {
    this.state.update(s => ({ ...s, compras, errorCompras: null }));
  }

  setConsolidado(consolidado: ReporteTributarioConsolidadoEntity[]) {
    this.state.update(s => ({ ...s, consolidado, errorConsolidado: null }));
  }

  // Mutadores de error
  setErrorVentas(message: string | null) {
    this.state.update(s => ({ ...s, errorVentas: message, loadingVentas: false }));
  }

  setErrorCompras(message: string | null) {
    this.state.update(s => ({ ...s, errorCompras: message, loadingCompras: false }));
  }

  setErrorConsolidado(message: string | null) {
    this.state.update(s => ({ ...s, errorConsolidado: message, loadingConsolidado: false }));
  }

  clearErrors() {
    this.state.update(s => ({
      ...s,
      errorVentas: null,
      errorCompras: null,
      errorConsolidado: null,
    }));
  }

  resetState() {
    this.state.set(initialReporteTributarioState);
  }
}
