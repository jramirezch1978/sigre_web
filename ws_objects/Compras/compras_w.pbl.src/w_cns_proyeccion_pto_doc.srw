$PBExportHeader$w_cns_proyeccion_pto_doc.srw
$PBExportComments$Consulta que muestra los movimientos de un articulo por almacen.
forward
global type w_cns_proyeccion_pto_doc from w_report_smpl
end type
end forward

global type w_cns_proyeccion_pto_doc from w_report_smpl
integer width = 2930
integer height = 1348
string title = "Consulta de movimientos"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
end type
global w_cns_proyeccion_pto_doc w_cns_proyeccion_pto_doc

type variables
integer ii_tipo
end variables

on w_cns_proyeccion_pto_doc.create
call super::create
end on

on w_cns_proyeccion_pto_doc.destroy
call super::destroy
end on

event ue_open_pre();call super::ue_open_pre;str_parametros sl_param

sl_param = message.PowerObjectParm

// Llena tabla temporal
Long 	ll_row, li_tipo, ll_mes, ll_ano
String ls_dato1, ls_dato2, ls_msg
Date ld_fecha

ld_fecha = today()
ll_mes = MONTH( ld_fecha)
ll_ano = YEAR( ld_fecha)

delete from tt_alm_seleccion;

Select doc_sc into :ls_dato1 from logparam where reckey = '1';

ls_dato1 = sl_param.string3
ls_dato2 = sl_param.string2
li_tipo = sl_param.long1

Insert into tt_alm_seleccion(tipo_doc, nro_doc) values ( :ls_dato1, :ls_dato2);	
If sqlca.sqlcode = -1 then
	messagebox("Error al insertar registro",sqlca.sqlerrtext)
END IF
		
// Llenar tabla temporal
DECLARE proc1 PROCEDURE FOR USP_ALM_PROYECCION_PTO(:li_tipo, :ll_mes, :ll_mes, :ll_ano);
EXECUTE proc1;
if sqlca.sqlcode = -1 then   // Fallo
	ls_msg = sqlca.sqlerrtext
	rollback ;			
	close proc1;
	MessageBox( 'Error en USP_ALM_PROYECCION_PTO',ls_msg, StopSign! )		
	RETURN 
End If
close proc1;

idw_1 = dw_report
ib_preview = true
Event ue_preview()
idw_1.Visible = True

idw_1.SetTransObject(Sqlca)
idw_1.Retrieve()
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
end event

type dw_report from w_report_smpl`dw_report within w_cns_proyeccion_pto_doc
integer y = 0
integer height = 688
string dataobject = "d_cns_proyeccion_pto"
end type

