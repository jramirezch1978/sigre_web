$PBExportHeader$w_ap903_actualizar_costos_compra.srw
forward
global type w_ap903_actualizar_costos_compra from w_abc
end type
type pb_1 from picturebutton within w_ap903_actualizar_costos_compra
end type
type pb_2 from picturebutton within w_ap903_actualizar_costos_compra
end type
type st_1 from statictext within w_ap903_actualizar_costos_compra
end type
end forward

global type w_ap903_actualizar_costos_compra from w_abc
integer width = 1838
integer height = 872
string title = "Actualizas Costos de Ultima Compra [AP903]"
string menuname = "m_salir"
event ue_aceptar ( )
event ue_salir ( )
pb_1 pb_1
pb_2 pb_2
st_1 st_1
end type
global w_ap903_actualizar_costos_compra w_ap903_actualizar_costos_compra

event ue_aceptar();// Para actualizar los costos de ultima compra
SetPointer (HourGlass!)
 
string ls_mensaje, ls_null
 
SetNull(ls_null)
 
DECLARE USP_ACT_COSTO_ALMACEN PROCEDURE FOR
 USP_AP_ACT_COSTO_ALMACEN( :ls_null );
 
EXECUTE USP_ACT_COSTO_ALMACEN;
 
IF SQLCA.sqlcode = -1 THEN
	 ls_mensaje = "PROCEDURE USP_AP_ACT_COSTO_ALMACEN: " + SQLCA.SQLErrText
	 ROLLBACK ;
	 MessageBox('SQL error', ls_mensaje, StopSign!) 
	 SetPointer (Arrow!)
	 RETURN 
END IF
 
CLOSE USP_ACT_COSTO_ALMACEN;
 
MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')
 
SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

on w_ap903_actualizar_costos_compra.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.st_1
end on

on w_ap903_actualizar_costos_compra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
end on

type pb_1 from picturebutton within w_ap903_actualizar_costos_compra
integer x = 462
integer y = 352
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

type pb_2 from picturebutton within w_ap903_actualizar_costos_compra
integer x = 965
integer y = 352
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
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type st_1 from statictext within w_ap903_actualizar_costos_compra
integer x = 55
integer y = 40
integer width = 1691
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
string text = "Actualizar Costos de Ultima Compra"
alignment alignment = center!
boolean focusrectangle = false
end type

