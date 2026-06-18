import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AccionesVerDescImpComponent } from './acciones-ver-desc-imp.component';

describe('AccionesVerDescImpComponent', () => {
  let component: AccionesVerDescImpComponent;
  let fixture: ComponentFixture<AccionesVerDescImpComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AccionesVerDescImpComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AccionesVerDescImpComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
