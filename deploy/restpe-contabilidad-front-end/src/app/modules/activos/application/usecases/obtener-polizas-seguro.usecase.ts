import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IPolizaSeguroRepository } from '../../domain/repositories/ipoliza-seguro.repository';
import { PolizaSeguroEntity } from '../../domain/models/poliza-seguro.entity';

/**
 * Caso de uso: Obtener listado de pólizas de seguro.
 * SRP: única responsabilidad de solicitar todos los registros al repositorio.
 */
@Injectable()
export class ObtenerPolizasSeguroUseCase {
  private readonly repository = inject(IPolizaSeguroRepository);

  execute(): Observable<PolizaSeguroEntity[]> {
    return this.repository.obtenerTodos();
  }
}
