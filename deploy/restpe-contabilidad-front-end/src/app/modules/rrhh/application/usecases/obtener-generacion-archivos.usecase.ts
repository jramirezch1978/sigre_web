import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { GeneracionArchivosEntity } from '../../domain/models/generacion-archivos.entity';

@Injectable()
export class ObtenerGeneracionArchivosUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<GeneracionArchivosEntity[]> {
    return this.repository.obtenerGeneracionArchivos();
  }
}
