import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IConsultaFlujoCajaRepository } from '../../domain/repositories/iconsulta-flujo-caja.repository';
import { ConsultaFlujoCajaEntity } from '../../domain/models/consulta-flujo-caja.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class ConsultaFlujoCajaRepositoryImpl implements IConsultaFlujoCajaRepository {
  private readonly url = 'assets/data/finanzas/consultas/consulta-flujo-caja.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<ConsultaFlujoCajaEntity[]> {
    return this.http.get<ConsultaFlujoCajaEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
