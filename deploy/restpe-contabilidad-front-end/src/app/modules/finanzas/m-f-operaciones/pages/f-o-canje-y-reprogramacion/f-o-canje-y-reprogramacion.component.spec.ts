import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FOCanjeYReprogramacionComponent } from './f-o-canje-y-reprogramacion.component';

describe('FOCanjeYReprogramacionComponent', () => {
  let component: FOCanjeYReprogramacionComponent;
  let fixture: ComponentFixture<FOCanjeYReprogramacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FOCanjeYReprogramacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FOCanjeYReprogramacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
