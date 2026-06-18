import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenConsultasArticuloComponent } from './almacen-consultas-articulo.component';

describe('AlmacenConsultasArticuloComponent', () => {
  let component: AlmacenConsultasArticuloComponent;
  let fixture: ComponentFixture<AlmacenConsultasArticuloComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenConsultasArticuloComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenConsultasArticuloComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
