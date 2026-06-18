import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { PGeneracionNumeracionComponent } from './p-generacion-numeracion.component';

describe('PGeneracionNumeracionComponent', () => {
  let component: PGeneracionNumeracionComponent;
  let fixture: ComponentFixture<PGeneracionNumeracionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PGeneracionNumeracionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(PGeneracionNumeracionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
