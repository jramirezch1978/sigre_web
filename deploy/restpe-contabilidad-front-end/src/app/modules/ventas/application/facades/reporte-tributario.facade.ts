import { Injectable, inject } from '@angular/core';
import { ObtenerReporteTributarioUseCase } from '../usecases/obtener-reporte-tributario.usecase';
import { ReporteTributarioStore } from '../../store/reporte-tributario.store';

@Injectable()
export class ReporteTributarioFacade {

  private readonly store = inject(ReporteTributarioStore);
  private readonly obtenerUC = inject(ObtenerReporteTributarioUseCase);

  // Selectores
  readonly ventas = this.store.ventas;
  readonly compras = this.store.compras;
  readonly consolidado = this.store.consolidado;

  readonly loadingVentas = this.store.loadingVentas;
  readonly loadingCompras = this.store.loadingCompras;
  readonly loadingConsolidado = this.store.loadingConsolidado;

  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  readonly errorVentas = this.store.errorVentas;
  readonly errorCompras = this.store.errorCompras;
  readonly errorConsolidado = this.store.errorConsolidado;

  cargarReporte(): void {
    this.cargarVentas();
    this.cargarCompras();
    this.cargarConsolidado();
  }

  cargarVentas(): void {
    this.store.setLoadingVentas(true);

    this.obtenerUC.executeVentas().subscribe({
      next: (ventas) => {
        this.store.setVentas(ventas);
      },
      error: (err) => {
        this.store.setErrorVentas(err.message || 'Error al cargar ventas del reporte tributario');
      },
      complete: () => {
        this.store.setLoadingVentas(false);
      }
    });
  }

  cargarCompras(): void {
    this.store.setLoadingCompras(true);

    this.obtenerUC.executeCompras().subscribe({
      next: (compras) => {
        this.store.setCompras(compras);
      },
      error: (err) => {
        this.store.setErrorCompras(err.message || 'Error al cargar compras del reporte tributario');
      },
      complete: () => {
        this.store.setLoadingCompras(false);
      }
    });
  }

  cargarConsolidado(): void {
    this.store.setLoadingConsolidado(true);

    this.obtenerUC.executeConsolidado().subscribe({
      next: (consolidado) => {
        this.store.setConsolidado(consolidado);
      },
      error: (err) => {
        this.store.setErrorConsolidado(err.message || 'Error al cargar consolidado del reporte tributario');
      },
      complete: () => {
        this.store.setLoadingConsolidado(false);
      }
    });
  }

  limpiarErrores(): void {
    this.store.clearErrors();
  }

  resetState(): void {
    this.store.resetState();
  }
}
