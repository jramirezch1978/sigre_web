import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { RADistribucionCostosComponent } from './r-a-distribucion-costos.component';

describe('RADistribucionCostosComponent', () => {
  let component: RADistribucionCostosComponent;
  let fixture: ComponentFixture<RADistribucionCostosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ RADistribucionCostosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(RADistribucionCostosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
