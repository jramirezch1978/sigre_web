import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { VRPanelEstadosDocComponent } from './v-r-panel-estados-doc.component';

describe('VRPanelEstadosDocComponent', () => {
  let component: VRPanelEstadosDocComponent;
  let fixture: ComponentFixture<VRPanelEstadosDocComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ VRPanelEstadosDocComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(VRPanelEstadosDocComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
