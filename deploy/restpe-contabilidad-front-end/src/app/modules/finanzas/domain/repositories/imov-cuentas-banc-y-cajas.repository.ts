import { Observable } from 'rxjs';
import { MovCuentasBancYCajasEntity } from '../models/mov-cuentas-banc-y-cajas.entity';

export abstract class IMovCuentasBancYCajasRepository {
  abstract obtenerTodos(): Observable<MovCuentasBancYCajasEntity[]>;
}
