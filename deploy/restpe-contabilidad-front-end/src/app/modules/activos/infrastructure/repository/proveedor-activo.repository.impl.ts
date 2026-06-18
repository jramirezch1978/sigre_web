import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IProveedorActivoRepository } from '../../domain/repositories/iproveedor-activo.repository';
import { ProveedorActivoEntity } from '../../domain/models/proveedor-activo.entity';

const PROVEEDOR_JSON_PATH = 'assets/data/compras/tablas/proveedores.json';

@Injectable()
export class ProveedorActivoRepositoryImpl extends IProveedorActivoRepository {

  private readonly http = inject(HttpClient);

  obtenerTodos(): Observable<ProveedorActivoEntity[]> {
    return this.http.get<ProveedorActivoEntity[]>(PROVEEDOR_JSON_PATH).pipe(
      delay(500),
    );
  }
}
