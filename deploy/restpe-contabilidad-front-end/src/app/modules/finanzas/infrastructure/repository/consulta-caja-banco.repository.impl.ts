import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IConsultaCajaBancoRepository } from '../../domain/repositories/iconsulta-caja-banco.repository';
import { ConsultaCajaBancoEntity } from '../../domain/models/consulta-caja-banco.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class ConsultaCajaBancoRepositoryImpl implements IConsultaCajaBancoRepository {
  private readonly url = 'assets/data/finanzas/consultas/consulta-caja-banco.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<ConsultaCajaBancoEntity[]> {
    return this.http.get<ConsultaCajaBancoEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
