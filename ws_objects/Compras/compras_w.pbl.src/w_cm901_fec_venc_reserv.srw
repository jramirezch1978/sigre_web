$PBExportHeader$w_cm901_fec_venc_reserv.srw
forward
global type w_cm901_fec_venc_reserv from w_abc
end type
type sle_almacen from singlelineedit within w_cm901_fec_venc_reserv
end type
type st_2 from statictext within w_cm901_fec_venc_reserv
end type
type st_1 from statictext within w_cm901_fec_venc_reserv
end type
type pb_2 from picturebutton within w_cm901_fec_venc_reserv
end type
type pb_1 from picturebutton within w_cm901_fec_venc_reserv
end type
end forward

global type w_cm901_fec_venc_reserv from w_abc
integer width = 2007
integer height = 716
string title = "Cierra Mov Proy Reservados Vencidos (CM901)"
string menuname = "m_salir"
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
sle_almacen sle_almacen
st_2 st_2
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_cm901_fec_venc_reserv w_cm901_fec_venc_reserv

event ue_aceptar();SetPointer (HourGlass!)

string 	ls_mensaje, ls_almacen
integer	li_ok

ls_almacen = sle_almacen.text

if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe colocar almacen')
	return
end if

//create or replace procedure USP_CMP_FEC_VENC_RESERV(
//       asi_almacen          in almacen.almacen%TYPE
//) is

DECLARE USP_CMP_FEC_VENC_RESERV PROCEDURE FOR
	USP_CMP_FEC_VENC_RESERV( :ls_almacen );

EXECUTE USP_CMP_FEC_VENC_RESERV;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_CMP_FEC_VENC_RESERV: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetPointer (Arrow!)
	return 
END IF

CLOSE USP_CMP_FEC_VENC_RESERV;

MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')

SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

on w_cm901_fec_venc_reserv.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.sle_almacen=create sle_almacen
this.st_2=create st_2
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_almacen
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_1
end on

on w_cm901_fec_venc_reserv.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_almacen)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
end event

type sle_almacen from singlelineedit within w_cm901_fec_venc_reserv
event dobleclick pbm_lbuttondblclk
integer x = 910
integer y = 220
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\Cur\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
		  + "desc_almacen AS descripcion_almacen " &
		  + "FROM almacen " &
		  + "where flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if

end event

type st_2 from statictext within w_cm901_fec_venc_reserv
integer x = 553
integer y = 228
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacén:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cm901_fec_venc_reserv
integer width = 1984
integer height = 172
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Cierra Todos los movimientos proyectados reservados que han vencido"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_cm901_fec_venc_reserv
integer x = 1001
integer y = 344
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

type pb_1 from picturebutton within w_cm901_fec_venc_reserv
integer x = 626
integer y = 344
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

event clicked;parent.event dynamic ue_aceptar()
end event

