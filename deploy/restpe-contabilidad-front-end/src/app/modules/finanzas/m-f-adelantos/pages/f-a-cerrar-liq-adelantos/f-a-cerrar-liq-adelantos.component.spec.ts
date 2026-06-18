import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FACerrarLiqAdelantosComponent } from './f-a-cerrar-liq-adelantos.component';

describe('FACerrarLiqAdelantosComponent', () => {
  let component: FACerrarLiqAdelantosComponent;
  let fixture: ComponentFixture<FACerrarLiqAdelantosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FACerrarLiqAdelantosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FACerrarLiqAdelantosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
