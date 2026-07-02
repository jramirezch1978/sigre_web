<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    if (ctx == null || ctx.isEmpty()) {
        ctx = "";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SunatWebServices | SIGRE</title>
    <style>
        :root {
            --bg: #0b1220;
            --bg-card: #111b2e;
            --bg-card-hover: #152238;
            --border: rgba(148, 163, 184, 0.14);
            --text: #e2e8f0;
            --muted: #94a3b8;
            --accent: #38bdf8;
            --accent-2: #f59e0b;
            --active: #22c55e;
            --active-bg: rgba(34, 197, 94, 0.12);
            --shadow: 0 24px 60px rgba(0, 0, 0, 0.35);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background:
                radial-gradient(circle at top left, rgba(56, 189, 248, 0.12), transparent 28%),
                radial-gradient(circle at top right, rgba(245, 158, 11, 0.10), transparent 24%),
                var(--bg);
            color: var(--text);
            min-height: 100vh;
            line-height: 1.5;
        }

        .page {
            max-width: 1100px;
            margin: 0 auto;
            padding: 48px 24px 64px;
        }

        .hero {
            position: relative;
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 48px 40px;
            background: linear-gradient(135deg, rgba(17, 27, 46, 0.96), rgba(11, 18, 32, 0.98));
            box-shadow: var(--shadow);
            margin-bottom: 32px;
        }

        .hero::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                linear-gradient(120deg, transparent 0%, rgba(56, 189, 248, 0.05) 45%, transparent 70%),
                repeating-linear-gradient(
                    90deg,
                    rgba(255, 255, 255, 0.015) 0,
                    rgba(255, 255, 255, 0.015) 1px,
                    transparent 1px,
                    transparent 48px
                );
            pointer-events: none;
        }

        .hero-content { position: relative; z-index: 1; }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            border: 1px solid rgba(56, 189, 248, 0.25);
            background: rgba(56, 189, 248, 0.08);
            color: var(--accent);
            font-size: 0.82rem;
            font-weight: 600;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            margin-bottom: 18px;
        }

        .badge-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--active);
            box-shadow: 0 0 12px rgba(34, 197, 94, 0.8);
        }

        h1 {
            font-size: clamp(2rem, 4vw, 3.2rem);
            line-height: 1.1;
            letter-spacing: -0.03em;
            margin-bottom: 14px;
        }

        h1 span {
            background: linear-gradient(90deg, #ffffff, #93c5fd);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .hero p {
            max-width: 720px;
            color: var(--muted);
            font-size: 1.05rem;
            margin-bottom: 28px;
        }

        .hero-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
        }

        .meta-item {
            padding: 12px 16px;
            border-radius: 14px;
            border: 1px solid var(--border);
            background: rgba(255, 255, 255, 0.02);
            min-width: 180px;
        }

        .meta-label {
            display: block;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: var(--muted);
            margin-bottom: 4px;
        }

        .meta-value {
            font-size: 0.98rem;
            font-weight: 600;
            color: #f8fafc;
            word-break: break-all;
        }

        .section-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
        }

        .section-title h2 {
            font-size: 1.35rem;
            letter-spacing: -0.02em;
        }

        .section-title span {
            color: var(--muted);
            font-size: 0.92rem;
        }

        .services {
            display: grid;
            gap: 14px;
        }

        .service-card {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 16px;
            align-items: center;
            padding: 20px 22px;
            border-radius: 18px;
            border: 1px solid var(--border);
            background: var(--bg-card);
            transition: background 0.2s ease, transform 0.2s ease, border-color 0.2s ease;
        }

        .service-card:hover {
            background: var(--bg-card-hover);
            transform: translateY(-1px);
            border-color: rgba(56, 189, 248, 0.22);
        }

        .service-name {
            font-size: 1.05rem;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .service-desc {
            color: var(--muted);
            font-size: 0.92rem;
            margin-bottom: 10px;
        }

        .service-endpoint {
            display: inline-block;
            font-family: Consolas, "Courier New", monospace;
            font-size: 0.82rem;
            color: #cbd5e1;
            background: rgba(15, 23, 42, 0.75);
            border: 1px solid rgba(148, 163, 184, 0.12);
            border-radius: 8px;
            padding: 6px 10px;
        }

        .status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.03em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .status-active {
            color: #86efac;
            background: var(--active-bg);
            border: 1px solid rgba(34, 197, 94, 0.25);
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }

        .status-active .status-dot { background: var(--active); }

        .footer {
            margin-top: 28px;
            text-align: center;
            color: var(--muted);
            font-size: 0.88rem;
        }

        @media (max-width: 720px) {
            .page { padding: 28px 16px 48px; }
            .hero { padding: 32px 24px; }
            .service-card {
                grid-template-columns: 1fr;
            }
            .status { justify-self: start; }
        }
    </style>
</head>
<body>
    <div class="page">
        <section class="hero">
            <div class="hero-content">
                <div class="badge">
                    <span class="badge-dot"></span>
                    Plataforma de servicios SIGRE
                </div>
                <h1><span>SunatWebServices</span></h1>
                <p>
                    Portal de servicios web para consultas tributarias y operaciones de apoyo
                    a los sistemas SIGRE. Expone APIs REST y SOAP para integracion con
                    aplicaciones de escritorio y servicios internos.
                </p>
                <div class="hero-meta">
                    <div class="meta-item">
                        <span class="meta-label">Contexto</span>
                        <span class="meta-value"><%= ctx.isEmpty() ? "/" : ctx %></span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">API REST</span>
                        <span class="meta-value"><%= ctx %>/api</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">SOAP legacy</span>
                        <span class="meta-value"><%= ctx %>/ImplConsultaRUC</span>
                    </div>
                </div>
            </div>
        </section>

        <div class="section-title">
            <h2>Servicios disponibles</h2>
            <span>Listado de servicios publicados por esta aplicacion</span>
        </div>

        <div class="services">
            <article class="service-card">
                <div>
                    <div class="service-name">Autenticacion JWT</div>
                    <div class="service-desc">Generacion de token de acceso para consumo de APIs REST.</div>
                    <code class="service-endpoint">POST <%= ctx %>/api/auth/token</code>
                </div>
                <span class="status status-active"><span class="status-dot"></span>Activo</span>
            </article>

            <article class="service-card">
                <div>
                    <div class="service-name">Consulta RUC</div>
                    <div class="service-desc">Consulta de padron RUC desde base de datos corporativa.</div>
                    <code class="service-endpoint">POST <%= ctx %>/api/ruc/consultar</code>
                </div>
                <span class="status status-active"><span class="status-dot"></span>Activo</span>
            </article>

            <article class="service-card">
                <div>
                    <div class="service-name">Consulta Tipo de Cambio</div>
                    <div class="service-desc">Consulta de tipo de cambio SUNAT/SBS por fecha.</div>
                    <code class="service-endpoint">POST <%= ctx %>/api/tipo-cambio/consultar</code>
                </div>
                <span class="status status-active"><span class="status-dot"></span>Activo</span>
            </article>

            <article class="service-card">
                <div>
                    <div class="service-name">Consulta RUC SOAP</div>
                    <div class="service-desc">Servicio SOAP legacy para compatibilidad con clientes anteriores.</div>
                    <code class="service-endpoint"><%= ctx %>/ImplConsultaRUC</code>
                </div>
                <span class="status status-active"><span class="status-dot"></span>Activo</span>
            </article>
        </div>

        <p class="footer">SunatWebServices &mdash; SIGRE &copy; <%= new java.util.GregorianCalendar().get(java.util.Calendar.YEAR) %></p>
    </div>
</body>
</html>
