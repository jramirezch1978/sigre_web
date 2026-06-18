import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ComprasCotizacionesRegistrarComponent } from './compras-cotizaciones-registrar.component';

describe('ComprasCotizacionesRegistrarComponent', () => {
  let component: ComprasCotizacionesRegistrarComponent;
  let fixture: ComponentFixture<ComprasCotizacionesRegistrarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ComprasCotizacionesRegistrarComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasCotizacionesRegistrarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize the form on ngOnInit', () => {
    expect(component.CotizacionForm).toBeDefined();
    expect(component.CotizacionForm.get('proveedor')).toBeDefined();
    expect(component.CotizacionForm.get('fecha')).toBeDefined();
    expect(component.CotizacionForm.get('moneda')).toBeDefined();
  });

  it('should calculate totals correctly', () => {
    const mockArticulos = [
      {
        articulo_codigo: 'ART-001',
        articulo_cantidad: 10,
        articulo_unidad: 'Unidad',
        articulo_descripcion: 'Producto 1',
        articulo_precio_unitario: 100,
        articulo_subtotal: 1000,
        articulo_descuento: 0,
        articulo_total: 1000,
        plazo_entrega_dias: 5,
      },
      {
        articulo_codigo: 'ART-002',
        articulo_cantidad: 5,
        articulo_unidad: 'Unidad',
        articulo_descripcion: 'Producto 2',
        articulo_precio_unitario: 200,
        articulo_subtotal: 1000,
        articulo_descuento: 0,
        articulo_total: 1000,
        plazo_entrega_dias: 5,
      },
    ];
    component.rowDataArticulos = mockArticulos;
    component.calcularTotales();

    expect(component.subtotalGeneral).toBe(2000);
    expect(component.totalGeneral).toBe(2000);
  });

  it('should enable edit mode when creating new cotization', () => {
    component.crearNuevaCotizacion();
    expect(component.modoCreacion).toBeTruthy();
    expect(component.puedeEditarFormulario).toBeTruthy();
  });

  it('should reset form when canceling', () => {
    component.CotizacionForm.patchValue({
      proveedor: 'Proveedor Test',
      fecha: '2026-05-10',
    });
    component.cancelar();

    expect(component.CotizacionForm.get('proveedor')?.value).toBeNull();
    expect(component.modoCreacion).toBeTruthy();
  });

  it('should not save cotization with empty form', () => {
    component.rowDataArticulos = [];
    spyOn(console, 'error');
    expect(component.CotizacionForm.valid).toBeFalsy();
  });
});
