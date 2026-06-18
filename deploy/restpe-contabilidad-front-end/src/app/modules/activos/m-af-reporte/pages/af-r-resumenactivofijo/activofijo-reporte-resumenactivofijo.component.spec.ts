import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivofijoReporteResumenactivofijoComponent } from './activofijo-reporte-resumenactivofijo.component';

describe('ActivofijoReporteResumenactivofijoComponent', () => {
  let component: ActivofijoReporteResumenactivofijoComponent;
  let fixture: ComponentFixture<ActivofijoReporteResumenactivofijoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoReporteResumenactivofijoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoReporteResumenactivofijoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
