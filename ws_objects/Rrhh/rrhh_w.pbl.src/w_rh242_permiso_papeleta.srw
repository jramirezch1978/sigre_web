$PBExportHeader$w_rh242_permiso_papeleta.srw
forward
global type w_rh242_permiso_papeleta from w_abc
end type
type tab_1 from tab within w_rh242_permiso_papeleta
end type
type tp_1 from userobject within tab_1
end type
type cb_1 from commandbutton within tp_1
end type
type dp_2 from datepicker within tp_1
end type
type st_2 from statictext within tp_1
end type
type dp_1 from datepicker within tp_1
end type
type dw_1 from u_dw_abc within tp_1
end type
type gb_1 from groupbox within tp_1
end type
type tp_1 from userobject within tab_1
cb_1 cb_1
dp_2 dp_2
st_2 st_2
dp_1 dp_1
dw_1 dw_1
gb_1 gb_1
end type
type tp_2 from userobject within tab_1
end type
type dw_2 from u_dw_abc within tp_2
end type
type tp_2 from userobject within tab_1
dw_2 dw_2
end type
type tab_1 from tab within w_rh242_permiso_papeleta
tp_1 tp_1
tp_2 tp_2
end type
end forward

global type w_rh242_permiso_papeleta from w_abc
integer y = 360
integer width = 2458
integer height = 1757
string title = "(RH242) Papeletas de Salida"
string menuname = "m_master_cl_anular"
tab_1 tab_1
end type
global w_rh242_permiso_papeleta w_rh242_permiso_papeleta

type variables
u_dw_abc idw_lis, idw_det
datetime idt_fecsys
end variables

forward prototypes
public function integer of_nro_registro (long al_row)
end prototypes

public function integer of_nro_registro (long al_row);//Numera documento
Long ll_ult_nro
string ls_mensaje, ls_nro, ls_tabla

ls_tabla = idw_det.Object.Datawindow.Table.UpdateTable
				 
if ls_tabla = '' or Isnull(ls_tabla) then
	 MessageBox('Error', 'No ha especificado una tabla a actualizar para el datawindows maestro, por favor verifique!')
	 return 0
end if
	 
Select ult_nro 
into :ll_ult_nro 
from num_tablas 
where origen = :gs_origen
and tabla = :ls_tabla for update;
	 
IF SQLCA.SQLCode = 100 then
	
	 ll_ult_nro = 1
	 
	 Insert into num_tablas ( origen, tabla, ult_nro)
						  values ( :gs_origen, :ls_tabla, 1);
	 
	 IF SQLCA.SQLCode < 0 then
		  ls_mensaje = SQLCA.SQLErrText
		  ROLLBACK;
		  MessageBox('Error al insertar registro en num_tablas', ls_mensaje)
		  return 0
	 end if
	 
end if                
	 
//Incrementa contador
Update num_tablas 
	set ult_nro = :ll_ult_nro + 1 
 where origen = :gs_origen
   and tabla = :ls_tabla;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error al actualizar num_tablas', ls_mensaje)
	return 0
end if
	 
idw_det.object.nro_papeleta[al_row] = gs_origen+right('00000000'+string(ll_ult_nro),8)
  
return 1
end function

on w_rh242_permiso_papeleta.create
int iCurrent
call super::create
if this.MenuName = "m_master_cl_anular" then this.MenuID = create m_master_cl_anular
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_rh242_permiso_papeleta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_lis = tab_1.tp_1.dw_1
idw_det = tab_1.tp_2.dw_2

tab_1.tp_2.dw_2.settransobject(sqlca)
tab_1.tp_1.dw_1.settransobject(sqlca)

m_master_cl_anular.m_file.m_basedatos.m_eliminar.enabled = false
m_master_cl_anular.m_file.m_basedatos.m_eliminar.toolbaritemvisible = false

m_master_cl_anular.m_file.m_basedatos.m_modificar.enabled = false
m_master_cl_anular.m_file.m_basedatos.m_modificar.toolbaritemvisible = false

m_master_cl_anular.m_file.m_basedatos.m_abrirlista.enabled = false
m_master_cl_anular.m_file.m_basedatos.m_abrirlista.toolbaritemvisible = false
end event

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 32
tab_1.height = newheight - tab_1.y - 32

tab_1.tp_1.dw_1.width = tab_1.tp_1.width - (tab_1.tp_1.dw_1.x + 32)
tab_1.tp_1.dw_1.height = tab_1.tp_1.height - (tab_1.tp_1.dw_1.y + 32)

tab_1.tp_2.dw_2.width = tab_1.tp_2.width - (tab_1.tp_2.dw_2.x + 32)
tab_1.tp_2.dw_2.height = tab_1.tp_2.height - (tab_1.tp_2.dw_2.y + 32)
end event

event ue_insert;call super::ue_insert;tab_1.selecttab(2)

Long  ll_row

ll_row = tab_1.tp_2.dw_2.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

idw_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	idw_det.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_det.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    		Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		
		dwItemStatus l_status
		l_status = idw_det.GetItemStatus( idw_det.GetRow(), "nro_papeleta", Primary!)
		
		if l_status = New! or l_status = NewModified! then
			string ls_null
			setnull(ls_null)
			idw_det.object.nro_papeleta[ idw_det.GetRow() ] = ls_null
		end if
		
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_det.ii_update = 0
END IF
end event

event ue_update_pre;call super::ue_update_pre;long ll_row
string ls_papeleta, ls_hsal, ls_hing, ls_codtra, ls_ret

ib_update_check = False

//Verificación de Data en Detalle de Documento
IF gnvo_app.of_row_Processing( idw_det ) <> true then	
	idw_det.setFocus( )
	return
END IF

ll_row = idw_det.getrow()

if ll_row <= 0 then return

ls_hsal = string(idw_det.object.salida_autorizada[ll_row],'hh:mm')

if ls_hsal = '00:00' or isnull(ls_hsal) or ls_hsal = '' then
	MessageBox('Aviso','Debe Ingresar una hora de salida autorizada valida')
	return
end if

ls_hing = string(idw_det.object.ingreso_autorizado[ll_row],'hh:mm')

if ls_hing = '00:00' or isnull(ls_hing) or ls_hing = '' then
	MessageBox('Aviso','Debe Ingresar una hora de ingreso autorizado valido')
	return
end if

date ld_emi
datetime ldt_emi, ldt_sal, ldt_ing

ld_emi = date(idw_det.object.fec_emision[ll_row])

idw_det.object.fec_emision[ll_row] = datetime( ld_emi, time('00:00:00') )
idw_det.object.salida_autorizada[ll_row] = datetime( ld_emi, time(ls_hsal) )
idw_det.object.ingreso_autorizado[ll_row] = datetime( ld_emi, time(ls_hing) )

ls_codtra = idw_det.object.cod_trabajador[ ll_row ]

select usf_rh_fecha_cerrada( :ld_emi, :ls_codtra ) into :ls_ret from dual;
 
if gnvo_app.of_existserror(sqlca) then
	return
end if

if ls_ret <> '0' then
	MessageBox('Aviso','No se puede grabar la papeleta porque el calculo que corresponde a la fecha de emision ya finalizo')
	return
end if

ls_papeleta = idw_det.object.nro_papeleta[ ll_row ]

//valor por defecto cuando se inserta un registro
if ls_papeleta = '' or isnull(ls_papeleta) then
	
	if of_nro_registro( ll_row ) = 0 then
		return
	end if
	
end if

ib_update_check = true
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (idw_det.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_det.ii_update = 0
	END IF
END IF
end event

event ue_anular;call super::ue_anular;long ll_row

ll_row = idw_det.getrow()

if ll_row <= 0 then return

if MessageBox('Aviso','¿Está seguro de anular la papeleta?',Question!,YesNo!,2) = 2 then return

string ls_estado

ls_estado = idw_det.object.flag_estado[ll_row] 

if ls_estado = '0' then
	MessageBox('Aviso','La papeleta ya se encuentra anulada')
	return
end if

date ld_emi
string ls_codtra, ls_ret

ld_emi = date(idw_det.object.fec_emision[ll_row])
ls_codtra = idw_det.object.cod_trabajador[ ll_row ]

select usf_rh_fecha_cerrada( :ld_emi, :ls_codtra ) into :ls_ret from dual;
 
if gnvo_app.of_existserror(sqlca) then
	return
end if

if ls_ret <> '0' then
	MessageBox('Aviso','No se puede grabar la papeleta porque el calculo que corresponde a la fecha de emision ya finalizo')
	return
end if

idw_det.object.flag_estado[ll_row] = '0'
idw_det.ii_update = 1

event ue_update()
end event

event ue_print;call super::ue_print;string ls_nro
long ll_row

ll_row = tab_1.tp_2.dw_2.getrow()

if ll_row <= 0 then return

if tab_1.tp_2.dw_2.object.flag_estado[ll_row] <> '1' then
	MessageBox('Aviso','Papeleta no se encuentra activa')
	return
end if

ls_nro = tab_1.tp_2.dw_2.object.nro_papeleta[ll_row]

str_parametros lstr_parametros

lstr_parametros.string1 = ls_nro

OpenSheetWithParm( w_rh242_permiso_papeleta_impresion, lstr_parametros, this, 2, Layered!)
end event

type tab_1 from tab within w_rh242_permiso_papeleta
integer x = 29
integer y = 26
integer width = 2373
integer height = 1565
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_1 tp_1
tp_2 tp_2
end type

on tab_1.create
this.tp_1=create tp_1
this.tp_2=create tp_2
this.Control[]={this.tp_1,&
this.tp_2}
end on

on tab_1.destroy
destroy(this.tp_1)
destroy(this.tp_2)
end on

event selectionchanged;if newindex = 2 then
	long ll_row
	ll_row = idw_lis.getrow()
	if ll_row > 0 then
		idw_det.retrieve( idw_lis.object.nro_papeleta[ll_row])
	end if
end if
end event

type tp_1 from userobject within tab_1
integer x = 15
integer y = 90
integer width = 2344
integer height = 1462
long backcolor = 79741120
string text = "Lista"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_1 cb_1
dp_2 dp_2
st_2 st_2
dp_1 dp_1
dw_1 dw_1
gb_1 gb_1
end type

on tp_1.create
this.cb_1=create cb_1
this.dp_2=create dp_2
this.st_2=create st_2
this.dp_1=create dp_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_1,&
this.dp_2,&
this.st_2,&
this.dp_1,&
this.dw_1,&
this.gb_1}
end on

on tp_1.destroy
destroy(this.cb_1)
destroy(this.dp_2)
destroy(this.st_2)
destroy(this.dp_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

type cb_1 from commandbutton within tp_1
integer x = 1115
integer y = 134
integer width = 315
integer height = 99
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Aceptar"
end type

event clicked;datetime ldt_ini, ldt_fin

ldt_ini = datetime( date(dp_1.value), time('00:00:00') )

ldt_fin = datetime( date(dp_2.value), time('23:59:59') )

idt_fecsys = gnvo_app.of_fecha_actual()

dw_1.retrieve(ldt_ini, ldt_fin, gs_origen)

idw_det.reset()
end event

type dp_2 from datepicker within tp_1
integer x = 607
integer y = 102
integer width = 446
integer height = 99
integer taborder = 40
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-16"), Time("19:04:53.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_2 from statictext within tp_1
integer x = 523
integer y = 122
integer width = 80
integer height = 51
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type dp_1 from datepicker within tp_1
integer x = 73
integer y = 102
integer width = 446
integer height = 99
integer taborder = 30
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-16"), Time("19:04:53.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type dw_1 from u_dw_abc within tp_1
integer x = 33
integer y = 259
integer width = 2286
integer height = 1187
integer taborder = 20
string dataobject = "d_abc_papeleta_permiso_list_grd"
end type

event doubleclicked;call super::doubleclicked;if row > 0 then
	tab_1.tp_2.dw_2.retrieve( this.object.nro_papeleta[row] )
	tab_1.selecttab(2)
end if
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'grid'	// tabular, form (default)
end event

event ue_delete;//override
return 0
end event

type gb_1 from groupbox within tp_1
integer x = 33
integer y = 26
integer width = 1061
integer height = 208
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas de Ingreso"
end type

type tp_2 from userobject within tab_1
integer x = 15
integer y = 90
integer width = 2344
integer height = 1462
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tp_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tp_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_abc within tp_2
integer x = 33
integer y = 32
integer width = 2286
integer height = 1414
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_papeleta_permiso_grd"
end type

event buttonclicked;call super::buttonclicked;if row > 0 then
	string ls_sql, ls_return1, ls_return2, ls_rest
	
	ls_rest = 'if ( isrownew(), 0,1)'
	
	if this.Describe("Evaluate('"+ls_rest+"', "+string(row)+")") = '1' then
		return
	end if
	
	if dwo.name = 'b_cod_trabajador' then
		ls_sql = "select cod_trabajador as codigo, usf_rh_nombre_trabajador(cod_trabajador) as descripcion from maestro where flag_estado = '1' and cod_origen = '"+gs_origen+"' order by 2" 
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cod_trabajador [row] = ls_return1
		this.object.nomtra [row] = ls_return2
		this.ii_update = 1
	elseif dwo.name = 'b_tipo_permiso' then
		ls_sql = "select tipo_permiso as codigo, desc_tipo_permiso as descripcion from rrhh_tipo_permiso where flag_estado = '1' order by 2" 
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.tipo_permiso [row] = ls_return1
		this.object.desc_tipo_permiso [row] = ls_return2
		this.ii_update = 1
	end if
	
end if
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event itemchanged;call super::itemchanged;this.AcceptText()
string ls_desc
datetime ldt_null
setnull(ldt_null)

choose case dwo.name
		
	case 'fec_emision'

		this.object.fec_emision[row] = datetime(date(data),time('00:00:00'))
		this.object.salida_autorizada [row] = ldt_null
		this.object.ingreso_autorizado [row] = ldt_null
	
	case 'salida_autorizada'
		
		if datetime(Data) >= datetime(this.object.ingreso_autorizado[row]) then
			MessageBox('Aviso','La hora de salida no puede ser mayor o igual a la hora de ingreso')
			this.object.salida_autorizada[row] = ldt_null
			return 1
		end if
		
	case 'ingreso_autorizado'
		
		if datetime(Data) <= datetime(this.object.salida_autorizada[row]) then
			MessageBox('Aviso','La hora de ingreso no puede ser menor o igual a la hora de salida')
			this.object.ingreso_autorizado[row] = ldt_null
			return 1
		end if
	
	case 'cod_trabajador'
		
		select usf_rh_nombre_trabajador(cod_trabajador)
		  into :ls_desc
		  from maestro 
		 where cod_trabajador = :data and flag_estado = '1' and cod_origen = :gs_origen;
		
		if sqlca.sqlcode = 100 then
			this.object.cod_trabajador[row] = ''
			this.object.nomtra[row] = ''
			return 1
		end if
		
		this.object.nombra[row] = ls_desc
	
		
	case 'tipo_permiso'
		
		select desc_tipo_permiso 
		  into :ls_desc
		  from rrhh_tipo_permiso where tipo_permiso = :data and flag_estado = '1';
		
		if sqlca.sqlcode = 100 then
			this.object.tipo_permiso[row] = ''
			this.object.desc_tipo_permiso[row] = ''
			return 1
		end if
		
		this.object.desc_tipo_permiso[row] = ls_desc
		
end choose
end event

event itemerror;call super::itemerror;return 1
end event

event ue_delete;//override
return 0
end event

event ue_insert;//override
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF not Isnull(idw_mst) and IsValid(idw_mst) then
		if idw_mst.il_row = 0 THEN
			MessageBox("Error", "No ha seleccionado registro Maestro")
			RETURN - 1
		end if
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	//of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF (is_mastdet = 'md' OR is_mastdet = 'dd') and (not ISNull(idw_det) and isValid(idw_det)) THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr				[al_row] = gs_user
this.object.codigo_origen [al_row] = gs_origen
this.object.fec_registro [al_row] = datetime(today(),now())
this.object.fec_emision [al_row] = datetime(today(),time('00:00:00'))
this.object.salida_autorizada [al_row] = datetime(today(),time('00:00:00'))
this.object.ingreso_autorizado [al_row] = datetime(today(),time('00:00:00'))
setcolumn('fec_emision')
end event

