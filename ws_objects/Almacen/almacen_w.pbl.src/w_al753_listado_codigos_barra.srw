$PBExportHeader$w_al753_listado_codigos_barra.srw
forward
global type w_al753_listado_codigos_barra from w_report_smpl
end type
type cb_1 from commandbutton within w_al753_listado_codigos_barra
end type
type sle_almacen from singlelineedit within w_al753_listado_codigos_barra
end type
type sle_descrip from singlelineedit within w_al753_listado_codigos_barra
end type
type st_2 from statictext within w_al753_listado_codigos_barra
end type
type cbx_almacen from checkbox within w_al753_listado_codigos_barra
end type
type hpb_1 from hprogressbar within w_al753_listado_codigos_barra
end type
type cbx_articulos from checkbox within w_al753_listado_codigos_barra
end type
type cb_articulos from commandbutton within w_al753_listado_codigos_barra
end type
type st_1 from statictext within w_al753_listado_codigos_barra
end type
type em_copias from editmask within w_al753_listado_codigos_barra
end type
type gb_1 from groupbox within w_al753_listado_codigos_barra
end type
end forward

global type w_al753_listado_codigos_barra from w_report_smpl
integer width = 3890
integer height = 1740
string title = "[AL753] Listado de Codigos de Barra"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
cbx_almacen cbx_almacen
hpb_1 hpb_1
cbx_articulos cbx_articulos
cb_articulos cb_articulos
st_1 st_1
em_copias em_copias
gb_1 gb_1
end type
global w_al753_listado_codigos_barra w_al753_listado_codigos_barra

type variables
string is_clase, is_almacen
integer ii_opc2, ii_opc1
date id_fecha1, id_fecha2
end variables

forward prototypes
public subroutine of_procesar ()
end prototypes

public subroutine of_procesar ();Long 		ll_row, ll_nro_am
String 	ls_org_am
Decimal	ldc_precio_real

try 
	hpb_1.visible = true

	for ll_row = 1 to dw_Report.RowCount()
		ls_org_am 			= dw_report.object.org_am 						[ll_row]
		ll_nro_am 			= Long(dw_report.object.nro_am				[ll_row])
		ldc_precio_real 	= Dec(dw_report.object.precio_unit_real	[ll_row])
		
		update articulo_mov am
			set am.precio_unit = :ldc_precio_real
		where cod_origen 	= :ls_org_am
		  and nro_mov		= :ll_nro_am;
		
		if gnvo_app.of_existserror( SQLCA, "update ARTICULO_MOV") then 
			ROLLBACK;
			return
		end if
		
		hpb_1.Position = ll_row / dw_report.RowCount() * 100
		
	next
	
	commit;


catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMessage())
finally
	hpb_1.visible = false
end try


end subroutine

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al753_listado_codigos_barra.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.cbx_almacen=create cbx_almacen
this.hpb_1=create hpb_1
this.cbx_articulos=create cbx_articulos
this.cb_articulos=create cb_articulos
this.st_1=create st_1
this.em_copias=create em_copias
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_almacen
this.Control[iCurrent+3]=this.sle_descrip
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cbx_almacen
this.Control[iCurrent+6]=this.hpb_1
this.Control[iCurrent+7]=this.cbx_articulos
this.Control[iCurrent+8]=this.cb_articulos
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.em_copias
this.Control[iCurrent+11]=this.gb_1
end on

on w_al753_listado_codigos_barra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.cbx_almacen)
destroy(this.hpb_1)
destroy(this.cbx_articulos)
destroy(this.cb_articulos)
destroy(this.st_1)
destroy(this.em_copias)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_almacen
Decimal	ldc_nro_copias

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	
	if trim(sle_almacen.text) = '' then
		MessageBox('Error', 'Debe Seleccionar un almacen primero, por favor verifique!', StopSign!)
		sle_almacen.setfocus()
		return
	end if
	
	ls_almacen = trim(sle_almacen.text) + '%'
	
end if

if cbx_articulos.checked then
	
	//Inserción de todos los articulos
	Insert Into tt_art(cod_art)  
	select distinct am.cod_art
	  from vale_mov vm,
	  		 articulo_mov am
	 where vm.nro_Vale = am.nro_Vale
	   and vm.flag_estado <> '0'
		and am.flag_estado <> '0'
		and vm.tipo_mov like 'I%'
		and vm.almacen like :ls_almacen;
	
	if gnvo_app.of_existsError(SQLCA) then
		rollback;
		return 
	end if	
end if

ldc_nro_copias = Dec(em_copias.text)

if ldc_nro_copias <= 0 then
	rollback;
	gnvo_app.of_message_error("Debe seleccionar un numero mayor que cero, por favor corrija")
	em_copias.setFocus()
	return
end if

gnvo_app.almacen.of_rpt_codigo_barras(dw_report, hpb_1, ls_almacen, ldc_nro_copias)

dw_report.object.DataWindow.print.Orientation = 2
end event

event ue_open_pre;call super::ue_open_pre;Decimal ldc_cantidad

try 
	dw_report.Object.DataWindow.Print.Orientation = 1

	ldc_cantidad = gnvo_app.of_get_parametro_dec("NRO_COPIAS_CODIGO_BARRAS", 3.0)
	
	em_copias.text = string(ldc_cantidad)
	
catch ( Exception ex)
	
	gnvo_app.of_catch_exception(ex, "Error en evento uo_open_pre")
	
end try

end event

type dw_report from w_report_smpl`dw_report within w_al753_listado_codigos_barra
integer x = 0
integer y = 304
integer width = 3753
integer height = 988
string dataobject = "d_rpt_codigos_barra_lbl"
end type

type cb_1 from commandbutton within w_al753_listado_codigos_barra
integer x = 2697
integer y = 152
integer width = 471
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Genera Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type sle_almacen from singlelineedit within w_al753_listado_codigos_barra
event dobleclick pbm_lbuttondblclk
integer x = 279
integer y = 64
integer width = 224
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al753_listado_codigos_barra
integer x = 512
integer y = 68
integer width = 1157
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_al753_listado_codigos_barra
integer x = 18
integer y = 80
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen :"
boolean focusrectangle = false
end type

type cbx_almacen from checkbox within w_al753_listado_codigos_barra
integer x = 1687
integer y = 72
integer width = 256
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type hpb_1 from hprogressbar within w_al753_listado_codigos_barra
integer x = 2702
integer y = 52
integer width = 462
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cbx_articulos from checkbox within w_al753_listado_codigos_barra
integer x = 46
integer y = 176
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los articulos"
boolean righttoleft = true
end type

event clicked;if this.checked then
	cb_articulos.enabled = false
else
	cb_articulos.enabled = true
end if
end event

type cb_articulos from commandbutton within w_al753_listado_codigos_barra
integer x = 690
integer y = 164
integer width = 549
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccionar"
end type

event clicked;String	ls_almacen
str_parametros lstr_param 

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	
	if trim(sle_almacen.text) = '' then
		MessageBox('Error', 'Debe Seleccionar un almacen primero, por favor verifique!', StopSign!)
		sle_almacen.setfocus()
		return
	end if
	
	ls_almacen = trim(sle_almacen.text) + '%'
	
end if

delete tt_art ;
commit;

lstr_param.dw1		= 'd_lista_articulos_almacen_tbl'
lstr_param.titulo	= 'Listado de ARTICULOS'
lstr_param.opcion   = 1
lstr_param.tipo		= '1S'
lstr_param.string1	= ls_almacen


OpenWithParm( w_abc_seleccion_lista_search, lstr_param)
end event

type st_1 from statictext within w_al753_listado_codigos_barra
integer x = 1961
integer y = 80
integer width = 311
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro Copias :"
boolean focusrectangle = false
end type

type em_copias from editmask within w_al753_listado_codigos_barra
integer x = 2286
integer y = 60
integer width = 343
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
boolean spin = true
double increment = 1
string minmax = "1~~999"
end type

type gb_1 from groupbox within w_al753_listado_codigos_barra
integer width = 3200
integer height = 284
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Datos para Reporte"
end type

