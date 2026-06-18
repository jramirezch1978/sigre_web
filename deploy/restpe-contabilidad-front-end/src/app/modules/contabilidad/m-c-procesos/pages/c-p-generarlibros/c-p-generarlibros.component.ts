import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faDownload } from '@fortawesome/pro-solid-svg-icons';



export interface registro{
  codigo:string,
  nombre:string,
  periodo:string,
  fecha: string,
  usuario: string
  estado: string,
  archivo: string,
}

@Component({
  selector: 'app-c-p-generarlibros',
  templateUrl: './c-p-generarlibros.component.html',
  styleUrls: ['./c-p-generarlibros.component.scss'],
  standalone: false,
})
export class CPGenerarlibrosComponent  implements OnInit {
  // Font Awesome Icons
  fasDownload = faDownload;



  form!: FormGroup;
  fechaEjecucion: Date | undefined;  

  directorio= '';
  entidadtributaria:any;
  registro: registro | null = null;

  tArchivos=[
    { label: 'TXT', value: 'txt' },
    { label: 'XML', value: 'xml' },
    { label: 'XLSX', value: 'xlsx' },
    { label: 'PDF', value: 'pdf' },


  ];
  tlibros:any[]=[];
  countries=ALL_COUNTRIES;
  
  dataReporte:registro ={codigo:'PLE-0801', nombre: 'Rergistro de compras', periodo: '202511', fecha: '15/11/2025, 12:48', usuario: 'Javier Correa', estado: 'Éxito', archivo: 'LE20531256391-20251000080300.txt',}


  constructor(
    private fb: FormBuilder,
    private toastService : ToastService,
    private countryService: CountryService,
  ) {
    
  }

  ngOnInit() {
    this.form = this.fb.group({
      tipoLibro: ['', Validators.required],
      periodoContable: ['', Validators.required],
      tipoArchivo: ['txt', Validators.required],
      directorio: ['C:/Users/…/Carpeta'],
      incluirNul: [false]
    });
    this.form.get('directorio')?.disable();
    // Inicializar la fecha de ejecución con la fecha de hoy
    this.fechaEjecucion = new Date();
    this.setEntidadTributaria();
    this.librocontablesporpais();
  }
  librocontablesporpais(){
    const country = this.countries.find(
    c => c.codigo === this.countryService.getCountryCode()
    );
    this.tlibros= country?.libroscontables || [];
  }
setEntidadTributaria() {
  if (!this.countries || this.countries.length === 0) {
    return;
  }

  const country = this.countries.find(
    c => c.codigo === this.countryService.getCountryCode()
  );

  this.entidadtributaria = country?.entidad || '';
}


  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
    
    let periodoValue = '';
    
    // El evento viene como {month: number, year: number}
    if (event && typeof event === 'object' && event.month && event.year) {
      const year = event.year;
      const month = String(event.month).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (event instanceof Date) {
      const year = event.getFullYear();
      const month = String(event.getMonth() + 1).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (typeof event === 'string') {
      periodoValue = event;
    }
    
    if (periodoValue) {
      this.form.patchValue({ periodoContable: periodoValue });
      console.log('Periodo guardado en formulario:', periodoValue);
    } else {
      console.warn('No se pudo procesar el evento del período:', event);
    }
  }


  onFechaEjecucion(date: Date) {
    console.log('Fecha Ejecucion:', date);
    this.fechaEjecucion = date;  
  }
  
  generarReporte() {
    // VALIDACIÓN 1 — Detectar campos faltantes
    const camposFaltantes: string[] = [];
    
    const tipoLibro = this.form.get('tipoLibro');
    const periodoContable = this.form.get('periodoContable');
    const tipoArchivo = this.form.get('tipoArchivo');

    if (!tipoLibro || !tipoLibro.value) { 
      camposFaltantes.push('Tipo de libro'); 
    }
    if (!periodoContable || !periodoContable.value) { 
      camposFaltantes.push('Período contable'); 
    }
    if (!tipoArchivo || !tipoArchivo.value) { 
      camposFaltantes.push('Tipo de archivo'); 
    }

    if (camposFaltantes.length > 0) {
      const mensaje = `Campos requeridos faltantes: ${camposFaltantes.join(', ')}`;
      this.toastService.danger(mensaje,'',12000);
      return;
    }

    // VALIDACIÓN 2 — Validaciones del formulario
    if (this.form.invalid) {
      this.toastService.danger('Existen errores de validación.',' Corríjalos antes de generar el archivo', 12000);
      return;
    }

    // VALIDACIÓN 3 — Simulamos que hay registros
    const registrosEncontrados = true; // cambia a false para simular

    if (!registrosEncontrados) {
      this.toastService.danger('No existen registros contables en el período seleccionado');
      return;
    }

    // VALIDACIÓN 4 — error de sistema simulado
    const errorSistema = false; // cambia a true para probar

    if (errorSistema) {
      this.toastService.danger('Error al procesar un archivo.',' Contacte a un administrador del sistema', 12000);
      return;
    }

    // ÉXITO: generar reporte
    this.registro = this.dataReporte;
    this.toastService.success('¡Libro generado exitosamente!');
  }
  
  carpetaSeleccionada(event: any) {
    const files = event.target.files;
    if (files.length > 0) {
      const ruta = files[0].webkitRelativePath.split('/')[0];
      this.form.patchValue({ directorio: ruta });
    }
  }
  DescargarArchivo() {
  }

}




