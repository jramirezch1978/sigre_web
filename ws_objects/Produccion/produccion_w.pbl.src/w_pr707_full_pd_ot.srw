$PBExportHeader$w_pr707_full_pd_ot.srw
forward
global type w_pr707_full_pd_ot from w_rpt_general
end type
type st_2 from statictext within w_pr707_full_pd_ot
end type
type sle_nro_ot from singlelineedit within w_pr707_full_pd_ot
end type
type st_desc from statictext within w_pr707_full_pd_ot
end type
type uo_rango from ou_rango_fechas within w_pr707_full_pd_ot
end type
type st_1 from statictext within w_pr707_full_pd_ot
end type
type cb_1 from commandbutton within w_pr707_full_pd_ot
end type
type gb_1 from groupbox within w_pr707_full_pd_ot
end type
end forward

global type w_pr707_full_pd_ot from w_rpt_general
integer width = 3374
integer height = 1980
string title = "[PR707] Parte Diario de Produccion - OT"
windowstate windowstate = maximized!
boolean center = false
event ue_retrieve_list ( )
event ue_query_retrieve ( )
st_2 st_2
sle_nro_ot sle_nro_ot
st_desc st_desc
uo_rango uo_rango
st_1 st_1
cb_1 cb_1
gb_1 gb_1
end type
global w_pr707_full_pd_ot w_pr707_full_pd_ot

event ue_retrieve_list();//string ls_sql,  ls_return1, ls_return2
//ls_sql = "select parte as nro_parte, fec as fecha from vw_pr_parte_destajo"
//f_lista (ls_sql, ls_return1, ls_return2, '2')
//if trim(ls_return1) = '' or isnull(ls_return1) then return
//sle_parte.text = ls_return1
//this.event ue_query_retrieve( )
//

end event

on w_pr707_full_pd_ot.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_nro_ot=create sle_nro_ot
this.st_desc=create st_desc
this.uo_rango=create uo_rango
this.st_1=create st_1
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_nro_ot
this.Control[iCurrent+3]=this.st_desc
this.Control[iCurrent+4]=this.uo_rango
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_1
end on

on w_pr707_full_pd_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_nro_ot)
destroy(this.st_desc)
destroy(this.uo_rango)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;string 	ls_nro_ot, ls_mensaje, ls_und_costo
integer 	li_ok
Decimal	ldc_costo_ot, ldc_costo_unit
Date		ld_fecha1, ld_Fecha2

ls_nro_ot = sle_nro_ot.text

if ls_nro_ot = '' or IsNull( ls_nro_ot ) then return

ld_Fecha1 = uo_rango.of_get_fecha1( )
ld_Fecha2 = uo_rango.of_get_fecha2( )

idw_1.Retrieve(ls_nro_ot, ld_Fecha1, ld_Fecha2)
idw_1.Visible = True
idw_1.Object.p_logo.filename 		= gs_logo
idw_1.Object.usuario_t.text  		= 'Usuario: ' + gs_user
idw_1.Object.titulo1_t.text  		= 'ORDEN TRABAJO Nº ' +  ls_nro_ot
idw_1.Object.titulo2_t.text  		= 'DEL ' + string(ld_fecha1, 'dd/mm/yyyy') + ' AL ' + string(ld_Fecha2, 'dd/mm/yyyy')
idw_1.Object.st_empresa.text  	= gs_empresa
end event

event ue_open_pre;//Override

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

end event

type dw_report from w_rpt_general`dw_report within w_pr707_full_pd_ot
integer y = 272
integer width = 3195
integer height = 1388
string dataobject = "d_rpt_full_pd_ot_cst"
boolean vscrollbar = false
end type

type st_2 from statictext within w_pr707_full_pd_ot
integer x = 96
integer y = 52
integer width = 466
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro Orden Trabajo"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nro_ot from singlelineedit within w_pr707_full_pd_ot
event ue_doubleclick pbm_lbuttondblclk
integer x = 571
integer y = 44
integer width = 407
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_doubleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_desc

ls_sql = "select t.nro_orden as nro_orden, t.titulo as titulo " &
		 + "from orden_trabajo t" 		
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

st_desc.text = string(ls_data)

IF ls_codigo <> '' THEN
	this.text = ls_codigo
	st_desc.text = ls_data
END IF
  



end event

event modified;//string ls_desc, ls_cod
//
//ls_cod = this.text
//
//select nombre
//	into :ls_desc
//from origen
//where cod_origen = :ls_cod
//  and flag_estado = '1';
// 
//if SQLCA.SQLCode = 100 then
//	MessageBox('Aviso', 'Origen no existe o no esta activo')
//	this.text = ''
//	st_1.text = ''
//	return
//end if
//
//st_1.text = ls_desc
end event

type st_desc from statictext within w_pr707_full_pd_ot
integer x = 987
integer y = 44
integer width = 1897
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean border = true
boolean focusrectangle = false
end type

type uo_rango from ou_rango_fechas within w_pr707_full_pd_ot
integer x = 553
integer y = 148
integer taborder = 40
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type st_1 from statictext within w_pr707_full_pd_ot
integer x = 69
integer y = 160
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pr707_full_pd_ot
integer x = 2281
integer y = 148
integer width = 631
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve( )
end event

type gb_1 from groupbox within w_pr707_full_pd_ot
integer width = 3040
integer height = 260
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
end type

