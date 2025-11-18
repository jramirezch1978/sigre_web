$PBExportHeader$w_ap308_calidad_matprim.srw
forward
global type w_ap308_calidad_matprim from w_abc_mastdet
end type
type st_master from statictext within w_ap308_calidad_matprim
end type
type st_especies from statictext within w_ap308_calidad_matprim
end type
type st_detail from statictext within w_ap308_calidad_matprim
end type
type dw_especies from u_dw_abc within w_ap308_calidad_matprim
end type
type p_arrow from picture within w_ap308_calidad_matprim
end type
end forward

global type w_ap308_calidad_matprim from w_abc_mastdet
integer width = 2921
integer height = 1776
string title = "Calidad de Materia Prima (AP308)"
string menuname = "m_mantto_smpl"
boolean maxbox = false
boolean resizable = false
boolean center = true
st_master st_master
st_especies st_especies
st_detail st_detail
dw_especies dw_especies
p_arrow p_arrow
end type
global w_ap308_calidad_matprim w_ap308_calidad_matprim

type variables
StaticText	ist_1
long			il_st_color

end variables

forward prototypes
public subroutine of_carga_detalle ()
public subroutine of_add_especies (long al_row, integer ai_insert)
public subroutine of_add_detail (long al_row, integer ai_insert)
end prototypes

public subroutine of_carga_detalle ();
end subroutine

public subroutine of_add_especies (long al_row, integer ai_insert);string ls_sql, ls_cod_calidad, ls_especie, ls_descr_especie, ls_where
long ll_master, ll_especies, ll_reco

ll_master = dw_master.getrow()
ls_cod_calidad = dw_master.object.cod_calidad[ll_master]

ls_sql = 'select cod_art as codigo, ' &
		 + 'descr_especie as nombre ' &
		 +	'from tg_especies e'

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
	ls_where += " and cod_art is not null"
else
	ls_where = " where cod_art is not null"
end if
ls_sql = ls_sql + ls_where

f_lista(ls_sql, ls_especie, ls_descr_especie, '2')

if ls_especie <> '' then
	dw_especies.object.especie[al_row] = ls_especie
	dw_especies.object.descr_especie[al_row] = ls_descr_especie
	dw_especies.object.cod_calidad[al_row] = ls_cod_calidad
end if
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

on w_ap308_calidad_matprim.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_master=create st_master
this.st_especies=create st_especies
this.st_detail=create st_detail
this.dw_especies=create dw_especies
this.p_arrow=create p_arrow
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_master
this.Control[iCurrent+2]=this.st_especies
this.Control[iCurrent+3]=this.st_detail
this.Control[iCurrent+4]=this.dw_especies
this.Control[iCurrent+5]=this.p_arrow
end on

on w_ap308_calidad_matprim.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_master)
destroy(this.st_especies)
destroy(this.st_detail)
destroy(this.dw_especies)
destroy(this.p_arrow)
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

dw_master.setrow(ll_master)
f_select_current_row(dw_master)

ls_cod_calidad = dw_master.object.cod_calidad[ll_master]

dw_especies.retrieve(ls_cod_calidad)
ll_especies = dw_especies.rowcount()
if ll_especies <= 0 then return

dw_especies.setrow(1)
f_select_current_row(dw_especies)

ls_especie = dw_especies.object.especie[1]
dw_detail.retrieve(ls_cod_calidad, ls_especie)

dw_master.SetFocus()
end event

event ue_open_pre;call super::ue_open_pre;dw_especies.settransobject(sqlca);
dw_especies.of_protect()

idw_1 = dw_master
ist_1  = st_master
il_st_color = ist_1.backcolor

idw_1.SetFocus()
end event

event resize;//dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height  = newheight  - dw_detail.x - 10

st_detail.X = dw_detail.X
st_detail.width = dw_detail.width

dw_especies.width  = newwidth  - dw_especies.x - 10

st_especies.X 		= dw_especies.X
st_especies.width = dw_especies.width

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
	dw_especies.of_create_log()
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
	
	dw_master.REsetUpdate()
	dw_detail.REsetUpdate()
	dw_especies.REsetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
END IF

end event

type dw_master from w_abc_mastdet`dw_master within w_ap308_calidad_matprim
integer x = 0
integer y = 80
integer width = 1280
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

event dw_master::ue_output;call super::ue_output;long ll_especies 
string ls_cod_calidad, ls_especie

ls_cod_calidad = this.object.cod_calidad[this.getrow()]
dw_especies.reset()
dw_especies.retrieve(ls_cod_calidad)
dw_detail.reset()
ll_especies = dw_especies.rowcount()
if ll_especies <= 0 then return
dw_especies.setrow(1)
dw_especies.scrolltorow(1)
dw_especies.selectrow(1, true)
ls_especie = dw_especies.object.especie[1]
dw_detail.retrieve(ls_cod_calidad, ls_especie)

end event

type dw_detail from w_abc_mastdet`dw_detail within w_ap308_calidad_matprim
integer x = 0
integer y = 876
integer width = 2606
integer height = 708
string dataobject = "d_tg_esp_cal_atrib_tbl"
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

type st_master from statictext within w_ap308_calidad_matprim
integer width = 1280
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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

type st_especies from statictext within w_ap308_calidad_matprim
integer x = 1289
integer width = 1605
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Especies asociadas a la calidad"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_detail from statictext within w_ap308_calidad_matprim
integer y = 796
integer width = 2606
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Atributos de calidad"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_especies from u_dw_abc within w_ap308_calidad_matprim
event ue_display ( string as_columna,  long al_row )
integer x = 1289
integer y = 80
integer width = 1605
integer height = 716
string dataobject = "d_tg_calidad_especie_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "ESPECIE"
		of_add_especies(al_row,0)
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
of_add_especies(al_row, 1)
ii_update = 1
ls_especie = trim(this.object.especie[al_row])
if isnull(ls_especie) or ls_especie = '' then 
	this.selectrow(al_row, true)
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

event ue_output;call super::ue_output;long ll_especies, ll_master
string ls_cod_calidad, ls_especie

if al_row <= 0 then
	return
end if

ll_master = dw_master.getrow()
ll_especies = dw_especies.getrow()
if ll_master <= 0 or ll_especies <= 0 then return
ls_cod_calidad = dw_master.object.cod_calidad[ll_master]
ls_especie = dw_especies.object.especie[ll_especies]

dw_detail.retrieve(ls_cod_calidad, ls_especie)
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

type p_arrow from picture within w_ap308_calidad_matprim
boolean visible = false
integer y = 1036
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "Custom035!"
boolean focusrectangle = false
end type

