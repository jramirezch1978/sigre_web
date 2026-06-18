import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IFacturacionRegaliasRepository } from '../../domain/repositories/ifacturacion-regalias.repository';
import { FacturacionRegaliasEntity } from '../../domain/models/facturacion-regalias.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable({ providedIn: 'root' })
export class FacturacionRegaliasRepositoryImpl implements IFacturacionRegaliasRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/ventas/operaciones/facturacion-regalias.json';

  obtenerTodos(): Observable<FacturacionRegaliasEntity[]> {
    return this.http.get<FacturacionRegaliasEntity[]>(this.JSON_PATH).pipe(
      delay(500)
    );
  }

  obtenerPorCodigo(codigo: string): Observable<FacturacionRegaliasEntity> {
    return this.http.get<FacturacionRegaliasEntity[]>(this.JSON_PATH).pipe(
      delay(300),
      map(facturas => {
        const factura = facturas.find(f => f.factura_codigo === codigo);
        if (!factura) {
          throw new Error(`Factura de regalía con código ${codigo} no encontrada`);
        }
        return factura;
      })
    );
  }

  guardar(factura: FacturacionRegaliasEntity): Observable<ApiResponse<FacturacionRegaliasEntity>> {
    return of({
      success: true,
      message: '¡Facturación de regalía registrada exitosamente!',
      data: { ...factura }
    }).pipe(delay(800));
  }

  anular(codigo: string, motivo: string): Observable<ApiResponse<FacturacionRegaliasEntity>> {
    return this.http.get<FacturacionRegaliasEntity[]>(this.JSON_PATH).pipe(
      delay(600),
      map(facturas => {
        const factura = facturas.find(f => f.factura_codigo === codigo);
        if (!factura) {
          throw new Error(`Factura con código ${codigo} no encontrada`);
        }
        const facturaAnulada: FacturacionRegaliasEntity = {
          ...factura,
          factura_estado: 'Anulado',
          factura_observaciones: motivo
        };
        return {
          success: true,
          message: '¡La acción se realizó con éxito!',
          data: facturaAnulada
        } as ApiResponse<FacturacionRegaliasEntity>;
      })
    );
  }
}
