import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ALCuentaBancariaComponent } from './a-l-cuenta-bancaria.component';

describe('ALCuentaBancariaComponent', () => {
  let component: ALCuentaBancariaComponent;
  let fixture: ComponentFixture<ALCuentaBancariaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ALCuentaBancariaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ALCuentaBancariaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
