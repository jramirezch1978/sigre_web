import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTProgramPagosPorRealizarPorVencComponent } from './f-t-program-pagos-por-realizar-por-venc.component';

describe('FTProgramPagosPorRealizarPorVencComponent', () => {
  let component: FTProgramPagosPorRealizarPorVencComponent;
  let fixture: ComponentFixture<FTProgramPagosPorRealizarPorVencComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTProgramPagosPorRealizarPorVencComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTProgramPagosPorRealizarPorVencComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
