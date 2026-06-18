import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasReportesComprasTransitoComponent } from './compras-reportes-compras-transito.component';

describe('ComprasReportesComprasTransitoComponent', () => {
  let component: ComprasReportesComprasTransitoComponent;
  let fixture: ComponentFixture<ComprasReportesComprasTransitoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasReportesComprasTransitoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasReportesComprasTransitoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
