import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenReportesDiagnosticoAlmacenesComponent } from './almacen-reportes-diagnostico-almacenes.component';

describe('AlmacenReportesDiagnosticoAlmacenesComponent', () => {
  let component: AlmacenReportesDiagnosticoAlmacenesComponent;
  let fixture: ComponentFixture<AlmacenReportesDiagnosticoAlmacenesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenReportesDiagnosticoAlmacenesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenReportesDiagnosticoAlmacenesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
