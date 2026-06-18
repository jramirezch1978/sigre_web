import { Injectable, inject } from '@angular/core';
import { IConsultaFlujoCajaRepository } from '../../domain/repositories/iconsulta-flujo-caja.repository';
import { ConsultaFlujoCajaStore } from '../../store/consulta-flujo-caja.store';

@Injectable()
export class ObtenerConsultaFlujoCajaUseCase {
  private readonly repo = inject(IConsultaFlujoCajaRepository);
  private readonly store = inject(ConsultaFlujoCajaStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setRegistros(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener flujo de caja');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
