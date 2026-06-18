import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenReportesVendidosZonaComponent } from './almacen-reportes-vendidos-zona.component';

describe('AlmacenReportesVendidosZonaComponent', () => {
  let component: AlmacenReportesVendidosZonaComponent;
  let fixture: ComponentFixture<AlmacenReportesVendidosZonaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenReportesVendidosZonaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenReportesVendidosZonaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
