import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IProveedorActivoRepository } from '../../domain/repositories/iproveedor-activo.repository';
import { ProveedorActivoEntity } from '../../domain/models/proveedor-activo.entity';

@Injectable()
export class ObtenerProveedoresActivoUseCase {
  private readonly repository = inject(IProveedorActivoRepository);

  execute(): Observable<ProveedorActivoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
