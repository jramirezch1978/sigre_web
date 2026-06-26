import { Component, OnInit, inject } from '@angular/core';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { EdicionErpDto } from '../../models/admin.models';

@Component({
  selector: 'app-admin-ediciones',
  templateUrl: './admin-ediciones.component.html',
  styleUrls: ['../admin-page-common.scss', './admin-ediciones.component.scss'],
  standalone: false,
})
export class AdminEdicionesComponent implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);

  ediciones: EdicionErpDto[] = [];
  loading = true;

  ngOnInit(): void {
    this.api.listarEdiciones().subscribe({
      next: r => {
        this.loading = false;
        this.ediciones = (r.data ?? []).sort((a, b) => (a.orden ?? 0) - (b.orden ?? 0));
      },
      error: () => { this.loading = false; },
    });
  }
}
