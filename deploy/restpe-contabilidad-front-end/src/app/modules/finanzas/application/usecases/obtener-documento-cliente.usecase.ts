import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IDocumentoClienteRepository } from '../../domain/repositories/idocumento-cliente.repository';
import { DocumentoClienteEntity } from '../../domain/models/documento-cliente.entity';

@Injectable()
export class ObtenerDocumentoClienteUseCase {
  private readonly repository = inject(IDocumentoClienteRepository);

  execute(): Observable<DocumentoClienteEntity[]> {
    return this.repository.obtenerDocumentos();
  }
}
