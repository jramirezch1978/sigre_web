import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadTablaCuentasvssubcategoriasComponent } from './contabilidad-tabla-cuentasvssubcategorias.component';

describe('ContabilidadTablaCuentasvssubcategoriasComponent', () => {
  let component: ContabilidadTablaCuentasvssubcategoriasComponent;
  let fixture: ComponentFixture<ContabilidadTablaCuentasvssubcategoriasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadTablaCuentasvssubcategoriasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadTablaCuentasvssubcategoriasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
