import { Observable } from 'rxjs';
import { RazonSocialEntity } from '../models/razon-social.entity';

export abstract class IRazonSocialRepository {
  abstract obtenerRazonesSociales(): Observable<RazonSocialEntity[]>;
}
