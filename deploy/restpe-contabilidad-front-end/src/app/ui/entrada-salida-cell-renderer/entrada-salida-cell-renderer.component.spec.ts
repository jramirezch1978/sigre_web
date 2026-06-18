import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { EntradaSalidaCellRendererComponent } from './entrada-salida-cell-renderer.component';

describe('EntradaSalidaCellRendererComponent', () => {
  let component: EntradaSalidaCellRendererComponent;
  let fixture: ComponentFixture<EntradaSalidaCellRendererComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ EntradaSalidaCellRendererComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(EntradaSalidaCellRendererComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
