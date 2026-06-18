import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasOperacionesFacturaNoComprasComponent } from './compras-operaciones-factura-no-compras.component';

describe('ComprasOperacionesFacturaNoComprasComponent', () => {
  let component: ComprasOperacionesFacturaNoComprasComponent;
  let fixture: ComponentFixture<ComprasOperacionesFacturaNoComprasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasOperacionesFacturaNoComprasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasOperacionesFacturaNoComprasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
