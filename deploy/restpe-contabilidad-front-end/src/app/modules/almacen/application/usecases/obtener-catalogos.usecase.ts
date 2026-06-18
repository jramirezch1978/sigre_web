import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICatalogosRepository } from '../../domain/repositories/icatalogos.repository';
import { CatalogosEntity } from '../../domain/models/catalogo.entity';

@Injectable()
export class ObtenerCatalogosUseCase {
  private readonly repository = inject(ICatalogosRepository);

  execute(): Observable<CatalogosEntity> {
    return this.repository.obtenerCatalogos();
  }
}
