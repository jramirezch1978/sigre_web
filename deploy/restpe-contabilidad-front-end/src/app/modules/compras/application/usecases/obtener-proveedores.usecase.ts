import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IProveedorRepository, ProveedorFiltro } from '../../domain/repositories/iproveedor.repository';
import { ProveedorEntity } from '../../domain/models/proveedor.entity';

@Injectable()
export class ObtenerProveedoresUseCase {
  private readonly repository = inject(IProveedorRepository);

  execute(filtros?: ProveedorFiltro): Observable<ProveedorEntity[]> {
    return this.repository.obtenerTodos(filtros);
  }
}
