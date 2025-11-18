$PBExportHeader$w_al025_modificar_almacen_ov.srw
forward
global type w_al025_modificar_almacen_ov from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_al025_modificar_almacen_ov
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al025_modificar_almacen_ov
end type
type sle_almacen from singlelineedit within w_al025_modificar_almacen_ov
end type
type sle_descrip from singlelineedit within w_al025_modificar_almacen_ov
end type
type st_2 from statictext within w_al025_modificar_almacen_ov
end type
type cbx_1 from checkbox within w_al025_modificar_almacen_ov
end type
type gb_fechas from groupbox within w_al025_modificar_almacen_ov
end type
type gb_1 from groupbox within w_al025_modificar_almacen_ov
end type
end forward

global type w_al025_modificar_almacen_ov from w_abc_master_smpl
integer width = 3621
integer height = 1600
string title = "[AL025] Modificar Datos en Orden de Venta"
string menuname = "m_mantenimiento_filter"
cb_1 cb_1
uo_fecha uo_fecha
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
cbx_1 cbx_1
gb_fechas gb_fechas
gb_1 gb_1
end type
global w_al025_modificar_almacen_ov w_al025_modificar_almacen_ov

on w_al025_modificar_almacen_ov.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_filter" then this.MenuID = create m_mantenimiento_filter
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.cbx_1=create cbx_1
this.gb_fechas=create gb_fechas
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.sle_descrip
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.gb_fechas
this.Control[iCurrent+8]=this.gb_1
end on

on w_al025_modificar_almacen_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.gb_fechas)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Date ld_fecha1, ld_fecha2
ii_lec_mst = 0

select trunc(min(fec_registro)), trunc(max(fec_registro))
	into :ld_Fecha1, :ld_Fecha2
from orden_Venta;

if SQLCA.SQLCode = 100 then
	ld_Fecha1 = Date(gnvo_app.of_fecha_Actual())
	ld_Fecha2 = Date(gnvo_app.of_fecha_Actual())
end if

uo_fecha.of_set_fecha( ld_fecha1, ld_fecha2)
end event

event ue_retrieve;call super::ue_retrieve;Date	ld_fecha1, ld_fecha2
String	ls_almacen

ld_Fecha1 = uo_fecha.of_get_fecha1( )
ld_Fecha2 = uo_fecha.of_get_fecha2( )

if cbx_1.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Error', 'Debe ingresar un almacen valido', StopSign!)
		sle_almacen.setFocus()
		return
	end if
	
	ls_almacen = sle_almacen.text
end if

dw_master.Retrieve(ld_fecha1, ld_fecha2, ls_almacen)
end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return



ib_update_check = true


end event

type dw_master from w_abc_master_smpl`dw_master within w_al025_modificar_almacen_ov
integer y = 320
integer width = 2725
integer height = 1024
string dataobject = "d_abc_ordenes_venta_tbl"
end type

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_data2, ls_factor_saldo_total, ls_mensaje
Long		ll_count

this.AcceptText()

choose case lower(as_columna)
		
	case "almacen"
		select count(*)
			into :ll_count
		from almacen_user
		where cod_usr = :gs_user;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			gnvo_app.of_mensaje_error('Error al consultar la tabla ALMACEN_USER. Mensaje: ' + ls_mensaje)
			return
		end if
		
		if ll_count = 0 then
			ls_sql = "SELECT almacen AS CODIGO_almacen, " &
					  + "desc_almacen AS descripcion_almacen, " &
					  + "flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen " &
					  + "where cod_origen = '" + gs_origen + "' " &
					  + "and flag_estado = '1' " &
					  + "and flag_tipo_almacen <> 'O' " &
					  + "order by almacen " 
		else
			ls_sql = "SELECT al.almacen AS CODIGO_almacen, " &
					  + "al.desc_almacen AS descripcion_almacen, " &
					  + "al.flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen al, " &
					  + "     almacen_user au " &
					  + "where al.almacen = au.almacen " &
					  + "  and au.cod_usr = '" + gs_user + "'" &
					  + "  and al.cod_origen = '" + gs_origen + "' " &
					  + "  and al.flag_estado = '1' " &
					  + "  and al.flag_tipo_almacen <> 'O' " &
					  + "order by al.almacen " 
		end if			

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			this.object.almacen				[al_row] = ls_codigo
			this.object.desc_almacen		[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return


end choose

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type cb_1 from commandbutton within w_al025_modificar_almacen_ov
integer x = 2469
integer y = 32
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

type uo_fecha from u_ingreso_rango_fechas_v within w_al025_modificar_almacen_ov
event destroy ( )
integer x = 18
integer y = 60
integer taborder = 40
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type sle_almacen from singlelineedit within w_al025_modificar_almacen_ov
event dobleclick pbm_lbuttondblclk
integer x = 1015
integer y = 68
integer width = 224
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
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

type sle_descrip from singlelineedit within w_al025_modificar_almacen_ov
integer x = 1243
integer y = 68
integer width = 1157
integer height = 88
integer taborder = 80
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

type st_2 from statictext within w_al025_modificar_almacen_ov
integer x = 709
integer y = 80
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_al025_modificar_almacen_ov
integer x = 722
integer y = 184
integer width = 951
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los almacenes"
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type gb_fechas from groupbox within w_al025_modificar_almacen_ov
integer width = 667
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_al025_modificar_almacen_ov
integer x = 677
integer width = 1746
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

