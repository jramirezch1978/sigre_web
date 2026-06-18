import { Injectable, signal, computed } from '@angular/core';
import { ConfiguracionState, initialConfiguracionState } from './configuracion.state';
import { HistorialActualizacionEntity } from '../domain/models/historial-actualizacion.entity';
import { PlanEntity } from '../domain/models/plan.entity';
import { PlantillaNotificacionEntity } from '../domain/models/plantilla-notificacion.entity';
import { CompaniaEntity } from '../domain/models/compania.entity';
import { CanalPagoCobroEntity } from '../domain/models/canal-pago-cobro.entity';
import { CondicionPagoCobroEntity } from '../domain/models/condicion-pago-cobro.entity';
import { CuentaBancariaEntity } from '../domain/models/cuenta-bancaria.entity';
import { EjercicioFiscalEntity } from '../domain/models/ejercicio-fiscal.entity';
import { MonedaEntity } from '../domain/models/moneda.entity';
import { RetencionEntity } from '../domain/models/retencion.entity';
import { UsuarioEntity } from '../domain/models/usuario.entity';
import { SucursalEntity } from '../domain/models/sucursal.entity';

@Injectable()
export class ConfiguracionStore {

  private readonly state = signal<ConfiguracionState>(initialConfiguracionState);

  // Selectores
  readonly historialDatosGenerales = computed(() => this.state().historialDatosGenerales);
  readonly planes = computed(() => this.state().planes);
  readonly plantillasNotificacion = computed(() => this.state().plantillasNotificacion);
  readonly historialPlantillasNotificacion = computed(() => this.state().historialPlantillasNotificacion);
  readonly companias = computed(() => this.state().companias);
  readonly canalesPagoCobro = computed(() => this.state().canalesPagoCobro);
  readonly condicionesPagoCobro = computed(() => this.state().condicionesPagoCobro);
  readonly cuentasBancarias = computed(() => this.state().cuentasBancarias);
  readonly ejerciciosFiscales = computed(() => this.state().ejerciciosFiscales);
  readonly monedas = computed(() => this.state().monedas);
  readonly retenciones = computed(() => this.state().retenciones);
  readonly usuarios = computed(() => this.state().usuarios);
  readonly sucursales = computed(() => this.state().sucursales);
  
  readonly loadingHistorialDatosGenerales = computed(() => this.state().loadingHistorialDatosGenerales);
  readonly loadingPlanes = computed(() => this.state().loadingPlanes);
  readonly loadingPlantillasNotificacion = computed(() => this.state().loadingPlantillasNotificacion);
  readonly loadingHistorialPlantillasNotificacion = computed(() => this.state().loadingHistorialPlantillasNotificacion);
  readonly loadingCompanias = computed(() => this.state().loadingCompanias);
  readonly loadingCanalesPagoCobro = computed(() => this.state().loadingCanalesPagoCobro);
  readonly loadingCondicionesPagoCobro = computed(() => this.state().loadingCondicionesPagoCobro);
  readonly loadingCuentasBancarias = computed(() => this.state().loadingCuentasBancarias);
  readonly loadingEjerciciosFiscales = computed(() => this.state().loadingEjerciciosFiscales);
  readonly loadingMonedas = computed(() => this.state().loadingMonedas);
  readonly loadingRetenciones = computed(() => this.state().loadingRetenciones);
  readonly loadingUsuarios = computed(() => this.state().loadingUsuarios);
  readonly loadingSucursales = computed(() => this.state().loadingSucursales);
  
  readonly errorHistorialDatosGenerales = computed(() => this.state().errorHistorialDatosGenerales);
  readonly errorPlanes = computed(() => this.state().errorPlanes);
  readonly errorPlantillasNotificacion = computed(() => this.state().errorPlantillasNotificacion);
  readonly errorHistorialPlantillasNotificacion = computed(() => this.state().errorHistorialPlantillasNotificacion);
  readonly errorCompanias = computed(() => this.state().errorCompanias);
  readonly errorCanalesPagoCobro = computed(() => this.state().errorCanalesPagoCobro);
  readonly errorCondicionesPagoCobro = computed(() => this.state().errorCondicionesPagoCobro);
  readonly errorCuentasBancarias = computed(() => this.state().errorCuentasBancarias);
  readonly errorEjerciciosFiscales = computed(() => this.state().errorEjerciciosFiscales);
  readonly errorMonedas = computed(() => this.state().errorMonedas);
  readonly errorRetenciones = computed(() => this.state().errorRetenciones);
  readonly errorUsuarios = computed(() => this.state().errorUsuarios);
  readonly errorSucursales = computed(() => this.state().errorSucursales);

  readonly isLoading = computed(() =>
    this.state().loadingHistorialDatosGenerales ||
    this.state().loadingPlanes ||
    this.state().loadingPlantillasNotificacion ||
    this.state().loadingHistorialPlantillasNotificacion ||
    this.state().loadingCompanias ||
    this.state().loadingCanalesPagoCobro ||
    this.state().loadingCondicionesPagoCobro ||
    this.state().loadingCuentasBancarias ||
    this.state().loadingEjerciciosFiscales ||
    this.state().loadingMonedas ||
    this.state().loadingRetenciones ||
    this.state().loadingUsuarios ||
    this.state().loadingSucursales
  );

  readonly hasError = computed(() =>
    !!this.state().errorHistorialDatosGenerales ||
    !!this.state().errorPlanes ||
    !!this.state().errorPlantillasNotificacion ||
    !!this.state().errorHistorialPlantillasNotificacion ||
    !!this.state().errorCompanias ||
    !!this.state().errorCanalesPagoCobro ||
    !!this.state().errorCondicionesPagoCobro ||
    !!this.state().errorCuentasBancarias ||
    !!this.state().errorEjerciciosFiscales ||
    !!this.state().errorMonedas ||
    !!this.state().errorRetenciones ||
    !!this.state().errorUsuarios ||
    !!this.state().errorSucursales
  );

  // Setters para loading
  setLoadingHistorialDatosGenerales(value: boolean) {
    this.state.update((s) => ({ ...s, loadingHistorialDatosGenerales: value }));
  }

  setLoadingPlanes(value: boolean) {
    this.state.update((s) => ({ ...s, loadingPlanes: value }));
  }

  setLoadingPlantillasNotificacion(value: boolean) {
    this.state.update((s) => ({ ...s, loadingPlantillasNotificacion: value }));
  }

  setLoadingHistorialPlantillasNotificacion(value: boolean) {
    this.state.update((s) => ({ ...s, loadingHistorialPlantillasNotificacion: value }));
  }

  setLoadingCompanias(value: boolean) {
    this.state.update((s) => ({ ...s, loadingCompanias: value }));
  }

  setLoadingCanalesPagoCobro(value: boolean) {
    this.state.update((s) => ({ ...s, loadingCanalesPagoCobro: value }));
  }

  setLoadingCondicionesPagoCobro(value: boolean) {
    this.state.update((s) => ({ ...s, loadingCondicionesPagoCobro: value }));
  }

  setLoadingCuentasBancarias(value: boolean) {
    this.state.update((s) => ({ ...s, loadingCuentasBancarias: value }));
  }

  setLoadingEjerciciosFiscales(value: boolean) {
    this.state.update((s) => ({ ...s, loadingEjerciciosFiscales: value }));
  }

  setLoadingMonedas(value: boolean) {
    this.state.update((s) => ({ ...s, loadingMonedas: value }));
  }

  setLoadingRetenciones(value: boolean) {
    this.state.update((s) => ({ ...s, loadingRetenciones: value }));
  }

  setLoadingUsuarios(value: boolean) {
    this.state.update((s) => ({ ...s, loadingUsuarios: value }));
  }

  setLoadingSucursales(value: boolean) {
    this.state.update((s) => ({ ...s, loadingSucursales: value }));
  }

  // Setters para datos
  setHistorialDatosGenerales(historial: HistorialActualizacionEntity[]) {
    this.state.update((s) => ({
      ...s,
      historialDatosGenerales: historial,
      loadingHistorialDatosGenerales: false,
      errorHistorialDatosGenerales: null
    }));
  }

  setPlanes(planes: PlanEntity[]) {
    this.state.update((s) => ({
      ...s,
      planes,
      loadingPlanes: false,
      errorPlanes: null
    }));
  }

  setPlantillasNotificacion(plantillas: PlantillaNotificacionEntity[]) {
    this.state.update((s) => ({
      ...s,
      plantillasNotificacion: plantillas,
      loadingPlantillasNotificacion: false,
      errorPlantillasNotificacion: null
    }));
  }

  setHistorialPlantillasNotificacion(historial: HistorialActualizacionEntity[]) {
    this.state.update((s) => ({
      ...s,
      historialPlantillasNotificacion: historial,
      loadingHistorialPlantillasNotificacion: false,
      errorHistorialPlantillasNotificacion: null
    }));
  }

  setCompanias(companias: CompaniaEntity[]) {
    this.state.update((s) => ({
      ...s,
      companias,
      loadingCompanias: false,
      errorCompanias: null
    }));
  }

  setCanalesPagoCobro(canales: CanalPagoCobroEntity[]) {
    this.state.update((s) => ({
      ...s,
      canalesPagoCobro: canales,
      loadingCanalesPagoCobro: false,
      errorCanalesPagoCobro: null
    }));
  }

  clearCanalesPagoCobro() {
    this.state.update((s) => ({
      ...s,
      canalesPagoCobro: [],
      loadingCanalesPagoCobro: false,
      errorCanalesPagoCobro: null
    }));
  }

  setCondicionesPagoCobro(condiciones: CondicionPagoCobroEntity[]) {
    this.state.update((s) => ({
      ...s,
      condicionesPagoCobro: condiciones,
      loadingCondicionesPagoCobro: false,
      errorCondicionesPagoCobro: null
    }));
  }

  clearCondicionesPagoCobro() {
    this.state.update((s) => ({
      ...s,
      condicionesPagoCobro: [],
      loadingCondicionesPagoCobro: false,
      errorCondicionesPagoCobro: null
    }));
  }

  setCuentasBancarias(cuentas: CuentaBancariaEntity[]) {
    this.state.update((s) => ({
      ...s,
      cuentasBancarias: cuentas,
      loadingCuentasBancarias: false,
      errorCuentasBancarias: null
    }));
  }

  clearCuentasBancarias() {
    this.state.update((s) => ({
      ...s,
      cuentasBancarias: [],
      loadingCuentasBancarias: false,
      errorCuentasBancarias: null
    }));
  }

  setEjerciciosFiscales(ejercicios: EjercicioFiscalEntity[]) {
    this.state.update((s) => ({
      ...s,
      ejerciciosFiscales: ejercicios,
      loadingEjerciciosFiscales: false,
      errorEjerciciosFiscales: null
    }));
  }

  clearEjerciciosFiscales() {
    this.state.update((s) => ({
      ...s,
      ejerciciosFiscales: [],
      loadingEjerciciosFiscales: false,
      errorEjerciciosFiscales: null
    }));
  }

  setMonedas(monedas: MonedaEntity[]) {
    this.state.update((s) => ({
      ...s,
      monedas,
      loadingMonedas: false,
      errorMonedas: null
    }));
  }

  clearMonedas() {
    this.state.update((s) => ({
      ...s,
      monedas: [],
      loadingMonedas: false,
      errorMonedas: null
    }));
  }

  setRetenciones(retenciones: RetencionEntity[]) {
    this.state.update((s) => ({
      ...s,
      retenciones,
      loadingRetenciones: false,
      errorRetenciones: null
    }));
  }

  clearRetenciones() {
    this.state.update((s) => ({
      ...s,
      retenciones: [],
      loadingRetenciones: false,
      errorRetenciones: null
    }));
  }

  setUsuarios(usuarios: UsuarioEntity[]) {
    this.state.update((s) => ({
      ...s,
      usuarios,
      loadingUsuarios: false,
      errorUsuarios: null
    }));
  }

  clearUsuarios() {
    this.state.update((s) => ({
      ...s,
      usuarios: [],
      loadingUsuarios: false,
      errorUsuarios: null
    }));
  }

  setSucursales(sucursales: SucursalEntity[]) {
    this.state.update((s) => ({
      ...s,
      sucursales,
      loadingSucursales: false,
      errorSucursales: null
    }));
  }

  clearSucursales() {
    this.state.update((s) => ({
      ...s,
      sucursales: [],
      loadingSucursales: false,
      errorSucursales: null
    }));
  }

  // Setters para errores
  setErrorHistorialDatosGenerales(error: string) {
    this.state.update((s) => ({
      ...s,
      errorHistorialDatosGenerales: error,
      loadingHistorialDatosGenerales: false
    }));
  }

  setErrorPlanes(error: string) {
    this.state.update((s) => ({
      ...s,
      errorPlanes: error,
      loadingPlanes: false
    }));
  }

  setErrorPlantillasNotificacion(error: string) {
    this.state.update((s) => ({
      ...s,
      errorPlantillasNotificacion: error,
      loadingPlantillasNotificacion: false
    }));
  }

  setErrorHistorialPlantillasNotificacion(error: string) {
    this.state.update((s) => ({
      ...s,
      errorHistorialPlantillasNotificacion: error,
      loadingHistorialPlantillasNotificacion: false
    }));
  }

  setErrorCompanias(error: string) {
    this.state.update((s) => ({
      ...s,
      errorCompanias: error,
      loadingCompanias: false
    }));
  }

  setErrorCanalesPagoCobro(error: string) {
    this.state.update((s) => ({
      ...s,
      errorCanalesPagoCobro: error,
      loadingCanalesPagoCobro: false
    }));
  }

  setErrorCondicionesPagoCobro(error: string) {
    this.state.update((s) => ({
      ...s,
      errorCondicionesPagoCobro: error,
      loadingCondicionesPagoCobro: false
    }));
  }

  setErrorCuentasBancarias(error: string) {
    this.state.update((s) => ({
      ...s,
      errorCuentasBancarias: error,
      loadingCuentasBancarias: false
    }));
  }

  setErrorEjerciciosFiscales(error: string) {
    this.state.update((s) => ({
      ...s,
      errorEjerciciosFiscales: error,
      loadingEjerciciosFiscales: false
    }));
  }

  setErrorMonedas(error: string) {
    this.state.update((s) => ({
      ...s,
      errorMonedas: error,
      loadingMonedas: false
    }));
  }

  setErrorRetenciones(error: string) {
    this.state.update((s) => ({
      ...s,
      errorRetenciones: error,
      loadingRetenciones: false
    }));
  }

  setErrorUsuarios(error: string) {
    this.state.update((s) => ({
      ...s,
      errorUsuarios: error,
      loadingUsuarios: false
    }));
  }

  setErrorSucursales(error: string) {
    this.state.update((s) => ({
      ...s,
      errorSucursales: error,
      loadingSucursales: false
    }));
  }

  // Reset state
  resetState(): void {
    this.state.set(initialConfiguracionState);
  }
}
