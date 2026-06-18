import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

export interface Talonario {
  id: string;
  talonario: string;        // Descripción
  prefijo: string;
  'número desde': string;
  'número hasta': string;
  'próximo número': string;
  // Campos del panel derecho
  porDefecto: boolean;
  metodoNumeracion: 'Automática' | 'Manual';
  facturaVenta: boolean;
  notaDebito: boolean;
  notaCredito: boolean;
  tipoComprobante: 'x' | 'i' | 'o';
  ordenPago: boolean;
  recibo: boolean;
  remito: boolean;
  facturaElectronica: boolean;
}

export interface Carpeta{
  id:string,
  nombre:string;
  Nrocuenta:string;
  Saldoinicio:string;
  Debito:string;
  Credito:string;
  Saldofinal:string;
  AsientoManual:string;
}

export interface subcarpetas{
  id:string;
  carpetaPadreId: string; // ID de la carpeta padre
  nombre:string;
  Nrocuenta:string;
  Saldoinicio:string;
  Debito:string;
  Credito:string;
  Saldofinal:string;
  AsientoManual:string;
}


const MOCK: Talonario[] = [
  {
    id: 't1', talonario: 'Factura C', prefijo: '0001',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  {
    id: 't2', talonario: 'Factura B', prefijo: '0001',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  {
    id: 't3', talonario: 'Factura D', prefijo: '0002',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  {
    id: 't4', talonario: 'Factura D', prefijo: '0002',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  {
    id: 't5', talonario: 'Factura D', prefijo: '0002',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  {
    id: 't6', talonario: 'Factura D', prefijo: '0002',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },{
    id: 't7', talonario: 'Factura D', prefijo: '0002',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  {
    id: 't8', talonario: 'Factura D', prefijo: '0002',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  {
    id: 't9', talonario: 'Factura D', prefijo: '0002',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  {
    id: 't10', talonario: 'Factura D', prefijo: '0002',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  {
    id: 't11', talonario: 'Factura D', prefijo: '0002',
    'número desde': '00000001', 'número hasta': '99999999', 'próximo número': '00000001',
    porDefecto: true, metodoNumeracion: 'Automática',
    facturaVenta: true, notaDebito: false, notaCredito: false, tipoComprobante: 'x',
    ordenPago: false, recibo: false, remito: false, facturaElectronica: true,
  },
  // ...agrega más items si quieres
];

const carpetas: Carpeta[] = [
  {
    id: '1', nombre: 'Activo', Nrocuenta: '', Saldoinicio: '0', Debito: '0',
    Credito: '0', Saldofinal: '0', AsientoManual: 'N',
  },
  {
    id: '2', nombre: 'Pasivo',Nrocuenta: '', Saldoinicio: '0', 
    Debito: '0', Credito: '0', Saldofinal: '',AsientoManual: 'N',
  },
  {
    id: '3', nombre: 'Patrimonio neto', Nrocuenta: '', Saldoinicio: '0',
    Debito: '0', Credito: '0', Saldofinal: '0', AsientoManual: 'N'
  },
  {
    id: '4', nombre: 'Resultados', Nrocuenta: '',Saldoinicio: '0',
    Debito: '0', Credito: '0', Saldofinal: '0', AsientoManual: 'N'
  },
  
  
];

const subcarpetas: subcarpetas[] = [
  {
    id: '11', carpetaPadreId: 'Activo', nombre: 'Caja y bancos', Nrocuenta: '1010', Saldoinicio: '15000', Debito: '5000',
    Credito: '2000', Saldofinal: '18000', AsientoManual: 'SI'
  },
  {
    id: '22', carpetaPadreId: 'Pasivo', nombre: 'Deudas comerciales',Nrocuenta: '1020', Saldoinicio: '25000',
    Debito: '8000', Credito: '3000', Saldofinal: '30000', AsientoManual: 'NO'
  },
  {
    id: '33', carpetaPadreId: 'Patrimonio neto', nombre: 'Impuestos a los IBB a pagar', Nrocuenta: '2010', Saldoinicio: '10000',
    Debito: '2000', Credito: '4000', Saldofinal: '8000', AsientoManual: 'SI'
  },
  {
    id: '44', carpetaPadreId: 'Resultados', nombre: 'Capital social', Nrocuenta: '3010',Saldoinicio: '50000',
    Debito: '0', Credito: '10000', Saldofinal: '60000', AsientoManual: 'NO'
  }
];




@Injectable({ providedIn: 'root' })
export class TalonariosService {
  private list$ = new BehaviorSubject<Talonario[]>(MOCK);
  private selected$ = new BehaviorSubject<Talonario | null>(MOCK[0]);
  
  // Estado para controlar qué carpetas están expandidas
  private carpetasExpandidas: Set<string> = new Set();

  getAll$() { return this.list$.asObservable(); }
  get value() { return this.list$.value; }

  getSelected$() { return this.selected$.asObservable(); }
  get selectedValue() { return this.selected$.value; }

  selectById(id: string) {
    const found = this.value.find(t => t.id === id) ?? null;
    this.selected$.next(found);
  }

  create(t: Talonario) {
    this.list$.next([t, ...this.value]);
    this.selected$.next(t);
  }

  update(id: string, changes: Partial<Talonario>) {
    const updated = this.value.map(t => t.id === id ? { ...t, ...changes } : t);
    this.list$.next(updated);
    const sel = updated.find(t => t.id === id) ?? null;
    this.selected$.next(sel);
  }

  delete(id: string) {
    const updated = this.value.filter(t => t.id !== id);
    this.list$.next(updated);
    if (this.selectedValue?.id === id) this.selected$.next(updated[0] ?? null);
  }

  // Métodos para carpetas
  getCarpetas() {
    return carpetas;
  }

  // Métodos para subcarpetas
  getSubcarpetas() {
    return subcarpetas;
  }

  // Obtener subcarpetas por carpeta padre
  getSubcarpetasByPadre(carpetaPadreId: string) {
    return subcarpetas.filter(sub => sub.carpetaPadreId === carpetaPadreId);
  }

  // Métodos para manejar expansión/colapso de carpetas
  toggleCarpetaExpansion(carpetaNombre: string): void {
    if (this.carpetasExpandidas.has(carpetaNombre)) {
      this.carpetasExpandidas.delete(carpetaNombre);
    } else {
      this.carpetasExpandidas.add(carpetaNombre);
    }
  }

  isCarpetaExpandida(carpetaNombre: string): boolean {
    return this.carpetasExpandidas.has(carpetaNombre);
  }

  expandirTodasLasCarpetas(): void {
    carpetas.forEach(carpeta => {
      this.carpetasExpandidas.add(carpeta.nombre);
    });
  }

  colapsarTodasLasCarpetas(): void {
    this.carpetasExpandidas.clear();
  }

  // Crear estructura jerárquica completa
  getCarpetasConSubcarpetas() {
    return carpetas.map(carpeta => ({
      ...carpeta,
      subcarpetas: this.getSubcarpetasByPadre(carpeta.id)
    }));
  }

  // Método alternativo para estructura jerárquica plana (carpetas + subcarpetas en secuencia)
  getEstructuraJerarquicaPlana() {
    const estructuraCompleta: any[] = [];
    
    // Recorrer cada carpeta padre
    carpetas.forEach(carpetaPadre => {
      const estaExpandida = this.isCarpetaExpandida(carpetaPadre.nombre);
      
      // Agregar carpeta padre con su información
      estructuraCompleta.push({
        id: carpetaPadre.id,
        nombre: carpetaPadre.nombre,
        Nrocuenta: carpetaPadre.Nrocuenta,
        Saldoinicio: carpetaPadre.Saldoinicio,
        Debito: carpetaPadre.Debito,
        Credito: carpetaPadre.Credito,
        Saldofinal: carpetaPadre.Saldofinal,
        tipo: 'carpeta',
        nivel: 0,
        esCarpetaPadre: true,
        expandida: estaExpandida
      });
      
      // Solo agregar subcarpetas si la carpeta está expandida
      if (estaExpandida) {
        // Encontrar todas las subcarpetas que pertenecen a esta carpeta padre
        const subcarpetasHijas = subcarpetas.filter(sub => sub.carpetaPadreId === carpetaPadre.nombre);
        
        // Agregar cada subcarpeta debajo de su carpeta padre
        subcarpetasHijas.forEach(subcarpeta => {
          estructuraCompleta.push({
            id: subcarpeta.id,
            nombre: subcarpeta.nombre,
            Nrocuenta: subcarpeta.Nrocuenta,
            Saldoinicio: subcarpeta.Saldoinicio,
            Debito: subcarpeta.Debito,
            Credito: subcarpeta.Credito,
            Saldofinal: subcarpeta.Saldofinal,
            tipo: 'subcarpeta',
            nivel: 1,
            esCarpetaPadre: false,
            carpetaPadreId: subcarpeta.carpetaPadreId
          });
        });
      }
    });
    
    console.log('=== ESTRUCTURA JERÁRQUICA PLANA ===');
    console.log('Total elementos:', estructuraCompleta.length);
    console.log('Carpetas padre:', estructuraCompleta.filter(item => item.tipo === 'carpeta').length);
    console.log('Subcarpetas:', estructuraCompleta.filter(item => item.tipo === 'subcarpeta').length);
    estructuraCompleta.forEach((item, index) => {
      console.log(`${index + 1}. ${item.nivel === 0 ? '📁' : '  📄'} ${item.nombre} (${item.tipo})`);
    });
    
    return estructuraCompleta;
  }
  }
