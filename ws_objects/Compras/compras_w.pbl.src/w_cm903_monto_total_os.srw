$PBExportHeader$w_cm903_monto_total_os.srw
forward
global type w_cm903_monto_total_os from w_abc
end type
type st_1 from statictext within w_cm903_monto_total_os
end type
type pb_2 from picturebutton within w_cm903_monto_total_os
end type
type pb_1 from picturebutton within w_cm903_monto_total_os
end type
end forward

global type w_cm903_monto_total_os from w_abc
integer width = 2007
integer height = 548
string title = "Regenera el monto Total de la OS (CM903)"
string menuname = "m_salir"
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_cm903_monto_total_os w_cm903_monto_total_os

event ue_aceptar();string 	ls_mensaje

update orden_servicio os
   set os.monto_total = (select sum(NVL(osd.importe,0) - NVL(osd.decuento,0) + NVL(osd.impuesto,0) + NVL(osd.impuesto2,0)) 
                          from orden_servicio_det osd
                         where osd.nro_os = os.nro_os
                           and osd.cod_origen = os.cod_origen
                           and osd.flag_estado <> '0'),
       os.flag_replicacion = '1';

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', ls_mensaje)
	return
end if

commit;

end event

event ue_salir();close(this)
end event

on w_cm903_monto_total_os.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_1
end on

on w_cm903_monto_total_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
end event

type st_1 from statictext within w_cm903_monto_total_os
integer width = 1984
integer height = 116
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Regenera el Monto Total de la OS"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_cm903_monto_total_os
integer x = 997
integer y = 164
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

type pb_1 from picturebutton within w_cm903_monto_total_os
integer x = 622
integer y = 164
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

