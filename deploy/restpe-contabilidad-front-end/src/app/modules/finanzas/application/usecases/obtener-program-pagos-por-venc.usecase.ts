import { Injectable, inject } from '@angular/core';
import { IProgramPagosPorVencRepository } from '../../domain/repositories/iprogram-pagos-por-venc.repository';
import { ProgramPagosPorVencStore } from '../../store/program-pagos-por-venc.store';

@Injectable()
export class ObtenerProgramPagosPorVencUseCase {
  private readonly repo = inject(IProgramPagosPorVencRepository);
  private readonly store = inject(ProgramPagosPorVencStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setPagos(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener pagos programados por vencimiento');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
