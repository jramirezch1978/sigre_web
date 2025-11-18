$PBExportHeader$w_ope759_orden_trabajo_fmt_tbl.srw
forward
global type w_ope759_orden_trabajo_fmt_tbl from w_report_smpl
end type
type st_1 from statictext within w_ope759_orden_trabajo_fmt_tbl
end type
type cb_1 from commandbutton within w_ope759_orden_trabajo_fmt_tbl
end type
type sle_1 from singlelineedit within w_ope759_orden_trabajo_fmt_tbl
end type
type cb_2 from commandbutton within w_ope759_orden_trabajo_fmt_tbl
end type
end forward

global type w_ope759_orden_trabajo_fmt_tbl from w_report_smpl
integer x = 329
integer y = 188
integer width = 1856
integer height = 1716
string title = "Formato de Orden Trabajo (OPE759)"
string menuname = "m_rpt_smpl"
windowstate windowstate = maximized!
long backcolor = 12632256
st_1 st_1
cb_1 cb_1
sle_1 sle_1
cb_2 cb_2
end type
global w_ope759_orden_trabajo_fmt_tbl w_ope759_orden_trabajo_fmt_tbl

type variables
Str_cns_pop istr_1
end variables

event ue_open_pre;call super::ue_open_pre;

idw_1.Visible = True
idw_1.SettransObject(sqlca)
//dw_report.object.dw_1.object.p_logo.filename = gs_logo

//This.Event ue_retrieve()
of_position(0,0)



end event

event ue_retrieve;call super::ue_retrieve;

idw_1.Retrieve(TRIM(sle_1.text))
dw_report.object.dw_1.object.p_logo.filename = gs_logo








end event

on w_ope759_orden_trabajo_fmt_tbl.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_1=create sle_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.cb_2
end on

on w_ope759_orden_trabajo_fmt_tbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.cb_2)
end on

type dw_report from w_report_smpl`dw_report within w_ope759_orden_trabajo_fmt_tbl
integer y = 228
integer width = 1778
integer height = 1296
string dataobject = "d_rpt_formato_ot_corr_tbl"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
idw_1 = This
end event

type st_1 from statictext within w_ope759_orden_trabajo_fmt_tbl
integer x = 32
integer y = 124
integer width = 283
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Nro Orden :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope759_orden_trabajo_fmt_tbl
integer x = 754
integer y = 104
integer width = 114
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN         AS CODIGO_ORIGEN       ,'&
								+' NRO_OT         AS NRO_ORDEN_TRABAJO 		  ,'&
						  	   +'ADMINISTRACION AS ADMINISTRACION	   		  ,'&
								+'TIPO           AS TIPO_OT				 		  ,'&
								+'CENCOS_SOLIC   AS CC_SOLICITANTE	 			  ,'&
								+'DESC_CC_SOLICITANTE  AS DESC_CC_SOLICITANTE  ,'&
								+'CENCOS_RESP    AS CC_RESPONSABLE	 			  ,'&
								+'DESC_CC_RESPONSABLE  AS DESC_CC_RESPONSABLE  ,'&
								+'USUARIO        AS CODIGO_USUARIO	 			  ,'&
								+'CODIGO_RESPONSABLE   AS CODIGO_RESPONSABLE   ,'&
								+'NOMBRE_RESPONSABLE   AS NOMBRES_RESPONSABLES ,'&
							  	+'FECHA_INICIO         AS FECHA_INICIO 		  ,'&		
								+'TITULO_ORDEN_TRABAJO AS TITULO_ORDEN_TRABAJO  '&
								+'FROM VW_OPE_CONSULTA_ORDEN_TRABAJO '

				
OpenWithParm(w_seleccionar_op,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_1.text = lstr_seleccionar.param2[1]
	END IF


end event

type sle_1 from singlelineedit within w_ope759_orden_trabajo_fmt_tbl
integer x = 370
integer y = 104
integer width = 370
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_ope759_orden_trabajo_fmt_tbl
integer x = 1440
integer y = 116
integer width = 343
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_nro_ot

ls_nro_ot = sle_1.text

IF Isnull(ls_nro_ot) or Trim(ls_nro_ot) = '' THEN
	Messagebox('Aviso','Debe Ingresar Algun Nro de Orden Trabajo')
	Return
END IF	



Parent.TriggerEvent('ue_retrieve')
end event

