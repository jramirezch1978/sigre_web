$PBExportHeader$w_pr733_control_de_procesos.srw
forward
global type w_pr733_control_de_procesos from w_rpt
end type
type st_1 from statictext within w_pr733_control_de_procesos
end type
type ddlb_tipo_impresion from dropdownlistbox within w_pr733_control_de_procesos
end type
type em_nro_version from editmask within w_pr733_control_de_procesos
end type
type sle_desc_formato from editmask within w_pr733_control_de_procesos
end type
type sle_formato from singlelineedit within w_pr733_control_de_procesos
end type
type uo_rango from ou_rango_fechas within w_pr733_control_de_procesos
end type
type pb_1 from picturebutton within w_pr733_control_de_procesos
end type
type dw_report from u_dw_rpt within w_pr733_control_de_procesos
end type
type gb_1 from groupbox within w_pr733_control_de_procesos
end type
type gb_2 from groupbox within w_pr733_control_de_procesos
end type
end forward

global type w_pr733_control_de_procesos from w_rpt
integer width = 4416
integer height = 6664
string title = "Control de Procesos(PR733)"
string menuname = "m_reporte"
long backcolor = 67108864
event ue_query_retrieve ( )
st_1 st_1
ddlb_tipo_impresion ddlb_tipo_impresion
em_nro_version em_nro_version
sle_desc_formato sle_desc_formato
sle_formato sle_formato
uo_rango uo_rango
pb_1 pb_1
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
end type
global w_pr733_control_de_procesos w_pr733_control_de_procesos

forward prototypes
public subroutine of_muestra_detalle (boolean alb_promedio, boolean alb_media, boolean alb_suma, boolean alb_moda, boolean alb_minimo, boolean alb_maximo, boolean alb_todos, boolean alb_ninguno)
end prototypes

event ue_query_retrieve();this.event ue_retrieve()
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

on w_pr733_control_de_procesos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.ddlb_tipo_impresion=create ddlb_tipo_impresion
this.em_nro_version=create em_nro_version
this.sle_desc_formato=create sle_desc_formato
this.sle_formato=create sle_formato
this.uo_rango=create uo_rango
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_tipo_impresion
this.Control[iCurrent+3]=this.em_nro_version
this.Control[iCurrent+4]=this.sle_desc_formato
this.Control[iCurrent+5]=this.sle_formato
this.Control[iCurrent+6]=this.uo_rango
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_pr733_control_de_procesos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.ddlb_tipo_impresion)
destroy(this.em_nro_version)
destroy(this.sle_desc_formato)
destroy(this.sle_formato)
destroy(this.uo_rango)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_title, ls_formato, ls_aprobador, ls_formato_des, &
			ls_origen
long 		ll_cuenta, li_count
Integer  li_nro_version, li_nro_tipo_report
date		ld_fecha_aprob, ld_date, ld_fecha_parte

// Ancestor Script has been Override
string 	ls_planta, ls_parte_c
date		ld_fecha1, ld_fecha2
Integer	ll_nro_version_c

ld_fecha1 			= date(uo_rango.of_get_fecha1( ))
ld_fecha2 			= date(uo_rango.of_get_fecha2( ))
ls_formato 			= trim(sle_formato.text)
ll_nro_version_c 	= integer(em_nro_version.text)

li_nro_tipo_report = Integer(left(ddlb_tipo_impresion.text,1))

IF li_nro_tipo_report = 0 then
	MessageBox('Producción', 'Debe Seleccionar un Nivel de Atributos')
	Return
END IF

CHOOSE CASE li_nro_tipo_report
		
   CASE 1 // 1
    dw_report.object.dw_2.dataobject = 'd_rpt_parte_control_procesos_1_n1_crs'
	 dw_report.settransobject(sqlca)
	 dw_report.retrieve(ls_formato, ll_nro_version_c, ld_fecha1, ld_fecha2)
	CASE 2 // 2
	 dw_report.object.dw_2.dataobject = 'd_rpt_parte_control_procesos_1_n2_crs'
	 dw_report.settransobject(sqlca)
    dw_report.retrieve(ls_formato, ll_nro_version_c, ld_fecha1, ld_fecha2)
	CASE 3 //3 
    dw_report.object.dw_2.dataobject = 'd_rpt_parte_control_procesos_1_n3_crs'
	 dw_report.settransobject(sqlca)
	 dw_report.retrieve(ls_formato, ll_nro_version_c, ld_fecha1, ld_fecha2)
	CASE 4 //3 
    dw_report.object.dw_2.dataobject = 'd_rpt_parte_control_procesos_1_n4_crs'
	 dw_report.settransobject(sqlca)
	 dw_report.retrieve(ls_formato, ll_nro_version_c, ld_fecha1, ld_fecha2)
	END CHOOSE
  
idw_1.Visible = True

 select upper(fma.descripcion)
   into :ls_title
   from tg_fmt_med_act fma
  where fma.formato = :ls_formato
    and fma.nro_version = :ll_nro_version_c;
	
ld_date = date(f_fecha_actual())
	
SELECT F.FORMATO, F.APROBADOR, F.NRO_VERSION, F.FECHA_FORMATO, P.FECHA_PARTE
   into :ls_formato, :ls_aprobador, :li_nro_version, :ld_fecha_aprob, :ld_fecha_parte
   from tg_parte_piso p, tg_fmt_med_act f
  where f.formato = :ls_formato
    and f.nro_version = :ll_nro_version_c;	 
dw_report.object.t_title.text 			= ls_title
dw_report.object.t_formato.text 			= 'Formato: ' + ls_formato
dw_report.object.t_aprob.text 			= 'Aprob: ' + ls_aprobador
dw_report.object.t_fecha_aprob.text 	= 'Fecha Aprob: ' + String(ld_fecha_aprob)
dw_report.object.t_rev.text 				= 'Revisión: ' + String(li_nro_version)
dw_report.object.t_date.text 				= 'Fecha de impresión: ' + string(ld_date)
dw_report.object.t_user.text 				= 'Impreso por: ' + gs_user
dw_report.object.t_nombre.text 			= 'U.O. ' + gs_origen
dw_report.object.p_logo.filename 		= gs_logo
idw_1.Object.Datawindow.Print.Orientation = '1'
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

THIS.Event ue_preview()

end event

event resize;call super::resize;dw_report.width 	= newwidth - dw_report.x
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

type st_1 from statictext within w_pr733_control_de_procesos
integer x = 41
integer y = 192
integer width = 480
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro. Atributos"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_tipo_impresion from dropdownlistbox within w_pr733_control_de_procesos
integer x = 37
integer y = 264
integer width = 485
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
string item[] = {"1 -","2 - ","3 - ","4 -"}
borderstyle borderstyle = stylelowered!
end type

type em_nro_version from editmask within w_pr733_control_de_procesos
integer x = 1787
integer y = 68
integer width = 174
integer height = 88
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

type sle_desc_formato from editmask within w_pr733_control_de_procesos
integer x = 1975
integer y = 68
integer width = 937
integer height = 88
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

type sle_formato from singlelineedit within w_pr733_control_de_procesos
event dobleclick pbm_lbuttondblclk
integer x = 1248
integer y = 68
integer width = 530
integer height = 88
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

type uo_rango from ou_rango_fechas within w_pr733_control_de_procesos
event destroy ( )
integer x = 50
integer y = 68
integer width = 1129
integer taborder = 40
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_pr733_control_de_procesos
integer x = 549
integer y = 244
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
string text = "Generar Reporte"
string picturename = "H:\source\BMP\find_ot_SMALL.bmp"
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_pr733_control_de_procesos
integer x = 32
integer y = 392
integer width = 3671
integer height = 1316
string dataobject = "d_rpt_contro_proceses_cps"
boolean hscrollbar = true
boolean vscrollbar = true
integer ii_zoom_actual = 200
end type

type gb_1 from groupbox within w_pr733_control_de_procesos
integer x = 37
integer y = 8
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

type gb_2 from groupbox within w_pr733_control_de_procesos
integer x = 1216
integer y = 8
integer width = 1728
integer height = 168
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Formato de Medición"
end type

