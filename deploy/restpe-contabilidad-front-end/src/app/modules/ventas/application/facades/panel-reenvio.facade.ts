import { Injectable, inject } from '@angular/core';
import { ObtenerPanelReenvioUseCase } from '../usecases/obtener-panel-reenvio.usecase';
import { PanelReenvioStore } from '../../store/panel-reenvio.store';
import { PanelReenvioEntity } from '../../domain/models/panel-reenvio.entity';
import { Signal } from '@angular/core';
import { ToastService } from '@ui/services/toast.service';

@Injectable()
export class PanelReenvioFacade {

  private readonly store     = inject(PanelReenvioStore);
  private readonly obtenerUC = inject(ObtenerPanelReenvioUseCase);
  private readonly toastService = inject(ToastService);

  // Selectores
  readonly registros: Signal<PanelReenvioEntity[]> = this.store.registros;
  readonly isLoading = this.store.isLoading;
  readonly hasError  = this.store.hasError;
  readonly error     = this.store.error;

  cargarReporte(filtros?: { comprobante: string; tipo: string; estado: string }): void {
    this.store.setLoading(true);

    this.obtenerUC.execute().subscribe({
      next: (registros) => {
        this.store.setRegistros(registros);
        if (filtros) {
          this.store.filtrarRegistros(filtros);
        }
      },
      error: (err) => {
        this.store.setError(err.message || 'Error al cargar el panel de reenvío');
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

  actualizarEstadoRegistro(nroDocumento: string, nuevoEstado: string): void {
    this.store.actualizarEstadoRegistro(nroDocumento, nuevoEstado);
  }

  filtrarRegistros(filtros: { comprobante: string; tipo: string; estado: string }): void {
    this.store.filtrarRegistros(filtros);
  }
}
