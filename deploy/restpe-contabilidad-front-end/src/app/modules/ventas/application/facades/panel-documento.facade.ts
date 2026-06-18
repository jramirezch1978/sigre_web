import { Injectable, inject } from '@angular/core';
import { ObtenerPanelDocumentoUseCase } from '../usecases/obtener-panel-documento.usecase';
import { PanelDocumentoStore } from '../../store/panel-documento.store';
import { PanelDocumentoEntity } from '../../domain/models/panel-documento.entity';
import { Signal } from '@angular/core';
import { ToastService } from '@ui/services/toast.service';

@Injectable()
export class PanelDocumentoFacade {

  private readonly store     = inject(PanelDocumentoStore);
  private readonly obtenerUC = inject(ObtenerPanelDocumentoUseCase);
  private readonly toastService = inject(ToastService);

  // Selectores
  readonly registros: Signal<PanelDocumentoEntity[]> = this.store.registros;
  readonly isLoading = this.store.isLoading;
  readonly hasError  = this.store.hasError;
  readonly error     = this.store.error;

  cargarReporte(filtros?: { comprobante: string; estadoProv: string; estado: string }): void {
    this.store.setLoading(true);

    this.obtenerUC.execute().subscribe({
      next: (registros) => {
        this.store.setRegistros(registros);
        if (filtros) {
          this.store.filtrarRegistros(filtros);
        }
      },
      error: (err) => {
        this.store.setError(err.message || 'Error al cargar el panel de estados de documento');
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

  filtrarRegistros(filtros: { comprobante: string; estadoProv: string; estado: string }): void {
    this.store.filtrarRegistros(filtros);
  }
}
