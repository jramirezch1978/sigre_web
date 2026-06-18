import { Injectable, inject } from '@angular/core';
import { ConsultaFlujoCajaStore } from '../../store/consulta-flujo-caja.store';
import { ObtenerConsultaFlujoCajaUseCase } from '../usecases/obtener-consulta-flujo-caja.usecase';

@Injectable()
export class ConsultaFlujoCajaFacade {
  private readonly store = inject(ConsultaFlujoCajaStore);
  private readonly obtenerUC = inject(ObtenerConsultaFlujoCajaUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly registros = this.store.registros;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(): void {
    this.obtenerUC.execute();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
