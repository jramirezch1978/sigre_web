import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IDocumentoClienteRepository } from '../../domain/repositories/idocumento-cliente.repository';
import { DocumentoClienteEntity } from '../../domain/models/documento-cliente.entity';

@Injectable()
export class DocumentoClienteRepositoryImpl implements IDocumentoClienteRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/reportes/documentos-clientes.json';

  obtenerDocumentos(): Observable<DocumentoClienteEntity[]> {
    return this.http.get<DocumentoClienteEntity[]>(this.url).pipe(delay(800));
  }
}
