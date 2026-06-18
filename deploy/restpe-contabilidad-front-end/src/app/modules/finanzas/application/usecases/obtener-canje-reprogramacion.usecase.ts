import { Injectable } from '@angular/core';
import { ICanjeReprogramacionRepository } from '../../domain/repositories/icanje-reprogramacion.repository';
import { CanjeReprogramacionStore } from '../../store/canje-reprogramacion.store';

@Injectable()
export class ObtenerCanjeReprogramacionUseCase {
  constructor(
    private repository: ICanjeReprogramacionRepository,
    private store: CanjeReprogramacionStore,
  ) {}

  execute(): void {
    this.store.setLoadingObtener(true);
    this.repository.obtenerTodos().subscribe({
      next: (registros) => this.store.setRegistros(registros),
      error: (err) => this.store.setErrorObtener(err?.message ?? 'Error al obtener registros'),
    });
  }
}
