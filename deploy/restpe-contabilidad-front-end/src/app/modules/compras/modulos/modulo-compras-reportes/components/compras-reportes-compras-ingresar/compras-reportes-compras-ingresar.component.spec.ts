import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasReportesComprasIngresarComponent } from './compras-reportes-compras-ingresar.component';

describe('ComprasReportesComprasIngresarComponent', () => {
  let component: ComprasReportesComprasIngresarComponent;
  let fixture: ComponentFixture<ComprasReportesComprasIngresarComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasReportesComprasIngresarComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasReportesComprasIngresarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
