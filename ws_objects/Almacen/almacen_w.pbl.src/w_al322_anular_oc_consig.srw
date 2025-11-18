$PBExportHeader$w_al322_anular_oc_consig.srw
forward
global type w_al322_anular_oc_consig from w_abc
end type
type st_ori from statictext within w_al322_anular_oc_consig
end type
type sle_ori from singlelineedit within w_al322_anular_oc_consig
end type
type st_nro from statictext within w_al322_anular_oc_consig
end type
type sle_nro_oc from singlelineedit within w_al322_anular_oc_consig
end type
type st_1 from statictext within w_al322_anular_oc_consig
end type
type pb_salir from picturebutton within w_al322_anular_oc_consig
end type
type pb_aceptar from picturebutton within w_al322_anular_oc_consig
end type
end forward

global type w_al322_anular_oc_consig from w_abc
integer width = 2007
integer height = 708
string title = "Anular Liquidacion de Consignacion (AL322)"
string menuname = "m_salir"
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
st_ori st_ori
sle_ori sle_ori
st_nro st_nro
sle_nro_oc sle_nro_oc
st_1 st_1
pb_salir pb_salir
pb_aceptar pb_aceptar
end type
global w_al322_anular_oc_consig w_al322_anular_oc_consig

forward prototypes
public function boolean of_proceso (string as_origen, string as_nro_oc)
end prototypes

event ue_aceptar();DAte ld_Fecha
SetPointer (HourGlass!)

this.of_proceso(sle_ori.text, sle_nro_oc.text)

SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

public function boolean of_proceso (string as_origen, string as_nro_oc);string ls_mensaje
//create or replace procedure USP_ALM_ANULAR_OC_CONSIG(
//       asi_origen in origen.cod_origen%TYPE,
//       asi_nro_oc in orden_compra.nro_oc%TYPE
//) is

DECLARE USP_ALM_ANULAR_OC_CONSIG PROCEDURE FOR
	USP_ALM_ANULAR_OC_CONSIG( :as_origen, :as_nro_oc );

EXECUTE USP_ALM_ANULAR_OC_CONSIG;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_ANULAR_OC_CONSIG:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_ALM_ANULAR_OC_CONSIG;

MessageBox('Aviso', 'Proceso ha sido ejecutado satisfactoriamente')

return true
end function

on w_al322_anular_oc_consig.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_ori=create st_ori
this.sle_ori=create sle_ori
this.st_nro=create st_nro
this.sle_nro_oc=create sle_nro_oc
this.st_1=create st_1
this.pb_salir=create pb_salir
this.pb_aceptar=create pb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_ori
this.Control[iCurrent+2]=this.sle_ori
this.Control[iCurrent+3]=this.st_nro
this.Control[iCurrent+4]=this.sle_nro_oc
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.pb_salir
this.Control[iCurrent+7]=this.pb_aceptar
end on

on w_al322_anular_oc_consig.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_ori)
destroy(this.sle_ori)
destroy(this.st_nro)
destroy(this.sle_nro_oc)
destroy(this.st_1)
destroy(this.pb_salir)
destroy(this.pb_aceptar)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
end event

type st_ori from statictext within w_al322_anular_oc_consig
integer x = 123
integer y = 176
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type sle_ori from singlelineedit within w_al322_anular_oc_consig
event dobleclick pbm_lbuttondblclk
integer x = 425
integer y = 164
integer width = 229
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_origen as cod_origen, " &
		 + "nombre AS DESCRIPCION_origen " &
		 + "FROM origen " 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type st_nro from statictext within w_al322_anular_oc_consig
integer x = 754
integer y = 176
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero:"
boolean focusrectangle = false
end type

type sle_nro_oc from singlelineedit within w_al322_anular_oc_consig
integer x = 1042
integer y = 164
integer width = 512
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_al322_anular_oc_consig
integer x = 46
integer y = 16
integer width = 1883
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Anular Liquidacion de Consignacion"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_salir from picturebutton within w_al322_anular_oc_consig
integer x = 1074
integer y = 324
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_aceptar from picturebutton within w_al322_anular_oc_consig
integer x = 699
integer y = 324
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_aceptar()
end event

