import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { TimeService } from '../../services/time.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-clock',
  standalone: true,
  imports: [CommonModule, MatCardModule, MatIconModule],
  templateUrl: './clock.component.html',
  styleUrls: ['./clock.component.scss']
})
export class ClockComponent implements OnInit, OnDestroy {
  currentTime: Date = new Date();
  private timeSubscription: Subscription = new Subscription();
  private localTimer: any;
  isServerConnected = false;

  constructor(private timeService: TimeService) {}

  ngOnInit() {
    // Iniciar con hora local como fallback
    this.startLocalClock();
    
    // Intentar conectar al servidor
    this.timeSubscription = this.timeService.getCurrentTime().subscribe({
      next: (serverTime) => {
        // Conexión exitosa al servidor
        this.currentTime = serverTime;
        this.isServerConnected = true;
        this.stopLocalClock(); // Detener reloj local
        console.log('✅ Conectado al servidor - Hora sincronizada');
      },
      error: (error) => {
        // Error de conexión - usar hora local
        console.warn('❌ Error conectando al servidor, usando hora local:', error);
        this.isServerConnected = false;
        this.startLocalClock(); // Asegurar que el reloj local esté funcionando
      }
    });
  }

  private startLocalClock() {
    if (this.localTimer) {
      clearInterval(this.localTimer);
    }
    this.localTimer = setInterval(() => {
      this.currentTime = new Date();
    }, 1000);
  }

  private stopLocalClock() {
    if (this.localTimer) {
      clearInterval(this.localTimer);
      this.localTimer = null;
    }
  }

  ngOnDestroy() {
    if (this.timeSubscription) {
      this.timeSubscription.unsubscribe();
    }
    this.stopLocalClock();
  }

  formatTime(date: Date): string {
    const hours = date.getHours();
    const minutes = date.getMinutes();
    const seconds = date.getSeconds();
    const ampm = hours >= 12 ? 'PM' : 'AM';
    
    const displayHours = hours % 12 || 12;
    const formattedHours = displayHours.toString().padStart(2, '0');
    const formattedMinutes = minutes.toString().padStart(2, '0');
    const formattedSeconds = seconds.toString().padStart(2, '0');
    
    return `${formattedHours}:${formattedMinutes}:${formattedSeconds} ${ampm}`;
  }

  formatDate(date: Date): string {
    const options: Intl.DateTimeFormatOptions = {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    };
    
    return date.toLocaleDateString('es-PE', options);
  }
}
