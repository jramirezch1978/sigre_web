$PBExportHeader$w_ma508_costo_x_orden_trabajo.srw
forward
global type w_ma508_costo_x_orden_trabajo from w_report_smpl
end type
type dw_1 from datawindow within w_ma508_costo_x_orden_trabajo
end type
end forward

global type w_ma508_costo_x_orden_trabajo from w_report_smpl
integer x = 329
integer y = 188
integer width = 3141
integer height = 1944
string title = "Operaciones Por Orden de Trabajo (MA508)"
string menuname = "m_rpt_smpl"
dw_1 dw_1
end type
global w_ma508_costo_x_orden_trabajo w_ma508_costo_x_orden_trabajo

type variables
String is_corr_corte
end variables

event ue_open_pre();idw_1=dw_report
idw_1.SetTransObject(SqlCa)
of_position(0,0)


// ii_help = 101           // help topic



end event

event ue_retrieve();call super::ue_retrieve;String ls_nro_orden,ls_doc_ot

SELECT doc_ot
  INTO :ls_doc_ot
  FROM prod_param
 WHERE (reckey = '1') ;


IF Isnull(ls_doc_ot) OR Trim(ls_doc_ot) = '' THEN
	Messagebox('Aviso','Debe Ingresar en tabla PROD PARAM tipo de Documento de Orden de Trabajo')
	Return
END IF

ls_nro_orden = dw_1.GetItemString(dw_1.Getrow(),'nro_orden')

idw_1.Visible = True

idw_1.Retrieve(ls_doc_ot,ls_nro_orden,gs_empresa,gs_user)

idw_1.Object.p_logo.filename = gs_logo

//Help
// ii_help = 508
end event

on w_ma508_costo_x_orden_trabajo.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_ma508_costo_x_orden_trabajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

type dw_report from w_report_smpl`dw_report within w_ma508_costo_x_orden_trabajo
integer x = 14
integer y = 200
integer width = 3077
integer height = 1548
string dataobject = "d_rpt_operaciones_x_ordenes_trabajo"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
end event

type dw_1 from datawindow within w_ma508_costo_x_orden_trabajo
integer x = 46
integer y = 28
integer width = 1627
integer height = 128
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_orden_trabajo_ext"
boolean border = false
boolean livescroll = true
end type

event constructor;SettransObject(sqlca)
InsertRow(0)

end event

event itemchanged;Long ll_count

SELECT COUNT(*)
INTO   :ll_count
FROM   CAMPO_CICLO
WHERE  CAMPO_CICLO.CORR_CORTE = :data ;

IF ll_count > 0 THEN
	Parent.TriggerEvent('ue_retrieve')
ELSE
	Messagebox('Aviso','Correlativo No existe')
END IF	
end event

event doubleclicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_ORDEN,'&
		      				+'ORDEN_TRABAJO.CLIENTE AS CLIENTE, '&
								+'ORDEN_TRABAJO.FEC_SOLICITUD AS F_SOLICITUD, '&     	
								+'ORDEN_TRABAJO.FEC_INICIO AS F_INICIO '&     	
					 		   +'FROM ORDEN_TRABAJO '

									  
									  
 OpenWithParm(w_seleccionar,lstr_seleccionar)
 
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	Setitem(row,'nro_orden',lstr_seleccionar.param1[1])
	
	Parent.TriggerEvent('ue_retrieve')
END IF

end event

