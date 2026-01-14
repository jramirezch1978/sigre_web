package pe.sigre.lib.adapter;

import java.sql.Date;
import java.text.SimpleDateFormat;

import javax.xml.bind.annotation.adapters.XmlAdapter;

/**
 * Adaptador para convertir java.sql.Date a String en formato XML
 */
public class SqlDateToStringAdapter extends XmlAdapter<String, Date> {
    
    private static final String DATE_FORMAT = "yyyy-MM-dd";
    private final SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT);
    
    @Override
    public Date unmarshal(String v) throws Exception {
        if (v == null || v.trim().isEmpty()) {
            return null;
        }
        java.util.Date parsed = dateFormat.parse(v);
        return new Date(parsed.getTime());
    }
    
    @Override
    public String marshal(Date v) throws Exception {
        if (v == null) {
            return null;
        }
        return dateFormat.format(v);
    }
}
