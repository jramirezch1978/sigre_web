import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadTablaPlancontableComponent } from './contabilidad-tabla-plancontable.component';

describe('ContabilidadTablaPlancontableComponent', () => {
  let component: ContabilidadTablaPlancontableComponent;
  let fixture: ComponentFixture<ContabilidadTablaPlancontableComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadTablaPlancontableComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadTablaPlancontableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
