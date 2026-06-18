import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FRObligacionesPorVencerComponent } from './f-r-obligaciones-por-vencer.component';

describe('FRObligacionesPorVencerComponent', () => {
  let component: FRObligacionesPorVencerComponent;
  let fixture: ComponentFixture<FRObligacionesPorVencerComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FRObligacionesPorVencerComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FRObligacionesPorVencerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
