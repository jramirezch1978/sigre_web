import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadTablaPlancentrocostoComponent } from './contabilidad-tabla-plancentrocosto.component';

describe('ContabilidadTablaPlancentrocostoComponent', () => {
  let component: ContabilidadTablaPlancentrocostoComponent;
  let fixture: ComponentFixture<ContabilidadTablaPlancentrocostoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadTablaPlancentrocostoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadTablaPlancentrocostoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
