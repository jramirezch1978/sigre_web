import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { ActivosfijosOperacionesAsignacionratiosComponent } from './activosfijos-operaciones-asignacionratios.component';

describe('ActivosfijosOperacionesAsignacionratiosComponent', () => {
  let component: ActivosfijosOperacionesAsignacionratiosComponent;
  let fixture: ComponentFixture<ActivosfijosOperacionesAsignacionratiosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivosfijosOperacionesAsignacionratiosComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ActivosfijosOperacionesAsignacionratiosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
