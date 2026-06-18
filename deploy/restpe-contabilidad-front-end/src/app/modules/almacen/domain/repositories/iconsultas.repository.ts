import { Observable } from 'rxjs';
import { ArticuloConsultaEntity } from '../models/articulo-consulta.entity';
import { OrdenCompraConsultaEntity } from '../models/orden-compra-consulta.entity';
import { DevolucionConsultaEntity } from '../models/devolucion-consulta.entity';
import { KardexConsultaEntity } from '../models/kardex-consulta.entity';
import { PrestamoConsultaEntity } from '../models/prestamo-consulta.entity';

export abstract class IConsultasRepository {
    abstract obtenerConsultaArticulos(): Observable<ArticuloConsultaEntity[]>;
    abstract obtenerConsultaOrdenesCompra(): Observable<OrdenCompraConsultaEntity[]>;
    abstract obtenerConsultaDevoluciones(): Observable<DevolucionConsultaEntity[]>;
    abstract obtenerConsultaKardex(): Observable<KardexConsultaEntity[]>;
    abstract obtenerConsultaPrestamos(): Observable<PrestamoConsultaEntity[]>;
}
