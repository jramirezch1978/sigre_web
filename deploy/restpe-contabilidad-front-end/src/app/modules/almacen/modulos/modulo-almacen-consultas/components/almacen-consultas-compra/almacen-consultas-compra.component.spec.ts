import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenConsultasCompraComponent } from './almacen-consultas-compra.component';

describe('AlmacenConsultasCompraComponent', () => {
  let component: AlmacenConsultasCompraComponent;
  let fixture: ComponentFixture<AlmacenConsultasCompraComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenConsultasCompraComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenConsultasCompraComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
