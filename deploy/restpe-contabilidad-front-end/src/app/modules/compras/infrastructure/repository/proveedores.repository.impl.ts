import { Injectable, inject } from '@angular/core';
import { Observable, catchError, forkJoin, map, of, switchMap } from 'rxjs';
import {
  IProveedorRepository,
  ProveedorFiltro,
} from '../../domain/repositories/iproveedor.repository';
import {
  CuentaBancariaEntity,
  ProveedorEntity,
} from '../../domain/models/proveedor.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { ApiClientService } from '../../../../core/infrastructure/http/api-client.service';
import { RelacionComercialModeService } from '../services/relacion-comercial-mode.service';

interface ProveedorListItemDto {
  id?: number;
  razonSocial?: string;
  nombreComercial?: string;
  tipoDocIdentidadId?: number;
  nroDocumento?: string;
  direccion?: string;
  telefono?: string;
  email?: string;
  flagEstado?: string;
  contactos?: ProveedorContactoDto[];
  cuentasBancarias?: ProveedorCuentaDto[];
}

interface ProveedorContactoDto {
  id?: number;
  nombre?: string;
  cargo?: string;
  telefono?: string;
  email?: string;
}

interface ProveedorCuentaDto {
  codBanco?: string;
  numeroCuenta?: string;
  cci?: string;
  tipoCuenta?: string;
  monedaCodigo?: string;
  monedaId?: number;
  flagEstado?: string;
}

interface ProveedorPageDto {
  content?: ProveedorListItemDto[];
}

interface ProveedorDetalleDto extends ProveedorListItemDto {
  id?: number;
  contactos?: ProveedorContactoDto[];
  cuentasBancarias?: ProveedorCuentaDto[];
}

interface ContactoRequestDto {
  nombre: string;
  cargo?: string;
  telefono?: string;
  email?: string;
}

interface CuentaBancariaRequestDto {
  codBanco?: string;
  numeroCuenta: string;
  cci?: string;
  monedaId: number;
  tipoCuenta?: string;
}

interface MonedaDto {
  id?: number;
  codigo?: string;
  nombre?: string;
  flagEstado?: string;
}

interface RelacionComercialRequestDto {
  razonSocial: string;
  nombreComercial?: string;
  tipoDocIdentidadId: number;
  nroDocumento: string;
  direccion?: string;
  telefono?: string;
  email?: string;
  esProveedor: boolean;
  esCliente: boolean;
  flagEstado: string;
}

@Injectable({ providedIn: 'root' })
export class ProveedorRepositoryImpl implements IProveedorRepository {
  private readonly api = inject(ApiClientService);
  private readonly modo = inject(RelacionComercialModeService);

  obtenerTodos(filtros?: ProveedorFiltro): Observable<ProveedorEntity[]> {
    const esCliente = this.modo.esCliente();
    return this.api
      .get<ProveedorPageDto | ProveedorListItemDto[]>('/core/relaciones-comerciales', {
        esProveedor: esCliente ? undefined : true,
        esCliente: esCliente ? true : undefined,
        razonSocial: filtros?.razonSocial,
        nroDocumento: filtros?.nroDocumento,
        activo: filtros?.activo,
        page: 0,
        size: 1000,
      })
      .pipe(
        switchMap((response) => {
          const items = this.extraerLista(response);
          if (!items.length) {
            return of([] as ProveedorEntity[]);
          }

          return this.cargarMapaMonedas().pipe(
            switchMap((monedasMap) =>
              forkJoin(
                items.map((item) => {
                  if (!item.id) {
                    return of(this.mapProveedor(item, monedasMap));
                  }

                  return this.api
                    .get<ProveedorDetalleDto>(`/core/relaciones-comerciales/${item.id}`)
                    .pipe(map((detalle) => this.mapProveedor(detalle, monedasMap)));
                })
              )
            )
          );
        })
      );
  }

  obtenerPorCodigo(codigo: string): Observable<ProveedorEntity> {
    return this.obtenerTodos().pipe(
      map((proveedores) => {
        const proveedor = proveedores.find((item) => item.proveedor_codigo === codigo);
        if (!proveedor) {
          throw new Error(`Proveedor con código ${codigo} no encontrado`);
        }
        return proveedor;
      })
    );
  }

  guardar(proveedor: ProveedorEntity): Observable<ApiResponse<ProveedorEntity>> {
    const payload: RelacionComercialRequestDto = {
      razonSocial: proveedor.proveedor_razon_social,
      nombreComercial: proveedor.proveedor_nombre_comercial,
      tipoDocIdentidadId: proveedor.proveedor_tipo_doc_identidad_id ?? 1,
      nroDocumento: proveedor.proveedor_identificacion_fiscal,
      direccion: proveedor.proveedor_direccion_fiscal,
      telefono: proveedor.proveedor_telefono,
      email: proveedor.proveedor_email,
      esProveedor: !this.modo.esCliente(),
      esCliente: this.modo.esCliente(),
      flagEstado: this.mapEstadoToFlag(proveedor.proveedor_estado),
    };

    return this.api.postRaw<ProveedorListItemDto>('/core/relaciones-comerciales', payload).pipe(
      switchMap((response) => {
        const proveedorId = this.parseNumericId(response.data?.id);
        return forkJoin([
          this.sincronizarCuentasBancarias(proveedorId, proveedor.proveedor_cuentas_bancarias),
          this.sincronizarContacto(proveedorId, proveedor),
        ]).pipe(
          switchMap(() => this.api.get<ProveedorDetalleDto>(`/core/relaciones-comerciales/${proveedorId}`)),
          map((detalle) => ({
            ...response,
            data: this.mapProveedor(detalle),
          }))
        );
      })
    );
  }

  actualizar(proveedor: ProveedorEntity): Observable<ApiResponse<ProveedorEntity>> {
    const proveedorId = this.parseNumericId(proveedor.id ?? proveedor.proveedor_codigo);
    const payload: RelacionComercialRequestDto = {
      razonSocial: proveedor.proveedor_razon_social,
      nombreComercial: proveedor.proveedor_nombre_comercial,
      tipoDocIdentidadId: proveedor.proveedor_tipo_doc_identidad_id ?? 1,
      nroDocumento: proveedor.proveedor_identificacion_fiscal,
      direccion: proveedor.proveedor_direccion_fiscal,
      telefono: proveedor.proveedor_telefono,
      email: proveedor.proveedor_email,
      esProveedor: !this.modo.esCliente(),
      esCliente: this.modo.esCliente(),
      flagEstado: this.mapEstadoToFlag(proveedor.proveedor_estado),
    };

    return this.api.put<ProveedorListItemDto>(`/core/relaciones-comerciales/${proveedorId}`, payload).pipe(
      switchMap(() =>
        this.api.get<ProveedorDetalleDto>(`/core/relaciones-comerciales/${proveedorId}`).pipe(
          switchMap((detalleActual) =>
            forkJoin([
              this.sincronizarCuentasBancarias(
                proveedorId,
                proveedor.proveedor_cuentas_bancarias,
                detalleActual.cuentasBancarias ?? []
              ),
              this.sincronizarContacto(proveedorId, proveedor, detalleActual.contactos ?? []),
            ]).pipe(
              switchMap(() => this.api.get<ProveedorDetalleDto>(`/core/relaciones-comerciales/${proveedorId}`))
            )
          )
        )
      ),
      map((detalle) => ({
        success: true,
        message: 'Proveedor actualizado correctamente',
        data: this.mapProveedor(detalle),
      }))
    );
  }

  eliminar(codigo: string): Observable<ApiResponse<boolean>> {
    const proveedorId = this.parseNumericId(codigo);
    // Baja lógica: se desactiva el proveedor (flagEstado=0) en lugar de eliminarlo físicamente.
    return this.api
      .patch<unknown>(`/core/relaciones-comerciales/${proveedorId}/desactivar`, {})
      .pipe(
        map(() => ({
          success: true,
          message: 'Proveedor dado de baja correctamente',
          data: true,
        }))
      );
  }

  private extraerLista(
    response: ProveedorPageDto | ProveedorListItemDto[] | null | undefined
  ): ProveedorListItemDto[] {
    if (Array.isArray(response)) {
      return response;
    }

    if (Array.isArray(response?.content)) {
      return response.content;
    }

    return [];
  }

  private mapProveedor(item: ProveedorListItemDto, monedasMap?: Map<number, string>): ProveedorEntity {
    const contacto = item.contactos?.[0];

    return {
      id: item.id,
      proveedor_codigo: item.id ? String(item.id) : item.nroDocumento ?? '',
      proveedor_razon_social: item.razonSocial ?? '',
      proveedor_identificacion_fiscal: item.nroDocumento ?? '',
      proveedor_tipo_doc_identidad_id: item.tipoDocIdentidadId,
      proveedor_estado: item.flagEstado === '1' ? 'Activo' : 'Inactivo',
      proveedor_condicion_pago: '',
      proveedor_nombre_comercial: item.nombreComercial ?? '',
      proveedor_direccion_fiscal: item.direccion ?? '',
      proveedor_email: item.email ?? '',
      proveedor_telefono: item.telefono ?? '',
      proveedor_nombre_contacto: contacto?.nombre ?? '',
      proveedor_cargo_contacto: contacto?.cargo ?? '',
      proveedor_telefono_contacto: contacto?.telefono ?? '',
      proveedor_email_contacto: contacto?.email ?? '',
      proveedor_cuentas_bancarias: (item.cuentasBancarias ?? []).map((cuenta) =>
        this.mapCuentaBancaria(cuenta, monedasMap)
      ),
    };
  }

  private mapCuentaBancaria(cuenta: ProveedorCuentaDto, monedasMap?: Map<number, string>): CuentaBancariaEntity {
    return {
      cuenta_bancaria_banco: cuenta.codBanco ?? '',
      cuenta_bancaria_numero_cuenta: cuenta.numeroCuenta ?? '',
      cuenta_bancaria_cci: cuenta.cci ?? '',
      cuenta_bancaria_tipo: this.mapTipoCuentaLabel(cuenta.tipoCuenta),
      cuenta_bancaria_moneda: this.resolverMonedaCodigo(cuenta.monedaCodigo, cuenta.monedaId, monedasMap),
      cuenta_bancaria_estado: cuenta.flagEstado === '0' ? 'Inactivo' : 'Activo',
    };
  }

  /** Resuelve el código/nombre de moneda a partir del id usando el catálogo cargado. */
  private resolverMonedaCodigo(
    monedaCodigo: string | undefined,
    monedaId: number | undefined,
    monedasMap?: Map<number, string>
  ): string {
    if (monedaCodigo) {
      return monedaCodigo;
    }
    if (monedaId != null) {
      const delCatalogo = monedasMap?.get(Number(monedaId));
      if (delCatalogo) {
        return delCatalogo;
      }
      // Fallback por convención de IDs conocidos.
      const fallback: Record<number, string> = { 1: 'Soles', 2: 'Dólares', 3: 'Euros' };
      return fallback[Number(monedaId)] ?? String(monedaId);
    }
    return '';
  }

  /** Convierte el código de tipo de cuenta del backend a una etiqueta legible. */
  private mapTipoCuentaLabel(tipo: string | undefined): string {
    const valor = this.normalizar(tipo);
    if (!valor) {
      return '';
    }
    const mapa: Record<string, string> = {
      corriente: 'Corriente',
      ahorros: 'Ahorros',
      ahorro: 'Ahorros',
      detraccion: 'Detracción',
      cts: 'CTS',
      plazo_fijo: 'Plazo fijo',
      'plazo fijo': 'Plazo fijo',
    };
    return mapa[valor] ?? (tipo ?? '');
  }

  /** Carga el catálogo de monedas como mapa id -> código/nombre. */
  private cargarMapaMonedas(): Observable<Map<number, string>> {
    return this.api.get<MonedaDto[] | { content?: MonedaDto[] }>('/core/monedas').pipe(
      map((response) => {
        const monedas = this.extraerMonedas(response);
        const mapa = new Map<number, string>();
        monedas.forEach((m) => {
          if (m.id != null) {
            mapa.set(Number(m.id), m.codigo ?? m.nombre ?? String(m.id));
          }
        });
        return mapa;
      }),
      catchError(() => of(new Map<number, string>()))
    );
  }

  private mapEstadoToFlag(estado?: string): string {
    return estado?.toLowerCase() === 'inactivo' ? '0' : '1';
  }

  private sincronizarContacto(
    proveedorId: number,
    proveedor: ProveedorEntity,
    contactosExistentes: ProveedorContactoDto[] = []
  ): Observable<unknown> {
    const nombre = proveedor.proveedor_nombre_contacto?.trim();
    if (!nombre) {
      return of(null);
    }

    const payload: ContactoRequestDto = {
      nombre,
      cargo: proveedor.proveedor_cargo_contacto?.trim() || undefined,
      telefono: proveedor.proveedor_telefono_contacto || undefined,
      email: proveedor.proveedor_email_contacto || undefined,
    };

    // Si ya hay un contacto registrado, lo ACTUALIZAMOS (PUT) en lugar de crear
    // uno nuevo. Antes solo se hacía POST y se omitía cuando nombre+email
    // coincidían, por lo que editar cargo/teléfono/email nunca se reflejaba.
    const existente = contactosExistentes.find((contacto) => contacto.id != null);
    if (existente?.id != null) {
      return this.api.put<ProveedorContactoDto>(
        `/core/relaciones-comerciales/${proveedorId}/contactos/${existente.id}`,
        payload
      );
    }

    return this.api.postRaw<ProveedorContactoDto>(
      `/core/relaciones-comerciales/${proveedorId}/contactos`,
      payload
    );
  }

  private sincronizarCuentasBancarias(
    proveedorId: number,
    cuentas: CuentaBancariaEntity[] | undefined,
    cuentasExistentes: ProveedorCuentaDto[] = []
  ): Observable<unknown[]> {
    const cuentasValidas = (cuentas ?? []).filter((cuenta) =>
      String(cuenta.cuenta_bancaria_numero_cuenta ?? '').trim()
    );
    if (!cuentasValidas.length) {
      return of([]);
    }

    return this.api.get<MonedaDto[] | { content?: MonedaDto[] }>('/core/monedas').pipe(
      switchMap((respuestaMonedas) => {
        const monedas = this.extraerMonedas(respuestaMonedas);
        const requests = cuentasValidas
          .filter((cuenta) => !this.existeCuentaBancaria(cuenta, cuentasExistentes))
          .map((cuenta) => {
            const payload: CuentaBancariaRequestDto = {
              codBanco: this.mapBancoCodigo(cuenta.cuenta_bancaria_banco),
              numeroCuenta: String(cuenta.cuenta_bancaria_numero_cuenta ?? '').trim(),
              cci: String(cuenta.cuenta_bancaria_cci ?? '').trim() || undefined,
              monedaId: this.resolverMonedaId(cuenta.cuenta_bancaria_moneda, monedas),
              tipoCuenta: this.mapTipoCuenta(cuenta.cuenta_bancaria_tipo),
            };

            return this.api.postRaw<ProveedorCuentaDto>(
              `/core/relaciones-comerciales/${proveedorId}/cuentas-bancarias`,
              payload
            );
          });

        return requests.length ? forkJoin(requests) : of([]);
      })
    );
  }

  private existeCuentaBancaria(
    cuenta: CuentaBancariaEntity,
    existentes: ProveedorCuentaDto[]
  ): boolean {
    return existentes.some(
      (item) =>
        String(item.numeroCuenta ?? '').trim() === String(cuenta.cuenta_bancaria_numero_cuenta ?? '').trim() &&
        String(item.cci ?? '').trim() === String(cuenta.cuenta_bancaria_cci ?? '').trim()
    );
  }

  /** Normaliza la respuesta de monedas (arreglo o página { content: [] }) a un arreglo. */
  private extraerMonedas(response: MonedaDto[] | { content?: MonedaDto[] } | null | undefined): MonedaDto[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content as MonedaDto[];
    }
    return [];
  }

  private resolverMonedaId(moneda: string | undefined, monedas: MonedaDto[]): number {
    const valor = this.normalizar(moneda);
    const encontrada = monedas.find((item) => {
      const codigo = this.normalizar(item.codigo);
      const nombre = this.normalizar(item.nombre);
      return codigo === valor || nombre === valor;
    });

    if (encontrada?.id) {
      return Number(encontrada.id);
    }

    if (valor.includes('dolar') || valor === 'usd') {
      return 2;
    }

    if (valor.includes('euro') || valor === 'eur') {
      return 3;
    }

    return 1;
  }

  private mapBancoCodigo(banco: string | undefined): string | undefined {
    const valor = this.normalizar(banco);
    const mapa: Record<string, string> = {
      bcp: 'BCP',
      bbva: 'BBV',
      interbank: 'IBK',
      scotiabank: 'SCO',
      banbif: 'BIF',
      pichincha: 'PIC',
      gnb: 'GNB',
      falabella: 'FAL',
      ripley: 'RIP',
      santander: 'SAN',
      citibank: 'CIT',
    };

    return mapa[valor] ?? (String(banco ?? '').trim() || undefined);
  }

  private mapTipoCuenta(tipoCuenta: string | undefined): string | undefined {
    const valor = this.normalizar(tipoCuenta);
    const mapa: Record<string, string> = {
      corriente: 'CORRIENTE',
      ahorros: 'AHORROS',
      detraccion: 'DETRACCION',
      cts: 'CTS',
      'plazo fijo': 'PLAZO_FIJO',
    };

    return mapa[valor] ?? tipoCuenta?.toUpperCase().replace(/\s+/g, '_') ?? undefined;
  }

  private normalizar(valor: string | undefined): string {
    return String(valor ?? '')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .trim()
      .toLowerCase();
  }

  private parseNumericId(value: string | number | undefined): number {
    const parsed = Number(value);
    if (!Number.isFinite(parsed) || parsed <= 0) {
      throw new Error(`No se pudo resolver el id del proveedor: ${value ?? 'sin valor'}`);
    }
    return parsed;
  }
}
