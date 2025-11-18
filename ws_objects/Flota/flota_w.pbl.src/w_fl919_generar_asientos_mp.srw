$PBExportHeader$w_fl919_generar_asientos_mp.srw
forward
global type w_fl919_generar_asientos_mp from w_abc
end type
type cb_aceptar from commandbutton within w_fl919_generar_asientos_mp
end type
type st_2 from statictext within w_fl919_generar_asientos_mp
end type
type st_3 from statictext within w_fl919_generar_asientos_mp
end type
type em_mes from editmask within w_fl919_generar_asientos_mp
end type
type em_ano from editmask within w_fl919_generar_asientos_mp
end type
type cb_cancelar from commandbutton within w_fl919_generar_asientos_mp
end type
end forward

global type w_fl919_generar_asientos_mp from w_abc
integer width = 1568
integer height = 568
string title = "[FL919] Generar Ingresos / Salidas en almacen"
string menuname = "m_only_exit"
event ue_aceptar ( )
cb_aceptar cb_aceptar
st_2 st_2
st_3 st_3
em_mes em_mes
em_ano em_ano
cb_cancelar cb_cancelar
end type
global w_fl919_generar_asientos_mp w_fl919_generar_asientos_mp

event ue_aceptar();Integer 	li_year, li_mes
string	ls_mensaje

li_year 	= Integer(em_ano.text)
li_mes 	= Integer(em_mes.text)

//PROCEDURE sp_traslada_fp_alm_mp(
//			ani_year    number, 
//			ani_mes     number,
//			asi_user    usuario.cod_usr%TYPE
//) is
DECLARE sp_traslada_fp_alm_mp PROCEDURE FOR
	PKG_ALMACEN.sp_traslada_fp_alm_mp( 	:li_year, 
									  				:li_mes, 
									  				:gs_user	);

EXECUTE sp_traslada_fp_alm_mp;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE sp_traslada_fp_alm_mp: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE sp_traslada_fp_alm_mp;

MessageBox('Informacion', 'Proceso ejecutado satisfactoriamente', Information!)

return
end event

on w_fl919_generar_asientos_mp.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.cb_aceptar=create cb_aceptar
this.st_2=create st_2
this.st_3=create st_3
this.em_mes=create em_mes
this.em_ano=create em_ano
this.cb_cancelar=create cb_cancelar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_mes
this.Control[iCurrent+5]=this.em_ano
this.Control[iCurrent+6]=this.cb_cancelar
end on

on w_fl919_generar_asientos_mp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_aceptar)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_mes)
destroy(this.em_ano)
destroy(this.cb_cancelar)
end on

event ue_open_pre;call super::ue_open_pre;em_ano.text = string( date(gnvo_app.of_fecha_actual()), 'yyyy' )
em_mes.text = string( date(gnvo_app.of_fecha_actual()), 'mm' )
end event

type cb_aceptar from commandbutton within w_fl919_generar_asientos_mp
integer x = 311
integer y = 168
integer width = 393
integer height = 124
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.event dynamic ue_aceptar()
end event

type st_2 from statictext within w_fl919_generar_asientos_mp
integer x = 635
integer y = 44
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_fl919_generar_asientos_mp
integer x = 78
integer y = 44
integer width = 137
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_mes from editmask within w_fl919_generar_asientos_mp
integer x = 846
integer y = 24
integer width = 370
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
end type

type em_ano from editmask within w_fl919_generar_asientos_mp
integer x = 251
integer y = 28
integer width = 366
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type cb_cancelar from commandbutton within w_fl919_generar_asientos_mp
integer x = 709
integer y = 168
integer width = 393
integer height = 124
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;close(parent)
end event

