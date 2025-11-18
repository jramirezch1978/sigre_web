$PBExportHeader$w_pr702_costo_ot_x_labor.srw
forward
global type w_pr702_costo_ot_x_labor from w_rpt_general
end type
type cb_buscar from cb_aceptar within w_pr702_costo_ot_x_labor
end type
type st_2 from statictext within w_pr702_costo_ot_x_labor
end type
type cb_1 from commandbutton within w_pr702_costo_ot_x_labor
end type
type sle_orden_t from singlelineedit within w_pr702_costo_ot_x_labor
end type
end forward

global type w_pr702_costo_ot_x_labor from w_rpt_general
integer width = 2121
integer height = 2280
string title = "Costo Orden Trabajo X Labor - Ejecutor (PR702)"
cb_buscar cb_buscar
st_2 st_2
cb_1 cb_1
sle_orden_t sle_orden_t
end type
global w_pr702_costo_ot_x_labor w_pr702_costo_ot_x_labor

on w_pr702_costo_ot_x_labor.create
int iCurrent
call super::create
this.cb_buscar=create cb_buscar
this.st_2=create st_2
this.cb_1=create cb_1
this.sle_orden_t=create sle_orden_t
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_orden_t
end on

on w_pr702_costo_ot_x_labor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.sle_orden_t)
end on

event ue_retrieve;call super::ue_retrieve;integer 	li_ok
string 	ls_mensaje, ls_nro_orden

//create or replace procedure USP_PR_COSTO_OT_LABOR(
//       asi_nro_orden orden_trabajo.nro_orden%type,
//       aso_mensaje   out varchar2, 
//       aio_ok 			 out number) is

ls_nro_orden = sle_orden_t.text

if ls_nro_orden = '' or IsNull(ls_nro_orden ) then
	MessageBox('PRODUCCION', 'LA ORDEN DE TRABAJO NO ESTA DEFINIDA', StopSign!)
	return
end if

/*DECLARE USP_PR_COSTO_OT_LABOR PROCEDURE FOR
	USP_PR_COSTO_OT_LABOR( :ls_nro_orden );

EXECUTE USP_PR_COSTO_OT_LABOR;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PR_COSTO_OT_LABOR: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_PR_COSTO_OT_LABOR INTO :ls_mensaje, :li_ok;
CLOSE USP_PR_COSTO_OT_LABOR;

if li_ok <> 1 then
	MessageBox('Error USP_PR_COSTO_OT_LABOR', ls_mensaje, StopSign!)	
	return
end if*/

idw_1.Retrieve(ls_nro_orden)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user

idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa
this.SetRedraw(true)
return
end event

type dw_report from w_rpt_general`dw_report within w_pr702_costo_ot_x_labor
integer x = 18
integer y = 156
integer width = 2011
integer height = 1908
string dataobject = "d_costo_labor_por_ot_tbl"
end type

type cb_buscar from cb_aceptar within w_pr702_costo_ot_x_labor
integer x = 919
integer y = 20
integer width = 667
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
boolean default = true
end type

event ue_procesar;call super::ue_procesar;parent.event dynamic ue_retrieve()
end event

type st_2 from statictext within w_pr702_costo_ot_x_labor
integer x = 46
integer y = 32
integer width = 315
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 67108864
string text = "Nro Orden :"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pr702_costo_ot_x_labor
integer x = 773
integer y = 16
integer width = 114
integer height = 100
integer taborder = 40
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
lstr_seleccionar.s_sql = 'SELECT ORIGEN         AS CODIGO_ORIGEN        ,'&
								+' NRO_OT         		AS NRO_ORDEN_TRABAJO    ,'&
						  	   +'ADMINISTRACION 		   AS ADMINISTRACION	      ,'&
								+'TIPO           			AS TIPO_OT				   ,'&
								+'CENCOS_SOLIC   			AS CC_SOLICITANTE	 	   ,'&
								+'DESC_CC_SOLICITANTE  	AS DESC_CC_SOLICITANTE  ,'&
								+'CENCOS_RESP    			AS CC_RESPONSABLE	 	   ,'&
								+'DESC_CC_RESPONSABLE  	AS DESC_CC_RESPONSABLE  ,'&
								+'USUARIO        			AS CODIGO_USUARIO	 	   ,'&
								+'CODIGO_RESPONSABLE   	AS CODIGO_RESPONSABLE   ,'&
								+'NOMBRE_RESPONSABLE   	AS NOMBRES_RESPONSABLES ,'&
							  	+'FECHA_INICIO         	AS FECHA_INICIO 		  ,'&		
								+'TITULO_ORDEN_TRABAJO 	AS TITULO_ORDEN_TRABAJO  '&
								+'FROM VW_OPE_CONSULTA_ORDEN_TRABAJO '

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_orden_t.text = lstr_seleccionar.param2[1]
	END IF


end event

type sle_orden_t from singlelineedit within w_pr702_costo_ot_x_labor
integer x = 389
integer y = 16
integer width = 370
integer height = 100
integer taborder = 50
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

