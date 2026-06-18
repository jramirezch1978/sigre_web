import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadTablaContabilidadComponent } from './contabilidad-tabla-contabilidad.component';

describe('ContabilidadTablaContabilidadComponent', () => {
  let component: ContabilidadTablaContabilidadComponent;
  let fixture: ComponentFixture<ContabilidadTablaContabilidadComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadTablaContabilidadComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadTablaContabilidadComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
