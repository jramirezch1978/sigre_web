$PBExportHeader$w_rh909_transferencia_txt_afp.srw
forward
global type w_rh909_transferencia_txt_afp from w_prc
end type
type dw_temporal from datawindow within w_rh909_transferencia_txt_afp
end type
type st_3 from statictext within w_rh909_transferencia_txt_afp
end type
type ddlb_mes from dropdownlistbox within w_rh909_transferencia_txt_afp
end type
type st_2 from statictext within w_rh909_transferencia_txt_afp
end type
type em_ano from editmask within w_rh909_transferencia_txt_afp
end type
type st_1 from statictext within w_rh909_transferencia_txt_afp
end type
type dw_lista from datawindow within w_rh909_transferencia_txt_afp
end type
type cb_1 from commandbutton within w_rh909_transferencia_txt_afp
end type
type gb_1 from groupbox within w_rh909_transferencia_txt_afp
end type
end forward

global type w_rh909_transferencia_txt_afp from w_prc
integer width = 2011
integer height = 1212
string title = "(RH908) Transferencia de Vacaciones"
dw_temporal dw_temporal
st_3 st_3
ddlb_mes ddlb_mes
st_2 st_2
em_ano em_ano
st_1 st_1
dw_lista dw_lista
cb_1 cb_1
gb_1 gb_1
end type
global w_rh909_transferencia_txt_afp w_rh909_transferencia_txt_afp

on w_rh909_transferencia_txt_afp.create
int iCurrent
call super::create
this.dw_temporal=create dw_temporal
this.st_3=create st_3
this.ddlb_mes=create ddlb_mes
this.st_2=create st_2
this.em_ano=create em_ano
this.st_1=create st_1
this.dw_lista=create dw_lista
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_temporal
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.ddlb_mes
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_ano
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_lista
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_rh909_transferencia_txt_afp.destroy
call super::destroy
destroy(this.dw_temporal)
destroy(this.st_3)
destroy(this.ddlb_mes)
destroy(this.st_2)
destroy(this.em_ano)
destroy(this.st_1)
destroy(this.dw_lista)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;call super::open;
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

dw_temporal.Settransobject(sqlca)
dw_lista.Settransobject(sqlca)
dw_lista.Retrieve()
end event

type dw_temporal from datawindow within w_rh909_transferencia_txt_afp
boolean visible = false
integer x = 1957
integer y = 48
integer width = 1010
integer height = 888
integer taborder = 50
string title = "none"
string dataobject = "d_abc_monto_afp_tt_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_3 from statictext within w_rh909_transferencia_txt_afp
integer x = 59
integer y = 332
integer width = 512
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Seleccionar Origen :"
boolean focusrectangle = false
end type

type ddlb_mes from dropdownlistbox within w_rh909_transferencia_txt_afp
integer x = 402
integer y = 216
integer width = 517
integer height = 856
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_rh909_transferencia_txt_afp
integer x = 41
integer y = 212
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_rh909_transferencia_txt_afp
integer x = 402
integer y = 100
integer width = 343
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_1 from statictext within w_rh909_transferencia_txt_afp
integer x = 41
integer y = 112
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_lista from datawindow within w_rh909_transferencia_txt_afp
integer x = 46
integer y = 396
integer width = 1851
integer height = 580
integer taborder = 20
string title = "none"
string dataobject = "d_abc_lista_origenes_tbl"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;accepttext()
end event

event itemerror;return 1
end event

type cb_1 from commandbutton within w_rh909_transferencia_txt_afp
integer x = 1559
integer y = 64
integer width = 320
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Long   ll_inicio,ll_ano,ll_mes
String ls_flag,ls_cadena,ls_msj_err


Parent.SetMicroHelp('Procesando Transferencia de Afp')
SetPointer(HourGlass!)

//
ll_ano    = Long(em_ano.text)
ll_mes    = Long(LEFT(ddlb_mes.text,2))
dw_lista.accepttext()


For ll_inicio = 1 to dw_lista.Rowcount()
	 //armar cadena
	 ls_flag   = dw_lista.object.indicador  [ll_inicio]
	 ls_cadena = dw_lista.object.cod_origen [ll_inicio]
	 
	 if trim(ls_flag) = '1' then
		 Insert Into TT_FIN_ORIGENES
		 (cod_origen)
		 Values
		 (:ls_cadena) ;
		 
	 end if
	 
Next	

//ejecuto procedimiento
DECLARE PB_usp_rrhh_texo_afp PROCEDURE FOR usp_rrhh_texo_afp
(:ll_ano,:ll_mes,:gs_user);
EXECUTE PB_usp_rrhh_texo_afp ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	MessageBox('SQL error',ls_msj_err )
	Rollback ;
END IF


dw_temporal.reset()
dw_temporal.retrieve()

dw_temporal.saveas('',Text!,false)

CLOSE PB_usp_rrhh_texo_afp ;


SetPointer(Arrow!)



end event

type gb_1 from groupbox within w_rh909_transferencia_txt_afp
integer x = 18
integer y = 16
integer width = 1934
integer height = 1008
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Ingrese Datos "
end type

