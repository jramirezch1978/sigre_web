import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { INotaCreditoRepository } from '../../../domain/repositories/inota-credito.repository';
import { NotaCreditoEntity } from '../../../domain/models/nota-credito.entity';

/**
 * Caso de uso: Obtener Notas de Crédito/Débito - Application Layer
 */
@Injectable()
export class ObtenerNotasCreditoUseCase {
  private readonly repository = inject(INotaCreditoRepository);

  execute(): Observable<NotaCreditoEntity[]> {
    return this.repository.obtenerNotas();
  }
}
