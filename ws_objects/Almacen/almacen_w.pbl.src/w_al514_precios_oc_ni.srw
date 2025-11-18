$PBExportHeader$w_al514_precios_oc_ni.srw
forward
global type w_al514_precios_oc_ni from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_al514_precios_oc_ni
end type
type cb_3 from commandbutton within w_al514_precios_oc_ni
end type
type cb_procesar from commandbutton within w_al514_precios_oc_ni
end type
type hpb_1 from hprogressbar within w_al514_precios_oc_ni
end type
end forward

global type w_al514_precios_oc_ni from w_report_smpl
integer width = 2930
integer height = 1836
string title = "Descuadre entre Precio OC y NI (AL514)"
string menuname = "m_impresion"
event ue_procesar ( )
uo_fecha uo_fecha
cb_3 cb_3
cb_procesar cb_procesar
hpb_1 hpb_1
end type
global w_al514_precios_oc_ni w_al514_precios_oc_ni

type variables
Integer ii_opcion
end variables

event ue_procesar();string 	ls_mensaje, ls_cod_art, ls_origen_mov
Long		ll_i, ll_nro_mov
Date		ld_fecha
Decimal	ldc_precio_real, ldc_precio_ni

idw_1 = dw_report
hpb_1.MaxPosition = idw_1.RowCount()
hpb_1.Position = 0
hpb_1.Visible = true

for ll_i = 1 to idw_1.RowCount()
	ls_cod_art 		= idw_1.object.cod_art		[ll_i]
	ls_origen_mov	= idw_1.object.cod_origen	[ll_i]
	ll_nro_mov		= idw_1.object.nro_mov		[ll_i]
	ld_fecha			= Date(idw_1.object.fec_registro[ll_i])
	ldc_precio_real= Dec(idw_1.object.precio_oc_fap[ll_i])
	ldc_precio_ni	= Dec(idw_1.object.precio_unit_ni[ll_i])

	//create or replace procedure USP_ALM_PREC_OC_NI_ART(
	//       asi_cod_art       in articulo.cod_art%TYPE,
	//       adi_fecha         in date,
	//       ani_precio_real   in number,
	//       ani_precio_ni     in number,
	//       ani_nro_mov       in articulo_mov.nro_mov%TYPE,
	//       asi_origen_mov    in articulo_mov.cod_origen%TYPE
	//) is
	
	DECLARE USP_ALM_PREC_OC_NI_ART PROCEDURE FOR
		USP_ALM_PREC_OC_NI_ART( :ls_cod_art, 
										:ld_fecha,
										:ldc_precio_real,
										:ldc_precio_ni,
										:ll_nro_mov,
										:ls_origen_mov);
	
	EXECUTE USP_ALM_PREC_OC_NI_ART;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE USP_ALM_PREC_OC_NI_ART (Cod_Art) " + ls_cod_Art + ": " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return
	END IF
	
	CLOSE USP_ALM_PREC_OC_NI_ART;
	
	hpb_1.position = ll_i
	
next

MessageBox('Aviso', 'Proceso a sido ejecutado satisfactoriamente')
hpb_1.Visible = false
end event

on w_al514_precios_oc_ni.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_3=create cb_3
this.cb_procesar=create cb_procesar
this.hpb_1=create hpb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cb_procesar
this.Control[iCurrent+4]=this.hpb_1
end on

on w_al514_precios_oc_ni.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_3)
destroy(this.cb_procesar)
destroy(this.hpb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_report.Object.DataWindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_al514_precios_oc_ni
integer x = 0
integer y = 152
integer width = 2752
integer height = 1424
string dataobject = "d_rpt_precio_oc_ni_grd"
end type

type uo_fecha from u_ingreso_rango_fechas within w_al514_precios_oc_ni
integer x = 46
integer y = 32
integer taborder = 30
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final
end event

type cb_3 from commandbutton within w_al514_precios_oc_ni
integer x = 1371
integer y = 28
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Date ld_desde, ld_hasta

ld_desde = uo_fecha.of_get_fecha1()
ld_hasta = uo_fecha.of_get_fecha2()


cb_procesar.enabled = false
idw_1 = dw_report
ib_preview = false
parent.Event ue_preview()
idw_1.Object.DataWindow.Print.Orientation = 1
idw_1.Visible = True

idw_1.SetTransObject(Sqlca)
dw_report.object.t_fechas.text   = 'Del: ' + string( ld_desde,'dd/mm/yyyy') + ' Al: ' + string( ld_hasta,'dd/mm/yyyy')
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text   	= gs_user
dw_report.object.t_ventana.text 	= parent.classname( )


idw_1.retrieve(ld_desde,ld_hasta)

if idw_1.Rowcount() > 0 then
	cb_procesar.enabled = true
end if
end event

type cb_procesar from commandbutton within w_al514_precios_oc_ni
integer x = 1783
integer y = 28
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;Parent.Event dynamic ue_procesar()
end event

type hpb_1 from hprogressbar within w_al514_precios_oc_ni
boolean visible = false
integer x = 2217
integer y = 48
integer width = 585
integer height = 64
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

