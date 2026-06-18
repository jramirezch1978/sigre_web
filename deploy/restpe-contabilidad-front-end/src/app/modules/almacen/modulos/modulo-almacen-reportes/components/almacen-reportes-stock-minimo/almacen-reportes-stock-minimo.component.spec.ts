import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenReportesStockMinimoComponent } from './almacen-reportes-stock-minimo.component';

describe('AlmacenReportesStockMinimoComponent', () => {
  let component: AlmacenReportesStockMinimoComponent;
  let fixture: ComponentFixture<AlmacenReportesStockMinimoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenReportesStockMinimoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenReportesStockMinimoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
