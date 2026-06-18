import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasReportesComprasSugeridasComponent } from './compras-reportes-compras-sugeridas.component';

describe('ComprasReportesComprasSugeridasComponent', () => {
  let component: ComprasReportesComprasSugeridasComponent;
  let fixture: ComponentFixture<ComprasReportesComprasSugeridasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasReportesComprasSugeridasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasReportesComprasSugeridasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
