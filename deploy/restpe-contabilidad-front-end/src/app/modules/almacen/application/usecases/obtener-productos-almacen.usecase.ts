import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ProductoAlmacenEntity } from '../../domain/models/producto-almacen.entity';

@Injectable()
export class ObtenerProductosAlmacenUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<ProductoAlmacenEntity[]> {
    return this.repository.obtenerProductosAlmacen();
  }
}
