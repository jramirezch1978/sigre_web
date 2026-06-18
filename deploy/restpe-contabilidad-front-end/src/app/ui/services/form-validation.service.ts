import { Injectable } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '../modal-confirmation/modal-confirmation.component';

/**
 * Servicio de Validación de Formularios
 * 
 * Proporciona funcionalidades para detectar cambios en formularios y mostrar
 * modales de confirmación antes de perder datos no guardados.
 * 
 * @example
 * ```typescript
 * // En el componente
 * constructor(private formValidationService: FormValidationService) {}
 * 
 * ngOnInit() {
 *   this.formValidationService.inicializarFormulario(this.miFormulario);
 * }
 * 
 * async onCellClicked(event: any) {
 *   if (await this.formValidationService.validarCambios()) {
 *     // Usuario confirmó continuar
 *     this.cargarDatos(event.data);
 *   }
 * }
 * ```
 */
@Injectable({
  providedIn: 'root'
})
export class FormValidationService {

  private formularioInicial: any = null;
  private formularioModificado: boolean = false;
  private formularioActual: FormGroup | null = null;
  private deteccionPausada: boolean = false;

  constructor(private modalController: ModalController) {}

  /**
   * Inicializa el tracking de cambios para un formulario
   * @param formulario FormGroup a monitorear
   */
  inicializarFormulario(formulario: FormGroup): void {
    this.formularioActual = formulario;
    // Usar getRawValue() para incluir campos deshabilitados
    this.formularioInicial = JSON.parse(JSON.stringify(formulario.getRawValue()));
    this.formularioModificado = false;

    // Suscribirse a cambios del formulario
    formulario.valueChanges.subscribe(() => {
      this.verificarCambios();
    });
  }

  /**
   * Guarda el estado actual del formulario como nuevo estado inicial
   * Se debe llamar después de guardar o cargar datos
   */
  resetearEstado(): void {
    if (this.formularioActual) {
      // Usar getRawValue() para incluir campos deshabilitados
      this.formularioInicial = JSON.parse(JSON.stringify(this.formularioActual.getRawValue()));
      this.formularioModificado = false;
    }
  }

  /**
   * Limpia completamente el tracking del formulario
   */
  limpiarFormulario(): void {
    this.formularioInicial = null;
    this.formularioModificado = false;
    this.formularioActual = null;
  }

  /**
   * Pausa temporalmente la detección de cambios
   * Útil cuando se cargan datos programáticamente
   */
  pausarDeteccion(): void {
    this.deteccionPausada = true;
  }

  /**
   * Reanuda la detección de cambios SIN actualizar el estado inicial
   * Útil cuando cargas datos en el formulario pero quieres detectar cambios posteriores
   */
  reanudarDeteccionSinActualizar(): void {
    this.deteccionPausada = false;
  }

  /**
   * Reanuda la detección de cambios y actualiza el estado inicial
   */
  reanudarDeteccion(): void {
    this.deteccionPausada = false;
    // Actualizar el estado inicial al reanudar
    if (this.formularioActual) {
      this.formularioInicial = JSON.parse(JSON.stringify(this.formularioActual.getRawValue()));
      this.formularioModificado = false;
    }
  }

  /**
   * Verifica si el formulario tiene cambios sin guardar
   * @returns true si hay cambios, false si no
   */
  tieneModificaciones(): boolean {
    return this.formularioModificado;
  }

  /**
   * Obtiene el estado actual para debugging
   */
  obtenerEstado(): { formularioModificado: boolean; deteccionPausada: boolean } {
    return {
      formularioModificado: this.formularioModificado,
      deteccionPausada: this.deteccionPausada
    };
  }

  /**
   * Verifica si el formulario tiene cambios sin guardar
   * @returns true si hay cambios, false si no
   */
  private verificarCambios(): void {
    // No detectar cambios si está pausado
    if (this.deteccionPausada) {
      return;
    }
    
    if (!this.formularioInicial || !this.formularioActual) {
      this.formularioModificado = false;
      return;
    }

    // Usar getRawValue() para incluir campos deshabilitados
    const valorActual = this.formularioActual.getRawValue();
    
    // Comparar como JSON strings para una comparación profunda confiable
    const actualJson = JSON.stringify(valorActual);
    const inicialJson = JSON.stringify(this.formularioInicial);
    
    this.formularioModificado = actualJson !== inicialJson;
  }

  /**
   * Muestra modal de confirmación si hay cambios sin guardar
   * @param config Configuración opcional del modal
   * @returns Promise<boolean> - true si confirma continuar, false si cancela
   */
  async validarCambios(config?: {
    titulo?: string;
    mensaje?: string;
    submensaje?: string;
    btnConfirmar?: string;
    btnCancelar?: string;
  }): Promise<boolean> {
    // Si no hay cambios, permitir continuar
    if (!this.formularioModificado) {
      return true;
    }

    // Mostrar modal de confirmación
    return await this.mostrarModalConfirmacion(config);
  }

  /**
   * Muestra el modal de confirmación
   * @param config Configuración del modal
   * @returns Promise<boolean> - Resultado de la confirmación
   */
  private async mostrarModalConfirmacion(config?: {
    titulo?: string;
    mensaje?: string;
    submensaje?: string;
    btnConfirmar?: string;
    btnCancelar?: string;
  }): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: config?.titulo || 'Continuar sin guardar',
        title: config?.mensaje || '¿Seguro que quieres continuar sin guardar la información?',
        message: config?.submensaje || 'Si continúas, perderás los cambios que has realizado',
        btnOkTxt: config?.btnConfirmar || 'Continuar',
        btnCancelTxt: config?.btnCancelar || 'Cancelar',
      }
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();
    return data === true;
  }

  /**
   * Método para usar con CanDeactivate guard
   * @returns Promise<boolean> - true si puede salir, false si debe quedarse
   */
  async canDeactivate(): Promise<boolean> {
    return await this.validarCambios();
  }

  /**
   * Actualiza el estado inicial con valores específicos
   * Útil cuando se cargan datos en el formulario desde una fuente externa
   * @param valores Valores a establecer como estado inicial
   */
  establecerEstadoInicial(valores: any): void {
    this.formularioInicial = JSON.parse(JSON.stringify(valores));
    this.formularioModificado = false;
  }
}
