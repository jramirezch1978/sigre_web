import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, forkJoin, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { HistorialActualizacionEntity } from '../../domain/models/historial-actualizacion.entity';
import { PlanEntity } from '../../domain/models/plan.entity';
import { PlantillaNotificacionEntity } from '../../domain/models/plantilla-notificacion.entity';
import { CompaniaEntity } from '../../domain/models/compania.entity';
import { CanalPagoCobroEntity } from '../../domain/models/canal-pago-cobro.entity';
import { CondicionPagoCobroEntity } from '../../domain/models/condicion-pago-cobro.entity';
import { CuentaBancariaEntity } from '../../domain/models/cuenta-bancaria.entity';
import { EjercicioFiscalEntity } from '../../domain/models/ejercicio-fiscal.entity';
import { MonedaEntity } from '../../domain/models/moneda.entity';
import { RetencionEntity } from '../../domain/models/retencion.entity';
import { UsuarioEntity } from '../../domain/models/usuario.entity';
import { SucursalEntity } from '../../domain/models/sucursal.entity';

@Injectable({ providedIn: 'root' })
export class ReportesRepositoryImpl implements IReportesRepository {

    private readonly http = inject(HttpClient);
    private readonly JSON_PATH_HISTORIAL_DATOS_GENERALES = 'assets/data/configuracion/ajustes/historial-datos-generales.json';
    private readonly JSON_PATH_PLANES = 'assets/data/configuracion/ajustes/planes.json';
    private readonly JSON_PATH_PLANTILLAS_NOTIFICACION = 'assets/data/configuracion/ajustes/plantillas-notificacion.json';
    private readonly JSON_PATH_HISTORIAL_PLANTILLAS = 'assets/data/configuracion/ajustes/historial-plantillas-notificacion.json';
    private readonly JSON_PATH_COMPANIAS = 'assets/data/configuracion/companias/companias.json';
    private readonly JSON_PATH_CANALES_PAGO_COBRO = 'assets/data/configuracion/localizacion/canales-pago-cobro.json';
    private readonly JSON_PATH_CONDICIONES_PAGO_COBRO = 'assets/data/configuracion/localizacion/condiciones-pago-cobro.json';
    private readonly JSON_PATH_CUENTAS_BANCARIAS = 'assets/data/configuracion/localizacion/cuentas-bancarias.json';
    private readonly JSON_PATH_EJERCICIOS_FISCALES = 'assets/data/configuracion/localizacion/ejercicios-fiscales.json';
    private readonly JSON_PATH_MONEDAS = 'assets/data/configuracion/localizacion/monedas.json';
    private readonly JSON_PATH_RETENCIONES = 'assets/data/configuracion/localizacion/retenciones.json';
    private readonly JSON_PATH_USUARIOS = 'assets/data/configuracion/localizacion/usuarios.json';
    private readonly JSON_PATH_SUCURSALES = 'assets/data/configuracion/localizacion/sucursales.json';

    obtenerHistorialDatosGenerales(): Observable<HistorialActualizacionEntity[]> {
        return this.http.get<HistorialActualizacionEntity[]>(this.JSON_PATH_HISTORIAL_DATOS_GENERALES).pipe(
            delay(1000)
        );
    }

    obtenerPlanes(): Observable<PlanEntity[]> {
        return this.http.get<PlanEntity[]>(this.JSON_PATH_PLANES).pipe(
            delay(1000)
        );
    }

    obtenerPlantillasNotificacion(): Observable<PlantillaNotificacionEntity[]> {
        return this.http.get<PlantillaNotificacionEntity[]>(this.JSON_PATH_PLANTILLAS_NOTIFICACION).pipe(
            delay(1000)
        );
    }

    obtenerHistorialPlantillasNotificacion(): Observable<HistorialActualizacionEntity[]> {
        return this.http.get<HistorialActualizacionEntity[]>(this.JSON_PATH_HISTORIAL_PLANTILLAS).pipe(
            delay(1000)
        );
    }

    obtenerCompanias(): Observable<CompaniaEntity[]> {
        return this.http.get<CompaniaEntity[]>(this.JSON_PATH_COMPANIAS).pipe(
            delay(1000)
        );
    }

    obtenerCanalesPagoCobro(): Observable<CanalPagoCobroEntity[]> {
        return this.http.get<CanalPagoCobroEntity[]>(this.JSON_PATH_CANALES_PAGO_COBRO).pipe(
            delay(1000)
        );
    }

    obtenerCondicionesPagoCobro(): Observable<CondicionPagoCobroEntity[]> {
        return this.http.get<CondicionPagoCobroEntity[]>(this.JSON_PATH_CONDICIONES_PAGO_COBRO).pipe(
            delay(1000)
        );
    }

    obtenerCuentasBancarias(): Observable<CuentaBancariaEntity[]> {
        // Backend real (ms-finanzas) + catálogos banco/moneda para mostrar nombres.
        const base = environment.apiBaseUrl;
        return forkJoin({
            cuentas: this.http.get<any>(`${base}/finanzas/cuentas-bancarias?size=1000`),
            bancos: this.http.get<any>(`${base}/finanzas/bancos?size=1000`),
            monedas: this.http.get<any>(`${base}/core/monedas?size=100`),
        }).pipe(
            map(({ cuentas, bancos, monedas }) => {
                const bancoMap = new Map<number, string>(
                    (bancos?.data?.content ?? []).map((b: any) => [b.id, b.nomBanco ?? b.codBanco ?? '']));
                const monedaMap = new Map<number, string>(
                    (monedas?.data?.content ?? []).map((m: any) => [m.id, m.nombre ?? m.codigo ?? '']));
                return (cuentas?.data?.content ?? []).map((c: any) =>
                    this.toCuentaBancaria(c, bancoMap, monedaMap));
            }),
            catchError(() => of([] as CuentaBancariaEntity[])),
        );
    }

    /** Backend `CuentaBancariaResponse` → entidad de dominio del front. */
    private toCuentaBancaria(c: any, bancoMap: Map<number, string>, monedaMap: Map<number, string>): CuentaBancariaEntity {
        return {
            cuenta_bancaria_id: c.id,
            cuenta_bancaria_codigo: c.codigo ?? '',
            cuenta_bancaria_banco_id: c.bancoId,
            cuenta_bancaria_moneda_id: c.monedaId,
            cuenta_bancaria_plan_contable_det_id: c.planContableDetId,
            cuenta_bancaria_saldo_contable: c.saldoContable != null ? Number(c.saldoContable) : 0,
            cuenta_bancaria_sucursal_id: c.sucursalId ?? undefined,
            cuenta_bancaria_fecha_creacion: c.fecCreacion ?? '',
            cuenta_bancaria_entidad: bancoMap.get(c.bancoId) ?? '',
            cuenta_bancaria_tipo_cuenta: c.tipoCtaBco ?? '',
            cuenta_bancaria_moneda: monedaMap.get(c.monedaId) ?? '',
            cuenta_bancaria_numero_cuenta: c.nroCuenta ?? '',
            cuenta_bancaria_cci: c.nroCci ?? '',
            cuenta_bancaria_cuenta_contable: c.planContableDetId != null ? String(c.planContableDetId) : '',
            cuenta_bancaria_titular: '',
            cuenta_bancaria_flujo_caja: '',
            cuenta_bancaria_descripcion: c.descripcion ?? '',
            cuenta_bancaria_estado: c.flagEstado === '0' ? 'Inactivo' : 'Activo',
            cuenta_bancaria_sucursales: { id: '', nombre: '' },
        };
    }

    obtenerEjerciciosFiscales(): Observable<EjercicioFiscalEntity[]> {
        return this.http.get<EjercicioFiscalEntity[]>(this.JSON_PATH_EJERCICIOS_FISCALES).pipe(
            delay(1000)
        );
    }

    obtenerMonedas(): Observable<MonedaEntity[]> {
        return this.http.get<MonedaEntity[]>(this.JSON_PATH_MONEDAS).pipe(
            delay(1000)
        );
    }

    obtenerRetenciones(): Observable<RetencionEntity[]> {
        return this.http.get<RetencionEntity[]>(this.JSON_PATH_RETENCIONES).pipe(
            delay(1000)
        );
    }

    obtenerUsuarios(): Observable<UsuarioEntity[]> {
        return this.http.get<UsuarioEntity[]>(this.JSON_PATH_USUARIOS).pipe(
            delay(1000)
        );
    }

    obtenerSucursales(): Observable<SucursalEntity[]> {
        return this.http.get<SucursalEntity[]>(this.JSON_PATH_SUCURSALES).pipe(
            delay(1000)
        );
    }
}
