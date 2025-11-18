$PBExportHeader$w_rpt_consistencia_reg_compras.srw
forward
global type w_rpt_consistencia_reg_compras from w_rpt
end type
type sle_desc from singlelineedit within w_rpt_consistencia_reg_compras
end type
type cb_2 from commandbutton within w_rpt_consistencia_reg_compras
end type
type sle_origen from singlelineedit within w_rpt_consistencia_reg_compras
end type
type st_3 from statictext within w_rpt_consistencia_reg_compras
end type
type dw_reporte from u_dw_rpt within w_rpt_consistencia_reg_compras
end type
type cb_1 from commandbutton within w_rpt_consistencia_reg_compras
end type
type st_1 from statictext within w_rpt_consistencia_reg_compras
end type
type st_2 from statictext within w_rpt_consistencia_reg_compras
end type
type em_ano from editmask within w_rpt_consistencia_reg_compras
end type
type ddlb_mes from dropdownlistbox within w_rpt_consistencia_reg_compras
end type
type gb_1 from groupbox within w_rpt_consistencia_reg_compras
end type
end forward

global type w_rpt_consistencia_reg_compras from w_rpt
integer width = 2807
integer height = 1992
string title = "Consistencia de Registro de Compras"
string menuname = "m_reporte"
boolean resizable = false
long backcolor = 12632256
boolean righttoleft = true
sle_desc sle_desc
cb_2 cb_2
sle_origen sle_origen
st_3 st_3
dw_reporte dw_reporte
cb_1 cb_1
st_1 st_1
st_2 st_2
em_ano em_ano
ddlb_mes ddlb_mes
gb_1 gb_1
end type
global w_rpt_consistencia_reg_compras w_rpt_consistencia_reg_compras

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

public function boolean of_validacion_rpt ();//========== VALIDACION DE LA LONGITUD DEL AÑO Y MES ========//

IF len(em_ano.text) < 4 OR em_ano.text = '0000' THEN 
	Messagebox('EL INGRESO DEL AÑO ESTA MAL','EL AÑO DEBE SER DE 4 DIGITOS')
	em_ano.SetFocus()
	RETURN FALSE
END IF 

IF ddlb_mes.text = 'none' or IsNull(ddlb_mes.text) THEN
	Messagebox('EL INGRESO DEL MES ESTA MAL','EL MES DEBE SER DE 2 DIGITOS')
	ddlb_mes.SetFocus()
	RETURN FALSE
END IF	

IF Trim(sle_origen.text) = '' or IsNull(sle_origen.text) THEN
	Messagebox('EL INGRESO DEL ORIGEN ESTA MAL','DEBE SELECCIONAR ALGUN ITEM DE ORIGEN')
	sle_origen.SetFocus()
	RETURN FALSE
END IF	

RETURN TRUE
end function

on w_rpt_consistencia_reg_compras.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_desc=create sle_desc
this.cb_2=create cb_2
this.sle_origen=create sle_origen
this.st_3=create st_3
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
this.em_ano=create em_ano
this.ddlb_mes=create ddlb_mes
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_desc
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.sle_origen
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.dw_reporte
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.em_ano
this.Control[iCurrent+10]=this.ddlb_mes
this.Control[iCurrent+11]=this.gb_1
end on

on w_rpt_consistencia_reg_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_desc)
destroy(this.cb_2)
destroy(this.sle_origen)
destroy(this.st_3)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_ano)
destroy(this.ddlb_mes)
destroy(this.gb_1)
end on

event ue_retrieve;string ai_ano, ai_mes,as_origen

ai_ano    = em_ano.text
ai_mes    = LEFT(ddlb_mes.text,2)
as_origen = LEFT(sle_origen.text,2)

dw_reporte.SetTransObject(SQLCA)
	
	
dw_reporte.object.p_logo.filename = gs_logo
dw_reporte.object.t_nombre.text   = gs_empresa

dw_reporte.retrieve(as_origen,integer(ai_ano),integer(ai_mes))

end event

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x - 10
dw_reporte.height = newheight - dw_reporte.y - 10

end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_zoom(integer ai_zoom);call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_reporte
Trigger Event ue_preview()

/*idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
*/
//THIS.Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

type sle_desc from singlelineedit within w_rpt_consistencia_reg_compras
integer x = 763
integer y = 292
integer width = 782
integer height = 88
integer taborder = 60
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

type cb_2 from commandbutton within w_rpt_consistencia_reg_compras
integer x = 631
integer y = 292
integer width = 119
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

type sle_origen from singlelineedit within w_rpt_consistencia_reg_compras
integer x = 407
integer y = 292
integer width = 206
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
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

type st_3 from statictext within w_rpt_consistencia_reg_compras
integer x = 201
integer y = 304
integer width = 197
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ORIGEN:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_reporte from u_dw_rpt within w_rpt_consistencia_reg_compras
integer x = 9
integer y = 488
integer width = 2761
integer height = 1472
integer taborder = 30
string dataobject = "d_rpt_consistencia_reg_compras_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

type cb_1 from commandbutton within w_rpt_consistencia_reg_compras
integer x = 1083
integer y = 184
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Event ue_retrieve()
end event

type st_1 from statictext within w_rpt_consistencia_reg_compras
integer x = 201
integer y = 108
integer width = 197
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AÑO:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rpt_consistencia_reg_compras
integer x = 201
integer y = 200
integer width = 197
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MES:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_rpt_consistencia_reg_compras
integer x = 407
integer y = 96
integer width = 174
integer height = 80
integer taborder = 10
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

type ddlb_mes from dropdownlistbox within w_rpt_consistencia_reg_compras
integer x = 407
integer y = 188
integer width = 517
integer height = 856
integer taborder = 20
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

type gb_1 from groupbox within w_rpt_consistencia_reg_compras
integer x = 174
integer y = 36
integer width = 1467
integer height = 388
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

