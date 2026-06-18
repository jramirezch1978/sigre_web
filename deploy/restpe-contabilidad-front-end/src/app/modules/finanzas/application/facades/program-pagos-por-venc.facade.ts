import { Injectable, inject } from '@angular/core';
import { ProgramPagosPorVencStore } from '../../store/program-pagos-por-venc.store';
import { ObtenerProgramPagosPorVencUseCase } from '../usecases/obtener-program-pagos-por-venc.usecase';

@Injectable()
export class ProgramPagosPorVencFacade {
  private readonly store = inject(ProgramPagosPorVencStore);
  private readonly obtenerUC = inject(ObtenerProgramPagosPorVencUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly pagos = this.store.pagos;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarPagos(): void {
    this.obtenerUC.execute();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
