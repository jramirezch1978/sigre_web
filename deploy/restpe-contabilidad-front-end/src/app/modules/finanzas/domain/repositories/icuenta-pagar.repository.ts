import { Observable } from 'rxjs';
import { CuentaPagarEntity } from '../models/cuenta-pagar.entity';

export abstract class ICuentaPagarRepository {
  abstract obtenerCuentasPagar(): Observable<CuentaPagarEntity[]>;
}
