import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ParamOperacionFacade } from 'src/app/modules/activos/application/facades/param-operacion.facade';
import { ParamOperacionFeedbackEffects } from 'src/app/modules/activos/effects/param-operacion-feedback.effect';
import { ParamOperacionSyncEffects } from 'src/app/modules/activos/effects/param-operacion-sync.effect';
import { ParamOperacionEntity } from 'src/app/modules/activos/domain/models/param-operacion.entity';

@Component({
  selector: 'app-activofijo-tabla-paramoperaciones',
  templateUrl: './activofijo-tabla-paramoperaciones.component.html',
  styleUrls: ['./activofijo-tabla-paramoperaciones.component.scss'],
  standalone: false,
})
export class ActivofijoTablaParamoperacionesComponent implements OnInit, OnDestroy {

  // Inyección del Facade y Effects
  private readonly paramOperacionFacade   = inject(ParamOperacionFacade);
  private readonly paramOperacionFeedback = inject(ParamOperacionFeedbackEffects);
  private readonly paramOperacionSync     = inject(ParamOperacionSyncEffects);
  private readonly toastService           = inject(ToastService);
  readonly isLoading                      = this.paramOperacionFacade.isLoading;

  ParametrosGroup: FormGroup;

  cuentasContables = [
    { id: '10023', nombre: '10023 - Cuentas por pagar' },
    { id: '11011', nombre: '11011 - Bancos' },
    { id: '11015', nombre: '11015 - Proveedores nacionales' },
    { id: '11017', nombre: '11017 - Documentos por pagar' },
    { id: '12001', nombre: '12001 - Mobiliario' },
    { id: '14001', nombre: '14001 - Capital social' },
    { id: '33910', nombre: '33910 - Inmuebles, maquinaria y equipo' },
    { id: '39110', nombre: '39110 - Depreciación acumulada' },
    { id: '68140', nombre: '68140 - Gastos por depreciación' },
  ];

  centrosCosto = [
    { id: 'CC001', nombre: 'CC001 - Recursos Humanos' },
    { id: 'CC002', nombre: 'CC002 - Oficina Administrativa' },
    { id: 'CC003', nombre: 'CC003 - Marketing' },
    { id: 'CC004', nombre: 'CC004 - Operaciones' },
    { id: 'CC005', nombre: 'CC005 - Producción' },
    { id: 'CC006', nombre: 'CC006 - Centro de Soporte' },
  ];

  constructor(private fb: FormBuilder) {
    this.ParametrosGroup = this.fb.group({
      cuentaGlobalActivoFijo: [''],
      metodoDepreciacion: [''],
      previosalcierre: [''],
      observacionesgenerales: [''],
      modificacioncheck: [false],
      correlativomanualcheck: [false],
      formatodenumeracioncheck: [false],
      modulocontablecheck: [false],
      modulocomprascheck: [false],
      moduloinventariocheck: [false],
      formatodenumeracion: [''],
      cuentaGlobalDepreciacion: [''],
      cuentaGastoDepr: [''],
      centroCostoPorDefecto: [''],
      estadoDepreciacion: [''],
      libroContable: ['']
    });

    // Sincronizar store → formulario (Signal effect)
    effect(() => {
      const params = this.paramOperacionFacade.paramOperacionActual();
      if (params) {
        this.ParametrosGroup.patchValue({
          cuentaGlobalActivoFijo:  params.param_op_cuenta_activo_fijo      || '',
          metodoDepreciacion:      params.param_op_metodo_depreciacion     || '',
          previosalcierre:         params.param_op_dias_previos_cierre     || '',
          observacionesgenerales:  params.param_op_observaciones           || '',
          modificacioncheck:       params.param_op_modificacion_post_cierre ?? false,
          correlativomanualcheck:  params.param_op_correlativo_manual      ?? false,
          modulocontablecheck:     params.param_op_modulo_contable         ?? false,
          modulocomprascheck:      params.param_op_modulo_compras          ?? false,
          moduloinventariocheck:   params.param_op_modulo_inventario       ?? false,
          formatodenumeracion:     params.param_op_formato_numeracion      || '',
          cuentaGlobalDepreciacion: params.param_op_cuenta_depreciacion    || '',
          cuentaGastoDepr:         params.param_op_cuenta_gasto_depr       || '',
          centroCostoPorDefecto:   params.param_op_centro_costo            || '',
          estadoDepreciacion:      params.param_op_metodo_depreciacion     || '',
          libroContable:           params.param_op_libro_contable          || ''
        }, { emitEvent: false });
      }
    });
  }

  ngOnInit() {
    // Cargar parámetros desde el repositorio
    this.paramOperacionFacade.cargarParamOperaciones();
  }

  ngOnDestroy(): void {}

  guardarParametros(): void {
    const v = this.ParametrosGroup.value;

    const entidad: ParamOperacionEntity = {
      param_op_codigo:                  'PARAM-001',
      param_op_metodo_depreciacion:     v.estadoDepreciacion         || '',
      param_op_libro_contable:          v.libroContable              || '',
      param_op_cuenta_activo_fijo:      v.cuentaGlobalActivoFijo     || '',
      param_op_cuenta_depreciacion:     v.cuentaGlobalDepreciacion   || '',
      param_op_cuenta_gasto_depr:       v.cuentaGastoDepr            || '',
      param_op_centro_costo:            v.centroCostoPorDefecto      || '',
      param_op_formato_numeracion:      v.formatodenumeracion        || '',
      param_op_correlativo_manual:      v.correlativomanualcheck     ?? false,
      param_op_modulo_contable:         v.modulocontablecheck        ?? false,
      param_op_modulo_compras:          v.modulocomprascheck         ?? false,
      param_op_modulo_inventario:       v.moduloinventariocheck      ?? false,
      param_op_dias_previos_cierre:     v.previosalcierre            || '',
      param_op_modificacion_post_cierre: v.modificacioncheck         ?? false,
      param_op_observaciones:           v.observacionesgenerales     || ''
    };

    const actual = this.paramOperacionFacade.paramOperacionActual();
    if (actual) {
      this.paramOperacionFacade.actualizarParamOperacion(entidad);
    } else {
      this.paramOperacionFacade.guardarParamOperacion(entidad);
    }
  }

  onCuentaGlobalActivoFijoSeleccionada(cuenta: any) {
    if (cuenta && cuenta.id) {
      this.ParametrosGroup.patchValue({ cuentaGlobalActivoFijo: cuenta.id });
    }
  }

  onCuentaGlobalDepreciacionSeleccionada(cuenta: any) {
    if (cuenta && cuenta.id) {
      this.ParametrosGroup.patchValue({ cuentaGlobalDepreciacion: cuenta.id });
    }
  }

  onCuentaGastoDeprSeleccionada(cuenta: any) {
    if (cuenta && cuenta.id) {
      this.ParametrosGroup.patchValue({ cuentaGastoDepr: cuenta.id });
    }
  }

  onCentroCostoSeleccionado(centro: any) {
    if (centro && centro.id) {
      this.ParametrosGroup.patchValue({ centroCostoPorDefecto: centro.id });
    }
  }

}
