import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivofijoReporteDepreciacionanualComponent } from './activofijo-reporte-depreciacionanual.component';

describe('ActivofijoReporteDepreciacionanualComponent', () => {
  let component: ActivofijoReporteDepreciacionanualComponent;
  let fixture: ComponentFixture<ActivofijoReporteDepreciacionanualComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoReporteDepreciacionanualComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoReporteDepreciacionanualComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
