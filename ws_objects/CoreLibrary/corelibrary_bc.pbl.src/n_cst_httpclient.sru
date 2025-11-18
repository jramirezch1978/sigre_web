$PBExportHeader$n_cst_httpclient.sru
forward
global type n_cst_httpclient from nonvisualobject
end type
end forward

global type n_cst_httpclient from nonvisualobject
end type
global n_cst_httpclient n_cst_httpclient

type prototypes
// Importa la biblioteca de servicios de seguridad en el objeto n_cst_httpclient
Function ulong ComputeHMAC (REF string digest, blob key, blob data) Library "pbcrypto110.dll" Alias For "PBHMACCompute;Ansi"
end prototypes

type variables
String access_key = "your_access_key"
String secret_key = "your_secret_key"
String region = "your_region" 
String service = "ses"
String host 
String endpoint 
end variables

forward prototypes
public function integer sendemail (string as_from, string as_to, string as_subject, string as_body)
end prototypes

public function integer sendemail (string as_from, string as_to, string as_subject, string as_body);// En n_cst_httpclient.SendEmail
Date fecha
Time hora
String 	date_long, date_short, request_parameters, canonical_request, payload_hash, string_to_sign, &
			signature_key, signature, digest, authorization_header
			
Blob payload_blob, key_blob, data_blob

String result

fecha = Today()
hora = Now()


date_long = String(Year(fecha)) + '-' + String(Month(fecha)) + '-' + String(Day(fecha)) + 'T' &
			 + String(Hour(hora)) + ':' + String(Minute(hora)) + ':' + String(Second(hora)) + 'Z'

date_short = String(Year(fecha)) + '-' + String(Month(fecha)) + '-' + String(Day(fecha))

request_parameters = '{"Action": "SendEmail","Source": "' + as_from &
						 + '","Destination.ToAddresses.member.1": "' + as_to &
				 	    + '","Message.Subject.Data":"' + as_subject &
						 + '","Message.Body.Text.Data":"' + as_body + '"}'

canonical_request = "POST" + "\n" + "/" + "\n" &
						+ "content-type:application/x-www-form-urlencoded" + "\n" &
						+ "host:" + host + "\n" + "x-amz-date:" + date_long
								 

payload_blob = Blob(request_parameters)
key_blob = Blob("AWS4" + secret_key)
data_blob = Blob(date_short + region + service + "aws4_request")

ComputeHMAC(digest, key_blob, data_blob)

payload_hash = digest

canonical_request += "\n" + payload_hash
    
string_to_sign = "AWS4-HMAC-SHA256" + "\n" + date_long + "\n" + date_short + "/" + region &
					+ "/" + service + "/aws4_request" + "\n" + payload_hash
    
    
ComputeHMAC(signature_key, key_blob, data_blob)
ComputeHMAC(signature, Blob(signature_key), Blob(string_to_sign))

authorization_header = "AWS4-HMAC-SHA256 Credential=" + access_key + "/" + date_short + "/" &
							+ region + "/" + service &
							+ "/aws4_request,SignedHeaders=content-type;host;x-amz-date,Signature=" &
							+ signature
    
    
   

return -1
end function

on n_cst_httpclient.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_httpclient.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;access_key = "your_access_key"
secret_key = "your_secret_key"
region = "your_region" // Ejemplo: "us-west-2"
service = "ses"
host = "email." + region + ".amazonaws.com"
endpoint = "https://" + host
end event

