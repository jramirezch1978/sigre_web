import { Observable } from 'rxjs';
import { RecepcionAlmacenamientoEntity } from '../models/recepcion-almacenamiento.entity';

export abstract class IOperacionesRepository {
    abstract obtenerRecepcionesAlmacenamiento(): Observable<RecepcionAlmacenamientoEntity[]>;
}
