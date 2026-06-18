import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { SimulationService } from 'src/app/simulation/simulation.service';
import {ModalController} from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';


@Component({
  selector: 'app-modal-crear-atfprod',
  templateUrl: './modal-crear-atfprod.component.html',
  styleUrls: ['./modal-crear-atfprod.component.scss'],
  standalone: false,
})
export class ModalCrearAtfprodComponent  implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;



  productoForm!: FormGroup;
  activofijoForm!: FormGroup;
  tipoSeleccionado: string = 'producto';
  fechaAdquisicion: Date | undefined;

  sucursales = [
    { id: '1', nombre: 'Sucursal Lima Centro' },
    { id: '2', nombre: 'Sucursal Miraflores' },
    { id: '3', nombre: 'Sucursal San Isidro' },
    { id: '4', nombre: 'Sucursal Surco' },
    { id: '5', nombre: 'Sucursal La Molina' }
  ];
  afectai=[
    {value: 'Si', nombre: 'Si'},
    {value: 'No', nombre: 'No'}
  ];
  unidad=[
    {value: 'und', nombre: 'UND'},
    {value: 'kg', nombre: 'KG'},
    {value: 'gr', nombre: 'GR'},
    {value: 'ml', nombre: 'ML'},
    {value: 'l', nombre: 'L'},
  ];
  igv=[
    {value: 'und', nombre: 'UND'},
    {value: 'kg', nombre: 'KG'},
    {value: 'gr', nombre: 'GR'},
    {value: 'ml', nombre: 'ML'},
    {value: 'l', nombre: 'L'},
  ];
  estado=[
    {value: 'activo', nombre: 'Activo'},
    {value: 'inactivo', nombre: 'Inactivo'},
  ];
  
  clasificacion: any[] = [];
  
  monedas=[
    {value: 'Soles', nombre: 'Soles'},
    {value: 'USD', nombre: 'Dólares'},
  ];
  
  cuentasContables: any[] = [];
  
  centrosCosto: any[] = [];
  impuestos: any[] = [];

  constructor(
    private simulation: SimulationService,
    private fb: FormBuilder,
    private modalCtrl: ModalController,
  ) { }

  ngOnInit() {
    this.inicializarFormulario();
    this.cargarCentrosCosto();
    this.cargarImpuestos();
    this.cargarClasificaciones();
    this.cargarCuentasContables();
  }

  /**
   * Inicializar el formulario con todos los campos
   */
  closemodal(){
    // Lógica para cerrar el modal
    this.modalCtrl.dismiss();
  }
  
  crear(){
    if (this.tipoSeleccionado === 'producto') {
      // Validar formulario de producto
      if (this.productoForm.invalid) {
        console.warn('  Formulario de producto inválido');
        return;
      }
      
      // Obtener datos del formulario
      const formValues = this.productoForm.value;
      console.log('  Datos del formulario de producto:', formValues);
      
      // Obtener productos existentes del simulation
      const productosExistentes = this.simulation.list('producto') || [];
      
      // Generar código único para el nuevo producto
      const nuevoCodigoNumero = productosExistentes.length > 0 
        ? Math.max(...productosExistentes.map((r: any) => parseInt(r.codigo?.split('-')[1]) || 0)) + 1 
        : 1;
      const codigo = `PROD-${String(nuevoCodigoNumero).padStart(3, '0')}`;
      
      // Mapear datos del formulario a la estructura esperada por la tabla de maestro productos
      const nuevoProducto = {
        codigo: codigo,
        producto: formValues.nombreProducto,
        descripcion: formValues.nombreProducto, // Agregar descripción para el autocomplete
        naturaleza: 'Inventario', // Valor por defecto, podrías agregarlo al formulario si es necesario
        centroC: formValues.centroCosto,
        sucursalIds: formValues.sucursales,
        sucursal: Array.isArray(formValues.sucursales) && formValues.sucursales.length > 0
          ? `${String(formValues.sucursales.length).padStart(2, '0')} sucursales` 
          : '00 sucursales',
        impuesto: formValues.impuestoPrincipal,
        clase: '', // Podrías agregarlo al formulario si es necesario
        medida: formValues.unidadMedida,
        unidad: formValues.unidadMedida, // Agregar unidad para la orden de compra
        precioUnitario: 0.00, // Precio por defecto, se puede editar después
        observacion: '',
        cuentaCI: '',
        cuentaCC: '',
        cuentaCIG: '',
        porcentajeI: '',
        afectoI: formValues.afectaImpuesto,
        fechaC: new Date().toLocaleDateString('es-PE'),
        estado: formValues.estado === 'activo' ? 'Activo' : 'Inactivo',
        fechaRegistro: new Date().toISOString(),
        id: Date.now().toString()
      };
      
      console.log('  Producto formateado para guardar:', nuevoProducto);
      
      // Guardar el producto usando save() que agrega automáticamente al array
      this.simulation.save('producto', nuevoProducto);
      console.log(' Producto guardado en simulation');
      
      // Cerrar modal y retornar confirmación con el producto creado
      this.modalCtrl.dismiss({
        action: 'created',
        tipo: 'producto',
        data: nuevoProducto
      });
      
    } else if (this.tipoSeleccionado === 'activoFijo') {
      // Validar formulario de activo fijo
      if (this.activofijoForm.invalid) {
        console.warn('  Formulario de activo fijo inválido');
        return;
      }
      
      // Obtener datos del formulario
      const formValues = this.activofijoForm.value;
      console.log('🏢 Datos del formulario de activo fijo:', formValues);
      
      // Obtener activos fijos existentes del simulation
      const activosFijosExistentes = this.simulation.list('activoFijo') || [];
      
      // Generar código único para el nuevo activo fijo (AF-0001, AF-0002, etc.)
      const nuevoCodigoNumero = activosFijosExistentes.length > 0 
        ? Math.max(...activosFijosExistentes.map((r: any) => parseInt(r.codigo?.split('-')[1]) || 0)) + 1 
        : 1;
      const codigo = `AF-${String(nuevoCodigoNumero).padStart(4, '0')}`;
      
      // Formatear fecha de adquisición
      let fechaAdquisicionFormateada = '';
      if (formValues.fechaAdquisicion) {
        const fecha = new Date(formValues.fechaAdquisicion);
        fechaAdquisicionFormateada = fecha.toLocaleDateString('es-PE');
      }
      
      // Mapear datos del formulario a la estructura esperada
      const nuevoActivoFijo = {
        codigo: codigo, // Usar código autogenerado en lugar del formulario
        nombre: formValues.nombreActivo,
        fechaAdquisicion: fechaAdquisicionFormateada,
        clasificacion: formValues.clasificacion,
        cuentaInventario: formValues.cuentaInventario,
        marcaModeloSerie: formValues.marcaModeloSerie,
        moneda: formValues.moneda,
        valorAdquisicion: formValues.valorAdquisicion,
        estado: formValues.estado === 'activo' ? 'Activo' : 'Inactivo',
        fechaRegistro: new Date().toISOString(),
        id: Date.now().toString()
      };
      
      console.log('  Activo fijo formateado para guardar:', nuevoActivoFijo);
      
      // Guardar el activo fijo usando save() que agrega automáticamente al array
      this.simulation.save('activoFijo', nuevoActivoFijo);
      console.log(' Activo fijo guardado en simulation');
      
      // Cerrar modal y retornar confirmación con el activo fijo creado
      this.modalCtrl.dismiss({
        action: 'created',
        tipo: 'activoFijo',
        data: nuevoActivoFijo
      });
    }
  }
  inicializarFormulario() {
    this.productoForm = this.fb.group({
      nombreProducto: ['', Validators.required],
      sucursales: [[]],
      centroCosto: [''],
      afectaImpuesto: ['Si'],
      cuentaInventario: [''],
      cuentaCosto: [''],
      unidadMedida: ['und'],
      impuestoPrincipal: [''],
      estado: ['activo']
    });
    
    this.activofijoForm = this.fb.group({
      fechaAdquisicion: ['', Validators.required],
      nombreActivo: ['', Validators.required],
      cuentaInventario: [''],
      clasificacion: [''],
      marcaModeloSerie: [''],
      moneda: ['Soles'],
      valorAdquisicion: [''],
      estado: ['activo']
    });
  }
  
  /**
   * Cambiar entre formulario de producto y activo fijo
   */
  onTipoChange(tipo: string) {
    this.tipoSeleccionado = tipo;
  }
  
  /**
   * Manejar selección de fecha de adquisición
   */
  onFechaAdquisicion(date: Date) {
    this.fechaAdquisicion = date;
    this.activofijoForm.patchValue({ fechaAdquisicion: date });
  }

  /**
   * Cargar centros de costo desde SimulationService
   */
  cargarCentrosCosto() {
    const centrosLS = this.simulation.list('centroCosto') || [];
    console.log('  Centros de costo cargados:', centrosLS);
    
    // Mapear centros de costo con el formato necesario para el autocomplete
    this.centrosCosto = centrosLS.map((item: any) => ({
      id: item.codigo,
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      ...item
    }));
    
    console.log(' Centros de costo listos para autocomplete:', this.centrosCosto.length);
  }

  /**
   * Cargar impuestos desde SimulationService
   */
  cargarImpuestos() {
    const impuestosLS = this.simulation.list('impuestos') || [];
    console.log('💰 Impuestos cargados:', impuestosLS);
    
    // Mapear impuestos con el formato necesario para el autocomplete
    this.impuestos = impuestosLS.map((item: any) => ({
      id: item.codigo || item.tipo,
      codigo: item.codigo,
      tipo: item.tipo,
      nombre: `${item.tipo} (${item.porcentaje})`,
      porcentaje: item.porcentaje,
      ...item
    }));
    
    console.log(' Impuestos listos para autocomplete:', this.impuestos.length);
  }

  /**
   * Cargar clasificaciones de activos fijos desde SimulationService
   */
  cargarClasificaciones() {
    const clasificacionesLS = this.simulation.list('clasificacionActivos') || [];
    console.log('🏷️ Clasificaciones cargadas:', clasificacionesLS);
    
    // Mapear clasificaciones con el formato necesario para el autocomplete
    this.clasificacion = clasificacionesLS.map((item: any) => ({
      id: item.codigo,
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      ...item
    }));
    
  }

  /**
   * Cargar cuentas contables desde SimulationService
   */
  cargarCuentasContables() {
    const cuentasLS = this.simulation.list('plancontable') || [];
    
    // Mapear cuentas con el formato necesario para el autocomplete
    this.cuentasContables = cuentasLS.map((item: any) => ({
      id: item.codigo,
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      ...item
    }));
    
  }

}
