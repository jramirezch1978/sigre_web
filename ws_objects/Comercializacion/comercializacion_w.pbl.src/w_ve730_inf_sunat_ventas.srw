$PBExportHeader$w_ve730_inf_sunat_ventas.srw
forward
global type w_ve730_inf_sunat_ventas from w_rpt
end type
type cbx_1 from checkbox within w_ve730_inf_sunat_ventas
end type
type st_3 from statictext within w_ve730_inf_sunat_ventas
end type
type cb_2 from commandbutton within w_ve730_inf_sunat_ventas
end type
type sle_origen from singlelineedit within w_ve730_inf_sunat_ventas
end type
type sle_desc from singlelineedit within w_ve730_inf_sunat_ventas
end type
type ddlb_mes from dropdownlistbox within w_ve730_inf_sunat_ventas
end type
type st_2 from statictext within w_ve730_inf_sunat_ventas
end type
type st_1 from statictext within w_ve730_inf_sunat_ventas
end type
type em_ano from editmask within w_ve730_inf_sunat_ventas
end type
type cb_1 from commandbutton within w_ve730_inf_sunat_ventas
end type
type dw_report from u_dw_rpt within w_ve730_inf_sunat_ventas
end type
type gb_1 from groupbox within w_ve730_inf_sunat_ventas
end type
end forward

global type w_ve730_inf_sunat_ventas from w_rpt
integer width = 3438
integer height = 2060
string title = "[VE730] Registros de Ventas y Cobros"
string menuname = "m_reporte"
long backcolor = 12632256
cbx_1 cbx_1
st_3 st_3
cb_2 cb_2
sle_origen sle_origen
sle_desc sle_desc
ddlb_mes ddlb_mes
st_2 st_2
st_1 st_1
em_ano em_ano
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve730_inf_sunat_ventas w_ve730_inf_sunat_ventas

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = FALSE
THIS.Event ue_preview()



idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user

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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_ve730_inf_sunat_ventas.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_1=create cbx_1
this.st_3=create st_3
this.cb_2=create cb_2
this.sle_origen=create sle_origen
this.sle_desc=create sle_desc
this.ddlb_mes=create ddlb_mes
this.st_2=create st_2
this.st_1=create st_1
this.em_ano=create em_ano
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.sle_origen
this.Control[iCurrent+5]=this.sle_desc
this.Control[iCurrent+6]=this.ddlb_mes
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.em_ano
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
end on

on w_ve730_inf_sunat_ventas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.st_3)
destroy(this.cb_2)
destroy(this.sle_origen)
destroy(this.sle_desc)
destroy(this.ddlb_mes)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

type cbx_1 from checkbox within w_ve730_inf_sunat_ventas
integer x = 1120
integer y = 68
integer width = 667
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes "
boolean lefttext = true
end type

type st_3 from statictext within w_ve730_inf_sunat_ventas
integer x = 69
integer y = 304
integer width = 210
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ORIGEN :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_ve730_inf_sunat_ventas
integer x = 544
integer y = 296
integer width = 96
integer height = 88
integer taborder = 50
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
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO ,'&
				      				 +'ORIGEN.NOMBRE AS DESCRIPCION '&
				   					 +'FROM ORIGEN '

														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
   sle_origen.text =  lstr_seleccionar.param1[1]
   sle_desc.text   =  lstr_seleccionar.param2[1]
END IF

end event

type sle_origen from singlelineedit within w_ve730_inf_sunat_ventas
integer x = 302
integer y = 296
integer width = 233
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_origen,ls_desc
Long   ll_count


ls_origen = this.text


select count(*) into :ll_count 
  from origen 
 where cod_origen = :ls_origen ;
 
IF ll_count > 0 THEN
	select nombre into :ls_desc from origen 
	 where cod_origen = :ls_origen ;
	 
	sle_desc.text = ls_desc
ELSE
	Setnull(ls_desc)
	sle_desc.text = ls_desc
END IF
 

end event

type sle_desc from singlelineedit within w_ve730_inf_sunat_ventas
integer x = 663
integer y = 296
integer width = 768
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type ddlb_mes from dropdownlistbox within w_ve730_inf_sunat_ventas
integer x = 302
integer y = 188
integer width = 517
integer height = 856
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ve730_inf_sunat_ventas
integer x = 69
integer y = 200
integer width = 210
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MES :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ve730_inf_sunat_ventas
integer x = 69
integer y = 108
integer width = 210
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AÑO :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_ve730_inf_sunat_ventas
integer x = 302
integer y = 96
integer width = 174
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type cb_1 from commandbutton within w_ve730_inf_sunat_ventas
integer x = 2962
integer y = 60
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_origen
Long	 ll_count,ll_ano,ll_mes

ll_ano    = Long(em_ano.text)
ll_mes    = Long(LEFT(ddlb_mes.text,2))
ls_origen = sle_origen.text



IF cbx_1.checked THEN
	ls_origen = '%'
ELSE
	select count(*) into :ll_count 
	  from origen where (cod_origen = :ls_origen) ;
	  
	IF ll_count = 0 THEN 
		Messagebox('Aviso','Codigo de Origen No Valido')
		sle_origen.SetFocus()
		RETURN
	END IF
		  
END IF
	
SetPointer(HourGlass!)	




DECLARE PB_usp_fin_rpt_sunat_ventas PROCEDURE FOR usp_fin_rpt_sunat_ventas
(:ll_ano,:ll_mes,:ls_origen);
EXECUTE PB_usp_fin_rpt_sunat_ventas ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


CLOSE PB_usp_fin_rpt_sunat_ventas ;


dw_report.retrieve()




end event

type dw_report from u_dw_rpt within w_ve730_inf_sunat_ventas
integer x = 18
integer y = 436
integer width = 3355
integer height = 1400
string dataobject = "d_rpt_sunat_cobros_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ve730_inf_sunat_ventas
integer x = 23
integer y = 16
integer width = 1815
integer height = 404
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Argumentos"
end type

