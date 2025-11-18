$PBExportHeader$w_cn700_consistencia.srw
forward
global type w_cn700_consistencia from w_rpt_htb
end type
type uo_fechas from u_ingreso_rango_fechas within w_cn700_consistencia
end type
type ddlb_moneda from dropdownlistbox within w_cn700_consistencia
end type
type ddlb_origenes from u_ddlb within w_cn700_consistencia
end type
type cbx_origen from checkbox within w_cn700_consistencia
end type
type cb_procesar from commandbutton within w_cn700_consistencia
end type
type cbx_1 from checkbox within w_cn700_consistencia
end type
end forward

global type w_cn700_consistencia from w_rpt_htb
integer width = 4059
integer height = 1988
string title = "Consistencia (CN700)"
string menuname = "m_rpt_htb"
long backcolor = 67108864
uo_fechas uo_fechas
ddlb_moneda ddlb_moneda
ddlb_origenes ddlb_origenes
cbx_origen cbx_origen
cb_procesar cb_procesar
cbx_1 cbx_1
end type
global w_cn700_consistencia w_cn700_consistencia

on w_cn700_consistencia.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_htb" then this.MenuID = create m_rpt_htb
this.uo_fechas=create uo_fechas
this.ddlb_moneda=create ddlb_moneda
this.ddlb_origenes=create ddlb_origenes
this.cbx_origen=create cbx_origen
this.cb_procesar=create cb_procesar
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.ddlb_moneda
this.Control[iCurrent+3]=this.ddlb_origenes
this.Control[iCurrent+4]=this.cbx_origen
this.Control[iCurrent+5]=this.cb_procesar
this.Control[iCurrent+6]=this.cbx_1
end on

on w_cn700_consistencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.ddlb_moneda)
destroy(this.ddlb_origenes)
destroy(this.cbx_origen)
destroy(this.cb_procesar)
destroy(this.cbx_1)
end on

event open;call super::open;ddlb_moneda.SelectItem( 1 )
end event

event ue_open_pre();call super::ue_open_pre;htb_1.visible = false
end event

type dw_report from w_rpt_htb`dw_report within w_cn700_consistencia
integer x = 5
integer y = 220
integer width = 3986
integer height = 1580
string dataobject = "d_consistencia"
end type

type htb_1 from w_rpt_htb`htb_1 within w_cn700_consistencia
integer x = 0
integer y = 136
integer width = 4014
integer height = 76
end type

type uo_fechas from u_ingreso_rango_fechas within w_cn700_consistencia
integer y = 20
integer taborder = 40
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Integer ln_ano, ln_mes, ln_dia 
string  ls_mes_ano, ls_fec1, ls_fec2
ln_ano = year( today() )
If month( today() ) = 1 then 
	ln_mes = 12
	ln_ano = ln_ano - 1 
else
	ln_mes = month( today() ) - 1
end if
If ln_mes = 01 or ln_mes = 03 or ln_mes = 05 or ln_mes = 07 or ln_mes = 08 or &
   ln_mes = 10 or ln_mes = 12 then 
	ln_dia = 31
else
   If ln_mes = 04 or ln_mes = 06 or ln_mes = 09 or ln_mes = 11 then 
    	ln_dia = 30
   else
      If mod( ln_ano, 4) = 0 then 
      	ln_dia = 29
	   else
			ln_dia = 28
		end if 
	end if
end if
ls_mes_ano = '/' + string( ln_mes, '00' ) + '/' + string( ln_ano, '0000' ) 
ls_fec1 = '01' + ls_mes_ano
ls_fec2 = string( ln_dia, '00' ) + ls_mes_ano

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date(ls_fec1), date(ls_fec2)) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1998')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type ddlb_moneda from dropdownlistbox within w_cn700_consistencia
integer x = 1312
integer y = 16
integer width = 645
integer height = 540
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"Moneda Nacional","Moneda Extranjera","Equivalente (ME en MN)"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_origenes from u_ddlb within w_cn700_consistencia
integer x = 2185
integer y = 12
integer width = 782
integer height = 756
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
boolean autohscroll = true
end type

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'origen_dddw'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 3                     // Longitud del campo 1
ii_lc2 = 50							 // Longitud del campo 2

end event

event selectionchanged;call super::selectionchanged;If len( trim( left( ddlb_origenes.Text, 2 ) ) ) = 0 then 
   cb_procesar.enabled = false
else 
	cb_procesar.enabled = true
end if 

end event

type cbx_origen from checkbox within w_cn700_consistencia
integer x = 1979
integer y = 12
integer width = 201
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo:"
boolean lefttext = true
end type

event clicked;If this.checked=true then 
	ddlb_origenes.enabled = true
	If len( trim( left( ddlb_origenes.Text, 2 ) ) ) = 0 then 
   	cb_procesar.enabled = false
	else 
		cb_procesar.enabled = true
	end if 
else
	ddlb_origenes.enabled = false
	cb_procesar.enabled = true 
end if
	
end event

type cb_procesar from commandbutton within w_cn700_consistencia
integer x = 3561
integer y = 4
integer width = 283
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;string ls_fecha1, ls_fecha2,  ls_ran_fechas
ls_fecha1 = string( uo_fechas.of_get_fecha1(), 'dd/mm/yyyy' )
ls_fecha2 = string( uo_fechas.of_get_fecha2(), 'dd/mm/yyyy' )
ls_ran_fechas = 'Del ' + ls_fecha1 + ' Al ' + ls_fecha2

String  ls_cod_moneda, ls_equivalent, ls_nom_moneda
integer li_moneda_index
ls_equivalent = 'N'
ls_nom_moneda = ddlb_moneda.Text
li_moneda_index = ddlb_moneda.SelectItem( ls_nom_moneda, 1)
choose case li_moneda_index
case 1
	ls_cod_moneda = '001'
case 2
	ls_cod_moneda = '002'
case 3 
	ls_cod_moneda = '002'
   ls_equivalent = 'S'
case else
	MessageBox( 'Moneda', 'Error en la ubicación de la moneda' ) 
	return
end choose 

string ls_chk_origen, ls_cod_origen
ls_cod_origen = ''
ls_chk_origen = 'N'
If cbx_origen.Checked = true then 
	ls_cod_origen = ddlb_origenes.Text
	ls_cod_origen = left( ls_cod_origen, 2 ) 
   ls_chk_origen = 'S'
end if
	
Parent.SetMicroHelp( 'Moneda:' + ls_cod_moneda + ' / '  + &
                     'Equiva:' + ls_equivalent + ' / '  + &
                     'Fecha1:' + ls_fecha1 + ' / '  + &
                     'Fecha2:' + ls_fecha2 + ' / '  + &
	                  'Chk_origen:' + ls_chk_origen  + ' / '  + &
						   'Cod_origen:' + ls_cod_origen )
					
DECLARE pb_usp_consistencia PROCEDURE FOR USP_CONSISTENCIA 
 ( :ls_cod_moneda, :ls_equivalent, :ls_fecha1, :ls_fecha2, :ls_chk_origen, :ls_cod_origen ) ;
Execute pb_usp_consistencia;
if sqlca.sqlcode = -1 Then
	MessageBox( 'Error', "Store procedure pb_usp_consistencia no funciona!!!" )
	return 
End If
dw_report.Retrieve( gs_empresa, gs_user, ls_nom_moneda, ls_ran_fechas )
dw_report.Show()
htb_1.Show()
Rollback ;

end event

type cbx_1 from checkbox within w_cn700_consistencia
integer x = 2985
integer y = 16
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar Fecha"
boolean checked = true
end type

event clicked;if cbx_1.checked then
	dw_report.object.t_fecha.visible = '1'
else
	dw_report.object.t_fecha.visible = '0'
end if
end event

