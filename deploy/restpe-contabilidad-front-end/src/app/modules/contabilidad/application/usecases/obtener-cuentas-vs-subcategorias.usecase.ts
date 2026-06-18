import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICuentaVsSubcategoriaRepository } from '../../domain/repositories/icuenta-vs-subcategoria.repository';
import { CuentaVsSubcategoriaEntity } from '../../domain/models/cuenta-vs-subcategoria.entity';

@Injectable()
export class ObtenerCuentasVsSubcategoriasUseCase {
  private readonly repository = inject(ICuentaVsSubcategoriaRepository);

  execute(): Observable<CuentaVsSubcategoriaEntity[]> {
    return this.repository.obtenerTodos();
  }
}
