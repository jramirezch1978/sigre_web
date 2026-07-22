package pe.com.sytco.fastsales.api.rrhh.dto;

public class ClienteDto {
    private String codCliente;
    private String nomCliente;
    private String ruc;
    private String sigla;

    public String getCodCliente() { return codCliente; }
    public void setCodCliente(String codCliente) { this.codCliente = codCliente; }
    public String getNomCliente() { return nomCliente; }
    public void setNomCliente(String nomCliente) { this.nomCliente = nomCliente; }
    public String getRuc() { return ruc; }
    public void setRuc(String ruc) { this.ruc = ruc; }
    public String getSigla() { return sigla; }
    public void setSigla(String sigla) { this.sigla = sigla; }
}
