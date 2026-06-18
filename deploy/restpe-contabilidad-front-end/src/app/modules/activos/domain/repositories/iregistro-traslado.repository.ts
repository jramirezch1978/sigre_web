import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RegistroTrasladoEntity } from '../models/registro-traslado.entity';

/**
 * Contrato (puerto) del repositorio de Registro de Traslados.
 * SRP: solo define el contrato de acceso a datos para traslados de activos fijos.
 */
@Injectable()
export abstract class IRegistroTrasladoRepository {
  abstract obtenerTodos(): Observable<RegistroTrasladoEntity[]>;
}
