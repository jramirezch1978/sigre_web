import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { Subscription } from 'rxjs';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-layout',
  templateUrl: './layout.component.html',
  styleUrls: ['./layout.component.scss'],
  standalone: false
})
export class LayoutComponent implements OnInit, OnDestroy {

  mostrarChatIa = true;
  private routerSub!: Subscription;

  constructor(private router: Router) {}

  ngOnInit(): void {
    this.actualizarChatIa(this.router.url);
    this.routerSub = this.router.events.pipe(
      filter(e => e instanceof NavigationEnd)
    ).subscribe((e: NavigationEnd) => {
      this.actualizarChatIa(e.urlAfterRedirects);
    });
  }

  private actualizarChatIa(url: string): void {
    this.mostrarChatIa = !url.includes('/ia');
  }

  ngOnDestroy(): void {
    this.routerSub?.unsubscribe();
  }

}
