import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadReporteValidacionComponent } from './contabilidad-reporte-validacion.component';

describe('ContabilidadReporteValidacionComponent', () => {
  let component: ContabilidadReporteValidacionComponent;
  let fixture: ComponentFixture<ContabilidadReporteValidacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadReporteValidacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadReporteValidacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
