$PBExportHeader$w_pt501_saldos_resumen.srw
forward
global type w_pt501_saldos_resumen from w_abc_master
end type
type st_1 from statictext within w_pt501_saldos_resumen
end type
type st_2 from statictext within w_pt501_saldos_resumen
end type
type st_3 from statictext within w_pt501_saldos_resumen
end type
type em_ano from editmask within w_pt501_saldos_resumen
end type
type em_cencos from editmask within w_pt501_saldos_resumen
end type
type cb_cencos from commandbutton within w_pt501_saldos_resumen
end type
type cb_2 from commandbutton within w_pt501_saldos_resumen
end type
type em_cnta_prsp from editmask within w_pt501_saldos_resumen
end type
type cb_3 from commandbutton within w_pt501_saldos_resumen
end type
type sle_cencos from singlelineedit within w_pt501_saldos_resumen
end type
type sle_cnta_prsp from singlelineedit within w_pt501_saldos_resumen
end type
end forward

global type w_pt501_saldos_resumen from w_abc_master
integer width = 3630
integer height = 1828
string title = "Resumen de saldos en dolares (PT501)"
string menuname = "m_only_exit"
st_1 st_1
st_2 st_2
st_3 st_3
em_ano em_ano
em_cencos em_cencos
cb_cencos cb_cencos
cb_2 cb_2
em_cnta_prsp em_cnta_prsp
cb_3 cb_3
sle_cencos sle_cencos
sle_cnta_prsp sle_cnta_prsp
end type
global w_pt501_saldos_resumen w_pt501_saldos_resumen

forward prototypes
public subroutine of_reg_presup_ejec (integer ai_year, string as_cencos, string as_cnta_prsp)
public subroutine of_reg_prsp_var (integer ai_year, string as_cencos, string as_cnta_prsp)
end prototypes

public subroutine of_reg_presup_ejec (integer ai_year, string as_cencos, string as_cnta_prsp);Integer 	li_ok
string	ls_mensaje

//create or replace procedure USP_PTO_ACT_PRSPPTDA_CCCP(
//       ani_ano          in cntbl_asiento.ano%type,
//       asi_cencos       in centros_costo.cencos%TYPE,
//       asi_Cnta_prsp    in presupuesto_cuenta.cnta_prsp%TYPE
//) is

DECLARE USP_PTO_ACT_PRSPPTDA_CCCP PROCEDURE FOR
	USP_PTO_ACT_PRSPPTDA_CCCP( :ai_year,
										:as_cencos,
										:as_cnta_prsp);

EXECUTE USP_PTO_ACT_PRSPPTDA_CCCP;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PTO_ACT_PRSPPTDA_CCCP: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_PTO_ACT_PRSPPTDA_CCCP;

return

end subroutine

public subroutine of_reg_prsp_var (integer ai_year, string as_cencos, string as_cnta_prsp);Integer 	li_ok
string	ls_mensaje

//create or replace procedure USP_PTO_ACT_PRSPVAR_CCCP(
//       ani_ano              in number,
//       asi_cencos           in centros_costo.cencos%TYPE,
//       asi_cnta_prsp        in presupuesto_cuenta.cnta_prsp%TYPE
//) is

DECLARE USP_PTO_ACT_PRSPVAR_CCCP PROCEDURE FOR
	USP_PTO_ACT_PRSPVAR_CCCP( :ai_year,
									  :as_cencos,
									  :as_cnta_prsp);

EXECUTE USP_PTO_ACT_PRSPVAR_CCCP;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PTO_ACT_PRSPVAR_CCCP: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_PTO_ACT_PRSPVAR_CCCP;

return

end subroutine

on w_pt501_saldos_resumen.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.em_ano=create em_ano
this.em_cencos=create em_cencos
this.cb_cencos=create cb_cencos
this.cb_2=create cb_2
this.em_cnta_prsp=create em_cnta_prsp
this.cb_3=create cb_3
this.sle_cencos=create sle_cencos
this.sle_cnta_prsp=create sle_cnta_prsp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.em_cencos
this.Control[iCurrent+6]=this.cb_cencos
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.em_cnta_prsp
this.Control[iCurrent+9]=this.cb_3
this.Control[iCurrent+10]=this.sle_cencos
this.Control[iCurrent+11]=this.sle_cnta_prsp
end on

on w_pt501_saldos_resumen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_ano)
destroy(this.em_cencos)
destroy(this.cb_cencos)
destroy(this.cb_2)
destroy(this.em_cnta_prsp)
destroy(this.cb_3)
destroy(this.sle_cencos)
destroy(this.sle_cnta_prsp)
end on

type dw_master from w_abc_master`dw_master within w_pt501_saldos_resumen
integer y = 208
integer width = 2185
integer height = 1436
integer taborder = 40
string dataobject = "d_cns_saldos_resumen"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

event dw_master::clicked;call super::clicked;String ls_name
Integer li_var = -1, li_ejec = -1, li_proy = -1
str_parametros sl_param
w_pt501_variaciones_detalle lw

ls_name = dwo.name

// Proyecciones
Choose case ls_name
	case 'proy_ene'
		li_proy = 1
	case 'proy_feb'
		li_proy = 2
	case 'proy_mar'
		li_proy = 3
	case 'proy_abr'
		li_proy = 4
	case 'proy_may'
		li_proy = 5
	case 'proy_jun'
		li_proy = 6
	case 'proy_jul'
		li_proy = 7
	case 'proy_ago'
		li_proy = 8
	case 'proy_set'
		li_proy = 9
	case 'proy_oct'
		li_proy = 10
	case 'proy_nov'
		li_proy = 11
	case 'proy_dic'
		li_proy = 12
	case 'proy_total'
		li_proy = 0
end choose


// Variaciones
Choose case ls_name
	case 'var_ene'
		li_var = 1
	case 'var_feb'
		li_var = 2
	case 'var_mar'
		li_var = 3
	case 'var_abr'
		li_var = 4
	case 'var_may'
		li_var = 5
	case 'var_jun'
		li_var = 6
	case 'var_jul'
		li_var = 7
	case 'var_ago'
		li_var = 8
	case 'var_set'
		li_var = 9
	case 'var_oct'
		li_var = 10
	case 'var_nov'
		li_var = 11
	case 'var_dic'
		li_var = 12
	case 'var_total'
		li_var = 0
end choose

// Ejecucion
Choose case ls_name
	case 'ejec_ene'
		li_ejec = 1
	case 'ejec_feb'
		li_ejec = 2
	case 'ejec_mar'
		li_ejec = 3
	case 'ejec_abr'
		li_ejec = 4
	case 'ejec_may'
		li_ejec = 5
	case 'ejec_jun'
		li_ejec = 6
	case 'ejec_jul'
		li_ejec = 7
	case 'ejec_ago'
		li_ejec = 8
	case 'ejec_set'
		li_ejec = 9
	case 'ejec_oct'
		li_ejec = 10
	case 'ejec_nov'
		li_ejec = 11
	case 'ejec_dic'
		li_ejec = 12
	case 'ejec_total'
		li_ejec = 0
end choose

sl_param.long1 = Long(em_ano.text)
sl_param.string1 = em_cencos.text
sl_param.string2 = em_cnta_prsp.text

if li_proy = 0 then
	
	sl_param.dw1 = 'd_cns_detalle_proyecciones_total'	
	sl_param.long2 = li_proy
	sl_param.opcion = 1
	
	OpenSheetWithParm( lw, sl_param, w_main, 0, Layered!)
	
end if

if li_proy > 0 then
	sl_param.dw1 = 'd_cns_detalle_proyecciones'	
	sl_param.long2 = li_proy
	sl_param.opcion = 1
	
	OpenSheetWithParm( lw, sl_param, w_main, 0, Layered!)

end if	

if li_var = 0 then
	
	sl_param.dw1 = 'd_cns_detalle_variaciones_total'	
	sl_param.long2 = li_var
	sl_param.opcion = 2
	
	OpenSheetWithParm( lw, sl_param, w_main, 0, Layered!)
	
end if

if li_var > 0 then
	
	sl_param.dw1 = 'd_cns_detalle_variaciones'	
	sl_param.long2 = li_var
	sl_param.opcion = 2
	
	OpenSheetWithParm( lw, sl_param, w_main, 0, Layered!)

end if

if li_ejec = 0 then
	
	sl_param.dw1 = 'd_cns_detalle_ejecucion_total'	
	sl_param.long2 = li_ejec
	sl_param.opcion = 2
	
	OpenSheetWithParm( lw, sl_param, w_main, 0, Layered!)
	
end if

if li_ejec > 0 then
	
	sl_param.dw1 = 'd_cns_detalle_ejecucion_x_cc_cp'
	sl_param.long2 = li_ejec
	sl_param.opcion = 2

	OpenSheetWithParm( lw, sl_param, w_main, 0, Layered!)
end if
end event

type st_1 from statictext within w_pt501_saldos_resumen
integer x = 37
integer y = 44
integer width = 128
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt501_saldos_resumen
integer x = 677
integer y = 44
integer width = 229
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Costo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pt501_saldos_resumen
integer x = 503
integer y = 128
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cnta. Presup:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_pt501_saldos_resumen
integer x = 192
integer y = 24
integer width = 274
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_cencos from editmask within w_pt501_saldos_resumen
integer x = 910
integer y = 28
integer width = 402
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;String ls_cencos, ls_descri

ls_cencos = em_cencos.text

Select desc_cencos 
	into :ls_descri 
from centros_costo
where cencos = :ls_cencos;
  
if SQLCA.SQLCode = 100 then
	Messagebox( "Atencion", "Centro de costo no existe")
	em_Cencos.text = ''
	return
end if

  
sle_cencos.text = ls_descri
end event

type cb_cencos from commandbutton within w_pt501_saldos_resumen
integer x = 1330
integer y = 20
integer width = 78
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Asigna valores a structura 
string ls_codigo, ls_data, ls_sql, ls_year

if trim(em_Ano.text) = '' then
	Messagebox( "Atencion", "Ingrese Año")
	em_ano.Setfocus()
	return
end if

ls_year = em_ano.text
		
ls_sql = "SELECT distinct cc.cencos as codigo_cencos, " &
		 + "cc.desc_cencos AS descripcion_cencos " &
		 + "FROM centros_costo cc, " &
		 + "presupuesto_partida b " &
		 + "where cc.cencos = b.cencos " &
		 + "and b.ano = " + ls_year
				 
f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	em_cencos.text 	= ls_codigo
	sle_cencos.text 	= ls_data
end if
end event

type cb_2 from commandbutton within w_pt501_saldos_resumen
integer x = 1330
integer y = 112
integer width = 78
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Asigna valores a structura 
String ls_cencos, ls_year, ls_sql, ls_codigo, ls_data

if trim( em_Ano.text) = '' then
	Messagebox( "Atencion", "Ingrese Año")
	em_ano.Setfocus()
	return
end if

ls_year = em_ano.text

if trim( em_cencos.text) = '' then
	Messagebox( "Atencion", "Ingrese Centro de costo")
	em_cencos.Setfocus()
	return
end if	

ls_cencos = em_cencos.text

ls_sql = "SELECT distinct a.cnta_prsp as codigo_cuenta, " &
		 + "a.descripcion AS descripcion_cuenta " &
		 + "FROM presupuesto_cuenta a, " &
		 + "presupuesto_partida b " &
		 + "where a.cnta_prsp = b.cnta_prsp " &
		 + "and b.ano = " + ls_year + " " &
		 + "and b.cencos = '" + ls_cencos + "'"
				 
f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	em_cnta_prsp.text 	= ls_codigo
	sle_cnta_prsp.text 	= ls_data
end if
end event

type em_cnta_prsp from editmask within w_pt501_saldos_resumen
integer x = 905
integer y = 120
integer width = 402
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;String ls_cnta, ls_desc

ls_cnta = em_cnta_prsp.text

Select descripcion 
	into :ls_desc
from presupuesto_cuenta
where cnta_prsp = :ls_cnta;
  
if SQLCA.SQLCode = 100 then
	Messagebox( "Atencion", "Cuenta presupuestal no existe")
	em_cnta_prsp.text = ''
	return
end if

sle_cnta_prsp.text = ls_desc
end event

type cb_3 from commandbutton within w_pt501_saldos_resumen
integer x = 3195
integer y = 56
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Long ll_ano
String ls_cencos, ls_cnta_prsp

if trim( em_Ano.text) = '' then
	Messagebox( "Atencion", "Ingrese Año")
	em_ano.Setfocus()
	return
end if
	
if trim( em_cencos.text) = '' then
	Messagebox( "Atencion", "Ingrese Centro de costo")
	em_cencos.Setfocus()
	return
end if	

if trim( em_cnta_prsp.text) = '' then
	Messagebox( "Atencion", "Ingrese Cuenta presupuestal")
	em_cnta_prsp.Setfocus()
	return
end if	

ll_ano = Long ( em_Ano.text)
ls_cencos = em_cencos.text
ls_cnta_prsp = em_cnta_prsp.text

parent.of_reg_presup_ejec( ll_ano, ls_cencos, ls_cnta_prsp)
parent.of_reg_prsp_var( ll_ano, ls_cencos, ls_cnta_prsp)

dw_master.retrieve( ll_Ano, ls_cencos, ls_cnta_prsp)
end event

type sle_cencos from singlelineedit within w_pt501_saldos_resumen
integer x = 1454
integer y = 24
integer width = 1207
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type sle_cnta_prsp from singlelineedit within w_pt501_saldos_resumen
integer x = 1454
integer y = 120
integer width = 1207
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

