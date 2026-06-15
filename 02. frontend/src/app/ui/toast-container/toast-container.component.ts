import { animate, style, transition, trigger } from '@angular/animations';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { ToastMessage, ToastService } from '../services/toast.service';

@Component({
  selector: 'app-toast-container',
  templateUrl: './toast-container.component.html',
  styleUrls: ['./toast-container.component.scss'],
  animations: [
    trigger('slideIn', [
      transition(':enter', [
        style({ transform: 'translateX(100%)', opacity: 0 }),
        animate('300ms ease-out', style({ transform: 'translateX(0)', opacity: 1 }))
      ]),
      transition(':leave', [
        animate('300ms ease-in', style({ transform: 'translateX(100%)', opacity: 0 }))
      ])
    ])
  ],
  standalone: false
})
export class ToastContainerComponent implements OnInit, OnDestroy {
  toasts: ToastMessage[] = [];
  private subscription!: Subscription;

  constructor(private toastService: ToastService) {}

  ngOnInit(): void {
    this.subscription = this.toastService.toast$.subscribe((toast) => {
      this.toasts = [toast];
      setTimeout(() => this.removeToast(toast.id), toast.duration || 6000);
    });
  }

  ngOnDestroy(): void {
    this.subscription?.unsubscribe();
  }

  removeToast(id: string): void {
    this.toasts = this.toasts.filter((t) => t.id !== id);
  }

  iconFor(type: string): string {
    switch (type) {
      case 'success': return 'checkmark-circle-outline';
      case 'warning': return 'warning-outline';
      case 'danger': return 'close-circle-outline';
      default: return 'information-circle-outline';
    }
  }

  trackByToastId(_index: number, toast: ToastMessage): string {
    return toast.id;
  }
}
