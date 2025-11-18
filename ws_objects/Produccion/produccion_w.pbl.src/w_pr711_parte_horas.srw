$PBExportHeader$w_pr711_parte_horas.srw
forward
global type w_pr711_parte_horas from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_pr711_parte_horas
end type
type cbx_fechas from checkbox within w_pr711_parte_horas
end type
type sle_nro_parte from singlelineedit within w_pr711_parte_horas
end type
type st_1 from statictext within w_pr711_parte_horas
end type
type st_2 from statictext within w_pr711_parte_horas
end type
type em_nro_parte from singlelineedit within w_pr711_parte_horas
end type
type sle_desc_formato from singlelineedit within w_pr711_parte_horas
end type
type gb_2 from groupbox within w_pr711_parte_horas
end type
end forward

global type w_pr711_parte_horas from w_report_smpl
integer width = 3863
integer height = 1900
string title = "Control de tiempos(PR711)"
string menuname = "m_reporte"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
event ue_retrieve_list ( )
uo_1 uo_1
cbx_fechas cbx_fechas
sle_nro_parte sle_nro_parte
st_1 st_1
st_2 st_2
em_nro_parte em_nro_parte
sle_desc_formato sle_desc_formato
gb_2 gb_2
end type
global w_pr711_parte_horas w_pr711_parte_horas

event ue_query_retrieve;this.event ue_retrieve()
end event

event ue_retrieve_list();string ls_sql, ls_return1, ls_return2, ls_return3, ls_ini, ls_fin, ls_where 

ls_ini = string(uo_1.of_get_fecha1(), 'dd/mm/yyyy')
ls_fin = string(uo_1.of_get_fecha2(), 'dd/mm/yyyy')

ls_where = " where f_parte >= to_date('"+ls_ini+"', 'dd/mm/yyyy') and f_parte <= to_date('"+ls_fin+"', 'dd/mm/yyyy')"

ls_sql = "select descripcion as formato, nro_parte as numero, fc_parte as fecha  from vw_tg_parte_piso_tiempo_uso "

if cbx_fechas.checked = true then
	ls_sql = ls_sql + ls_where
end if

f_lista_3ret(ls_sql, ls_return1, ls_return2, ls_return3, '2')

if isnull(ls_return2) or trim(ls_return2) = '' then 
	ls_return2 = sle_nro_parte.text
end if

sle_nro_parte.text = ls_return2

this.event ue_retrieve()
end event

event ue_retrieve;//long ll_cuenta
//string ls_nro_parte, ls_fecha, ls_desc_fmt
//
//ls_nro_parte = em_nro_parte.text
//
//if trim(ls_nro_parte) = '' or isnull(ls_nro_parte) then
//	messagebox(this.title,'No ha ingresado el número de parte a mostrar',stopsign!)
//	return
//end if
//idw_1.Visible = false
//declare usp_tuso_report procedure for
//	usp_pr_ppiso_tuso_report(:ls_nro_parte);
//
//execute usp_tuso_report;
//fetch usp_tuso_report into :ll_cuenta, :ls_fecha, :ls_desc_fmt;
//if ll_cuenta >= 1 then
//	idw_1.Retrieve()
//	idw_1.Object.p_logo.filename = gs_logo
//	idw_1.Object.t_user.text = 'Impreso por: ' + gs_user
//	idw_1.Object.t_date.text = 'Empreso el: ' + ls_fecha
//	idw_1.Object.t_empresa.text = gs_empresa
//	idw_1.Object.t_title.text = ls_desc_fmt
//	idw_1.Visible = true
//else
//	messagebox(this.title,'No se han encontrado regsitros',stopsign!)
//end if
//close usp_tuso_report;
end event

on w_pr711_parte_horas.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cbx_fechas=create cbx_fechas
this.sle_nro_parte=create sle_nro_parte
this.st_1=create st_1
this.st_2=create st_2
this.em_nro_parte=create em_nro_parte
this.sle_desc_formato=create sle_desc_formato
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cbx_fechas
this.Control[iCurrent+3]=this.sle_nro_parte
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.em_nro_parte
this.Control[iCurrent+7]=this.sle_desc_formato
this.Control[iCurrent+8]=this.gb_2
end on

on w_pr711_parte_horas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cbx_fechas)
destroy(this.sle_nro_parte)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_nro_parte)
destroy(this.sle_desc_formato)
destroy(this.gb_2)
end on

type dw_report from w_report_smpl`dw_report within w_pr711_parte_horas
integer y = 336
integer width = 3401
integer height = 1360
string dataobject = "d_pr_parte_piso_tuso_rep_cst"
end type

type uo_1 from u_ingreso_rango_fechas within w_pr711_parte_horas
integer x = 46
integer y = 112
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(relativedate(today(),-30), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type cbx_fechas from checkbox within w_pr711_parte_horas
integer x = 50
integer y = 12
integer width = 1102
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Filtrar los reportes por fecha del parte:"
boolean checked = true
end type

type sle_nro_parte from singlelineedit within w_pr711_parte_horas
boolean visible = false
integer x = 2871
integer y = 52
integer width = 398
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
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pr711_parte_horas
boolean visible = false
integer x = 2395
integer y = 48
integer width = 475
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Número de parte:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pr711_parte_horas
integer x = 1541
integer y = 36
integer width = 713
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Número de parte a mostrar"
boolean focusrectangle = false
end type

type em_nro_parte from singlelineedit within w_pr711_parte_horas
event dobleclick pbm_lbuttondblclk
integer x = 1669
integer y = 128
integer width = 416
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT T.NRO_PARTE AS CODIGO, "& 
		  + "F.DESCRIPCION AS DESCRIPCION "&
		  + "FROM TG_PARTE_PISO T, TG_FMT_MED_ACT F "&
		  + "WHERE F.FORMATO = T.FORMATO AND T.FLAG_ESTADO = '1'"
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_desc_formato.text = ls_data
end if
end event

event modified;String 	ls_nro_parte, ls_desc

ls_nro_parte = this.text
if ls_nro_parte = '' or IsNull(ls_nro_parte) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Parte')
	return
end if

SELECT F.DESCRIPCION INTO :ls_desc
  FROM TG_PARTE_PISO T, TG_FMT_MED_ACT F
 WHERE F.FORMATO = T.FORMATO 
       AND T.NRO_PARTE = :ls_nro_parte;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Parte no existe')
	return
end if

sle_desc_formato.text = ls_desc

end event

type sle_desc_formato from singlelineedit within w_pr711_parte_horas
integer x = 2117
integer y = 124
integer width = 1230
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_pr711_parte_horas
integer x = 1595
integer y = 72
integer width = 1783
integer height = 156
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

