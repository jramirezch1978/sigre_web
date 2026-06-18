import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasReportesComprasCategoriaComponent } from './compras-reportes-compras-categoria.component';

describe('ComprasReportesComprasCategoriaComponent', () => {
  let component: ComprasReportesComprasCategoriaComponent;
  let fixture: ComponentFixture<ComprasReportesComprasCategoriaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasReportesComprasCategoriaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasReportesComprasCategoriaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
