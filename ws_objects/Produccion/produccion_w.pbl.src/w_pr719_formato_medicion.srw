$PBExportHeader$w_pr719_formato_medicion.srw
forward
global type w_pr719_formato_medicion from w_rpt
end type
type pb_1 from picturebutton within w_pr719_formato_medicion
end type
type sle_desc_formato from singlelineedit within w_pr719_formato_medicion
end type
type st_1 from statictext within w_pr719_formato_medicion
end type
type em_nro_parte from singlelineedit within w_pr719_formato_medicion
end type
type dw_report from u_dw_rpt within w_pr719_formato_medicion
end type
type gb_2 from groupbox within w_pr719_formato_medicion
end type
end forward

global type w_pr719_formato_medicion from w_rpt
integer width = 3159
integer height = 1804
string title = "Partes de Piso(PR719)"
string menuname = "m_reporte"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
pb_1 pb_1
sle_desc_formato sle_desc_formato
st_1 st_1
em_nro_parte em_nro_parte
dw_report dw_report
gb_2 gb_2
end type
global w_pr719_formato_medicion w_pr719_formato_medicion

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr719_formato_medicion.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.pb_1=create pb_1
this.sle_desc_formato=create sle_desc_formato
this.st_1=create st_1
this.em_nro_parte=create em_nro_parte
this.dw_report=create dw_report
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.sle_desc_formato
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_nro_parte
this.Control[iCurrent+5]=this.dw_report
this.Control[iCurrent+6]=this.gb_2
end on

on w_pr719_formato_medicion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.sle_desc_formato)
destroy(this.st_1)
destroy(this.em_nro_parte)
destroy(this.dw_report)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_nro_parte, ls_date, ls_title, ls_formato, ls_aprobador
long 		ll_cuenta, li_count, ll_rev
Date 	   ld_fecha_aprob

ls_nro_parte = trim(em_nro_parte.text)

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

dw_report.reset()

dw_report.retrieve(ls_nro_parte)
idw_1.Visible = True

 select upper(fma.descripcion)
   into :ls_title
   from tg_parte_piso_det ppd, tg_fmt_med_act fma
  where ppd.formato   = fma.formato(+)
    and ppd.nro_parte = :ls_nro_parte;

if sqlca.sqlcode = 100 then ls_title = 'PARTE DE PISO'

select   to_char(sysdate, 'dd/mm/yyyy') 
	into  :ls_date
	from  dual;
	
ls_title = ls_title + ' Nº ' + ls_nro_parte

SELECT F.FORMATO, F.APROBADOR, F.REVISION, F.FECHA_FORMATO 
   into :ls_formato, :ls_aprobador, :ll_rev, :ld_fecha_aprob
   from tg_parte_piso p, tg_fmt_med_act f
  where p.formato   = f.formato(+)
    and p.nro_parte = :ls_nro_parte;

dw_report.object.t_title.text 			= ls_title
dw_report.object.t_formato.text 			= 'Formato: ' + ls_formato
dw_report.object.t_aprob.text 			= 'Aprob: ' + ls_aprobador
dw_report.object.t_fecha_aprob.text 	= 'Fecha: ' + String(ld_fecha_aprob)
dw_report.object.t_rev.text 				= 'Revisión' + String(ll_rev)
dw_report.object.t_date.text 				= 'Fecha de impresión: ' + ls_date
dw_report.object.t_user.text 				= 'Impreso por: ' + gs_user
dw_report.object.t_empresa.text 			= gs_empresa
dw_report.object.p_logo.filename 		= gs_logo
idw_1.Object.Datawindow.Print.Orientation = '1'
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)


THIS.Event ue_preview()

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

type pb_1 from picturebutton within w_pr719_formato_medicion
integer x = 1897
integer y = 72
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type sle_desc_formato from singlelineedit within w_pr719_formato_medicion
integer x = 443
integer y = 132
integer width = 1371
integer height = 84
integer taborder = 20
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

type st_1 from statictext within w_pr719_formato_medicion
integer x = 64
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

type em_nro_parte from singlelineedit within w_pr719_formato_medicion
event dobleclick pbm_lbuttondblclk
integer x = 123
integer y = 136
integer width = 315
integer height = 72
integer taborder = 10
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
else
	messagebox('Modulo de Producción','El parte de Piso Nº ' + ls_codigo +' no existe o se encuntra anulado')
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
 		 AND T.FLAG_ESTADO = '1'
       AND T.NRO_PARTE = :ls_nro_parte;

IF SQLCA.SQLCode = 100 THEN
	messagebox('Modulo de Producción','El parte de Piso Nº ' + ls_nro_parte +' no existe o se encuntra anulado')
	return
end if

sle_desc_formato.text = ls_desc

end event

type dw_report from u_dw_rpt within w_pr719_formato_medicion
integer x = 55
integer y = 264
integer width = 2697
integer height = 1328
string dataobject = "d_rpt_pd_formato_medicion_cps"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within w_pr719_formato_medicion
integer x = 64
integer y = 80
integer width = 1783
integer height = 156
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

