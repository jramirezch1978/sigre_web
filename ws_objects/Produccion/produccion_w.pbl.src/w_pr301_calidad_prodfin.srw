$PBExportHeader$w_pr301_calidad_prodfin.srw
forward
global type w_pr301_calidad_prodfin from w_abc_mastdet
end type
type st_master from statictext within w_pr301_calidad_prodfin
end type
type st_especies from statictext within w_pr301_calidad_prodfin
end type
type st_detail from statictext within w_pr301_calidad_prodfin
end type
type p_arrow from picture within w_pr301_calidad_prodfin
end type
type dw_especies from u_dw_abc within w_pr301_calidad_prodfin
end type
end forward

global type w_pr301_calidad_prodfin from w_abc_mastdet
integer width = 3022
integer height = 1860
string title = "Calidad del Producto Terminado (PR301)"
string menuname = "m_mantto_smpl"
boolean maxbox = false
boolean resizable = false
boolean center = true
st_master st_master
st_especies st_especies
st_detail st_detail
p_arrow p_arrow
dw_especies dw_especies
end type
global w_pr301_calidad_prodfin w_pr301_calidad_prodfin

type variables
statictext 	ist_1
long 			il_st_color
end variables

forward prototypes
public subroutine of_carga_detalle ()
public subroutine of_add_detail (long al_row, integer ai_insert)
public subroutine of_add_prodfin (long al_row, integer ai_insert)
end prototypes

public subroutine of_carga_detalle ();
end subroutine

public subroutine of_add_detail (long al_row, integer ai_insert);long ll_master, ll_especies, ll_detail, ll_reco
string ls_sql, ls_cod_caldiad, ls_especie, ls_atributo, ls_descripcion, ls_unidad, ls_where 


ls_sql = "select atrib_codi as codigo, " &
		 + "atrib_desc as descripcion, " &
		 + "unid_desc as unidad " &
		 + "from vw_ap_atributo_unidad "

if ai_insert = 1 then
	ll_detail = dw_detail.rowcount() - 1
else
	ll_detail = dw_detail.rowcount() 
end if

if ll_detail >= 1 then
	ls_where = " where "
	for ll_reco = 1 to ll_detail step 1
		ls_where = ls_where + " atrib_codi <> '" + dw_detail.object.atributo[ll_reco] + "'"
		if ll_reco < ll_detail then
			ls_where = ls_where + " and "
		end if
	next
	ls_sql = ls_sql + ls_where
end if

f_lista_3ret(ls_sql, ls_atributo, ls_descripcion, ls_unidad, '2')
ll_master = dw_master.getrow()
ll_especies = dw_especies.getrow()
ls_cod_caldiad = dw_master.object.cod_calidad[ll_master]
ls_especie = dw_especies.object.especie[ll_especies]
dw_detail.object.atributo[al_row] = ls_atributo
dw_detail.object.descripcion[al_row] = ls_descripcion
dw_detail.object.desc_unidad[al_row] = ls_unidad
dw_detail.object.especie[al_row] = ls_especie
dw_detail.object.cod_calidad[al_row] = ls_cod_caldiad
end subroutine

public subroutine of_add_prodfin (long al_row, integer ai_insert);string ls_sql, ls_cod_calidad, ls_codart 
string ls_desc_prodfin, ls_where
long ll_master, ll_especies, ll_reco

ll_master = dw_master.getrow()
ls_cod_calidad = dw_master.object.cod_calidad[ll_master]

ls_sql = 'select cod_art as codigo, ' &
		 + 'desc_prodfin as descripcion ' &
		 +	'from tg_producto_final '

if ai_insert = 1 then
	ll_especies = dw_especies.rowcount() - 1
else
	ll_especies = dw_especies.rowcount()
end if

if ll_especies >= 1 then
	ls_where = ' where '
	for ll_reco = 1 to ll_especies
		ls_where = ls_where + "cod_art <> '" + trim(dw_especies.object.especie[ll_reco]) + "'"
		if ll_reco < ll_especies then
			ls_where = ls_where + ' and '
		end if
	next
	ls_where += " and flag_estado = '1'"
else
	ls_where = " where flag_estado = '1'"
end if
ls_sql = ls_sql + ls_where

f_lista(ls_sql, ls_codart, ls_desc_prodfin, '2')

if ls_codart <> '' then
	dw_especies.object.especie[al_row] = ls_codart
	dw_especies.object.desc_prodfin[al_row] = ls_desc_prodfin
	dw_especies.object.cod_calidad[al_row] = ls_cod_calidad
end if
end subroutine

on w_pr301_calidad_prodfin.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_master=create st_master
this.st_especies=create st_especies
this.st_detail=create st_detail
this.p_arrow=create p_arrow
this.dw_especies=create dw_especies
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_master
this.Control[iCurrent+2]=this.st_especies
this.Control[iCurrent+3]=this.st_detail
this.Control[iCurrent+4]=this.p_arrow
this.Control[iCurrent+5]=this.dw_especies
end on

on w_pr301_calidad_prodfin.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_master)
destroy(this.st_especies)
destroy(this.st_detail)
destroy(this.p_arrow)
destroy(this.dw_especies)
end on

event ue_dw_share;call super::ue_dw_share;string ls_cod_calidad, ls_especie
long ll_master, ll_especies

dw_master.SetRowFocusIndicator(p_arrow)
dw_especies.SetRowFocusIndicator(p_arrow)

dw_master.retrieve()
ll_master = dw_master.rowcount()
if ll_master <= 0 then
	return
end if

dw_master.scrolltorow(ll_master)
dw_master.setrow(ll_master)
dw_master.selectrow(ll_master, true)
ls_cod_calidad = dw_master.object.cod_calidad[ll_master]

dw_especies.retrieve(ls_cod_calidad)
ll_especies = dw_especies.rowcount()
if ll_especies <= 0 then return
dw_especies.setrow(1)
dw_especies.scrolltorow(1)
dw_especies.selectrow(1, true)
ls_especie = dw_especies.object.especie[1]
dw_detail.retrieve(ls_cod_calidad, ls_especie)


end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_master              		// asignar dw corriente
il_st_color = st_master.backcolor
ist_1 = st_master

dw_especies.settransobject(sqlca);
dw_especies.of_protect()
end event

event resize;//dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10

end event

event ue_modify;call super::ue_modify;dw_especies.of_protect()
end event

event ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_especies.of_Create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF
IF dw_especies.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_especies.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion de Especies", ls_msg, StopSign!)
	END IF
END IF
IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_especies.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_especies.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_especies.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	dw_especies.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
END IF

end event

event ue_query_retrieve;dw_master.Retrieve()
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_especies.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )

end event

type dw_master from w_abc_mastdet`dw_master within w_pr301_calidad_prodfin
integer x = 23
integer y = 92
integer width = 1335
integer height = 716
string dataobject = "d_tg_calidad_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear
ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle


end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer li_cod_calidad 

select seq_tg_calidad.nextval 
	into :li_cod_calidad 
	from dual;
	
if sqlca.sqlcode = 100 or isnull(li_cod_calidad) or li_cod_calidad = 0 then
	messagebox(parent.title, 'Error, no se puedo tener acceso al numerador de calidades', StopSign!)
end if

this.object.cod_calidad[al_row] = string(li_cod_calidad, '000')
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_master
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true

end event

event dw_master::rowfocuschanging;call super::rowfocuschanging;if dw_especies.ii_update = 1 then
	if messagebox(Parent.Title,'Cambiar de estándar de calidad provocará que se piertan ~r las especies relacioandas y sus rangos no guardados en ~r los atributos.    ¿Desea gaurdar los cambios?',Exclamation!,YesNo!,1) = 1 then
		parent.event ue_update()
	end if
end if
if dw_detail.ii_update = 1 then
	if messagebox(Parent.Title,'Cambiar de especie provocará que se piertan ~r los rangos no guardados en los atributos. ~r ¿Desea gaurdar los cambios?',Exclamation!,YesNo!,1) = 1 then
		parent.event ue_update()
	end if
end if
end event

event dw_master::ue_output;call super::ue_output;string ls_calidad

if al_row <= 0 then return

ls_calidad = this.object.cod_calidad[al_row]
dw_especies.retrieve(ls_calidad)
end event

type dw_detail from w_abc_mastdet`dw_detail within w_pr301_calidad_prodfin
integer x = 146
integer y = 940
integer width = 2679
integer height = 716
string dataobject = "d_tg_articulo_calidad_atrib_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
idw_det = dw_detail
end event

event dw_detail::ue_insert_pre;string ls_atributo

of_add_detail(al_row,1)
ii_update = 1

ls_atributo = trim(this.object.atributo[al_row])
if isnull(ls_atributo) or ls_atributo = '' then 
	this.selectrow(al_row, true)
	this.setrow(al_row)
	this.scrolltorow(al_row)
	this.event ue_delete()
end if
end event

event dw_detail::ue_insert;if dw_master.getrow() <= 0 then 
	messagebox(Parent.title,'Debe seleccionar una calidad',StopSign!)
	return -1
end if
if dw_especies.getrow() <= 0 then 
	messagebox(Parent.title,'Debe seleccionar una especie',StopSign!)
	return -1
end if
//IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
//	IF idw_mst.il_row = 0 THEN
//		MessageBox("Error", "No ha seleccionado registro Maestro")
//		RETURN - 1
//	END IF
//END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row

end event

event dw_detail::doubleclicked;call super::doubleclicked;if dwo.name = 'atributo' and ii_protect = 0 then of_add_detail(this.getrow(), 0)
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_detail
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true

end event

event dw_detail::itemchanged;call super::itemchanged;long ll_row
string ls_atributo, ls_descripcion, ls_desc_unidad

accepttext()

ll_row = this.getrow()
ls_atributo = this.object.atributo[ll_row]
declare usp_ap_atributo_busca procedure for
	usp_ap_atributo_busca(:ls_atributo);
execute usp_ap_atributo_busca;
fetch usp_ap_atributo_busca into :ls_atributo, :ls_descripcion, :ls_desc_unidad;
close usp_ap_atributo_busca;

this.object.atributo[ll_row] = ls_atributo
this.object.descripcion[ll_row] = ls_descripcion
this.object.desc_unidad[ll_row] = ls_desc_unidad

if isnull(ls_atributo) or trim(ls_atributo) = '' then messagebox(Parent.title,'No se ha encontrado el atributo',StopSign!)
return 2
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

type st_master from statictext within w_pr301_calidad_prodfin
integer x = 27
integer y = 12
integer width = 1330
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Definiciones de calidad"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_especies from statictext within w_pr301_calidad_prodfin
integer x = 1385
integer y = 16
integer width = 1563
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Articulos asociadas a la calidad"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_detail from statictext within w_pr301_calidad_prodfin
integer x = 18
integer y = 864
integer width = 2807
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Atributos de calidad"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type p_arrow from picture within w_pr301_calidad_prodfin
boolean visible = false
integer x = 18
integer y = 1008
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "Custom035!"
boolean focusrectangle = false
end type

type dw_especies from u_dw_abc within w_pr301_calidad_prodfin
event ue_display ( string as_columna,  long al_row )
integer x = 1390
integer y = 92
integer width = 1563
integer height = 716
string dataobject = "d_tg_calidad_prodfin_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "ESPECIE"
		of_add_prodfin(al_row,0)
		ii_update = 1
end choose
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event ue_insert_pre;string ls_especie
of_add_prodfin(al_row, 1)
ii_update = 1
ls_especie = trim(this.object.especie[al_row])
if isnull(ls_especie) or ls_especie = '' then 
	this.SelectRow(0, false)
	this.selectRow(al_row, true)
	this.setrow(al_row)
	this.scrolltorow(al_row)
	this.event ue_delete()
end if
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_especies
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true

end event

event ue_insert;if dw_master.getrow() <= 0 then 
	messagebox(Parent.title,'Debe seleccionar una calidad',StopSign!)
	return -1
end if

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF


end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event rowfocuschanging;call super::rowfocuschanging;if dw_detail.ii_update = 1 then
	if messagebox(Parent.Title,'Cambiar de especie provocará que se piertan ~r los rangos no guardados en los atributos. ~r ¿Desea gaurdar los cambios?',Exclamation!,YesNo!,1) = 1 then
		parent.event ue_update()
	end if
end if
end event

event itemchanged;call super::itemchanged;if dwo.name = 'especie' then
	long ll_row
	string ls_especie, ls_descr_especie
	accepttext()
	ll_row = this.getrow()
	ls_especie = this.object.especie[ll_row]
	declare usp_ap_especie_busca procedure for 
		usp_ap_especie_busca(:ls_especie);
	execute usp_ap_especie_busca;
	fetch usp_ap_especie_busca into :ls_especie, :ls_descr_especie;
	close usp_ap_especie_busca;
	this.object.especie[ll_row] = ls_especie
	this.object.descr_especie[ll_row] = ls_descr_especie
	if isnull(ls_especie) or trim(ls_especie) = '' then messagebox(Parent.title,'Especie no encontrada',StopSign!)
	return 2
end if
end event

event ue_output;call super::ue_output;string ls_calidad, ls_especie

if al_row <= 0 then
	return
end if

ls_calidad = this.object.cod_calidad[al_row]
ls_especie = this.object.especie[al_row]

dw_detail.retrieve(ls_calidad, ls_especie)
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event itemerror;call super::itemerror;return 1
end event

