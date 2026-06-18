import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RevaluacionEntity } from '../models/revaluacion.entity';

@Injectable()
export abstract class IRevaluacionRepository {
  abstract obtenerTodos(): Observable<RevaluacionEntity[]>;
}
