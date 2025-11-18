$PBExportHeader$w_pr505_destajo_consistencia_trab.srw
forward
global type w_pr505_destajo_consistencia_trab from w_abc_master_smpl
end type
type uo_rango from ou_rango_fechas within w_pr505_destajo_consistencia_trab
end type
type em_ot_adm from singlelineedit within w_pr505_destajo_consistencia_trab
end type
type em_descripcion from singlelineedit within w_pr505_destajo_consistencia_trab
end type
type gb_2 from groupbox within w_pr505_destajo_consistencia_trab
end type
type gb_1 from groupbox within w_pr505_destajo_consistencia_trab
end type
end forward

global type w_pr505_destajo_consistencia_trab from w_abc_master_smpl
integer width = 2889
integer height = 1456
string title = "Consistencia de Destajo por Trabajador(PR505) "
string menuname = "m_reporte"
windowstate windowstate = maximized!
uo_rango uo_rango
em_ot_adm em_ot_adm
em_descripcion em_descripcion
gb_2 gb_2
gb_1 gb_1
end type
global w_pr505_destajo_consistencia_trab w_pr505_destajo_consistencia_trab

on w_pr505_destajo_consistencia_trab.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_rango=create uo_rango
this.em_ot_adm=create em_ot_adm
this.em_descripcion=create em_descripcion
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_rango
this.Control[iCurrent+2]=this.em_ot_adm
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.gb_1
end on

on w_pr505_destajo_consistencia_trab.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_rango)
destroy(this.em_ot_adm)
destroy(this.em_descripcion)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
end event

event ue_query_retrieve;//override
string ls_nro_parte, ls_fecha, ls_ot_adm
date ld_fecha_1, ld_fecha_2

ld_fecha_1 = uo_rango.of_get_fecha1( )
ld_fecha_2 = uo_rango.of_get_fecha2( )
ls_ot_adm	=	em_ot_adm.text

idw_1.Retrieve(ld_fecha_1, ld_fecha_2, ls_ot_adm)

if idw_1.rowcount( ) < 1 then return

select to_char(sysdate, 'dd/mm/yyyy hh24:mi') 
   into :ls_fecha
	from dual;
	
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = 'Impreso por: ' + trim(gs_user)
idw_1.object.t_date.text = 'Fecha de impresión: ' + trim(ls_fecha)
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr505_destajo_consistencia_trab
integer x = 23
integer y = 292
integer width = 2706
integer height = 836
string dataobject = "d_destajo_consistencia_trab_tbl"
end type

type uo_rango from ou_rango_fechas within w_pr505_destajo_consistencia_trab
event destroy ( )
integer x = 27
integer y = 136
integer taborder = 40
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type em_ot_adm from singlelineedit within w_pr505_destajo_consistencia_trab
event dobleclick pbm_lbuttondblclk
integer x = 1248
integer y = 132
integer width = 251
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT O.OT_ADM, O.DESCRIPCION AS DESCRIPCION," &
				  + "P.COD_USR AS USUARIO " &
				  + "FROM OT_ADMINISTRACION O, OT_ADM_USUARIO P " &
				  + "WHERE O.OT_ADM = P.OT_ADM " &
				  + "AND P.COD_USR = '" + gs_user + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

em_descripcion.text = ls_data

end if
end event

event modified;//String ls_origen, ls_desc
//
//ls_origen = this.text
//if ls_origen = '' or IsNull(ls_origen) then
//	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
//	return
//end if
//
//SELECT descripcion INTO :ls_desc
//FROM ot_administracion
//WHERE ot_adm =:ls_origen;
//
//IF SQLCA.SQLCode = 100 THEN
//	Messagebox('Aviso', 'Codigo de Origen no existe')
//	return
//end if
//
//em_descripcion.text = ls_desc


end event

type em_descripcion from singlelineedit within w_pr505_destajo_consistencia_trab
integer x = 1518
integer y = 132
integer width = 1189
integer height = 72
integer taborder = 90
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

type gb_2 from groupbox within w_pr505_destajo_consistencia_trab
integer x = 1207
integer y = 40
integer width = 1531
integer height = 220
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Administacion OT:"
borderstyle borderstyle = stylebox!
end type

type gb_1 from groupbox within w_pr505_destajo_consistencia_trab
integer x = 18
integer y = 40
integer width = 1175
integer height = 220
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Seleccione rango de fechas"
end type

