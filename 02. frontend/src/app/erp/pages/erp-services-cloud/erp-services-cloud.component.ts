import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

export type TicketEstado = 'ABIERTO' | 'EN_PROGRESO' | 'ESPERA' | 'RESUELTO' | 'CERRADO';
export type TicketPrioridad = 'BAJA' | 'MEDIA' | 'ALTA' | 'CRITICA';

export interface TicketResumen {
  id: string;
  asunto: string;
  solicitante: string;
  cola: string;
  prioridad: TicketPrioridad;
  estado: TicketEstado;
  actualizado: string;
}

@Component({
  selector: 'app-erp-services-cloud',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './erp-services-cloud.component.html',
  styleUrls: ['./erp-services-cloud.component.scss'],
})
export class ErpServicesCloudComponent {
  /** Datos demo hasta existir el microservicio + BD dedicada. */
  readonly kpis = [
    { label: 'Abiertos', valor: 12, icono: 'mark_email_unread', tono: 'primary' },
    { label: 'En progreso', valor: 7, icono: 'autorenew', tono: 'warning' },
    { label: 'Resueltos hoy', valor: 4, icono: 'task_alt', tono: 'success' },
    { label: 'SLA en riesgo', valor: 2, icono: 'timer', tono: 'danger' },
  ] as const;

  readonly acciones = [
    { titulo: 'Nuevo ticket', desc: 'Registrar una solicitud o incidente', icono: 'add_circle', disabled: true },
    { titulo: 'Mis tickets', desc: 'Casos donde usted es solicitante', icono: 'person', disabled: true },
    { titulo: 'Cola de soporte', desc: 'Bandeja del equipo de atención', icono: 'support_agent', disabled: true },
    { titulo: 'Base de conocimiento', desc: 'Artículos y soluciones frecuentes', icono: 'menu_book', disabled: true },
  ] as const;

  readonly tickets: TicketResumen[] = [
    {
      id: 'SC-1042',
      asunto: 'No puedo ingresar a Compras desde Hermes',
      solicitante: 'Ana Torres',
      cola: 'Aplicaciones',
      prioridad: 'ALTA',
      estado: 'EN_PROGRESO',
      actualizado: 'Hace 12 min',
    },
    {
      id: 'SC-1041',
      asunto: 'Solicitud de alta de usuario en Blue Coast',
      solicitante: 'Carlos Ruiz',
      cola: 'Seguridad',
      prioridad: 'MEDIA',
      estado: 'ABIERTO',
      actualizado: 'Hace 35 min',
    },
    {
      id: 'SC-1038',
      asunto: 'Error al sincronizar movimiento de almacén',
      solicitante: 'Lucía Méndez',
      cola: 'Integraciones',
      prioridad: 'CRITICA',
      estado: 'ESPERA',
      actualizado: 'Hace 1 h',
    },
    {
      id: 'SC-1035',
      asunto: 'Consulta sobre reporte de stock',
      solicitante: 'Jorge Castillo',
      cola: 'Consultas',
      prioridad: 'BAJA',
      estado: 'RESUELTO',
      actualizado: 'Hoy 09:40',
    },
  ];

  clasePrioridad(p: TicketPrioridad): string {
    switch (p) {
      case 'CRITICA': return 'badge-prio badge-prio--critica';
      case 'ALTA': return 'badge-prio badge-prio--alta';
      case 'MEDIA': return 'badge-prio badge-prio--media';
      default: return 'badge-prio badge-prio--baja';
    }
  }

  claseEstado(e: TicketEstado): string {
    switch (e) {
      case 'ABIERTO': return 'badge-estado badge-estado--abierto';
      case 'EN_PROGRESO': return 'badge-estado badge-estado--progreso';
      case 'ESPERA': return 'badge-estado badge-estado--espera';
      case 'RESUELTO': return 'badge-estado badge-estado--resuelto';
      default: return 'badge-estado badge-estado--cerrado';
    }
  }

  etiquetaEstado(e: TicketEstado): string {
    switch (e) {
      case 'ABIERTO': return 'Abierto';
      case 'EN_PROGRESO': return 'En progreso';
      case 'ESPERA': return 'En espera';
      case 'RESUELTO': return 'Resuelto';
      default: return 'Cerrado';
    }
  }
}
