using System;
using System.Net.Http;
using System.Runtime.InteropServices;
using System.Text;
using Newtonsoft.Json;

namespace SigreWebServiceWrapper
{
    /// <summary>
    /// Servicio REST para consultar RUC desde SUNAT con autenticación JWT
    /// Expuesto como objeto COM para uso desde PowerBuilder 2025
    /// </summary>
    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("SigreWebServiceWrapper.ConsultaRUCRest")]
    [Guid("A1B2C3D4-E5F6-4789-ABCD-EF0123456789")]
    public class ConsultaRUCRest
    {
        private static readonly HttpClient _httpClient = new HttpClient();
        private string _baseUrl = "http://pegazus.serveftp.com:9080/SunatWebServices";
        private string _token = null;
        private DateTime _tokenExpiration = DateTime.MinValue;

        /// <summary>
        /// Constructor - inicializa el cliente HTTP
        /// </summary>
        public ConsultaRUCRest()
        {
            _httpClient.Timeout = TimeSpan.FromSeconds(30);
        }

        /// <summary>
        /// Configura la URL base del servicio
        /// </summary>
        /// <param name="baseUrl">URL base (ej: http://servidor:puerto/SunatWebServices)</param>
        public void ConfigurarUrl(string baseUrl)
        {
            if (!string.IsNullOrEmpty(baseUrl))
            {
                _baseUrl = baseUrl.TrimEnd('/');
            }
        }

        /// <summary>
        /// Obtiene un token JWT para autenticación
        /// El token es válido por 15 minutos
        /// </summary>
        /// <param name="usuario">Usuario del servicio</param>
        /// <param name="clave">Clave del servicio</param>
        /// <param name="empresa">Código de empresa</param>
        /// <returns>Token JWT o mensaje de error</returns>
        public string ObtenerToken(string usuario, string clave, string empresa)
        {
            try
            {
                // Verificar si el token actual aún es válido (con 1 minuto de margen)
                if (!string.IsNullOrEmpty(_token) && DateTime.Now.AddMinutes(1) < _tokenExpiration)
                {
                    return _token;
                }

                var requestBody = new
                {
                    usuario = usuario,
                    clave = clave,
                    empresa = empresa
                };

                string jsonBody = JsonConvert.SerializeObject(requestBody);
                var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var response = _httpClient.PostAsync($"{_baseUrl}/api/auth/token", content).Result;
                string responseBody = response.Content.ReadAsStringAsync().Result;

                if (response.IsSuccessStatusCode)
                {
                    var tokenResponse = JsonConvert.DeserializeObject<TokenResponse>(responseBody);
                    
                    if (tokenResponse.success)
                    {
                        _token = tokenResponse.token;
                        _tokenExpiration = DateTime.Now.AddSeconds(tokenResponse.expiresIn);
                        return _token;
                    }
                    else
                    {
                        return "ERROR: " + (tokenResponse.mensaje ?? "Error desconocido al obtener token");
                    }
                }
                else
                {
                    return "ERROR: HTTP " + (int)response.StatusCode + " - " + response.ReasonPhrase;
                }
            }
            catch (Exception ex)
            {
                return "ERROR: " + ex.Message;
            }
        }

        /// <summary>
        /// Consulta información del RUC usando el API REST con JWT
        /// Requiere haber obtenido un token previamente con ObtenerToken()
        /// </summary>
        /// <param name="rucConsulta">RUC a consultar</param>
        /// <param name="rucOrigen">RUC de la empresa que consulta</param>
        /// <param name="computerName">Nombre del computador</param>
        /// <returns>Objeto PadronRUC con la información</returns>
        public PadronRUC ConsultarRUC(string rucConsulta, string rucOrigen, string computerName)
        {
            try
            {
                // Validar que hay token
                if (string.IsNullOrEmpty(_token))
                {
                    return new PadronRUC
                    {
                        IsOk = false,
                        Mensaje = "No hay token de autenticación. Llame primero a ObtenerToken()"
                    };
                }

                // Validar si el token expiró
                if (DateTime.Now >= _tokenExpiration)
                {
                    return new PadronRUC
                    {
                        IsOk = false,
                        Mensaje = "El token ha expirado. Obtenga un nuevo token con ObtenerToken()"
                    };
                }

                // Validar parámetros
                if (string.IsNullOrEmpty(rucConsulta))
                {
                    return new PadronRUC
                    {
                        IsOk = false,
                        Mensaje = "El RUC a consultar no puede estar vacío"
                    };
                }

                var requestBody = new
                {
                    rucConsulta = rucConsulta,
                    rucOrigen = rucOrigen ?? "",
                    computerName = computerName ?? ""
                };

                string jsonBody = JsonConvert.SerializeObject(requestBody);
                var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                // Agregar el header de autorización
                var request = new HttpRequestMessage(HttpMethod.Post, $"{_baseUrl}/api/ruc/consultar");
                request.Headers.Add("Authorization", "Bearer " + _token);
                request.Content = content;

                var response = _httpClient.SendAsync(request).Result;
                string responseBody = response.Content.ReadAsStringAsync().Result;

                if (response.IsSuccessStatusCode)
                {
                    var rucResponse = JsonConvert.DeserializeObject<RucApiResponse>(responseBody);
                    
                    if (rucResponse.success && rucResponse.data != null)
                    {
                        return new PadronRUC
                        {
                            IsOk = true,
                            Mensaje = rucResponse.mensaje ?? "OK",
                            Ruc = rucResponse.data.ruc ?? "",
                            RazonSocial = rucResponse.data.razonSocial ?? "",
                            Estado = rucResponse.data.estado ?? "",
                            Condicion = rucResponse.data.condicion ?? "",
                            Ubigeo = rucResponse.data.ubigeo ?? "",
                            TipoVia = rucResponse.data.tipoVia ?? "",
                            NombreVia = rucResponse.data.nombreVia ?? "",
                            CodigoZona = rucResponse.data.codigoZona ?? "",
                            TipoZona = rucResponse.data.tipoZona ?? "",
                            Numero = rucResponse.data.numero ?? "",
                            Interior = rucResponse.data.interior ?? "",
                            Lote = rucResponse.data.lote ?? "",
                            Departamento = rucResponse.data.departamento ?? "",
                            Manzana = rucResponse.data.manzana ?? "",
                            Kilometro = rucResponse.data.kilometro ?? "",
                            CodProvincia = rucResponse.data.codProvincia ?? "",
                            DescProvincia = rucResponse.data.descProvincia ?? "",
                            CodDepartamento = rucResponse.data.codDepartamento ?? "",
                            DescDepartamento = rucResponse.data.descDepartamento ?? "",
                            DescDistrito = rucResponse.data.descDistrito ?? ""
                        };
                    }
                    else
                    {
                        return new PadronRUC
                        {
                            IsOk = false,
                            Mensaje = rucResponse.mensaje ?? "Error desconocido"
                        };
                    }
                }
                else if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                {
                    _token = null; // Invalidar token
                    return new PadronRUC
                    {
                        IsOk = false,
                        Mensaje = "Token inválido o expirado. Obtenga un nuevo token."
                    };
                }
                else
                {
                    return new PadronRUC
                    {
                        IsOk = false,
                        Mensaje = "Error HTTP " + (int)response.StatusCode + ": " + response.ReasonPhrase
                    };
                }
            }
            catch (Exception ex)
            {
                return new PadronRUC
                {
                    IsOk = false,
                    Mensaje = "Error al consultar RUC: " + ex.Message
                };
            }
        }

        /// <summary>
        /// Consulta RUC en un solo paso (obtiene token y consulta)
        /// Útil para consultas individuales sin reutilizar token
        /// </summary>
        /// <param name="rucConsulta">RUC a consultar</param>
        /// <param name="rucOrigen">RUC de la empresa que consulta</param>
        /// <param name="usuario">Usuario del servicio</param>
        /// <param name="clave">Clave del servicio</param>
        /// <param name="empresa">Código de empresa</param>
        /// <param name="computerName">Nombre del computador</param>
        /// <returns>Objeto PadronRUC con la información</returns>
        public PadronRUC ConsultarRUCCompleto(
            string rucConsulta,
            string rucOrigen,
            string usuario,
            string clave,
            string empresa,
            string computerName)
        {
            try
            {
                // Obtener token
                string tokenResult = ObtenerToken(usuario, clave, empresa);
                
                if (tokenResult.StartsWith("ERROR:"))
                {
                    return new PadronRUC
                    {
                        IsOk = false,
                        Mensaje = tokenResult
                    };
                }

                // Consultar RUC
                return ConsultarRUC(rucConsulta, rucOrigen, computerName);
            }
            catch (Exception ex)
            {
                return new PadronRUC
                {
                    IsOk = false,
                    Mensaje = "Error: " + ex.Message
                };
            }
        }

        /// <summary>
        /// Verifica si hay un token válido activo
        /// </summary>
        /// <returns>true si hay un token válido</returns>
        public bool TieneTokenValido()
        {
            return !string.IsNullOrEmpty(_token) && DateTime.Now < _tokenExpiration;
        }

        /// <summary>
        /// Obtiene los segundos restantes del token actual
        /// </summary>
        /// <returns>Segundos restantes o 0 si no hay token</returns>
        public int SegundosRestantesToken()
        {
            if (string.IsNullOrEmpty(_token) || DateTime.Now >= _tokenExpiration)
            {
                return 0;
            }
            return (int)(_tokenExpiration - DateTime.Now).TotalSeconds;
        }

        /// <summary>
        /// Invalida el token actual
        /// </summary>
        public void InvalidarToken()
        {
            _token = null;
            _tokenExpiration = DateTime.MinValue;
        }

        /// <summary>
        /// Obtiene el token actual (puede estar expirado)
        /// </summary>
        /// <returns>Token actual o vacío</returns>
        public string GetToken()
        {
            return _token ?? "";
        }

        /// <summary>
        /// Establece un token externo (usado por TokenManager)
        /// </summary>
        /// <param name="token">Token JWT</param>
        /// <param name="expiracionMinutos">Minutos de validez (default 14)</param>
        public void EstablecerToken(string token, int expiracionMinutos = 14)
        {
            _token = token;
            _tokenExpiration = DateTime.Now.AddMinutes(expiracionMinutos);
        }
    }

    #region Clases de respuesta JSON

    /// <summary>
    /// Respuesta del endpoint /api/auth/token
    /// </summary>
    internal class TokenResponse
    {
        public bool success { get; set; }
        public string token { get; set; }
        public string mensaje { get; set; }
        public int expiresIn { get; set; }
    }

    /// <summary>
    /// Respuesta del endpoint /api/ruc/consultar
    /// </summary>
    internal class RucApiResponse
    {
        public bool success { get; set; }
        public string mensaje { get; set; }
        public RucData data { get; set; }
    }

    /// <summary>
    /// Datos del RUC en la respuesta
    /// </summary>
    internal class RucData
    {
        public string ruc { get; set; }
        public string razonSocial { get; set; }
        public string estado { get; set; }
        public string condicion { get; set; }
        public string ubigeo { get; set; }
        public string tipoVia { get; set; }
        public string nombreVia { get; set; }
        public string codigoZona { get; set; }
        public string tipoZona { get; set; }
        public string numero { get; set; }
        public string interior { get; set; }
        public string lote { get; set; }
        public string departamento { get; set; }
        public string manzana { get; set; }
        public string kilometro { get; set; }
        public string codDepartamento { get; set; }
        public string descDepartamento { get; set; }
        public string codProvincia { get; set; }
        public string descProvincia { get; set; }
        public string descDistrito { get; set; }
    }

    #endregion
}
