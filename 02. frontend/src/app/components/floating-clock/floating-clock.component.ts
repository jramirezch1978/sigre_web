import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { Subscription, interval } from 'rxjs';

@Component({
  selector: 'app-floating-clock',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  template: `
    <div class="floating-clock-container">
      <div class="time-display">{{ formatTime(currentTime) }}</div>
      <div class="date-display">{{ formatDate(currentTime) }}</div>
    </div>
  `,
  styles: [`
    .floating-clock-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      text-align: center;
    }
    
    .time-display {
      color: #ffffff;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      font-size: 14px;
      font-weight: 500;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
      letter-spacing: 0.5px;
      margin: 0;
      line-height: 1.2;
    }

    .date-display {
      color: rgba(255, 255, 255, 0.8);
      font-size: 11px;
      font-weight: 400;
      margin-top: 2px;
      text-shadow: 0 1px 1px rgba(0, 0, 0, 0.4);
      margin: 0;
      line-height: 1.2;
    }
  `]
})
export class FloatingClockComponent implements OnInit, OnDestroy {
  currentTime: Date = new Date();
  private subscription: Subscription = new Subscription();

  constructor() {}

  ngOnInit() {
    // Actualizar cada segundo - SIMPLE y SIN DEPENDENCIAS
    this.subscription.add(
      interval(1000).subscribe(() => {
        this.currentTime = new Date();
      })
    );
  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
  }

  formatTime(date: Date): string {
    return date.toLocaleString('es-PE', {
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hour12: true
    });
  }

  formatDate(date: Date): string {
    return date.toLocaleDateString('es-PE', {
      weekday: 'short',
      day: '2-digit',
      month: 'short',
      year: 'numeric'
    });
  }
}
