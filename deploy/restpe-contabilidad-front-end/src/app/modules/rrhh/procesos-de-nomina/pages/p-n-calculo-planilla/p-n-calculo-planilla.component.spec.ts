import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { PNCalculoPlanillaComponent } from './p-n-calculo-planilla.component';

describe('PNCalculoPlanillaComponent', () => {
  let component: PNCalculoPlanillaComponent;
  let fixture: ComponentFixture<PNCalculoPlanillaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PNCalculoPlanillaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(PNCalculoPlanillaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
