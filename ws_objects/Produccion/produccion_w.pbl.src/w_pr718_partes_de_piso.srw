$PBExportHeader$w_pr718_partes_de_piso.srw
forward
global type w_pr718_partes_de_piso from w_rpt
end type
type cbx_suma from checkbox within w_pr718_partes_de_piso
end type
type cbx_promedio from checkbox within w_pr718_partes_de_piso
end type
type st_2 from statictext within w_pr718_partes_de_piso
end type
type ddlb_tipo_impresion from dropdownlistbox within w_pr718_partes_de_piso
end type
type em_nro_version from editmask within w_pr718_partes_de_piso
end type
type sle_desc_formato from editmask within w_pr718_partes_de_piso
end type
type sle_formato from singlelineedit within w_pr718_partes_de_piso
end type
type cbx_formato from checkbox within w_pr718_partes_de_piso
end type
type st_1 from statictext within w_pr718_partes_de_piso
end type
type cbx_tipo_m from checkbox within w_pr718_partes_de_piso
end type
type em_origen from singlelineedit within w_pr718_partes_de_piso
end type
type em_descripcion from editmask within w_pr718_partes_de_piso
end type
type uo_rango from ou_rango_fechas within w_pr718_partes_de_piso
end type
type dw_partes from u_dw_abc within w_pr718_partes_de_piso
end type
type pb_1 from picturebutton within w_pr718_partes_de_piso
end type
type dw_report from u_dw_rpt within w_pr718_partes_de_piso
end type
type gb_1 from groupbox within w_pr718_partes_de_piso
end type
type gb_2 from groupbox within w_pr718_partes_de_piso
end type
type gb_3 from groupbox within w_pr718_partes_de_piso
end type
type gb_4 from groupbox within w_pr718_partes_de_piso
end type
end forward

global type w_pr718_partes_de_piso from w_rpt
integer width = 4695
integer height = 3244
string title = "Partes de Piso(PR718)"
string menuname = "m_reporte"
long backcolor = 67108864
event ue_query_retrieve ( )
event ue_retrieve_partes ( )
cbx_suma cbx_suma
cbx_promedio cbx_promedio
st_2 st_2
ddlb_tipo_impresion ddlb_tipo_impresion
em_nro_version em_nro_version
sle_desc_formato sle_desc_formato
sle_formato sle_formato
cbx_formato cbx_formato
st_1 st_1
cbx_tipo_m cbx_tipo_m
em_origen em_origen
em_descripcion em_descripcion
uo_rango uo_rango
dw_partes dw_partes
pb_1 pb_1
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_pr718_partes_de_piso w_pr718_partes_de_piso

forward prototypes
public subroutine of_muestra_detalle (boolean alb_promedio, boolean alb_media, boolean alb_suma, boolean alb_moda, boolean alb_minimo, boolean alb_maximo, boolean alb_todos, boolean alb_ninguno)
end prototypes

event ue_query_retrieve();this.event ue_retrieve_partes()
end event

event ue_retrieve_partes();// Ancestor Script has been Override
string 	ls_planta, ls_parte_c
date		ld_fecha1, ld_fecha2
Integer	ll_nro_version_c

ld_fecha1	=	date(uo_rango.of_get_fecha1( ))
ld_fecha2 	= 	date(uo_rango.of_get_fecha2( ))

if cbx_tipo_m.checked = true then
	ls_planta = '%%'
else
	ls_planta 	= trim(em_origen.text)
	IF ls_planta = '' or isnull(ls_planta) then
		Messagebox('Producción', 'Debe de Indicar un Código de Planta')
		Return
	end if
	
end if

if cbx_formato.checked = true then
	ls_parte_c = '%%'
	dw_partes.dataobject = 'd_pastes_de_piso_tbl'
	dw_partes.settransobject(sqlca)
	dw_partes.retrieve(ld_fecha1, ld_fecha2, ls_planta, ls_parte_c)
else
	ls_parte_c 			= trim(sle_formato.text)
	ll_nro_version_c  = integer(em_nro_version.text)
	
	if ls_parte_c = '' or IsNull(ls_parte_c) then
		MessageBox('Producción', 'Debe indicar un Codigo de formato/Version')
		return
	end if
	dw_partes.dataobject = 'd_pastes_de_piso_nro_ver_tbl'
	dw_partes.settransobject(sqlca)
	dw_partes.retrieve(ld_fecha1, ld_fecha2, ls_planta, ls_parte_c, ll_nro_version_c)
end if
end event

public subroutine of_muestra_detalle (boolean alb_promedio, boolean alb_media, boolean alb_suma, boolean alb_moda, boolean alb_minimo, boolean alb_maximo, boolean alb_todos, boolean alb_ninguno);//Muestra detalle de Informacion del Reporte del Parte de Piso

IF alb_todos = true then
	dw_report.object.dw_2.object.t_promedio.visible = true
	dw_report.object.dw_2.object.promedio.visible 	= true
	dw_report.object.dw_2.object.t_media.visible 	= true
	dw_report.object.dw_2.object.media.visible 		= true
	dw_report.object.dw_2.object.t_suma.visible 		= true
	dw_report.object.dw_2.object.suma.visible 		= true
	dw_report.object.dw_2.object.t_moda.visible 		= true
	dw_report.object.dw_2.object.moda.visible 		= true
	dw_report.object.dw_2.object.t_maximo.visible 	= true
	dw_report.object.dw_2.object.maximo.visible 		= true
	dw_report.object.dw_2.object.t_maximo.visible 	= true
	dw_report.object.dw_2.object.maximo.visible 		= true	
ELSE
	dw_report.object.dw_2.object.t_promedio.visible = FALSE
	dw_report.object.dw_2.object.promedio.visible 	= FALSE
	dw_report.object.dw_2.object.t_media.visible 	= FALSE
	dw_report.object.dw_2.object.media.visible 		= FALSE
	dw_report.object.dw_2.object.t_suma.visible 		= FALSE
	dw_report.object.dw_2.object.suma.visible 		= FALSE
	dw_report.object.dw_2.object.t_moda.visible 		= FALSE
	dw_report.object.dw_2.object.moda.visible 		= FALSE
	dw_report.object.dw_2.object.t_maximo.visible 	= FALSE
	dw_report.object.dw_2.object.maximo.visible 		= FALSE
	dw_report.object.dw_2.object.t_maximo.visible 	= FALSE
	dw_report.object.dw_2.object.maximo.visible 		= FALSE
End If
end subroutine

on w_pr718_partes_de_piso.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_suma=create cbx_suma
this.cbx_promedio=create cbx_promedio
this.st_2=create st_2
this.ddlb_tipo_impresion=create ddlb_tipo_impresion
this.em_nro_version=create em_nro_version
this.sle_desc_formato=create sle_desc_formato
this.sle_formato=create sle_formato
this.cbx_formato=create cbx_formato
this.st_1=create st_1
this.cbx_tipo_m=create cbx_tipo_m
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.uo_rango=create uo_rango
this.dw_partes=create dw_partes
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_suma
this.Control[iCurrent+2]=this.cbx_promedio
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_tipo_impresion
this.Control[iCurrent+5]=this.em_nro_version
this.Control[iCurrent+6]=this.sle_desc_formato
this.Control[iCurrent+7]=this.sle_formato
this.Control[iCurrent+8]=this.cbx_formato
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cbx_tipo_m
this.Control[iCurrent+11]=this.em_origen
this.Control[iCurrent+12]=this.em_descripcion
this.Control[iCurrent+13]=this.uo_rango
this.Control[iCurrent+14]=this.dw_partes
this.Control[iCurrent+15]=this.pb_1
this.Control[iCurrent+16]=this.dw_report
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_3
this.Control[iCurrent+20]=this.gb_4
end on

on w_pr718_partes_de_piso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_suma)
destroy(this.cbx_promedio)
destroy(this.st_2)
destroy(this.ddlb_tipo_impresion)
destroy(this.em_nro_version)
destroy(this.sle_desc_formato)
destroy(this.sle_formato)
destroy(this.cbx_formato)
destroy(this.st_1)
destroy(this.cbx_tipo_m)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.uo_rango)
destroy(this.dw_partes)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_nro_parte, ls_title, ls_formato, ls_aprobador, ls_formato_des, &
			ls_origen
long 		ll_cuenta, li_count
Integer  li_nro_version, li_nro_tipo_report
date		ld_fecha_aprob, ld_date, ld_fecha_parte
Boolean  lb_promedio, lb_media, lb_suma, lb_moda, lb_maximo,&
			lb_minimo, lb_ninguno, lb_todos, lb_simple

if dw_partes.getrow( ) = 0 then Return

ls_nro_parte   = dw_partes.GetItemString(dw_partes.GetRow(),'nro_parte')
ls_formato_des = dw_partes.GetItemString(dw_partes.GetRow(),'formato') 

SELECT COUNT(P.NRO_PARTE)
  into :li_count
  FROM TG_PARTE_PISO P
 WHERE P.NRO_PARTE   =  :ls_nro_parte 
   AND P.FLAG_ESTADO =  '0';

if li_count > 0 then
	messagebox('Modulo de Producción','El parte de Piso Nº ' + ls_nro_parte +' se encuntra anulado')
	dw_report.reset()
	return 
end if

lb_promedio = cbx_promedio.checked
//lb_media	   = cbx_media.checked
lb_suma     = cbx_suma.checked
//lb_simple	= cbx_simple.checked
//lb_moda     = cbx_suma.checked
//lb_maximo	= cbx_maximo.checked
//lb_minimo	= cbx_minimo.checked
//lb_ninguno  = cbx_ninguno.checked
//lb_todos    = cbx_todos.checked

dw_report.reset()

IF ls_formato_des = 'SPSAC-R-048' THEN
	
	dw_report.dataobject = 'd_rpt_pd_partes_de_piso_despacho_cps'
	dw_report.settransobject(sqlca)
   dw_report.retrieve(ls_nro_parte)

else

li_nro_tipo_report = Integer(left(ddlb_tipo_impresion.text,1))

IF li_nro_tipo_report = 0 then
	MessageBox('Producción', 'Debe Seleccionar un Tipo de Impresión')
	Return
END IF

CHOOSE CASE li_nro_tipo_report
		
   CASE 1 // 1 - Vertical
		
		if lb_promedio = true then
			dw_report.object.dw_2.dataobject = 'd_rpt_pd_parte_piso_horizontal_det_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
		else
		   dw_report.object.dw_2.dataobject = 'd_rpt_pd_parte_piso_horizontal_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
	   end if
		
	CASE 2 //2 - LEcturas con Control y Lectura 
		
		if lb_promedio = true and lb_suma = true then
		   dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_lectura_control_det_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
    ElseIf lb_promedio = true and lb_suma = false then
			dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_lectura_control_pro_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
	 ElseIf lb_promedio = false and lb_suma = false then
			dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_lectura_control_sim_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
	ElseIf lb_promedio = false and lb_suma = TRUE then
			dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_lectura_control_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
		end if
		
   CASE 3 //3 - Lecturas Con Control y Horas 
		if lb_promedio = true and lb_suma = true then
		   dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_hora_sin_control_de_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
    ElseIf lb_promedio = true and lb_suma = false then
			dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_hora_sin_contro_pro_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
	 ElseIf lb_promedio = false and lb_suma = false then
			dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_hora_control_simple_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
	ElseIf lb_promedio = false and lb_suma = TRUE then
			dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_hora_sin_control_crs'
			dw_report.settransobject(sqlca)
			dw_report.retrieve(ls_nro_parte)
		end if
      
  END CHOOSE
  
end if

idw_1.Visible = True

 select upper(fma.descripcion)
   into :ls_title
   from tg_parte_piso_det ppd, tg_fmt_med_act fma
  where ppd.formato   = fma.formato(+)
    and ppd.nro_version	= fma.nro_version(+)
    and ppd.nro_parte = :ls_nro_parte;

if sqlca.sqlcode = 100 then ls_title = 'PARTE DE PISO'
	
ld_date = date(f_fecha_actual())
	
SELECT F.FORMATO, F.APROBADOR, F.NRO_VERSION, F.FECHA_FORMATO, P.FECHA_PARTE
   into :ls_formato, :ls_aprobador, :li_nro_version, :ld_fecha_aprob, :ld_fecha_parte
   from tg_parte_piso p, tg_fmt_med_act f
  where p.formato   		= f.formato(+)
    and p.nro_version 	= f.nro_version(+)
    and p.nro_parte 		= :ls_nro_parte;
	 
Select o.nombre
  into :ls_origen
  from origen o, tg_plantas p, tg_parte_piso pp
 where o.cod_origen = p.cod_origen
   and p.cod_planta = pp.cod_planta
	and pp.nro_parte = :ls_nro_parte;

dw_report.object.t_title.text 			= ls_title
dw_report.object.t_parte.text 			= 'Nro de Parte: ' + ls_nro_parte
dw_report.object.t_fecha.text 			= 'Fecha de parte: ' + string(ld_fecha_parte)
dw_report.object.t_formato.text 			= 'Formato: ' + ls_formato
dw_report.object.t_aprob.text 			= 'Aprob: ' + ls_aprobador
dw_report.object.t_fecha_aprob.text 	= 'Fecha Aprob: ' + String(ld_fecha_aprob)
dw_report.object.t_rev.text 				= 'Revisión: ' + String(li_nro_version)
dw_report.object.t_date.text 				= 'Fecha de impresión: ' + string(ld_date)
dw_report.object.t_user.text 				= 'Impreso por: ' + gs_user
dw_report.object.t_nombre.text 			= 'U.O. ' + ls_origen
dw_report.object.p_logo.filename 		= gs_logo
idw_1.Object.Datawindow.Print.Orientation = '1'

//	CASE 4 //4 - Lectura Sin Rangos Max y Min
//		dw_report.object.dw_2.dataobject = 'd_rpt_pd_parte_piso_tbl'
//		dw_report.settransobject(sqlca)
//		dw_report.retrieve(ls_nro_parte)
//	CASE 5 //5 - Hora Con Rangos Max y Min 
//		dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_hora_sin_control_crs'
//		dw_report.settransobject(sqlca)
//		dw_report.retrieve(ls_nro_parte)
//	CASE 6 //6 - Hora Sin Rangos Max y Min
//		dw_report.object.dw_2.dataobject = 'd_rpt_parte_piso_hora_sin_lim_con_crs'
//		dw_report.settransobject(sqlca)
//		dw_report.retrieve(ls_nro_parte)
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
dw_partes.SetTransObject(sqlca)

cbx_tipo_m.checked = true
cbx_formato.checked = true

THIS.Event ue_preview()

end event

event resize;call super::resize;dw_partes.width   = newwidth - dw_partes.x
dw_report.width 	= newwidth - dw_report.x
dw_report.height 	= newheight - dw_report.y
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type cbx_suma from checkbox within w_pr718_partes_de_piso
integer x = 1065
integer y = 680
integer width = 270
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Suma"
end type

type cbx_promedio from checkbox within w_pr718_partes_de_piso
integer x = 1326
integer y = 680
integer width = 347
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Promedio"
end type

type st_2 from statictext within w_pr718_partes_de_piso
integer x = 1010
integer y = 616
integer width = 219
integer height = 56
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle:"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_tipo_impresion from dropdownlistbox within w_pr718_partes_de_piso
integer x = 37
integer y = 676
integer width = 1001
integer height = 352
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"1 - Vertical","2 - Horizontal / Control / Lectura","3 - Horizontal / Control / Hora"}
borderstyle borderstyle = stylelowered!
end type

type em_nro_version from editmask within w_pr718_partes_de_piso
integer x = 2642
integer y = 92
integer width = 174
integer height = 84
integer taborder = 70
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###,##0"
boolean autoskip = true
boolean spin = true
double increment = 1
string minmax = "0~~"
end type

type sle_desc_formato from editmask within w_pr718_partes_de_piso
integer x = 2853
integer y = 92
integer width = 841
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
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type sle_formato from singlelineedit within w_pr718_partes_de_piso
event dobleclick pbm_lbuttondblclk
integer x = 2309
integer y = 88
integer width = 329
integer height = 84
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
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  formato as codigo_formato, " & 
		  +"descripcion AS desc_formato " &
		  + "FROM tg_fmt_med_act " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_desc_formato.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un Formato')
	return
end if

SELECT descripcion INTO :ls_desc
FROM tg_fmt_med_act
WHERE formato =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Formato no existe')
	return
end if

sle_desc_formato.text = ls_desc

end event

type cbx_formato from checkbox within w_pr718_partes_de_piso
integer x = 2235
integer y = 84
integer width = 91
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;if this.checked = true then
	
	sle_formato.enabled = false
	em_nro_version.enabled = false
	sle_formato.text = '' 
	em_nro_version.text = ''
	
else
	
	sle_formato.enabled = true
	em_nro_version.enabled = true

end if
end event

type st_1 from statictext within w_pr718_partes_de_piso
integer x = 5
integer y = 620
integer width = 485
integer height = 56
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Impresión:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_tipo_m from checkbox within w_pr718_partes_de_piso
integer x = 1221
integer y = 84
integer width = 91
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;if this.checked = true then
	
	em_origen.enabled = false
	em_origen.text = '' 
	
else
	
	em_origen.enabled = true

end if
end event

type em_origen from singlelineedit within w_pr718_partes_de_piso
event dobleclick pbm_lbuttondblclk
integer x = 1294
integer y = 100
integer width = 128
integer height = 64
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_planta as codigo_de_planta, " & 
		  +"desc_planta AS nombre_de_planta " &
		  + "FROM tg_plantas " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Planta')
	return
end if

SELECT desc_planta INTO :ls_desc
FROM tg_plantas
WHERE cod_planta =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Planta no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type em_descripcion from editmask within w_pr718_partes_de_piso
integer x = 1422
integer y = 88
integer width = 745
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type uo_rango from ou_rango_fechas within w_pr718_partes_de_piso
event destroy ( )
integer x = 46
integer y = 88
integer width = 1129
integer taborder = 40
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type dw_partes from u_dw_abc within w_pr718_partes_de_piso
integer x = 32
integer y = 212
integer width = 3698
integer height = 392
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pastes_de_piso_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event rowfocuschanged;call super::rowfocuschanged;//dw_detail.reset()
//dw_master.reset()
//
//if currentrow >= 1 then
//	if dw_master.retrieve(this.object.nro_parte[currentrow]) >= 1 then
//		dw_master.scrolltorow(1)
//		dw_master.setrow(1)
//		dw_master.selectrow( 1, true)
//	end if
//end if
end event

event doubleclicked;call super::doubleclicked;//String ls_fec_ini, ls_fec_fin
//
//IF row = 0 THEN RETURN
//
//STR_CNS_POP lstr_1
//
//lstr_1.DataObject = 'd_rpt_pd_partes_de_piso_cps'
//lstr_1.Width = 5000
//lstr_1.Height= 5000
//lstr_1.Arg[1] = GetItemString(row,'nro_parte')
//lstr_1.Title = 'Parte de Piso Nro: '+ GetItemString(row,'nro_parte')
//lstr_1.Tipo_Cascada = 'R'
//of_new_sheet(lstr_1)
end event

type pb_1 from picturebutton within w_pr718_partes_de_piso
integer x = 1733
integer y = 656
integer width = 617
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ver Detalle de Parte"
string picturename = "H:\source\BMP\find_ot_SMALL.bmp"
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_pr718_partes_de_piso
integer y = 784
integer width = 3671
integer height = 1880
string dataobject = "d_rpt_pd_partes_de_piso_cps"
boolean hscrollbar = true
boolean vscrollbar = true
integer ii_zoom_actual = 200
end type

type gb_1 from groupbox within w_pr718_partes_de_piso
integer x = 32
integer y = 28
integer width = 1161
integer height = 168
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas:"
end type

type gb_2 from groupbox within w_pr718_partes_de_piso
integer x = 2199
integer y = 28
integer width = 1522
integer height = 168
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todos   -   Seleccione Formato"
end type

type gb_3 from groupbox within w_pr718_partes_de_piso
integer x = 1198
integer y = 28
integer width = 1001
integer height = 168
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todas   -   Seleccione Planta"
end type

type gb_4 from groupbox within w_pr718_partes_de_piso
integer x = 1042
integer y = 644
integer width = 658
integer height = 120
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

