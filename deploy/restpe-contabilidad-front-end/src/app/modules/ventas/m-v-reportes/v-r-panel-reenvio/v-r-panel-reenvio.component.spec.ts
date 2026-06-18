import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { VRPanelReenvioComponent } from './v-r-panel-reenvio.component';

describe('VRPanelReenvioComponent', () => {
  let component: VRPanelReenvioComponent;
  let fixture: ComponentFixture<VRPanelReenvioComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ VRPanelReenvioComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(VRPanelReenvioComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
