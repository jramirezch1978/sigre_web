$PBExportHeader$w_cm900_oc_camb_moneda.srw
forward
global type w_cm900_oc_camb_moneda from w_abc
end type
type st_3 from statictext within w_cm900_oc_camb_moneda
end type
type uo_fecha from u_ingreso_fecha within w_cm900_oc_camb_moneda
end type
type st_2 from statictext within w_cm900_oc_camb_moneda
end type
type st_1 from statictext within w_cm900_oc_camb_moneda
end type
type sle_moneda from singlelineedit within w_cm900_oc_camb_moneda
end type
type sle_nro_oc from singlelineedit within w_cm900_oc_camb_moneda
end type
type pb_1 from picturebutton within w_cm900_oc_camb_moneda
end type
type pb_2 from picturebutton within w_cm900_oc_camb_moneda
end type
end forward

global type w_cm900_oc_camb_moneda from w_abc
integer width = 1861
integer height = 692
string title = "Cambio de Moneda en OC"
string menuname = "m_salir"
event ue_aceptar ( )
event ue_cancelar ( )
st_3 st_3
uo_fecha uo_fecha
st_2 st_2
st_1 st_1
sle_moneda sle_moneda
sle_nro_oc sle_nro_oc
pb_1 pb_1
pb_2 pb_2
end type
global w_cm900_oc_camb_moneda w_cm900_oc_camb_moneda

forward prototypes
public function boolean of_reproc_art (string as_nro_oc, string as_moneda)
end prototypes

event ue_aceptar();string 	ls_nro_oc, ls_moneda, ls_mensaje
Date		ld_fecha

ls_nro_oc = sle_nro_oc.text
if ls_nro_oc = '' or IsNull(ls_nro_oc) then
	MessageBox('Aviso', 'Debe indicar una Orden de Compra')
	return
end if

ls_moneda = sle_moneda.text
if ls_moneda = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'Debe indicar aluna moneda')
	return 
end if

ld_fecha = uo_fecha.of_get_fecha()

//create or replace procedure usp_cmp_act_cod_moneda(
//       asi_nro_oc           in orden_compra.nro_oc%TYPE,
//       asi_moneda           in moneda.cod_moneda%TYPE,
//       adi_fecha            in date
//) is

DECLARE usp_cmp_act_cod_moneda PROCEDURE FOR
	usp_cmp_act_cod_moneda( :ls_nro_oc, :ls_moneda, :ld_fecha );

EXECUTE usp_cmp_act_cod_moneda;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_cmp_act_cod_moneda:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return
END IF

CLOSE usp_cmp_act_cod_moneda;

MessageBox('Aviso', 'Proceso ejecutado satisfactoriamente')


end event

event ue_cancelar();Close(this)
end event

public function boolean of_reproc_art (string as_nro_oc, string as_moneda);string  ls_mensaje

//create or replace procedure usp_cmp_act_cod_moneda(
//       asi_nro_oc           in orden_compra.nro_oc%TYPE,
//       asi_moneda           in moneda.cod_moneda%TYPE
//       
//) is

DECLARE usp_cmp_act_cod_moneda PROCEDURE FOR
	usp_cmp_act_cod_moneda( :as_nro_oc, :as_moneda );

EXECUTE usp_cmp_act_cod_moneda;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_cmp_act_cod_moneda:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE usp_cmp_act_cod_moneda;

return true
end function

on w_cm900_oc_camb_moneda.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_3=create st_3
this.uo_fecha=create uo_fecha
this.st_2=create st_2
this.st_1=create st_1
this.sle_moneda=create sle_moneda
this.sle_nro_oc=create sle_nro_oc
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_moneda
this.Control[iCurrent+6]=this.sle_nro_oc
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_2
end on

on w_cm900_oc_camb_moneda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.uo_fecha)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_moneda)
destroy(this.sle_nro_oc)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type st_3 from statictext within w_cm900_oc_camb_moneda
integer x = 699
integer y = 24
integer width = 224
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_fecha within w_cm900_oc_camb_moneda
integer x = 987
integer y = 16
integer taborder = 30
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

type st_2 from statictext within w_cm900_oc_camb_moneda
integer x = 974
integer y = 160
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cm900_oc_camb_moneda
integer x = 37
integer y = 160
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro de OC:"
boolean focusrectangle = false
end type

type sle_moneda from singlelineedit within w_cm900_oc_camb_moneda
event dobleclick pbm_lbuttondblclk
integer x = 1248
integer y = 152
integer width = 279
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\Cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_moneda as codigo_moneda, " &
		 + "descripcion AS descripcion_moneda " &
	    + "FROM moneda " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type sle_nro_oc from singlelineedit within w_cm900_oc_camb_moneda
event dobleclick pbm_lbuttondblclk
integer x = 402
integer y = 152
integer width = 402
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\Cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT tipo_doc as tipo_documento, " &
		 + "nro_doc AS Numero_doc " &
	    + "FROM articulo_mov_proy amp " &
		 + "where amp.flag_estado <> '0' " &
		 + "and amp.tipo_doc = (select doc_oc from logparam where reckey = '1') "
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_data
end if

end event

type pb_1 from picturebutton within w_cm900_oc_camb_moneda
integer x = 567
integer y = 284
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
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type pb_2 from picturebutton within w_cm900_oc_camb_moneda
integer x = 942
integer y = 284
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
boolean cancel = true
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

