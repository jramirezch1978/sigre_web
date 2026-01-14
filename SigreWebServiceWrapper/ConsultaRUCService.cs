using System;
using System.Runtime.InteropServices;
using SigreWebServiceWrapper.ConsultaRUCService;

namespace SigreWebServiceWrapper
{
    /// <summary>
    /// Servicio para consultar RUC desde SUNAT
    /// Expuesto como objeto COM para uso desde PowerBuilder 2025
    /// </summary>
    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("SigreWebServiceWrapper.ConsultaRUC")]
    public class ConsultaRUC
    {
        private FaceConsultaRUCClient _client;

        /// <summary>
        /// Constructor - inicializa el cliente WCF
        /// </summary>
        public ConsultaRUC()
        {
            try
            {
                _client = new FaceConsultaRUCClient();
            }
            catch (System.Exception ex)
            {
                throw new COMException("Error al inicializar el servicio de consulta RUC: " + ex.Message, ex);
            }
        }

        /// <summary>
        /// Consulta información del RUC desde el servicio remoto SUNAT
        /// Este es el método principal usado desde PowerBuilder
        /// </summary>
        /// <param name="rucConsulta">RUC a consultar</param>
        /// <param name="rucOrigen">RUC de la empresa que consulta</param>
        /// <param name="usuario">Usuario del servicio</param>
        /// <param name="clave">Clave del servicio</param>
        /// <param name="empresa">Código de empresa</param>
        /// <param name="computerName">Nombre del computador</param>
        /// <returns>Objeto PadronRUC con la información del RUC consultado</returns>
        public PadronRUC ConsultarRUC(
            string rucConsulta,
            string rucOrigen,
            string usuario,
            string clave,
            string empresa,
            string computerName)
        {
            try
            {
                // Validar parámetros
                if (string.IsNullOrEmpty(rucConsulta))
                {
                    return new PadronRUC
                    {
                        IsOk = false,
                        Mensaje = "El RUC a consultar no puede estar vacío"
                    };
                }

                // Llamar al servicio SOAP usando el método consultarPB
                var resultado = _client.consultarPB(
                    rucConsulta,
                    rucOrigen ?? "",
                    usuario ?? "",
                    clave ?? "",
                    empresa ?? "",
                    computerName ?? "");

                // Convertir la respuesta a un formato simple para COM
                return ConvertirRespuesta(resultado);
            }
            catch (System.ServiceModel.FaultException<SigreWebServiceWrapper.ConsultaRUCService.Exception> fex)
            {
                return new PadronRUC
                {
                    IsOk = false,
                    Mensaje = "Error del servicio: " + (fex.Detail?.message ?? fex.Message)
                };
            }
            catch (System.ServiceModel.CommunicationException cex)
            {
                return new PadronRUC
                {
                    IsOk = false,
                    Mensaje = "Error de comunicación con el servicio: " + cex.Message
                };
            }
            catch (System.Exception ex)
            {
                return new PadronRUC
                {
                    IsOk = false,
                    Mensaje = "Error al consultar RUC: " + ex.Message
                };
            }
        }

        /// <summary>
        /// Método de prueba del servicio
        /// </summary>
        /// <param name="ruc">RUC para probar</param>
        /// <returns>Mensaje de respuesta del servicio</returns>
        public string Test(string ruc)
        {
            try
            {
                return _client.test(ruc ?? "");
            }
            catch (System.Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        /// <summary>
        /// Convierte la respuesta del servicio SOAP a un formato simple para COM
        /// </summary>
        private PadronRUC ConvertirRespuesta(beanPadronRuc bean)
        {
            if (bean == null)
            {
                return new PadronRUC
                {
                    IsOk = false,
                    Mensaje = "No se recibió respuesta del servicio"
                };
            }

            return new PadronRUC
            {
                IsOk = bean.isOk,
                Mensaje = bean.mensaje ?? "",
                Ruc = bean.ruc ?? "",
                RazonSocial = bean.razonSocial ?? "",
                Estado = bean.estado ?? "",
                Condicion = bean.condicion ?? "",
                Ubigeo = bean.ubigeo ?? "",
                TipoVia = bean.tipoVia ?? "",
                NombreVia = bean.nombreVia ?? "",
                CodigoZona = bean.codigoZona ?? "",
                TipoZona = bean.tipoZona ?? "",
                Numero = bean.numero ?? "",
                Interior = bean.interior ?? "",
                Lote = bean.lote ?? "",
                Departamento = bean.departamento ?? "",
                Manzana = bean.manzana ?? "",
                Kilometro = bean.kilometro ?? "",
                CodProvincia = bean.codProvincia ?? "",
                DescProvincia = bean.descProvincia ?? "",
                CodDepartamento = bean.codDepartamento ?? "",
                DescDepartamento = bean.descDepartamento ?? "",
                DescDistrito = bean.descDistrito ?? ""
            };
        }

        /// <summary>
        /// Cierra la conexión del cliente WCF
        /// </summary>
        public void Dispose()
        {
            try
            {
                if (_client != null)
                {
                    if (_client.State == System.ServiceModel.CommunicationState.Opened)
                    {
                        _client.Close();
                    }
                    else if (_client.State == System.ServiceModel.CommunicationState.Faulted)
                    {
                        _client.Abort();
                    }
                }
            }
            catch
            {
                // Ignorar errores al cerrar
            }
        }
    }

    /// <summary>
    /// Clase de respuesta simplificada para PowerBuilder
    /// Contiene toda la información del Padrón RUC de SUNAT
    /// </summary>
    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.AutoDual)]
    public class PadronRUC
    {
        public bool IsOk { get; set; }
        public string Mensaje { get; set; }
        public string Ruc { get; set; }
        public string RazonSocial { get; set; }
        public string Estado { get; set; }
        public string Condicion { get; set; }
        public string Ubigeo { get; set; }
        public string TipoVia { get; set; }
        public string NombreVia { get; set; }
        public string CodigoZona { get; set; }
        public string TipoZona { get; set; }
        public string Numero { get; set; }
        public string Interior { get; set; }
        public string Lote { get; set; }
        public string Departamento { get; set; }
        public string Manzana { get; set; }
        public string Kilometro { get; set; }
        public string CodProvincia { get; set; }
        public string DescProvincia { get; set; }
        public string CodDepartamento { get; set; }
        public string DescDepartamento { get; set; }
        public string DescDistrito { get; set; }

        /// <summary>
        /// Constructor - inicializa todas las propiedades string vacías
        /// </summary>
        public PadronRUC()
        {
            Mensaje = "";
            Ruc = "";
            RazonSocial = "";
            Estado = "";
            Condicion = "";
            Ubigeo = "";
            TipoVia = "";
            NombreVia = "";
            CodigoZona = "";
            TipoZona = "";
            Numero = "";
            Interior = "";
            Lote = "";
            Departamento = "";
            Manzana = "";
            Kilometro = "";
            CodProvincia = "";
            DescProvincia = "";
            CodDepartamento = "";
            DescDepartamento = "";
            DescDistrito = "";
        }

        /// <summary>
        /// Retorna la dirección completa formateada
        /// </summary>
        public string ObtenerDireccionCompleta()
        {
            string direccion = "";

            if (!string.IsNullOrEmpty(TipoVia))
                direccion += TipoVia + " ";

            if (!string.IsNullOrEmpty(NombreVia))
                direccion += NombreVia + " ";

            if (!string.IsNullOrEmpty(Numero))
                direccion += "Nro. " + Numero + " ";

            if (!string.IsNullOrEmpty(Interior))
                direccion += "Int. " + Interior + " ";

            if (!string.IsNullOrEmpty(TipoZona))
                direccion += TipoZona + " ";

            if (!string.IsNullOrEmpty(CodigoZona))
                direccion += CodigoZona + " ";

            if (!string.IsNullOrEmpty(Manzana))
                direccion += "Mz. " + Manzana + " ";

            if (!string.IsNullOrEmpty(Lote))
                direccion += "Lt. " + Lote + " ";

            if (!string.IsNullOrEmpty(Kilometro))
                direccion += "Km. " + Kilometro + " ";

            return direccion.Trim();
        }

        /// <summary>
        /// Retorna la ubicación completa (Distrito, Provincia, Departamento)
        /// </summary>
        public string ObtenerUbicacionCompleta()
        {
            string ubicacion = "";

            if (!string.IsNullOrEmpty(DescDistrito))
                ubicacion += DescDistrito;

            if (!string.IsNullOrEmpty(DescProvincia))
            {
                if (ubicacion.Length > 0) ubicacion += " - ";
                ubicacion += DescProvincia;
            }

            if (!string.IsNullOrEmpty(DescDepartamento))
            {
                if (ubicacion.Length > 0) ubicacion += " - ";
                ubicacion += DescDepartamento;
            }

            return ubicacion;
        }
    }
}

