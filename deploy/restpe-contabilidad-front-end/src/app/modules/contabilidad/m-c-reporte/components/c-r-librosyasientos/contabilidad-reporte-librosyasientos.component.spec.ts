import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadReporteLibrosyasientosComponent } from './contabilidad-reporte-librosyasientos.component';

describe('ContabilidadReporteLibrosyasientosComponent', () => {
  let component: ContabilidadReporteLibrosyasientosComponent;
  let fixture: ComponentFixture<ContabilidadReporteLibrosyasientosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadReporteLibrosyasientosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadReporteLibrosyasientosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
