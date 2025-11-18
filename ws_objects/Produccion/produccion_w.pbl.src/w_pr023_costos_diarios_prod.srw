$PBExportHeader$w_pr023_costos_diarios_prod.srw
forward
global type w_pr023_costos_diarios_prod from w_abc_master_lstmst
end type
type st_1 from statictext within w_pr023_costos_diarios_prod
end type
type cbx_1 from checkbox within w_pr023_costos_diarios_prod
end type
type uo_fecha from u_ingreso_rango_fechas within w_pr023_costos_diarios_prod
end type
type cbx_2 from checkbox within w_pr023_costos_diarios_prod
end type
type sle_cod_art from singlelineedit within w_pr023_costos_diarios_prod
end type
type sle_desc_art from singlelineedit within w_pr023_costos_diarios_prod
end type
type cb_1 from commandbutton within w_pr023_costos_diarios_prod
end type
type sle_almacen from singlelineedit within w_pr023_costos_diarios_prod
end type
type sle_descrip from singlelineedit within w_pr023_costos_diarios_prod
end type
type cbx_3 from checkbox within w_pr023_costos_diarios_prod
end type
end forward

global type w_pr023_costos_diarios_prod from w_abc_master_lstmst
integer width = 4073
integer height = 2360
string title = "Costos de Produccion(PR023)"
string menuname = "m_mantto_consulta"
event ue_refrescar ( )
st_1 st_1
cbx_1 cbx_1
uo_fecha uo_fecha
cbx_2 cbx_2
sle_cod_art sle_cod_art
sle_desc_art sle_desc_art
cb_1 cb_1
sle_almacen sle_almacen
sle_descrip sle_descrip
cbx_3 cbx_3
end type
global w_pr023_costos_diarios_prod w_pr023_costos_diarios_prod

type variables
string is_mon_costo, is_almacen_mp, is_desc_almacen_mp
end variables

event ue_refrescar();date 		ld_fecha1, ld_Fecha2
string 	ls_cod_art, ls_almacen

if cbx_1.checked then
	// Si es un filtrado por fechas, debo cambiar los datawindows
	dw_lista.dataobject = 'd_lst_prod_cost_diarios_x_fechas'
	dw_master.dataobject = 'd_abc_prod_cdiarios_x_fechas'
	ld_fecha1 = uo_fecha.of_get_fecha1( )
	ld_fecha2 = uo_fecha.of_get_fecha2( )
else
	// Por el contrario simplemente asigno los que le pertenecen
	dw_lista.dataobject = 'd_abc_prod_costos_diarios_1'
	dw_master.dataobject = 'd_abc_prod_costos_diarios_2'
end if

if cbx_2.checked then
	if sle_cod_art.text = '' then
		MessageBox('Aviso', 'Debe especificar un artículo')
		return
	end if
	ls_cod_art = trim(sle_cod_art.text) + '%'
else
	ls_cod_art = '%%'
end if

if cbx_3.checked then
	if sle_almacen.text = '' then
		MessageBox('Aviso', 'Debe especificar un almacén')
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
else
	ls_almacen = '%%'
end if

dw_lista.SetTransObject(sqlca)
dw_master.SetTransObject(SQLCA)

idw_1 = dw_master
dw_lista.of_share_lista(dw_master)

if cbx_1.checked then
	dw_master.Retrieve(ls_cod_art, ls_almacen, ld_fecha1, ld_fecha2)
else
	dw_master.Retrieve(ls_cod_art, ls_almacen)	
end if

dw_lista.of_sort_lista()

idw_1.ii_protect = 0
idw_1.of_protect()

//is_tabla = dw_master.Object.Datawindow.Table.UpdateTable
end event

on w_pr023_costos_diarios_prod.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_1=create st_1
this.cbx_1=create cbx_1
this.uo_fecha=create uo_fecha
this.cbx_2=create cbx_2
this.sle_cod_art=create sle_cod_art
this.sle_desc_art=create sle_desc_art
this.cb_1=create cb_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.cbx_3=create cbx_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.cbx_2
this.Control[iCurrent+5]=this.sle_cod_art
this.Control[iCurrent+6]=this.sle_desc_art
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.sle_almacen
this.Control[iCurrent+9]=this.sle_descrip
this.Control[iCurrent+10]=this.cbx_3
end on

on w_pr023_costos_diarios_prod.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.uo_fecha)
destroy(this.cbx_2)
destroy(this.sle_cod_art)
destroy(this.sle_desc_art)
destroy(this.cb_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.cbx_3)
end on

event ue_open_pre;ii_lec_mst = 0    //deshabilita la lectura inicial del dw_master

select mon_costo
	into :is_mon_costo
from prod_param
where reckey = '1';

if SQLCA.SQLCode= 100 then
	MessageBox('Error', 'Debe ingresar parametros en prod_param, por favor verifique')
	return
end if

if IsNull(is_mon_costo) or is_mon_costo = '' then
	MessageBox('Error', 'Debe ingresar una moneda para el costo de produccion por defecto')
	return
end if

select almacen, desc_almacen
  into :is_almacen_mp, :is_desc_almacen_mp
  from almacen
 where flag_tipo_almacen = 'P'
   and flag_estado = '1'
	and cod_origen = :gs_origen;

this.event ue_refrescar()



end event

event ue_update;// 
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
end if

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
//	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then return

ib_update_check = true
end event

type dw_master from w_abc_master_lstmst`dw_master within w_pr023_costos_diarios_prod
event ue_display ( string as_columna,  long al_row )
integer x = 1147
integer y = 532
integer width = 2674
integer height = 1060
string dataobject = "d_abc_prod_costos_diarios_2"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_null

this.AcceptText()
SetNull(ls_null)

choose case lower(as_columna)
		
	case "almacen"
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen " &
				  + "where cod_origen = '" + gs_origen + "' " &
				  + "and flag_estado = '1' " &
  				  + "order by almacen " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.almacen		[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_art"
		
		ls_sql = "SELECT cod_art AS CODIGO_ARTICULO, " &
				  + "desc_art AS descripcion_articulo " &
				  + "FROM articulo " &
				  + "where flag_estado = '1' " &
  				  + "order by cod_art " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_art		[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		case "moneda"
		
		ls_sql = "SELECT cod_moneda AS codigo_moneda, " &
				  + "descripcion AS descripcion " &
				  + "FROM moneda " &
				  + "where flag_estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.moneda		[al_row] = ls_codigo
			this.object.desc_moneda	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		case "cod_plantilla"
		
		ls_sql = "SELECT cod_plantilla AS cod_plantilla, " &
				  + "observaciones AS descripcion " &
				  + "FROM plantilla_costo " &
				  + "where flag_estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_plantilla		[al_row] = ls_codigo
			this.object.observaciones		[al_row] = ls_data
			this.ii_update = 1
		end if

end choose

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
//str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
Date 		ld_fecha
Integer	li_ano, li_semana
Long		ll_count
Boolean	lb_ret

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)

	case "COD_ART"
		
		ls_codigo = this.object.cod_art[row]

		SetNull(ls_data)
		select desc_art
			into :ls_data
		from articulo
		where cod_art = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Produccion', "CODIGO DE ARTICULO NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_art [row] = ls_codigo
			this.object.desc_art[row] = ls_codigo
			return 1
		end if

		this.object.desc_art[row] = ls_data
		
	
	case "ALMACEN"
		
		ls_codigo = this.object.almacen[row]

		SetNull(ls_data)
		select desc_almacen
			into :ls_data
		from almacen
		where almacen = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Produccion', "CODIGO DE almacen NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.almacen [row] = ls_codigo
			this.object.desc_almacen[row] = ls_codigo
			return 1
		end if

		this.object.desc_almacen[row] = ls_data
		
		
	case "MONEDA"
		
		ls_codigo = this.object.moneda[row]

		SetNull(ls_data)
		select descripcion
			into :ls_data
		from moneda
		where cod_moneda = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('PRODUCCIÓN', "CODIGO DE MONEDA NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.moneda [row] = ls_codigo
			this.object.desc_moneda[row] = ls_codigo
			return 1
		end if

		this.object.desc_moneda[row] = ls_data
		
		case "cod_plantilla"
		
		ls_codigo = this.object.moneda[row]

		SetNull(ls_data)
		select observaciones
			into :ls_data
		from plantilla_costo
		where cod_plantilla = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('PRODUCCIÓN', "CODIGO DE Plantilla NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_plantilla [row] = ls_codigo
			this.object.observaciones[row] = ls_codigo
			return 1
		end if

		this.object.observaciones[row] = ls_data
		
end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1          // columnas de lectrua de este dw
ii_ck[2] = 2          // columnas de lectrua de este dw
ii_ck[4] = 4          // columnas de lectrua de este dw

ii_dk[1] = 1           // columnas que se pasan al detalle
ii_dk[2] = 2           // columnas que se pasan al detalle
ii_dk[4] = 4           // columnas que se pasan al ldetalle

end event

event dw_master::buttonclicked;call super::buttonclicked;this.AcceptText()

Long  	ll_row
Decimal	ldc_costo

str_parametros sl_param

choose case lower(dwo.name)
		
	case "b_costo_c"
		
		ldc_costo = Dec(this.object.costo_contable[row])
		
		if ldc_costo = 0 or IsNull(ldc_costo) then
			MessageBox('Aviso', 'Debe ingresar previamente un costo antes de activar esta opción?')
			return
		end if
		
		if MessageBox('Aviso', 'Dese actualizar este costo contable a todos los registros??', &
			information!, YesNo!, 1) = 2 then return
		
		for ll_row = 1 to dw_master.RowCount()
			this.object.costo_contable[ll_row] = ldc_costo
			this.ii_update = 1
		next
		
		
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;Date		ld_fecha
String 	ls_almacen

ld_fecha	=	date(f_fecha_actual())	

THIS.OBJECT.moneda	[al_row] = is_mon_costo

if al_row = 1 then
	this.object.fecha		[al_row]  = ld_fecha
else
	this.object.fecha		[al_row]  = RelativeDate (date(this.object.fecha[al_row - 1]),1)
end if

this.object.almacen 			[al_row] = is_almacen_mp
this.object.desc_almacen	[al_row] = is_desc_almacen_mp

end event

type dw_lista from w_abc_master_lstmst`dw_lista within w_pr023_costos_diarios_prod
integer x = 5
integer y = 336
integer width = 1111
integer height = 1432
string dataobject = "d_abc_prod_costos_diarios_1"
end type

event dw_lista::constructor;call super::constructor;
ii_ck[1] = 1          // columnas de lectrua de este dw
ii_ck[2] = 2          // columnas de lectrua de este dw
ii_ck[4] = 4          // columnas de lectrua de este dw

ii_dk[1] = 1           // columnas que se pasan al detalle
ii_dk[2] = 2           // columnas que se pasan al detalle
ii_dk[4] = 4           // columnas que se pasan al ldetalle


end event

event dw_lista::rowfocuschanged;call super::rowfocuschanged;this.Event ue_output(currentrow)
end event

type st_1 from statictext within w_pr023_costos_diarios_prod
integer x = 1303
integer y = 384
integer width = 1536
integer height = 88
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "COSTOS DIARIOS DE PRODUCCIÓN"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_pr023_costos_diarios_prod
integer x = 101
integer y = 20
integer width = 498
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtar por Fechas"
boolean checked = true
end type

type uo_fecha from u_ingreso_rango_fechas within w_pr023_costos_diarios_prod
integer x = 622
integer y = 16
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor; date ld_fecha1, ld_fecha2
 
 of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(date('01/01/1900'), date('31/12/9999')) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 
 ld_fecha2 = Date(f_fecha_actual())
 ld_fecha1 = Date('01/' + string(ld_fecha2, 'mm/yyyy'))
 
 this.of_set_fecha( ld_fecha1, ld_fecha2)
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cbx_2 from checkbox within w_pr023_costos_diarios_prod
integer x = 101
integer y = 116
integer width = 498
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtar por Artículo"
end type

type sle_cod_art from singlelineedit within w_pr023_costos_diarios_prod
event dobleclick pbm_lbuttondblclk
integer x = 622
integer y = 116
integer width = 352
integer height = 80
integer taborder = 100
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

ls_sql = "SELECT distinct a.cod_art AS CODIGO_artículo, " &
	  	 + "a.DESC_art AS DESCRIPCION_artículo, " &
		 + "a.und as unidad_articulo " &
	    + "FROM articulo a, " &
		 + "prod_costos_diarios b " &
		 + "where a.cod_art = b.cod_art " & 
		 + "and a.flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_desc_art.text 	= ls_data
end if

end event

event modified;String 	ls_cod_art, ls_desc

ls_cod_art = sle_cod_art.text
if ls_cod_art = '' or IsNull(ls_cod_art) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de artículo')
	return
end if

SELECT desc_art
	INTO :ls_desc
FROM articulo 
where cod_art = :ls_cod_art
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Artículo no existe o no esta activo')
	return
end if

sle_desc_art.text = ls_desc


end event

type sle_desc_art from singlelineedit within w_pr023_costos_diarios_prod
integer x = 987
integer y = 116
integer width = 1211
integer height = 80
integer taborder = 110
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

type cb_1 from commandbutton within w_pr023_costos_diarios_prod
integer x = 2766
integer y = 28
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refrescar"
end type

event clicked;parent.event ue_refrescar()
end event

type sle_almacen from singlelineedit within w_pr023_costos_diarios_prod
event dobleclick pbm_lbuttondblclk
integer x = 622
integer y = 204
integer width = 352
integer height = 88
integer taborder = 100
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

ls_sql = "SELECT distinct a.almacen AS CODIGO_almacen, " &
	  	 + "a.DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen a, " &
		 + "prod_costos_diarios b " &
		 + "where a.almacen = b.almacen " &
		 + "and a.flag_estado = '1'"
				 
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
Parent.event dynamic ue_seleccionar()

end event

type sle_descrip from singlelineedit within w_pr023_costos_diarios_prod
integer x = 987
integer y = 204
integer width = 1211
integer height = 88
integer taborder = 110
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

type cbx_3 from checkbox within w_pr023_costos_diarios_prod
integer x = 105
integer y = 204
integer width = 498
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtar por Almacén"
end type

