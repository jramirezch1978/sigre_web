import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { CarterasCobrosEntity } from '../models/carteras-cobros.entity';

@Injectable()
export abstract class ICarterasCobrosRepository {
  abstract obtenerTodos(): Observable<CarterasCobrosEntity[]>;
  abstract actualizar(entity: CarterasCobrosEntity): Observable<CarterasCobrosEntity>;
}
