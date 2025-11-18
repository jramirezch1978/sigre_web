$PBExportHeader$w_ope901_abrir_cerrar_operaciones.srw
forward
global type w_ope901_abrir_cerrar_operaciones from w_prc
end type
type st_6 from statictext within w_ope901_abrir_cerrar_operaciones
end type
type st_1 from statictext within w_ope901_abrir_cerrar_operaciones
end type
type ddlb_1 from dropdownlistbox within w_ope901_abrir_cerrar_operaciones
end type
type sle_1 from singlelineedit within w_ope901_abrir_cerrar_operaciones
end type
type uo_1 from u_ingreso_fecha within w_ope901_abrir_cerrar_operaciones
end type
type st_5 from statictext within w_ope901_abrir_cerrar_operaciones
end type
type st_4 from statictext within w_ope901_abrir_cerrar_operaciones
end type
type st_3 from statictext within w_ope901_abrir_cerrar_operaciones
end type
type st_2 from statictext within w_ope901_abrir_cerrar_operaciones
end type
type cb_2 from commandbutton within w_ope901_abrir_cerrar_operaciones
end type
type cb_procesar from commandbutton within w_ope901_abrir_cerrar_operaciones
end type
type gb_1 from groupbox within w_ope901_abrir_cerrar_operaciones
end type
end forward

global type w_ope901_abrir_cerrar_operaciones from w_prc
integer width = 1701
integer height = 1220
string title = "OPE901 - Abrir y cerrar operaciones"
event ue_procesar ( )
st_6 st_6
st_1 st_1
ddlb_1 ddlb_1
sle_1 sle_1
uo_1 uo_1
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
cb_2 cb_2
cb_procesar cb_procesar
gb_1 gb_1
end type
global w_ope901_abrir_cerrar_operaciones w_ope901_abrir_cerrar_operaciones

event ue_procesar();Date ld_fecha
String ls_msj, ls_tipo_doc, ls_flag

ld_fecha = uo_1.of_get_fecha()
ls_flag	= left(ddlb_1.text,1)
ls_tipo_doc = trim(sle_1.text)

cb_procesar.enabled = false

//create or replace procedure USP_OPE_CIERRE_AMP(
//       asi_tipo_doc   IN doc_tipo.tipo_doc%TYPE,
//       adi_fecha      IN DATE,
//       asi_flag       IN VARCHAR2,
//       asi_user       IN usuario.cod_usr%TYPE
//) IS

DECLARE USP_OPE_CIERRE_AMP PROCEDURE FOR 
		USP_OPE_CIERRE_AMP ( :ls_tipo_doc,
									:ld_fecha, 
									:ls_flag,
									:gs_user	);
											  
execute USP_OPE_CIERRE_AMP;

IF sqlca.sqlcode = -1 Then
	ls_msj = sqlca.sqlerrtext
	rollback ;
	MessageBox( 'Error USP_OPE_CIERRA_OPERACIONES', ls_msj, StopSign! )
	return
end if

CLOSE USP_OPE_CIERRE_AMP;

MessageBox( 'Mensaje', "Proceso terminado" )

cb_procesar.enabled = true

end event

on w_ope901_abrir_cerrar_operaciones.create
int iCurrent
call super::create
this.st_6=create st_6
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.sle_1=create sle_1
this.uo_1=create uo_1
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_procesar=create cb_procesar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_6
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_1
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.cb_procesar
this.Control[iCurrent+12]=this.gb_1
end on

on w_ope901_abrir_cerrar_operaciones.destroy
call super::destroy
destroy(this.st_6)
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.sle_1)
destroy(this.uo_1)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_procesar)
destroy(this.gb_1)
end on

event open;call super::open;string ls_doc_ot

select doc_ot 
	into :ls_doc_ot
from logparam
where reckey = '1';

sle_1.text = ls_doc_ot

end event

type st_6 from statictext within w_ope901_abrir_cerrar_operaciones
integer x = 169
integer y = 700
integer width = 256
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Flag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ope901_abrir_cerrar_operaciones
integer x = 174
integer y = 596
integer width = 256
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Tipo Doc:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_ope901_abrir_cerrar_operaciones
integer x = 434
integer y = 684
integer width = 1065
integer height = 300
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"1.- Reprogramar el AMP (si tiene OC)","2.- Liberar el AMP y cerrarlo (si tiene OC)"}
borderstyle borderstyle = stylelowered!
end type

type sle_1 from singlelineedit within w_ope901_abrir_cerrar_operaciones
integer x = 434
integer y = 584
integer width = 402
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type uo_1 from u_ingreso_fecha within w_ope901_abrir_cerrar_operaciones
event destroy ( )
integer x = 178
integer y = 496
integer taborder = 40
end type

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:') // para seatear el titulo del boton
 of_set_fecha(date(f_fecha_actual())) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type st_5 from statictext within w_ope901_abrir_cerrar_operaciones
integer x = 110
integer y = 312
integer width = 1463
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "tener acceso a esta opción."
boolean focusrectangle = false
end type

type st_4 from statictext within w_ope901_abrir_cerrar_operaciones
integer x = 105
integer y = 220
integer width = 1463
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Se sugiere que solo personal de Sistemas debe "
boolean focusrectangle = false
end type

type st_3 from statictext within w_ope901_abrir_cerrar_operaciones
integer x = 105
integer y = 124
integer width = 1463
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "abiertos en un determinado rango de fecha."
boolean focusrectangle = false
end type

type st_2 from statictext within w_ope901_abrir_cerrar_operaciones
integer x = 105
integer y = 44
integer width = 1463
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Opción que cerrará los registros pendientes o "
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_ope901_abrir_cerrar_operaciones
integer x = 983
integer y = 972
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir"
end type

event clicked;Close(Parent)
end event

type cb_procesar from commandbutton within w_ope901_abrir_cerrar_operaciones
integer x = 270
integer y = 976
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesa"
end type

event clicked;parent.event ue_procesar()
end event

type gb_1 from groupbox within w_ope901_abrir_cerrar_operaciones
integer x = 128
integer y = 436
integer width = 1403
integer height = 496
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

