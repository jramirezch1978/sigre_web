import { Injectable, inject } from '@angular/core';
import { ObtenerReporteVentasUseCase } from '../usecases/obtener-reporte-ventas.usecase';
import { ReporteVentasStore } from '../../store/reporte-ventas.store';
import { ReporteVentasEntity } from '../../domain/models/reporte-ventas.entity';
import { Signal } from '@angular/core';
import { ToastService } from '@ui/services/toast.service';

@Injectable()
export class ReporteVentasFacade {

  private readonly store   = inject(ReporteVentasStore);
  private readonly obtenerUC = inject(ObtenerReporteVentasUseCase);
  private readonly toastService = inject(ToastService);
  // Selectores
  readonly registros: Signal<ReporteVentasEntity[]> = this.store.registros;
  readonly isLoading = this.store.isLoading;
  readonly hasError  = this.store.hasError;
  readonly error     = this.store.error;

  cargarReporte(): void {
    this.store.setLoading(true);

    this.obtenerUC.execute().subscribe({
      next: (registros) => {
        this.store.setRegistros(registros);
      },
      error: (err) => {
        this.store.setError(err.message || 'Error al cargar el reporte de ventas');
      },
      complete: () => {
        this.store.setLoading(false);
        this.toastService.success('¡Reporte generado exitosamente!');
      },
    });
  }

  limpiarError(): void {
    this.store.setError(null);
  }

  resetState(): void {
    this.store.resetState();
  }
}
