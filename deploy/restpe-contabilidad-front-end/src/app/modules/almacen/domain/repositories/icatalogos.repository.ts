import { Observable } from 'rxjs';
import { CatalogosEntity, TransferenciaEntity } from '../models/catalogo.entity';

export abstract class ICatalogosRepository {
  abstract obtenerCatalogos(): Observable<CatalogosEntity>;
  abstract obtenerTransferencias(): Observable<TransferenciaEntity[]>;
}
