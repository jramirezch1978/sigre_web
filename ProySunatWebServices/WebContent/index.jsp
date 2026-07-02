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
            --bg: #f0f6fa;
            --bg-soft: #ffffff;
            --bg-card: #ffffff;
            --border: #dbe7ef;
            --text: #1e293b;
            --muted: #64748b;
            --sigre-dark: #2b2b2b;
            --teal: #1aa3b5;
            --teal-light: #e6f7fa;
            --teal-dark: #148a99;
            --blue: #2f80c9;
            --blue-light: #ebf4fc;
            --green: #7dc142;
            --green-light: #edf8e6;
            --shadow: 0 10px 30px rgba(26, 163, 181, 0.08);
            --shadow-hover: 0 16px 36px rgba(26, 163, 181, 0.14);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background:
                radial-gradient(circle at top left, rgba(26, 163, 181, 0.10), transparent 32%),
                radial-gradient(circle at top right, rgba(47, 128, 201, 0.08), transparent 28%),
                linear-gradient(180deg, #f8fbfd 0%, var(--bg) 100%);
            color: var(--text);
            min-height: 100vh;
            line-height: 1.5;
        }

        .page {
            max-width: 1100px;
            margin: 0 auto;
            padding: 32px 24px 64px;
        }

        .hero {
            position: relative;
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 36px 40px 32px;
            background: linear-gradient(135deg, #ffffff 0%, #f7fcfd 55%, #eef8fb 100%);
            box-shadow: var(--shadow);
            margin-bottom: 28px;
        }

        .hero-layout {
            display: flex;
            align-items: center;
            gap: 32px;
            position: relative;
            z-index: 1;
        }

        .hero-logo {
            flex: 0 0 260px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .hero-logo img {
            width: 100%;
            max-width: 260px;
            height: auto;
            display: block;
        }

        .hero-body {
            flex: 1;
            min-width: 0;
        }

        .hero::after {
            content: "";
            position: absolute;
            left: 40px;
            right: 40px;
            bottom: 0;
            height: 3px;
            border-radius: 999px;
            background: linear-gradient(90deg, transparent, var(--teal), var(--blue), var(--green), transparent);
            opacity: 0.55;
        }

        .hero-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            margin-top: 24px;
            position: relative;
            z-index: 1;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            border: 1px solid rgba(26, 163, 181, 0.22);
            background: var(--teal-light);
            color: var(--teal-dark);
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            margin-bottom: 16px;
        }

        .badge-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--green);
        }

        h1 {
            font-size: clamp(1.9rem, 4vw, 2.8rem);
            line-height: 1.15;
            letter-spacing: -0.03em;
            margin-bottom: 12px;
            color: var(--sigre-dark);
        }

        h1 span {
            color: var(--teal);
        }

        .hero p {
            max-width: 720px;
            color: var(--muted);
            font-size: 1.02rem;
            margin-bottom: 0;
        }

        .meta-item {
            padding: 12px 16px;
            border-radius: 14px;
            border: 1px solid var(--border);
            background: rgba(255, 255, 255, 0.85);
            min-width: 180px;
        }

        .meta-label {
            display: block;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: var(--teal-dark);
            font-weight: 700;
            margin-bottom: 4px;
        }

        .meta-value {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text);
            word-break: break-all;
            font-family: Consolas, "Courier New", monospace;
        }

        .section-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--teal-light);
        }

        .section-title h2 {
            font-size: 1.35rem;
            letter-spacing: -0.02em;
            color: var(--sigre-dark);
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
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.04);
            transition: transform 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .service-card:hover {
            transform: translateY(-2px);
            border-color: rgba(26, 163, 181, 0.35);
            box-shadow: var(--shadow-hover);
        }

        .service-name {
            font-size: 1.05rem;
            font-weight: 700;
            margin-bottom: 6px;
            color: var(--sigre-dark);
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
            color: var(--blue);
            background: var(--blue-light);
            border: 1px solid rgba(47, 128, 201, 0.18);
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
            color: #4d8f24;
            background: var(--green-light);
            border: 1px solid rgba(125, 193, 66, 0.35);
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }

        .status-active .status-dot { background: var(--green); }

        .footer {
            margin-top: 28px;
            text-align: center;
            color: var(--muted);
            font-size: 0.88rem;
        }

        @media (max-width: 720px) {
            .page { padding: 20px 16px 48px; }
            .hero { padding: 24px 20px 22px; }
            .hero-layout {
                flex-direction: column;
                align-items: center;
                text-align: center;
                gap: 20px;
            }
            .hero-logo { flex: 0 0 auto; max-width: 220px; }
            .hero-logo img { max-width: 220px; }
            .hero-meta { justify-content: center; }
            .service-card { grid-template-columns: 1fr; }
            .status { justify-self: start; }
            .section-title {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="page">
        <section class="hero">
            <div class="hero-layout">
                <div class="hero-logo">
                    <img
                        src="<%= ctx %>/img/logo-sigre.png"
                        alt="SIGRE">
                </div>
                <div class="hero-body">
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
                </div>
            </div>
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
