import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IMaestroPersonalRepository } from '../../domain/repositories/imaestro-personal.repository';
import { CategoriaLaboralEntity } from '../../domain/models/categoria-laboral.entity';
import { DefinicionAreasJerarquiasEntity } from '../../domain/models/definicion-areas-jerarquias.entity';
import { DefinicionCargosEntity } from '../../domain/models/definicion-cargos.entity';
import { DatosPersonalesEntity } from '../../domain/models/datos-personales.entity';

@Injectable()
export class MaestroPersonalRepositoryImpl extends IMaestroPersonalRepository {
  private readonly categoriasLaboralesUrl = 'assets/data/rr-hh/maestro-de-personal/categorias-laborales.json';
  private readonly definicionAreasJerarquiasUrl = 'assets/data/rr-hh/maestro-de-personal/definicion-areas-jerarquias.json';
  private readonly definicionCargosUrl = 'assets/data/rr-hh/maestro-de-personal/definicion-cargos.json';
  private readonly datosPersonalesUrl = 'assets/data/rr-hh/maestro-de-personal/datos-personales.json';

  constructor(private readonly http: HttpClient) {
    super();
  }

  obtenerCategoriasLaborales(): Observable<CategoriaLaboralEntity[]> {
    return this.http.get<CategoriaLaboralEntity[]>(this.categoriasLaboralesUrl).pipe(delay(1000));
  }

  obtenerDefinicionAreasJerarquias(): Observable<DefinicionAreasJerarquiasEntity[]> {
    return this.http.get<DefinicionAreasJerarquiasEntity[]>(this.definicionAreasJerarquiasUrl).pipe(delay(1000));
  }

  obtenerDefinicionCargos(): Observable<DefinicionCargosEntity[]> {
    return this.http.get<DefinicionCargosEntity[]>(this.definicionCargosUrl).pipe(delay(1000));
  }

  obtenerDatosPersonales(): Observable<DatosPersonalesEntity[]> {
    return this.http.get<DatosPersonalesEntity[]>(this.datosPersonalesUrl).pipe(delay(1000));
  }
}
