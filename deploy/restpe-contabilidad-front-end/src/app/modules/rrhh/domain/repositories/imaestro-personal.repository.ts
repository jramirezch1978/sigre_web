import { Observable } from 'rxjs';
import { CategoriaLaboralEntity } from '../models/categoria-laboral.entity';
import { DefinicionAreasJerarquiasEntity } from '../models/definicion-areas-jerarquias.entity';
import { DefinicionCargosEntity } from '../models/definicion-cargos.entity';
import { DatosPersonalesEntity } from '../models/datos-personales.entity';

export abstract class IMaestroPersonalRepository {
  abstract obtenerCategoriasLaborales(): Observable<CategoriaLaboralEntity[]>;
  abstract obtenerDefinicionAreasJerarquias(): Observable<DefinicionAreasJerarquiasEntity[]>;
  abstract obtenerDefinicionCargos(): Observable<DefinicionCargosEntity[]>;
  abstract obtenerDatosPersonales(): Observable<DatosPersonalesEntity[]>;
}
