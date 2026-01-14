using System;

namespace SigreWebServiceWrapper
{
    /// <summary>
    /// Programa de prueba para testear las funcionalidades del DLL
    /// Ejecutar: dotnet run o compilar y ejecutar TestConsole.exe
    /// </summary>
    public class TestConsole
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("============================================================");
            Console.WriteLine("  TEST SIGRE WEB SERVICE WRAPPER");
            Console.WriteLine("============================================================");
            Console.WriteLine();

            bool continuar = true;
            while (continuar)
            {
                Console.WriteLine("Seleccione una opcion:");
                Console.WriteLine("  1. Probar envio de correo");
                Console.WriteLine("  2. Probar consulta RUC REST");
                Console.WriteLine("  3. Ver ruta del log");
                Console.WriteLine("  4. Ver configuracion SMTP");
                Console.WriteLine("  0. Salir");
                Console.WriteLine();
                Console.Write("Opcion: ");

                string opcion = Console.ReadLine();
                Console.WriteLine();

                switch (opcion)
                {
                    case "1":
                        ProbarEmail();
                        break;
                    case "2":
                        ProbarRucRest();
                        break;
                    case "3":
                        Console.WriteLine("Ruta del log: " + Logger.GetLogPath());
                        break;
                    case "4":
                        VerConfiguracion();
                        break;
                    case "0":
                        continuar = false;
                        break;
                    default:
                        Console.WriteLine("Opcion no valida");
                        break;
                }

                Console.WriteLine();
            }
        }

        private static void ProbarEmail()
        {
            Console.WriteLine("=== PRUEBA DE EMAIL ===");
            Console.WriteLine();

            Console.Write("Destinatario (email): ");
            string destinatario = Console.ReadLine();

            Console.Write("Nombre del destinatario: ");
            string nombre = Console.ReadLine();

            Console.Write("Asunto: ");
            string asunto = Console.ReadLine();

            Console.Write("Mensaje: ");
            string mensaje = Console.ReadLine();

            Console.WriteLine();
            Console.WriteLine("Enviando correo...");

            try
            {
                var emailService = new EmailService();
                
                // Mostrar configuracion
                Console.WriteLine("Configuracion: " + emailService.ObtenerConfiguracion());
                
                var resultado = emailService.EnviarCorreoCompleto(
                    destinatario,
                    nombre,
                    "", // cc
                    "", // cco
                    asunto,
                    mensaje,
                    false,
                    "");

                if (resultado.Exitoso)
                {
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine("EXITO: " + resultado.Mensaje);
                }
                else
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("ERROR: " + resultado.Mensaje);
                }
                Console.ResetColor();
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("EXCEPCION: " + ex.Message);
                Console.ResetColor();
            }
        }

        private static void ProbarRucRest()
        {
            Console.WriteLine("=== PRUEBA DE CONSULTA RUC REST ===");
            Console.WriteLine();

            Console.Write("Usuario [sigre]: ");
            string usuario = Console.ReadLine();
            if (string.IsNullOrEmpty(usuario)) usuario = "sigre";

            Console.Write("Clave [sigre1234]: ");
            string clave = Console.ReadLine();
            if (string.IsNullOrEmpty(clave)) clave = "sigre1234";

            Console.Write("Empresa [TRANSMARINA]: ");
            string empresa = Console.ReadLine();
            if (string.IsNullOrEmpty(empresa)) empresa = "TRANSMARINA";

            Console.Write("RUC a consultar: ");
            string ruc = Console.ReadLine();

            Console.Write("RUC origen [20100070970]: ");
            string rucOrigen = Console.ReadLine();
            if (string.IsNullOrEmpty(rucOrigen)) rucOrigen = "20100070970";

            Console.WriteLine();
            Console.WriteLine("Obteniendo token...");

            try
            {
                var restClient = new ConsultaRUCRest();
                
                // Obtener token
                string token = restClient.ObtenerToken(usuario, clave, empresa);
                
                if (token.StartsWith("ERROR:"))
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("Error al obtener token: " + token);
                    Console.ResetColor();
                    return;
                }

                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("Token obtenido: " + token.Substring(0, Math.Min(50, token.Length)) + "...");
                Console.ResetColor();

                Console.WriteLine();
                Console.WriteLine("Consultando RUC...");

                var resultado = restClient.ConsultarRUC(ruc, rucOrigen, "TEST-CONSOLE");

                Console.WriteLine();
                if (resultado.IsOk)
                {
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine("=== RESULTADO ===");
                    Console.WriteLine("RUC:          " + resultado.Ruc);
                    Console.WriteLine("Razon Social: " + resultado.RazonSocial);
                    Console.WriteLine("Estado:       " + resultado.Estado);
                    Console.WriteLine("Condicion:    " + resultado.Condicion);
                    Console.WriteLine("Direccion:    " + resultado.ObtenerDireccionCompleta());
                    Console.WriteLine("Ubicacion:    " + resultado.ObtenerUbicacionCompleta());
                }
                else
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("ERROR: " + resultado.Mensaje);
                }
                Console.ResetColor();
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("EXCEPCION: " + ex.Message);
                if (ex.InnerException != null)
                {
                    Console.WriteLine("Inner: " + ex.InnerException.Message);
                }
                Console.ResetColor();
            }
        }

        private static void VerConfiguracion()
        {
            Console.WriteLine("=== CONFIGURACION ===");
            try
            {
                var emailService = new EmailService();
                Console.WriteLine("SMTP: " + emailService.ObtenerConfiguracion());
                Console.WriteLine("Log:  " + Logger.GetLogPath());
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }
    }
}
