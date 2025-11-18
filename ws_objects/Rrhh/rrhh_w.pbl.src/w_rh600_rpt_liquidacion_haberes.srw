$PBExportHeader$w_rh600_rpt_liquidacion_haberes.srw
forward
global type w_rh600_rpt_liquidacion_haberes from w_report_smpl
end type
type cb_1 from commandbutton within w_rh600_rpt_liquidacion_haberes
end type
type em_nombres from editmask within w_rh600_rpt_liquidacion_haberes
end type
type em_codigo from editmask within w_rh600_rpt_liquidacion_haberes
end type
type cb_2 from commandbutton within w_rh600_rpt_liquidacion_haberes
end type
type gb_2 from groupbox within w_rh600_rpt_liquidacion_haberes
end type
end forward

global type w_rh600_rpt_liquidacion_haberes from w_report_smpl
integer width = 3451
integer height = 1524
string title = "(RH600) Liquidación de Créditos Laborales"
string menuname = "m_impresion"
long backcolor = 12632256
cb_1 cb_1
em_nombres em_nombres
em_codigo em_codigo
cb_2 cb_2
gb_2 gb_2
end type
global w_rh600_rpt_liquidacion_haberes w_rh600_rpt_liquidacion_haberes

on w_rh600_rpt_liquidacion_haberes.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_nombres=create em_nombres
this.em_codigo=create em_codigo
this.cb_2=create cb_2
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_nombres
this.Control[iCurrent+3]=this.em_codigo
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.gb_2
end on

on w_rh600_rpt_liquidacion_haberes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_nombres)
destroy(this.em_codigo)
destroy(this.cb_2)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string  ls_codigo, ls_nombres, ls_mensaje
integer li_verifica

ls_codigo  = string(em_codigo.text)
ls_nombres = string(em_nombres.text)

li_verifica = 0 
select count(*)
  into :li_verifica
  from rh_liq_credito_laboral
  where cod_trabajador = :ls_codigo ;
  
if li_verifica = 0 then
	MessageBox('Atención','La liquidación del trabajador '+ls_nombres+' con código '+ls_codigo+' no existe. Verifique')
	return
end if

DECLARE pb_usp_rh_liq_reporte_trabajador PROCEDURE FOR USP_RH_LIQ_REPORTE_TRABAJADOR
        ( :ls_codigo, :ls_nombres ) ;
EXECUTE pb_usp_rh_liq_reporte_trabajador ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Proceso de reporte de liquidación, Falló', Exclamation! )
END IF

end event

type dw_report from w_report_smpl`dw_report within w_rh600_rpt_liquidacion_haberes
integer x = 14
integer y = 300
integer width = 3369
integer height = 1024
integer taborder = 50
string dataobject = "d_liq_cabecera_tbl"
end type

type cb_1 from commandbutton within w_rh600_rpt_liquidacion_haberes
integer x = 2523
integer y = 120
integer width = 293
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_nombres from editmask within w_rh600_rpt_liquidacion_haberes
integer x = 1243
integer y = 120
integer width = 1143
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_codigo from editmask within w_rh600_rpt_liquidacion_haberes
integer x = 773
integer y = 120
integer width = 315
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh600_rpt_liquidacion_haberes
integer x = 1120
integer y = 120
integer width = 87
integer height = 72
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

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_rpt_seleccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param )
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_codigo.text  = sl_param.field_ret[1]
	em_nombres.text = sl_param.field_ret[2]
END IF

end event

type gb_2 from groupbox within w_rh600_rpt_liquidacion_haberes
integer x = 713
integer y = 44
integer width = 1728
integer height = 200
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Trabajador "
borderstyle borderstyle = stylebox!
end type

