import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasReportesAnalisisProveedoresComponent } from './compras-reportes-analisis-proveedores.component';

describe('ComprasReportesAnalisisProveedoresComponent', () => {
  let component: ComprasReportesAnalisisProveedoresComponent;
  let fixture: ComponentFixture<ComprasReportesAnalisisProveedoresComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasReportesAnalisisProveedoresComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasReportesAnalisisProveedoresComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
