$PBExportHeader$w_al502_movimiento_articulo.srw
$PBExportComments$Consulta que muestra los movimientos de un articulo por almacen.
forward
global type w_al502_movimiento_articulo from w_report_smpl
end type
type st_1 from statictext within w_al502_movimiento_articulo
end type
type uo_1 from u_ingreso_rango_fechas within w_al502_movimiento_articulo
end type
type cb_3 from commandbutton within w_al502_movimiento_articulo
end type
type em_codigo from editmask within w_al502_movimiento_articulo
end type
type cb_4 from commandbutton within w_al502_movimiento_articulo
end type
type sle_nom from singlelineedit within w_al502_movimiento_articulo
end type
end forward

global type w_al502_movimiento_articulo from w_report_smpl
integer width = 3643
integer height = 1472
string title = "Consulta de movimientos  (AL502)"
string menuname = "m_impresion"
st_1 st_1
uo_1 uo_1
cb_3 cb_3
em_codigo em_codigo
cb_4 cb_4
sle_nom sle_nom
end type
global w_al502_movimiento_articulo w_al502_movimiento_articulo

type variables

end variables

on w_al502_movimiento_articulo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.uo_1=create uo_1
this.cb_3=create cb_3
this.em_codigo=create em_codigo
this.cb_4=create cb_4
this.sle_nom=create sle_nom
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.em_codigo
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.sle_nom
end on

on w_al502_movimiento_articulo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.em_codigo)
destroy(this.cb_4)
destroy(this.sle_nom)
end on

type dw_report from w_report_smpl`dw_report within w_al502_movimiento_articulo
integer x = 9
integer y = 224
integer width = 3538
integer height = 1020
string dataobject = "d_cns_mov_articulo_all_almacen"
end type

type st_1 from statictext within w_al502_movimiento_articulo
integer x = 55
integer y = 132
integer width = 233
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Articulo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_al502_movimiento_articulo
integer x = 41
integer y = 20
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

type cb_3 from commandbutton within w_al502_movimiento_articulo
integer x = 2706
integer y = 48
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

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

// Segun opcion procesa informacion

idw_1 = dw_report
ib_preview = false
parent.Event ue_preview()
idw_1.Visible = True

idw_1.SetTransObject(Sqlca)
idw_1.Retrieve(em_codigo.text, ld_desde, ld_hasta)

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_objeto.text = 'AL502'
idw_1.object.t_fecha.text = 'Desde: ' + String(ld_desde, 'dd/mm/yy') + ' Hasta: ' + String(ld_hasta, 'dd/mm/yy')

end event

type em_codigo from editmask within w_al502_movimiento_articulo
integer x = 293
integer y = 124
integer width = 338
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "XXXXXXXXXXXX"
end type

event modified;// Verifica que codigo exista
String ls_descri

Select nom_articulo into :ls_descri from articulo 
    where cod_art = :em_codigo.text;
if sqlca.sqlcode = 100 then
	Messagebox( "Atencion", "Codigo no existe")
	em_codigo.text = ''
	return
end if
sle_nom.text = ls_descri	 
end event

type cb_4 from commandbutton within w_al502_movimiento_articulo
integer x = 640
integer y = 124
integer width = 64
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_articulo lstr_articulo

lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )

if lstr_articulo.b_Return then

	em_codigo.text = lstr_articulo.cod_art
	sle_nom.text 	= lstr_articulo.desc_art

end if

end event

type sle_nom from singlelineedit within w_al502_movimiento_articulo
integer x = 736
integer y = 124
integer width = 1856
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

