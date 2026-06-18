import { Observable } from 'rxjs';
import { ProveedorActivoEntity } from '../models/proveedor-activo.entity';

export abstract class IProveedorActivoRepository {
  abstract obtenerTodos(): Observable<ProveedorActivoEntity[]>;
}
