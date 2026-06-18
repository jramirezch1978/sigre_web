import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { PolizaSeguroEntity } from '../models/poliza-seguro.entity';

/**
 * Contrato (puerto) del repositorio de Pólizas de Seguro de Activos Fijos.
 * SRP: solo define el contrato de acceso a datos para pólizas de seguro.
 */
@Injectable()
export abstract class IPolizaSeguroRepository {
  abstract obtenerTodos(): Observable<PolizaSeguroEntity[]>;
}
