import { Injectable, inject, signal, computed } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { toSignal } from '@angular/core/rxjs-interop';
import { catchError, map, of, shareReplay } from 'rxjs';

export interface SucursalEntity {
  codigo: string;
  nombre: string;
  direccion?: string;
  ciudad?: string;
  estado: string;
}

export interface EmpleadoEntity {
  codigo: string;
  nombre: string;
  cargo?: string;
  estado: string;
}

export interface CatalogoGenerico {
  id: string;
  codigo: string;
  nombre: string;
  descripcion?: string;
}

export interface AlmacenCatalogo {
  codigo: string;
  nombre: string;
  direccion?: string;
  tipo?: string;
  estado: string;
}

@Injectable({
  providedIn: 'root'
})
export class CatalogosFacade {
  private readonly http = inject(HttpClient);

  // Signals para almacenar los datos
  private readonly _sucursales = signal<SucursalEntity[]>([]);
  private readonly _empleados = signal<EmpleadoEntity[]>([]);
  private readonly _almacenes = signal<AlmacenCatalogo[]>([]);
  private readonly _ciudades = signal<CatalogoGenerico[]>([]);
  private readonly _distritos = signal<CatalogoGenerico[]>([]);
  private readonly _tiposAlmacen = signal<CatalogoGenerico[]>([]);
  private readonly _unidadesMedida = signal<CatalogoGenerico[]>([]);
  private readonly _cargado = signal<boolean>(false);

  // Computed signals para sucursales activas
  readonly sucursalesActivas = computed(() => 
    this._sucursales().filter(s => s.estado === 'Activo')
  );

  // Computed signals para empleados activos
  readonly empleadosActivos = computed(() => 
    this._empleados().filter(e => e.estado === 'Activo')
  );

  // Computed signals para almacenes activos
  readonly almacenesActivos = computed(() => 
    this._almacenes().filter(a => a.estado === 'Activo')
  );

  // Exposición de catálogos
  readonly sucursales = this._sucursales.asReadonly();
  readonly empleados = this._empleados.asReadonly();
  readonly almacenes = this._almacenes.asReadonly();
  readonly ciudades = this._ciudades.asReadonly();
  readonly distritos = this._distritos.asReadonly();
  readonly tiposAlmacen = this._tiposAlmacen.asReadonly();
  readonly unidadesMedida = this._unidadesMedida.asReadonly();
  readonly cargado = this._cargado.asReadonly();

  /**
   * Inicializa todos los catálogos compartidos
   * Se ejecuta una sola vez y cachea los resultados
   */
  inicializarCatalogos(): void {
    // Si ya están cargados, no volver a cargar
    if (this._cargado()) {
      console.log('  Catálogos ya inicializados, usando cache');
      return;
    }

    console.log('  Inicializando catálogos compartidos...');

    // Cargar sucursales
    this.cargarSucursales();

    // Cargar empleados
    this.cargarEmpleados();

    // Cargar almacenes
    this.cargarAlmacenes();

    // Cargar catálogos estáticos
    this.inicializarCatalogosEstaticos();

    this._cargado.set(true);
  }

  /**
   * Carga las sucursales desde assets/data
   */
  private cargarSucursales(): void {
    // Datos de ejemplo - En producción, cargar desde assets o API
    const sucursalesData: SucursalEntity[] = [
      { codigo: '1', nombre: 'Sucursal Central', direccion: 'Av. Principal 123', ciudad: 'Lima', estado: 'Activo' },
      { codigo: '2', nombre: 'Sucursal Norte', direccion: 'Jr. Los Olivos 456', ciudad: 'Lima', estado: 'Activo' },
      { codigo: '3', nombre: 'Sucursal Sur', direccion: 'Av. San Juan 789', ciudad: 'Lima', estado: 'Activo' },
      { codigo: '4', nombre: 'Sucursal Este', direccion: 'Calle Las Flores 321', ciudad: 'Lima', estado: 'Activo' }
    ];

    this._sucursales.set(sucursalesData);
  }

  /**
   * Carga los empleados desde assets/data
   */
  private cargarEmpleados(): void {
    const empleadosData: EmpleadoEntity[] = [
      { codigo: 'EMP-001', nombre: 'Eduardo Jimenez Lopez', cargo: 'Gerente', estado: 'Activo' },
      { codigo: 'EMP-002', nombre: 'Angel Antero Sandoval More', cargo: 'Almacenero', estado: 'Activo' },
      { codigo: 'EMP-003', nombre: 'Milagros Ontaneda Oblitas', cargo: 'Supervisor', estado: 'Activo' },
      { codigo: 'EMP-004', nombre: 'Mariela Guitierrito Alvarado', cargo: 'Asistente', estado: 'Activo' }
    ];

    this._empleados.set(empleadosData);
  }

  /**
   * Carga los almacenes desde assets/data
   */
  private cargarAlmacenes(): void {
    const almacenesData: AlmacenCatalogo[] = [
      { codigo: 'ALM-001', nombre: 'Almacén Alvarado', direccion: 'Jirón Enrique del Falcao 879', tipo: 'Secundario', estado: 'Activo' },
      { codigo: 'ALM-002', nombre: 'Almacén Principal', direccion: 'Jirón Aguirre Lopez 991', tipo: 'Principal', estado: 'Activo' },
      { codigo: 'ALM-003', nombre: 'Almacén chiquito', direccion: 'Av. del restaurantero 111', tipo: 'Secundaria', estado: 'Inactivo' }
    ];

    this._almacenes.set(almacenesData);
  }

  /**
   * Inicializa catálogos estáticos
   */
  private inicializarCatalogosEstaticos(): void {
    // Ciudades
    const ciudades: CatalogoGenerico[] = [
      { id: 'lima', codigo: 'LIM', nombre: 'Lima' },
      { id: 'piura', codigo: 'PIU', nombre: 'Piura' },
      { id: 'arequipa', codigo: 'AQP', nombre: 'Arequipa' },
      { id: 'cusco', codigo: 'CUS', nombre: 'Cusco' },
      { id: 'trujillo', codigo: 'TRU', nombre: 'Trujillo' }
    ];
    this._ciudades.set(ciudades);

    // Distritos (de Lima y Piura)
    const distritos: CatalogoGenerico[] = [
      { id: 'miraflores', codigo: 'MIR', nombre: 'Miraflores', descripcion: 'Lima' },
      { id: 'sanisidro', codigo: 'SI', nombre: 'San Isidro', descripcion: 'Lima' },
      { id: 'surco', codigo: 'SUR', nombre: 'Surco', descripcion: 'Lima' },
      { id: 'piura', codigo: 'PIU', nombre: 'Piura', descripcion: 'Piura' },
      { id: 'castilla', codigo: 'CAS', nombre: 'Castilla', descripcion: 'Piura' }
    ];
    this._distritos.set(distritos);

    // Tipos de almacén
    const tiposAlmacen: CatalogoGenerico[] = [
      { id: 'principal', codigo: 'PRIN', nombre: 'Principal' },
      { id: 'secundario', codigo: 'SEC', nombre: 'Secundario' },
      { id: 'transito', codigo: 'TRA', nombre: 'Tránsito' },
      { id: 'temporal', codigo: 'TEM', nombre: 'Temporal' }
    ];
    this._tiposAlmacen.set(tiposAlmacen);

    // Unidades de medida
    const unidadesMedida: CatalogoGenerico[] = [
      { id: 'und', codigo: 'UND', nombre: 'Unidad' },
      { id: 'kg', codigo: 'KG', nombre: 'Kilogramo' },
      { id: 'gr', codigo: 'GR', nombre: 'Gramo' },
      { id: 'lt', codigo: 'LT', nombre: 'Litro' },
      { id: 'ml', codigo: 'ML', nombre: 'Mililitro' },
      { id: 'mt', codigo: 'MT', nombre: 'Metro' },
      { id: 'cm', codigo: 'CM', nombre: 'Centímetro' },
      { id: 'cj', codigo: 'CJ', nombre: 'Caja' },
      { id: 'paq', codigo: 'PAQ', nombre: 'Paquete' },
      { id: 'doc', codigo: 'DOC', nombre: 'Docena' }
    ];
    this._unidadesMedida.set(unidadesMedida);
  }

  /**
   * Refresca todos los catálogos (para usar después de cambios)
   */
  refrescarCatalogos(): void {
    this._cargado.set(false);
    this.inicializarCatalogos();
  }
}
