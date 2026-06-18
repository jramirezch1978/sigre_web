import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenReportesHistorialVencimientoComponent } from './almacen-reportes-historial-vencimiento.component';

describe('AlmacenReportesHistorialVencimientoComponent', () => {
  let component: AlmacenReportesHistorialVencimientoComponent;
  let fixture: ComponentFixture<AlmacenReportesHistorialVencimientoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenReportesHistorialVencimientoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenReportesHistorialVencimientoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
