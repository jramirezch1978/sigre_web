import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenConsultasPrestamosComponent } from './almacen-consultas-prestamos.component';

describe('AlmacenConsultasPrestamosComponent', () => {
  let component: AlmacenConsultasPrestamosComponent;
  let fixture: ComponentFixture<AlmacenConsultasPrestamosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenConsultasPrestamosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenConsultasPrestamosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
