import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IConsultaDocumentosRepository } from '../../domain/repositories/iconsulta-documentos.repository';
import { ConsultaDocumentosEntity } from '../../domain/models/consulta-documentos.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class ConsultaDocumentosRepositoryImpl implements IConsultaDocumentosRepository {
  private readonly url = 'assets/data/finanzas/consultas/consulta-documentos.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<ConsultaDocumentosEntity[]> {
    return this.http.get<ConsultaDocumentosEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
