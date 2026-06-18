import { Injectable } from '@angular/core';
import { CountryService } from 'src/app/ui/services/countryservice.service';

export interface IContableRow {
  orgHierarchy: string[];
  codigo: string;
  descripcion: string;
  naturaleza: string;
  tipo: string;
  movimiento: string;
  nivel: string;
  ctaPadre: string;
  moneda: string;
  vigencia: string;
  estado: string;
  isNivel1?: boolean;
  rTercero?: string;
  reqDoc?: string;
  reqCentro?: string;
  reqSucursal?: string;
  asocImp?: string;
  afectaC?: string;
  asociacion?: string;
  monedap?: string;
  etiqueta?: string;
  plantillaV?: string;
  mapaN?: string;
  vigenciaH?: string;
}

@Injectable({
  providedIn: 'root'
})
export class PlanContableLoaderService {

  constructor(private countryService: CountryService) { }

  /**
   * Carga el plan contable desde un archivo Excel ubicado en assets
   * El archivo se selecciona automáticamente según el país configurado:
   * - PE (Perú): plan-contable-pcge-pe.xlsx
   * - CO (Colombia): plan-contable-pcge-co.xlsx
   * - MX (México): plan-contable-pcge-mx.xlsx
   * @param rutaExcel Ruta personalizada opcional (si no se proporciona, se construye automáticamente)
   * @returns Promise con el array de cuentas procesadas
   */
  async cargarDesdeExcel(rutaExcel?: string): Promise<IContableRow[]> {
    try {
      // Si no se proporciona ruta, construir automáticamente según el país
      if (!rutaExcel) {
        const codigoPais = this.countryService.getCountryCode()?.toLowerCase() || 'pe';
        rutaExcel = `assets/data/plan-contable-pcge-${codigoPais}.xlsx`;
      }

      console.log(' Cargando Excel desde:', rutaExcel);

      // Descargar el archivo Excel
      const response = await fetch(rutaExcel);
      if (!response.ok) {
        throw new Error(`Error al cargar el archivo: ${response.statusText}`);
      }

      const arrayBuffer = await response.arrayBuffer();
      const XLSX = await import('xlsx');
      const workbook = XLSX.read(arrayBuffer, { type: 'array' });

      // Obtener la primera hoja
      const primerHoja = workbook.SheetNames[0];
      const hoja = workbook.Sheets[primerHoja];

      // Convertir a JSON usando el encabezado de la fila 3 (índice 2)
      const datosExcel: any[] = XLSX.utils.sheet_to_json(hoja, { 
        header: 1,
        defval: ''
      });

      console.log('Datos crudos del Excel:', datosExcel.length, 'filas');

      // Procesar los datos
      const cuentasProcesadas = this.procesarDatosExcel(datosExcel);

      console.log('Cuentas procesadas:', cuentasProcesadas.length);
      return cuentasProcesadas;

    } catch (error) {
      console.error(' Error al cargar Excel:', error);
      throw error;
    }
  }

  /**
   * Procesa los datos del Excel y construye la estructura jerárquica
   * @param datosExcel Array de filas del Excel
   * @returns Array de cuentas con jerarquía construida
   */
  private procesarDatosExcel(datosExcel: any[]): IContableRow[] {
    const fechaActual = this.formatearFecha(new Date());

    // Buscar la fila del encabezado (debe contener "CÓDIGO" en la columna A)
    let indiceEncabezado = -1;
    for (let i = 0; i < Math.min(10, datosExcel.length); i++) {
      const fila = datosExcel[i];
      if (fila[0] && fila[0].toString().toUpperCase().includes('CÓDIGO')) {
        indiceEncabezado = i;
        break;
      }
    }

    if (indiceEncabezado === -1) {
      console.warn(' No se encontró el encabezado, usando fila 2 por defecto');
      indiceEncabezado = 2; // Fila 3 en Excel (índice 2)
    }

    console.log(' Encabezado encontrado en fila:', indiceEncabezado + 1);
    // Mapeo de columnas según la imagen del Excel PCGE
    const mapeoColumnas = {
      codigo: 0,        // Columna A: CÓDIGO
      descripcion: 1,   // Columna B: DESCRIPCIÓN DE LA CUENTA
      naturaleza: 2,    // Columna C: NATURALEZA (DEUDORA/ACREEDORA)
      tipo: 3,          // Columna D: TIPO (BALANCE/RESULTADOS)
      movimiento: 4,    // Columna E: MOVIMIENTOS (SI/NO)
      moneda: 5         // Columna F: MONEDA (SOLES)
    };

    // FASE 1: Procesar todas las filas y crear objetos básicos
    const cuentasTemporales: IContableRow[] = [];
    
    for (let i = indiceEncabezado + 1; i < datosExcel.length; i++) {
      const fila = datosExcel[i];
      
      // Saltar filas vacías
      if (!fila || !fila[mapeoColumnas.codigo]) {
        continue;
      }

      const codigo = this.limpiarCodigo(fila[mapeoColumnas.codigo]);
      
      // Saltar si el código está vacío o no es válido
      if (!codigo || codigo.trim() === '') {
        continue;
      }

      const descripcion = this.limpiarTexto(fila[mapeoColumnas.descripcion]);
      const naturaleza = this.normalizarNaturaleza(fila[mapeoColumnas.naturaleza]);
      const tipo = this.normalizarTipo(fila[mapeoColumnas.tipo]);
      const movimiento = this.normalizarSiNo(fila[mapeoColumnas.movimiento]);
      const moneda = this.normalizarMoneda(fila[mapeoColumnas.moneda]);

      // Calcular nivel según longitud del código
      const nivel = this.calcularNivel(codigo);
      const ctaPadre = this.obtenerCodigoPadre(codigo);
      const isNivel1 = nivel === '01';

      // Por ahora, jerarquía temporal solo con la cuenta actual
      const cuenta: IContableRow = {
        orgHierarchy: [`${codigo} - ${descripcion}`],
        codigo,
        descripcion,
        naturaleza,
        tipo,
        movimiento,
        nivel,
        ctaPadre,
        moneda,
        vigencia: fechaActual,
        estado: 'Activo',
        isNivel1
      };

      cuentasTemporales.push(cuenta);
    }

    console.log(' Fase 1: Procesadas', cuentasTemporales.length, 'cuentas');

    // FASE 2: Construir jerarquías correctas ahora que tenemos todas las cuentas
    const cuentas: IContableRow[] = cuentasTemporales.map(cuenta => {
      return {
        ...cuenta,
        orgHierarchy: this.construirJerarquiaCompleta(cuenta.codigo, cuenta.descripcion, cuentasTemporales)
      };
    });

    // Ordenar por código para mantener la estructura jerárquica
    cuentas.sort((a, b) => {
      const codigoA = a.codigo.padEnd(10, '0');
      const codigoB = b.codigo.padEnd(10, '0');
      return codigoA.localeCompare(codigoB);
    });

    console.log(' Fase 2: Jerarquías construidas');
    return cuentas;
  }

  /**
   * Limpia y normaliza el código de cuenta
   */
  private limpiarCodigo(codigo: any): string {
    if (!codigo) return '';
    return codigo.toString().trim().replace(/\s+/g, '');
  }

  /**
   * Limpia texto eliminando espacios extras
   */
  private limpiarTexto(texto: any): string {
    if (!texto) return '';
    return texto.toString().trim().replace(/\s+/g, ' ');
  }

  /**
   * Normaliza el valor de naturaleza
   */
  private normalizarNaturaleza(valor: any): string {
    if (!valor) return 'Deudora';
    const texto = valor.toString().toUpperCase();
    if (texto.includes('ACREEDOR')) return 'Acreedora';
    return 'Deudora';
  }

  /**
   * Normaliza el tipo de cuenta
   */
  private normalizarTipo(valor: any): string {
    if (!valor) return 'Balance';
    const texto = valor.toString().toUpperCase();
    if (texto.includes('RESULTADO')) return 'Resultados';
    if (texto.includes('ORDEN')) return 'Orden';
    if (texto.includes('CONTROL')) return 'Control';
    return 'Balance';
  }

  /**
   * Normaliza valores SI/NO
   */
  private normalizarSiNo(valor: any): string {
    if (!valor) return 'No';
    const texto = valor.toString().toUpperCase();
    if (texto.includes('SI') || texto.includes('SÍ') || texto === 'S') return 'Si';
    return 'No';
  }

  /**
   * Normaliza el valor de moneda
   */
  private normalizarMoneda(valor: any): string {
    if (!valor) return 'Soles';
    const texto = valor.toString().toUpperCase();
    if (texto.includes('DOLAR') || texto.includes('DOLLAR')) return 'Dolares';
    return 'Soles';
  }

  /**
   * Calcula el nivel de la cuenta según la longitud del código
   * 1 dígito = Nivel 01
   * 2 dígitos = Nivel 02
   * 3 dígitos = Nivel 03
   * 4 dígitos = Nivel 04
   * 5+ dígitos = Nivel 05
   */
  private calcularNivel(codigo: string): string {
    const longitud = codigo.length;
    if (longitud <= 0) return '01';
    if (longitud >= 5) return '05';
    return longitud.toString().padStart(2, '0');
  }

  /**
   * Obtiene el código de la cuenta padre
   * Ejemplo: '1031' -> '103', '103' -> '10', '10' -> '1', '1' -> ''
   */
  private obtenerCodigoPadre(codigo: string): string {
    if (codigo.length <= 1) return '';
    return codigo.substring(0, codigo.length - 1);
  }

  /**
   * Construye la jerarquía orgHierarchy completa buscando todas las cuentas padre
   * Este método se ejecuta después de tener todas las cuentas cargadas
   */
  private construirJerarquiaCompleta(codigo: string, descripcion: string, todasLasCuentas: IContableRow[]): string[] {
    const jerarquia: string[] = [];
    
    // Obtener todos los códigos padre hasta llegar al nivel 1
    const codigosPadre: string[] = [];
    let codigoActual = codigo;
    
    // Ir quitando dígitos del final para obtener códigos padre
    // Ej: '1031' -> ['1', '10', '103']
    while (codigoActual.length > 1) {
      codigoActual = codigoActual.substring(0, codigoActual.length - 1);
      codigosPadre.unshift(codigoActual);
    }

    // Construir jerarquía con las descripciones de los padres
    for (const codigoPadre of codigosPadre) {
      const padre = todasLasCuentas.find(c => c.codigo === codigoPadre);
      if (padre) {
        jerarquia.push(`${padre.codigo} - ${padre.descripcion}`);
      } else {
        // Si no encontramos el padre, agregarlo sin descripción (caso raro)
        jerarquia.push(`${codigoPadre} - (Cuenta padre)`);
      }
    }

    // Agregar la cuenta actual al final
    jerarquia.push(`${codigo} - ${descripcion}`);

    return jerarquia;
  }

  /**
   * Construye la jerarquía orgHierarchy buscando las cuentas padre (MÉTODO ANTIGUO - YA NO SE USA)
   */
  private construirJerarquia(codigo: string, descripcion: string, cuentasExistentes: IContableRow[]): string[] {
    const jerarquia: string[] = [];
    
    // Obtener todos los códigos padre hasta llegar al nivel 1
    const codigosPadre: string[] = [];
    let codigoActual = codigo;
    
    while (codigoActual.length > 1) {
      codigoActual = codigoActual.substring(0, codigoActual.length - 1);
      codigosPadre.unshift(codigoActual);
    }

    // Construir jerarquía con las descripciones de los padres
    for (const codigoPadre of codigosPadre) {
      const padre = cuentasExistentes.find(c => c.codigo === codigoPadre);
      if (padre) {
        jerarquia.push(`${padre.codigo} - ${padre.descripcion}`);
      }
    }

    // Agregar la cuenta actual
    jerarquia.push(`${codigo} - ${descripcion}`);

    return jerarquia;
  }

  /**
   * Formatea una fecha al formato YYYY-MM-DD
   */
  private formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  }
}
