$PBExportHeader$u_pb_email.sru
$PBExportComments$Boton para Enviar Email con el contenido del dw corriente
forward
global type u_pb_email from u_pb_std
end type
end forward

global type u_pb_email from u_pb_std
int Width=146
int Height=104
string Tag="Enviar Correo con Consulta o Reporte"
string PictureName="\source\bmp\envelope.bmp"
end type
global u_pb_email u_pb_email

event clicked;call super::clicked;Parent.Event Dynamic ue_mail_send()
end event

