$PBExportHeader$w_al507_despachos.srw
forward
global type w_al507_despachos from w_report_smpl
end type
type ddlb_1 from dropdownlistbox within w_al507_despachos
end type
type st_1 from statictext within w_al507_despachos
end type
type uo_1 from u_ingreso_rango_fechas within w_al507_despachos
end type
type cb_reporte from commandbutton within w_al507_despachos
end type
end forward

global type w_al507_despachos from w_report_smpl
integer width = 3026
integer height = 1132
string title = "Despachos (AL507)"
string menuname = "m_impresion"
ddlb_1 ddlb_1
st_1 st_1
uo_1 uo_1
cb_reporte cb_reporte
end type
global w_al507_despachos w_al507_despachos

type variables
Integer ii_opcion
String	is_doc_ov, is_flag[], is_subtitulo
end variables

forward prototypes
public function string of_get_doc_ov ()
end prototypes

public function string of_get_doc_ov ();String	ls_doc_ov

  SELECT "LOGPARAM"."DOC_OV"  
    INTO :ls_doc_ov  
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;


RETURN TRIM(ls_doc_ov)
end function

on w_al507_despachos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.uo_1=create uo_1
this.cb_reporte=create cb_reporte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.cb_reporte
end on

on w_al507_despachos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.cb_reporte)
end on

event ue_open_pre;call super::ue_open_pre;is_doc_ov = of_get_doc_ov()
end event

type dw_report from w_report_smpl`dw_report within w_al507_despachos
integer x = 23
integer y = 148
integer height = 572
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cant_procesada" 
		lstr_1.DataObject = 'd_ov_det_almacen_art_mov_tbl'
		lstr_1.Width = 3800
		lstr_1.Height= 1300
		lstr_1.Arg[1] = is_doc_ov
		lstr_1.Arg[2] = GetItemString(row,'nro_ov')
		lstr_1.Arg[3] = GetItemString(row,'almacen')
		lstr_1.Arg[4] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Salidas x OV x Almacen x Articulo'
		lstr_1.Tipo_Cascada = 'R'
		lstr_1.Nextcol = 'vale_mov_flag_estado'
		of_new_sheet(lstr_1)
	CASE "cant_facturada" 
		lstr_1.DataObject = 'd_ov_factura_det_tbl'
		lstr_1.Width = 3200
		lstr_1.Height= 800
		lstr_1.Arg[1] = is_doc_ov
		lstr_1.Arg[2] = GetItemString(row,'nro_ov')
		lstr_1.Arg[3] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Facturas por OV'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)	
	CASE "nro_ov" 
		lstr_1.DataObject = 'd_cns_orden_venta_cmp'
		lstr_1.Width = 3800
		lstr_1.Height= 2500
		lstr_1.Arg[1] = THIS.GetItemString(row,'nro_ov')		
		lstr_1.Title = 'Resumen OV'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)	
END CHOOSE

end event

type ddlb_1 from dropdownlistbox within w_al507_despachos
integer x = 233
integer y = 28
integer width = 1088
integer height = 400
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"OV por Cliente Pendiente","OV por Producto Pendiente","OV por Cliente","OV por Producto"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;String ls_colname
ls_colname = ddlb_1.Text(index)
ii_opcion = index

IF index < 0 then return
is_flag[1] = '1'

CHOOSE CASE index
	CASE 1 
		idw_1.Dataobject = "d_ov_cliente_det_tbl"
		SetNull(is_flag[2])
	CASE 2 
		idw_1.Dataobject = "d_ov_producto_det_tbl"
		SetNull(is_flag[2])
	CASE 3 
		idw_1.Dataobject = "d_ov_cliente_det_tbl"
		is_flag[2] = '2'
	CASE 4 
		idw_1.Dataobject = "d_ov_producto_det_tbl"
		is_flag[2] = '2'
end CHOOSE

idw_1.SetTransObject(sqlca)



end event

type st_1 from statictext within w_al507_despachos
integer x = 37
integer y = 28
integer width = 187
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_al507_despachos
integer x = 1353
integer y = 28
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final
end event

type cb_reporte from commandbutton within w_al507_despachos
integer x = 2679
integer y = 28
integer width = 283
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

idw_1 = dw_report
ib_preview = false
parent.Event ue_preview()
idw_1.Visible = True

idw_1.Retrieve(is_doc_ov, is_flag, ld_desde, ld_hasta)

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text     = gs_user
idw_1.object.t_empresa.text  = gs_empresa
idw_1.object.t_objeto.text   = 'CM711'
idw_1.object.t_fechas.text = 'Del:  '+ String(ld_desde) + '  AL:  ' + String(ld_hasta)
idw_1.object.t_subtitulo.text = ddlb_1.text
end event

