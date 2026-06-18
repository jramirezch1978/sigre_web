import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadTablaImpuestosComponent } from './contabilidad-tabla-impuestos.component';

describe('ContabilidadTablaImpuestosComponent', () => {
  let component: ContabilidadTablaImpuestosComponent;
  let fixture: ComponentFixture<ContabilidadTablaImpuestosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadTablaImpuestosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadTablaImpuestosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
