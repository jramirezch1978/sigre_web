$PBExportHeader$w_al905_act_prec_oc_ni.srw
forward
global type w_al905_act_prec_oc_ni from w_abc
end type
type st_3 from statictext within w_al905_act_prec_oc_ni
end type
type uo_fecha from u_ingreso_fecha within w_al905_act_prec_oc_ni
end type
type sle_nro_oc from singlelineedit within w_al905_act_prec_oc_ni
end type
type st_1 from statictext within w_al905_act_prec_oc_ni
end type
type pb_2 from picturebutton within w_al905_act_prec_oc_ni
end type
type pb_1 from picturebutton within w_al905_act_prec_oc_ni
end type
end forward

global type w_al905_act_prec_oc_ni from w_abc
integer width = 2007
integer height = 708
string title = "Recalculo del precio promedio (AL900)"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
st_3 st_3
uo_fecha uo_fecha
sle_nro_oc sle_nro_oc
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_al905_act_prec_oc_ni w_al905_act_prec_oc_ni

forward prototypes
public function boolean of_proceso (string as_nro_oc, date ad_fecha)
end prototypes

event ue_aceptar();DAte ld_Fecha
SetPointer (HourGlass!)

ld_fecha = uo_fecha.of_get_fecha()

this.of_proceso(sle_nro_oc.text, ld_fecha)

SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

public function boolean of_proceso (string as_nro_oc, date ad_fecha);string ls_mensaje
//create or replace procedure usp_cmp_act_prec_ni(
//       asi_nro_oc           in orden_compra.nro_oc%TYPE,
//       adi_fecha            in date
//) is

DECLARE usp_cmp_act_prec_ni PROCEDURE FOR
	usp_cmp_act_prec_ni( :as_nro_oc, :ad_fecha );

EXECUTE usp_cmp_act_prec_ni;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_cmp_act_prec_ni:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE usp_cmp_act_prec_ni;

MessageBox('Aviso', 'Proceso ha sido ejecutado satisfactoriamente')

return true
end function

on w_al905_act_prec_oc_ni.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_3=create st_3
this.uo_fecha=create uo_fecha
this.sle_nro_oc=create sle_nro_oc
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.sle_nro_oc
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_1
end on

on w_al905_act_prec_oc_ni.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.uo_fecha)
destroy(this.sle_nro_oc)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
end event

type st_3 from statictext within w_al905_act_prec_oc_ni
integer x = 50
integer y = 140
integer width = 480
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Compra"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_fecha within w_al905_act_prec_oc_ni
integer x = 1175
integer y = 128
integer taborder = 20
end type

event constructor;call super::constructor;string ls_fecha

ls_fecha = '01/01/' + string(year(Today()))

of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(date(ls_fecha)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

type sle_nro_oc from singlelineedit within w_al905_act_prec_oc_ni
event ue_dobleclick pbm_lbuttondblclk
integer x = 544
integer y = 128
integer width = 439
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_al905_act_prec_oc_ni
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
string text = "Regenerar Precio OC - NI"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_al905_act_prec_oc_ni
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
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_al905_act_prec_oc_ni
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
string picturename = "c:\sigre\resources\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

