package pe.com.sytco.fastsales.adapter;

import org.kobjects.isodate.IsoDate;
import org.ksoap2.serialization.Marshal;
import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlSerializer;

import java.io.IOException;

import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 05/04/2016.
 *
 */
public class MarshalDate implements Marshal {
    public static Class DATE_CLASS = java.sql.Date.class;

    public Object readInstance(XmlPullParser parser, String namespace, String name, PropertyInfo expected)
            throws IOException, XmlPullParserException
    {
        //IsoDate.DATE_TIME=3
        //String Test1 = parser.nextText();
        //return IsoDate.stringToDate(parser.nextText(), IsoDate.DATE_TIME);
        //return Util

        return UTIL.parseStringToSqlDate(parser.nextText());


    }
    public void register(SoapSerializationEnvelope cm)
    {
        //cm.addMapping(cm.xsd, "DateTime", MarshalDate.DATE_CLASS, this);
        // "DateTime" is wrong use "dateTime" ok
        cm.addMapping(cm.xsd, "dateTime", java.sql.Date.class, this);

    }
    public void writeInstance(XmlSerializer writer, Object obj)
            throws IOException
    {
        //String Test="";
        //Test = IsoDate.dateToString((java.sql.Date) obj, IsoDate.DATE_TIME);
        //writer.text(IsoDate.dateToString((java.sql.Date) obj, IsoDate.DATE_TIME));
        writer.text(UTIL.parseSqlDatetoString((java.sql.Date) obj));
    }

}