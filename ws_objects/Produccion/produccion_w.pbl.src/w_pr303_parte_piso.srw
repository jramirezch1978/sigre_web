$PBExportHeader$w_pr303_parte_piso.srw
forward
global type w_pr303_parte_piso from w_abc_master_smpl
end type
type dw_firmas from u_dw_abc within w_pr303_parte_piso
end type
type st_master from statictext within w_pr303_parte_piso
end type
type st_firmas from statictext within w_pr303_parte_piso
end type
type dw_formato from u_dw_abc within w_pr303_parte_piso
end type
type st_formato from statictext within w_pr303_parte_piso
end type
type dw_valores from u_dw_abc within w_pr303_parte_piso
end type
type st_lecturas from statictext within w_pr303_parte_piso
end type
type st_comentarios from statictext within w_pr303_parte_piso
end type
type dw_comentarios from u_dw_abc within w_pr303_parte_piso
end type
type cbx_fecha from checkbox within w_pr303_parte_piso
end type
type uo_1 from u_ingreso_rango_fechas within w_pr303_parte_piso
end type
type p_arrow from picture within w_pr303_parte_piso
end type
type dw_chata from u_dw_abc within w_pr303_parte_piso
end type
type st_chata from statictext within w_pr303_parte_piso
end type
type p_1 from picture within w_pr303_parte_piso
end type
type em_nro_parte from singlelineedit within w_pr303_parte_piso
end type
type st_1 from statictext within w_pr303_parte_piso
end type
type gb_1 from groupbox within w_pr303_parte_piso
end type
type gb_2 from groupbox within w_pr303_parte_piso
end type
end forward

global type w_pr303_parte_piso from w_abc_master_smpl
integer width = 3497
integer height = 2064
string title = "Parte de piso (PR303)"
string menuname = "m_mantto_lista_smpl"
boolean clientedge = true
dw_firmas dw_firmas
st_master st_master
st_firmas st_firmas
dw_formato dw_formato
st_formato st_formato
dw_valores dw_valores
st_lecturas st_lecturas
st_comentarios st_comentarios
dw_comentarios dw_comentarios
cbx_fecha cbx_fecha
uo_1 uo_1
p_arrow p_arrow
dw_chata dw_chata
st_chata st_chata
p_1 p_1
em_nro_parte em_nro_parte
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_pr303_parte_piso w_pr303_parte_piso

type variables
string is_nro_parte
long il_firmas
integer ii_mesg
end variables

forward prototypes
public subroutine of_carga_valores ()
public function integer of_firmas ()
public subroutine of_borra_detail (string asi_nro_parte, string asi_formato)
end prototypes

public subroutine of_carga_valores ();string ls_formato, ls_cod_maquina, ls_atributo 
long ll_formato
dw_valores.reset()
ll_formato = dw_formato.getrow()
if ll_formato >= 1 then
	ls_formato = dw_formato.object.formato[ll_formato]
	ls_cod_maquina = dw_formato.object.cod_maquina[ll_formato]
	ls_atributo = dw_formato.object.atributo[ll_formato]
	dw_valores.retrieve (is_nro_parte, ls_formato, ls_cod_maquina, ls_atributo)
end if
end subroutine

public function integer of_firmas ();if il_firmas >= 1 then
	if ii_mesg = 0 then
		messagebox('Control de Piso','El parte de piso ya ha sido firmado, ~r no se puede modificar mientras ~r tega firmas registradas',StopSign!)
	end if
	ii_mesg = 0
	return il_firmas
else
	return 0
end if

end function

public subroutine of_borra_detail (string asi_nro_parte, string asi_formato);long ll_error

declare usp_det_del procedure for 
	usp_pr_parte_piso_det_del (:asi_nro_parte, :asi_formato);
	
execute usp_det_del;
fetch usp_det_del into :ll_error;
if ll_error = 1 then
	messagebox(this.title,'Error borrando detalle',StopSign!)
end if
close usp_det_del;
end subroutine

on w_pr303_parte_piso.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_lista_smpl" then this.MenuID = create m_mantto_lista_smpl
this.dw_firmas=create dw_firmas
this.st_master=create st_master
this.st_firmas=create st_firmas
this.dw_formato=create dw_formato
this.st_formato=create st_formato
this.dw_valores=create dw_valores
this.st_lecturas=create st_lecturas
this.st_comentarios=create st_comentarios
this.dw_comentarios=create dw_comentarios
this.cbx_fecha=create cbx_fecha
this.uo_1=create uo_1
this.p_arrow=create p_arrow
this.dw_chata=create dw_chata
this.st_chata=create st_chata
this.p_1=create p_1
this.em_nro_parte=create em_nro_parte
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_firmas
this.Control[iCurrent+2]=this.st_master
this.Control[iCurrent+3]=this.st_firmas
this.Control[iCurrent+4]=this.dw_formato
this.Control[iCurrent+5]=this.st_formato
this.Control[iCurrent+6]=this.dw_valores
this.Control[iCurrent+7]=this.st_lecturas
this.Control[iCurrent+8]=this.st_comentarios
this.Control[iCurrent+9]=this.dw_comentarios
this.Control[iCurrent+10]=this.cbx_fecha
this.Control[iCurrent+11]=this.uo_1
this.Control[iCurrent+12]=this.p_arrow
this.Control[iCurrent+13]=this.dw_chata
this.Control[iCurrent+14]=this.st_chata
this.Control[iCurrent+15]=this.p_1
this.Control[iCurrent+16]=this.em_nro_parte
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.gb_1
this.Control[iCurrent+19]=this.gb_2
end on

on w_pr303_parte_piso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_firmas)
destroy(this.st_master)
destroy(this.st_firmas)
destroy(this.dw_formato)
destroy(this.st_formato)
destroy(this.dw_valores)
destroy(this.st_lecturas)
destroy(this.st_comentarios)
destroy(this.dw_comentarios)
destroy(this.cbx_fecha)
destroy(this.uo_1)
destroy(this.p_arrow)
destroy(this.dw_chata)
destroy(this.st_chata)
destroy(this.p_1)
destroy(this.em_nro_parte)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;dw_comentarios.height = newheight - dw_comentarios.y - 10

dw_firmas.width = newwidth - dw_firmas.x - 10
dw_chata.width = newwidth - dw_chata.x - 10
dw_valores.width = newwidth - dw_valores.x - 10
dw_comentarios.width = newwidth - dw_comentarios.x - 10

st_firmas.width = newwidth - st_firmas.x - 10
st_chata.width = newwidth - st_chata.x - 10
st_lecturas.width = newwidth - st_lecturas.x - 10
st_comentarios.width = newwidth - st_comentarios.x - 10
end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0

dw_firmas.of_protect()
dw_chata.of_protect()
dw_valores.of_protect()
dw_comentarios.of_protect()
end event

event ue_dw_share;string ls_formato, ls_cod_maquina, ls_atributo


if ii_lec_mst = 0 then return
is_nro_parte = em_nro_parte.text
if isnull(is_nro_parte) or trim(is_nro_parte) = '' then 
	messagebox(this.title,'Debe seleccionar un numero de parte de piso',stopsign!)
	return
end if

dw_master.reset()
dw_firmas.reset()
dw_chata.reset()
dw_formato.reset()
dw_valores.reset()
dw_comentarios.reset()

dw_master.retrieve(is_nro_parte)

if dw_master.rowcount() >= 1 then

	dw_firmas.retrieve(is_nro_parte)
	dw_comentarios.retrieve(is_nro_parte)
	dw_chata.retrieve(is_nro_parte)
	
	ls_formato = dw_master.object.formato[dw_master.getrow()]

	dw_formato.retrieve(ls_formato)

	if dw_formato.rowcount() >= 1 then
		dw_formato.setrow(1)
		dw_formato.scrolltorow(1)
		dw_formato.selectrow(1,true)

		ls_formato = dw_formato.object.formato[1]
		ls_cod_maquina = dw_formato.object.cod_maquina[1]
		ls_atributo = dw_formato.object.atributo[1]

		dw_valores.retrieve (is_nro_parte, ls_formato, ls_cod_maquina, ls_atributo)

	end if

end if

dw_master.il_row = dw_master.getrow()
il_firmas = dw_firmas.rowcount()
end event

event ue_list_open;call super::ue_list_open;string ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_where, ls_fecha_ini, ls_fecha_fin
ls_where = ''
if cbx_fecha.checked = true then
	ls_fecha_ini = string(uo_1.of_get_fecha1(), 'dd/mm/yyyy')
	ls_fecha_fin = string(uo_1.of_get_fecha2(), 'dd/mm/yyyy')
	ls_where  = " where to_date(parte_fecha, 'dd/mm/yyyy') >= to_date('"+ls_fecha_ini+"', 'dd/mm/yyyy') and to_date(parte_fecha, 'dd/mm/yyyy') <= to_date('"+ls_fecha_fin+"', 'dd/mm/yyyy')"
end if
ls_sql = "select flag_tipo as tipo, nro_parte as numero, descripcion as turno, parte_fecha as fecha from vw_pr_parte_piso" + ls_where
f_lista_4ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, '1')

if isnull(ls_return2) or trim(ls_return2) = '' then
	return
else
	is_nro_parte = ls_return2
	ii_lec_mst = 1
	em_nro_parte.text = is_nro_parte
	this.event ue_dw_share()
end if
end event

event ue_update;Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_firmas.of_create_log()
	dw_chata.of_create_log()
	dw_valores.of_create_log()
	dw_comentarios.of_create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_firmas.ii_update = 1 THEN
	IF dw_firmas.Update(true, false) = -1 then		// Grabacion de las firmas
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_chata.ii_update = 1 THEN
	IF dw_chata.Update(true, false) = -1 then		// Grabacion de la chata
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_valores.ii_update = 1 THEN
	IF dw_valores.Update(true, false) = -1 then		// Grabacion de los valores para las lecturas
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

// nota : el datawindows de formatos no debe de ser guardado, sólo sirve para mostrar los criterios de ingreso a las lecturas

IF	dw_comentarios.ii_update = 1 THEN
	IF dw_comentarios.Update(true, false) = -1 then		// Grabacion de los comentarios (observaciones / acciones correctiva)
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
		dw_firmas.of_save_log()
		dw_chata.of_save_log()
		dw_valores.of_save_log()
		dw_comentarios.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_firmas.ii_update = 0
	dw_chata.ii_update = 0
	dw_valores.ii_update = 0
	dw_comentarios.ii_update = 0
	dw_master.il_totdel = 0
	dw_firmas.il_totdel = 0
	dw_chata.il_totdel = 0
	dw_valores.il_totdel = 0
	dw_comentarios.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_firmas.ResetUpdate()
	dw_chata.ResetUpdate()
	dw_valores.ResetUpdate()
	dw_comentarios.ResetUpdate()
END IF

end event

event ue_modify;if of_firmas() >= 1 then
	dw_master.ii_protect = 0
	dw_firmas.ii_protect = 0
	dw_chata.ii_protect = 0
	dw_valores.ii_protect = 0
	dw_comentarios.ii_protect = 0
end if

dw_master.of_protect()
dw_firmas.of_protect()
dw_chata.of_protect()
dw_valores.of_protect()
dw_comentarios.of_protect()
end event

event ue_query_retrieve;long ll_cuenta
integer li_update
if dw_master.ii_update = 1 or dw_firmas.ii_update = 1 or dw_chata.ii_update = 1 or dw_valores.ii_update = 1 or dw_formato.ii_update = 1 or dw_comentarios.ii_update = 1 then
	li_update = messagebox(this.title,'',Question!, YesNoCancel!)
	choose case li_update
		case 1
			this.event ue_update()
		case 2
			messagebox(this.title,'No se han grabado las modificaciones',Exclamation!)
		case 3
			return
	end choose
end if

is_nro_parte = trim(em_nro_parte.text)
declare usp_busca_parte procedure for 
	usp_tg_busca_parte_piso(:is_nro_parte);
execute usp_busca_parte;
fetch usp_busca_parte into :ll_cuenta;
close usp_busca_parte;

if ll_cuenta = 1 then
	ii_lec_mst = 1
	this.event ue_dw_share()
else
	messagebox(this.title,'No se encontró el número de parte',stopsign!)
end if
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_firmas.of_set_flag_replicacion( )
dw_chata.of_set_flag_replicacion( )
dw_valores.of_set_flag_replicacion( )
dw_comentarios.of_set_flag_replicacion( )
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

IF dw_firmas.ii_update = 1 or dw_chata.ii_update = 1 or dw_valores.ii_update = 1 or dw_comentarios.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		THIS.EVENT ue_update()
	END IF
END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr303_parte_piso
integer y = 228
integer width = 1925
integer height = 560
string dataobject = "d_pr_parte_piso_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_insert_pre;string ls_nro_parte
dw_master.visible = false
declare usp_parte_piso procedure for
   usp_tg_parte_piso_num(:gs_origen, :gs_user);

execute usp_parte_piso;
fetch usp_parte_piso into :ls_nro_parte;
close usp_parte_piso;
if isnull(ls_nro_parte) or len(trim(ls_nro_parte)) < 10 then
	messagebox(parent.title,'Error al generar el número, intente nuevamente',StopSign!)
	return
else
	is_nro_parte = ls_nro_parte
	dw_master.retrieve(ls_nro_parte)
	dw_master.visible = true
end if
il_row = this.getrow()
end event

event dw_master::doubleclicked;call super::doubleclicked;if ii_protect = 1 then return
long ll_parte, ll_master
string ls_column, ls_sql, ls_return1, ls_return2, ls_return3, ls_nro_parte, ls_formato

ll_parte = dw_master.getrow()
ls_column = trim(lower(string(dwo.name)))

choose case ls_column
	case 'turno'
		ls_sql = "select turno as codigo, descripcion as nombre from turno where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then
		else
			this.object.turno[ll_parte] = ls_return1
			this.object.turno_descripcion[ll_parte] = ls_return2
			ii_update = 1
		end if
	case 'formato'
		if dw_valores.rowcount() >= 1 then
			if messagebox(this.title,'Al cambiar de formato se perderán definitivamente ~r todos los valores de las medidas asigandas.  ~r  ~r ¿Desea proceder de todas maneras?',Question!, YesNo!, 2) = 2 then
				messagebox(this.title,'No se ha cambiado el formato',Information!)
				return 
			end if
		end if
		ll_master = dw_master.getrow()
		ls_nro_parte = dw_master.object.nro_parte[ll_master]
		ls_formato = dw_master.object.formato[ll_master]
		of_borra_detail(ls_nro_parte, ls_formato)
		ls_sql = "select fmt_cod as codigo, fmt_desc as descripcion, lbr_desc as labor from vw_pr_foramto_labor"
		f_lista_3ret(ls_sql, ls_return1, ls_return2, ls_return3, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then
		else
			
			this.object.formato[ll_parte] = ls_return1
			this.object.descripcion[ll_parte] = ls_return2
			this.object.desc_labor[ll_parte] = ls_return3
			dw_formato.retrieve(ls_return1)
			of_carga_valores()
			ii_update = 1
			
		end if
end choose
end event

event dw_master::getfocus;call super::getfocus;idw_1 = THIS
il_row = this.getrow()

st_master.backcolor = rgb(100,0,0)
st_chata.backcolor = rgb(0,0,100)
st_lecturas.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(0,0,100)
st_formato.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
end event

event dw_master::ue_delete;if of_firmas() >= 1 then return -1

long ll_row
ll_row = this.getrow()

if this.object.flag_estado[ll_row] = '0' then
	this.object.flag_estado[ll_row] = '1'
else
	this.object.flag_estado[ll_row] = '0'
end if
this.ii_update = 1

return(ll_row)
end event

event dw_master::itemchanged;call super::itemchanged;long ll_parte, ll_master
string ls_column, ls_code, ls_name, ls_labor, ls_flag_tipo, ls_turno, ls_formato, ls_documento_desc, ls_turno_descripcion, ls_descripcion, ls_desc_labor, ls_xnro_parte, ls_xformato
datetime ld_fecha_parte

ll_parte = dw_master.getrow()

ls_flag_tipo 				= this.object.flag_tipo[ll_parte]
ld_fecha_parte 			= this.object.fecha_parte[ll_parte]
ls_turno 					= this.object.turno[ll_parte]
ls_formato 					= this.object.formato[ll_parte]
ls_documento_desc 		= this.object.documento_desc[ll_parte]
ls_turno_descripcion 	= this.object.turno_descripcion[ll_parte]
ls_descripcion 			= this.object.descripcion[ll_parte]
ls_desc_labor 				= this.object.desc_labor[ll_parte]

this.accepttext()

if of_firmas() >= 1 then
	this.object.flag_tipo[ll_parte] = ls_flag_tipo 
	this.object.fecha_parte[ll_parte] = ld_fecha_parte
	this.object.turno[ll_parte] = ls_turno 
	this.object.documento_desc[ll_parte] = ls_documento_desc
	this.object.turno_descripcion[ll_parte] = ls_turno_descripcion
	this.object.formato[ll_parte] = ls_formato
	this.object.descripcion[ll_parte] = ls_descripcion
	this.object.desc_labor[ll_parte] = ls_desc_labor
	this.accepttext()
	return 2
end if

ls_column = string(dwo.name)
this.accepttext()

choose case ls_column
	case 'turno'
		ls_code = this.object.turno[ll_parte]
		
		declare usp_turno procedure for usp_tg_busca_turno(:ls_code);
			
		execute usp_turno;

		fetch usp_turno into :ls_code, :ls_name;
		if isnull(ls_code) or trim(ls_code) = '' then
			ls_code = ls_turno
			ls_name = ls_turno_descripcion
			messagebox(parent.title,'Turno no registrado',StopSign!)
		end if
		this.object.turno[ll_parte] = ls_code
		this.object.turno_descripcion[ll_parte] = ls_name
		close usp_turno;

	case 'formato'
		if dw_valores.rowcount() >= 1 then
			if messagebox(parent.title,'Al cambiar de formato se perderán definitivamente ~r todos los valores de las medidas asigandas.  ~r  ~r ¿Desea proceder de todas maneras?',Question!, YesNo!, 2) = 2 then
				this.object.formato[ll_parte] = ls_formato
				this.object.descripcion[ll_parte] = ls_descripcion
				this.object.desc_labor[ll_parte] = ls_desc_labor
				messagebox(parent.title,'No se ha cambiado el formato',Information!)
				return 2	
			end if
		end if
		ls_code = this.object.formato[ll_parte]
		declare usp_formato procedure for 
			usp_tg_busca_formato_pr(:ls_code);
		execute usp_formato;
		fetch usp_formato into :ls_code, :ls_name, :ls_labor;
		if isnull(ls_code) or trim(ls_code) = '' then
			ls_code = ls_formato
			ls_name = ls_descripcion
			ls_labor = ls_desc_labor
			messagebox(parent.title,'Formato no existente',StopSign!)
		else
			ll_master = dw_master.getrow()
			of_borra_detail(is_nro_parte, ls_formato)
			dw_formato.reset()
			dw_formato.retrieve(ls_code)
		end if
		this.object.formato[ll_parte] = ls_code 
		this.object.descripcion[ll_parte] = ls_name 
		this.object.desc_labor[ll_parte] = ls_labor 
		close usp_formato;
end choose
this.accepttext()
return 2
end event

type dw_firmas from u_dw_abc within w_pr303_parte_piso
integer x = 1943
integer y = 232
integer width = 1486
integer height = 228
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pr_parte_piso_firma_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail

this.settransobject(sqlca);
end event

event ue_insert_pre;long ll_reco, ll_firmas
string ls_nombre, ls_user, ls_formato, ls_nro_parte, ls_mensaje
datetime ldt_fecha
integer li_error
boolean lb_find

ll_firmas = dw_firmas.rowcount()
lb_find = false
for ll_reco = 1 to ll_firmas
	ls_user = trim(this.object.cod_usr[ll_reco])
	if ls_user = gs_user then
		lb_find = true
	end if
end for

this.setrow(al_row)
this.scrolltorow(al_row)
if lb_find = true then
	messagebox(this.title,'Usted ya firmó el parte de piso, ~r no necesita volver a hacerlo',StopSign!)
	this.event ue_delete()
	return
end if

declare usp_pr_firma procedure for 
	usp_pr_parte_diario_firma (:gs_user);

execute usp_pr_firma;
fetch usp_pr_firma into :ls_nombre, :ldt_fecha, :li_error;
close usp_pr_firma;

if li_error = 0 then
	this.object.nombre[al_row] = ls_nombre
	this.object.nro_parte[al_row] = is_nro_parte
	this.object.cod_usr[al_row] = gs_user
	this.object.fecha[al_row] = ldt_fecha
	
	ls_nro_parte = dw_master.object.nro_parte[dw_master.getrow( )]
	this.ii_update = 1
//	declare pb_pp_fill procedure for
//		usp_pr_parte_piso_det_fill(:ls_nro_parte);
//	
//	execute pb_pp_fill;
//	fetch pb_pp_fill into :ls_mensaje;
//	close pb_pp_fill;
	if sqlca.sqlcode = -1 then 
		messagebox(parent.title, 'ORACLE: Error al ejecutar usp_pr_parte_piso_det_fill')
	else
		if not (trim(ls_mensaje) = '' or isnull(ls_mensaje)) then
			messagebox(parent.title,  ls_mensaje)
		end if
	end if
else
	messagebox(this.title,'Problemas con su usuario... ~r Comuniquese con sistemas',StopSign!)
	this.event ue_delete()
end if
end event

event getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(0,0,100)
st_lecturas.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(100,0,0)
st_formato.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
end event

event losefocus;call super::losefocus;il_firmas = this.rowcount()

if il_firmas >= 1  then
	dw_master.ii_protect = 0
	dw_firmas.ii_protect = 0
	dw_chata.ii_protect = 0
	dw_valores.ii_protect = 0
	dw_comentarios.ii_protect = 0
else
	dw_master.ii_protect = 1
	dw_firmas.ii_protect = 1
	dw_chata.ii_protect = 1
	dw_valores.ii_protect = 1
	dw_comentarios.ii_protect = 1
end if

dw_master.of_protect()
dw_firmas.of_protect()
dw_chata.of_protect()
dw_valores.of_protect()
dw_comentarios.of_protect()

ii_mesg = 1

of_firmas()

end event

event ue_delete;string ls_user
long ll_row = 1
ls_user = trim(this.object.cod_usr[this.getrow()])
if ls_user <> gs_user then
	messagebox(this.title,'Usted no puede borrar la firtma de otro usuario',StopSign!)
	return this.getrow()
end if
ib_insert_mode = False

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1
		if dw_master.ii_protect = 1 then
			dw_master.of_protect()
			dw_firmas.of_protect()
			dw_chata.of_protect()
			dw_valores.of_protect()
			dw_comentarios.of_protect()	
		end if
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

type st_master from statictext within w_pr303_parte_piso
integer y = 148
integer width = 1925
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Parte de Piso"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_firmas from statictext within w_pr303_parte_piso
integer x = 1938
integer y = 160
integer width = 1486
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Firmas"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_formato from u_dw_abc within w_pr303_parte_piso
integer y = 872
integer width = 1925
integer height = 584
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pr_parte_piso_atrib_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail
this.settransobject(sqlca);
this.SetRowFocusIndicator(p_arrow)
end event

event rowfocuschanged;call super::rowfocuschanged;parent.event ue_update_request( )
of_carga_valores()
end event

event getfocus;call super::getfocus;idw_1 = dw_valores
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(0,0,100)
st_lecturas.backcolor = rgb(100,0,0)
st_firmas.backcolor = rgb(0,0,100)
st_formato.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
end event

event doubleclicked;call super::doubleclicked;string ls_cadena, ls_nro_parte, ls_formato, ls_cod_maquina, ls_atributo
long ll_row
if dw_valores.ii_update = 1 then
	if messagebox(parent.title,'Se han realizado cambios en las ~r lecturas, si no las graba no se ~r podrá ver una gráfica actualizada.  ~r  ~r ¿Desea Grabar?',Question!, YesNo!) = 1 then
		parent.event ue_update()
	end if
end if
ll_row = this.getrow()

ls_nro_parte = right(fill(' ',10) + trim(is_nro_parte),10) //mid(ls_cadena,1,10)
ls_formato = right(fill(' ',8) + trim(this.object.formato[ll_row]),8) //mid(ls_cadena,11,8)
ls_cod_maquina = right(fill(' ',8) + trim(this.object.cod_maquina[ll_row]),8) //mid(ls_cadena,19,8)
ls_atributo = right(fill(' ',4) + trim(this.object.atributo[ll_row]),4) //mid(ls_cadena,27,4)

ls_cadena = ls_nro_parte + ls_formato + ls_cod_maquina + ls_atributo

openwithparm(w_pr701_mediciones_grf,ls_cadena)
end event

type st_formato from statictext within w_pr303_parte_piso
integer y = 792
integer width = 1925
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Lecturas del formato"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_valores from u_dw_abc within w_pr303_parte_piso
integer x = 1943
integer y = 748
integer width = 1486
integer height = 704
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pr_parte_piso_det_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail
this.settransobject(sqlca);
end event

event getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(0,0,100)
st_lecturas.backcolor = rgb(100,0,0)
st_firmas.backcolor = rgb(0,0,100)
st_formato.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
end event

event ue_insert_pre;call super::ue_insert_pre;long ll_formato, ll_cuenta, ll_valores
string ls_formato, ls_cod_maquina, ls_atributo

if this.ii_update = 1 then
	if this.update() = -1 then
		messagebox(this.title,'Error en grabar valores de medición',StopSign!)
		return
	else
		commit using sqlca;
	end if
end if
ll_formato = dw_formato.getrow()

if ll_formato <= 0 then 
	messagebox(this.title,'No se puede ingresar un nuevo valor si usted ~r no selecciona que lectura realizar...',StopSign!)
	return
end if

ls_formato = dw_formato.object.formato[ll_formato]
ls_cod_maquina = dw_formato.object.cod_maquina[ll_formato]
ls_atributo = dw_formato.object.atributo[ll_formato]

declare usp_par_dia_det procedure for 
	usp_pr_parte_diario_det (:is_nro_parte, :ls_formato, :ls_cod_maquina, :ls_atributo);

execute usp_par_dia_det;

fetch usp_par_dia_det  into :ll_cuenta;

if ll_cuenta <= 0 then 
	messagebox(this.title,'No se pudo generar el nuevo registro. ~r Intente nuevamente, o consulte con sistemas.',StopSign!)
	return
end if

close usp_par_dia_det;

of_carga_valores()

ll_valores = dw_valores.rowcount()

if ll_valores <= 0 then return

dw_valores.scrolltorow(ll_valores)
dw_valores.setrow(ll_valores)
dw_valores.selectrow(ll_valores,true)

end event

event itemchanged;call super::itemchanged;integer li_nro_control, li_nro_control_pre, li_nro_lectura, li_nro_lectura_pre
long ll_valores
string ls_column, ls_atributo, ls_cod_maquina, ls_formato, ls_atributo_pre, ls_cod_maquina_pre, ls_formato_pre, ls_valor_lectura, ls_valor_lectura_pre, ls_flag_tipo_dato

ll_valores = this.getrow()

ls_atributo_pre = this.object.atributo[ll_valores]
ls_cod_maquina_pre = this.object.cod_maquina[ll_valores]
ls_formato_pre = this.object.formato[ll_valores]
li_nro_control_pre = this.object.nro_control[ll_valores]
li_nro_lectura_pre = this.object.nro_lectura[ll_valores]
ls_valor_lectura_pre = this.object.valor_lectura[ll_valores]

this.accepttext()

ls_atributo = this.object.atributo[ll_valores]
ls_cod_maquina = this.object.cod_maquina[ll_valores]
ls_formato = this.object.formato[ll_valores]
li_nro_control = this.object.nro_control[ll_valores]
li_nro_lectura = this.object.nro_lectura[ll_valores]
ls_valor_lectura = this.object.valor_lectura[ll_valores]

if of_firmas() >= 1 then
	this.object.atributo[ll_valores] = ls_atributo_pre
	this.object.cod_maquina[ll_valores] = ls_cod_maquina_pre
	this.object.formato[ll_valores] = ls_formato_pre
	this.object.nro_control[ll_valores] = li_nro_control_pre
	this.object.nro_lectura[ll_valores] = li_nro_lectura_pre
	this.object.valor_lectura[ll_valores] = ls_valor_lectura_pre
	return 2
end if

ls_column = trim(lower(string(dwo.name)))
choose case ls_column
	case 'nro_control'
		declare usp_parte_piso_num procedure for 
			usp_pr_parte_piso_det_num (:is_nro_parte, :ls_atributo, :ls_cod_maquina, :ls_formato, :li_nro_control);
		execute usp_parte_piso_num;
		fetch usp_parte_piso_num into :li_nro_lectura;
		close usp_parte_piso_num;
		if isnull(li_nro_lectura) then
			messagebox(this.title,'No se pudo generar el número de lectura',StopSign!)
			return
		else
			this.object.nro_lectura[ll_valores] = li_nro_lectura
			if this.update() = -1 then
				messagebox(this.title,'Problemas al guardar',StopSign!)
				return
			end if
			commit using sqlca;
		end if
	case 'valor_lectura'
		ls_flag_tipo_dato = this.object.flag_tipo_dato[row]
		choose case ls_flag_tipo_dato
			case 'C'
				this.object.valor_lectura[row] = upper(data)
				return 2
			case 'N'
				if not isnumber(data) then
					messagebox(parent.title, 'ERROR: El valor que usted está ingresando debe ser numérico', StopSign!)
					this.object.valor_lectura[row] = '0.00'
					return 2
				end if
			case else
				messagebox(parent.title, 'ATENCIÓN: No ha definido el tipo de dato, defínalo antes de proseguir', Exclamation!)
				this.event ue_delete( )
				commit using sqlca;
		end choose
end choose
end event

event ue_insert;if of_firmas() >= 1 then return -1
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

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

event doubleclicked;call super::doubleclicked;if lower(trim(string(dwo.name))) = 'nro_lectura' then messagebox(parent.title,'Este número de autogenera dependiendo de la hora de medición ingresada',Information!)
end event

type st_lecturas from statictext within w_pr303_parte_piso
integer x = 1938
integer y = 680
integer width = 1486
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Valores para las lecturas"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_comentarios from statictext within w_pr303_parte_piso
integer y = 1456
integer width = 3419
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Comentarios"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_comentarios from u_dw_abc within w_pr303_parte_piso
integer y = 1536
integer width = 3419
integer height = 304
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pr_parte_piso_com_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail
this.settransobject(sqlca);
end event

event getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(0,0,100)
st_lecturas.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(0,0,100)
st_formato.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(100,0,0)
end event

event ue_insert_pre;call super::ue_insert_pre;integer li_cuenta

dw_comentarios.update( )
commit;

declare usp_pp_obs procedure for 
	usp_pr_parte_piso_obs(:is_nro_parte, :gs_user);

execute usp_pp_obs;
fetch usp_pp_obs into :li_cuenta;
close usp_pp_obs;

if li_cuenta <= 0 then 
	messagebox(this.title,'No se pudo insertar el comentario',StopSign!)
	this.deleterow(al_row)
	return
end if

dw_comentarios.retrieve(is_nro_parte);
end event

event ue_insert;if of_firmas() >= 1 then return -1
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

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

event itemchanged;call super::itemchanged;long ll_obs
string ls_tipo_obs_pre, ls_obs_pre, ls_autor_pre
	
ll_obs = this.getrow()

ls_tipo_obs_pre = this.object.tipo_obs[ll_obs]
ls_obs_pre = this.object.obs[ll_obs]
ls_autor_pre = this.object.autor[ll_obs]
	
	this.accepttext()
	
if of_firmas() >= 1 then
	this.object.autor[ll_obs] = ls_autor_pre
	this.object.obs[ll_obs] = ls_obs_pre
	this.object.tipo_obs[ll_obs] = ls_tipo_obs_pre
	return 2	
end if
end event

type cbx_fecha from checkbox within w_pr303_parte_piso
integer x = 14
integer y = 52
integer width = 786
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar para búsquedas"
boolean checked = true
end type

type uo_1 from u_ingreso_rango_fechas within w_pr303_parte_piso
integer x = 626
integer y = 44
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(relativedate(today(), - 30), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type p_arrow from picture within w_pr303_parte_piso
boolean visible = false
integer x = 9
integer y = 1012
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "Custom035!"
boolean focusrectangle = false
end type

type dw_chata from u_dw_abc within w_pr303_parte_piso
integer x = 1943
integer y = 532
integer width = 1486
integer height = 148
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_parte_piso_chata_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail

this.settransobject(sqlca);
end event

event getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(100,0,0)
st_lecturas.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(0,0,100)
st_formato.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
end event

event ue_insert_pre;call super::ue_insert_pre;
string ls_sql, ls_return1, ls_return2

this.object.nro_parte[al_row] = is_nro_parte

ls_sql = "select zona_descarga as codigo, descripcion as nombre from ap_zona_descarga where flag_estado = '1'"

f_lista(ls_sql, ls_return1, ls_return2, '2')

if isnull(ls_return1) or trim(ls_return1) = '' then 
	this.event ue_delete( )
	return
end if

this.object.zona_descarga[al_row] = ls_return1
this.object.zona_descarga_descripcion[al_row] = ls_return2
end event

event doubleclicked;call super::doubleclicked;string ls_cols, ls_sql, ls_return1, ls_return2

if this.ii_protect = 1 or this.rowcount() < 1 then return

ls_cols = trim(lower(string(dwo.name)))

choose case ls_cols
	case 'zona_descarga'
		ls_sql = "select zona_descarga as codigo, descripcion as nombre from ap_zona_descarga where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.zona_descarga[row] = ls_return1
		this.object.zona_descarga_descripcion[row] = ls_return2
		this.ii_update = 1
end choose

end event

event itemchanged;call super::itemchanged;string ls_cols, ls_sql, ls_return1, ls_return2


this.accepttext()

ls_cols = trim(lower(string(dwo.name)))

choose case ls_cols
	case 'zona_descarga'
		select zona_descarga, descripcion 
		   into :ls_return1, :ls_return2
		   from ap_zona_descarga
			where flag_estado = '1'
			   and zona_descarga = :data;
		
		if sqlca.sqlcode = 100 then 
			messagebox(parent.title, 'No existe la zona de descarga ingresada')
		else
			this.object.zona_descarga[row] = ls_return1
			this.object.zona_descarga_descripcion[row] = ls_return2
		end if
		return 2
end choose

end event

event ue_delete;if of_firmas() >= 1 then
	return -1
end if

long ll_row = 1

ib_insert_mode = False

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

event ue_insert;if of_firmas() >= 1 then
	return -1
end if

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

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

type st_chata from statictext within w_pr303_parte_piso
integer x = 1938
integer y = 456
integer width = 1486
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Zona de Descarga"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type p_1 from picture within w_pr303_parte_piso
integer x = 1952
integer width = 430
integer height = 160
boolean bringtotop = true
string picturename = "H:\source\jpg\cajas.jpg"
boolean focusrectangle = false
end type

type em_nro_parte from singlelineedit within w_pr303_parte_piso
event dobleclick pbm_lbuttondblclk
integer x = 2944
integer y = 48
integer width = 434
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql


ls_sql = "SELECT p.nro_parte as Nro_Parte, " & 
		  +"f.formato, f.descripcion as Descripción, " &
		  +"p.fecha_parte " &
		  +"FROM TG_FMT_MED_ACT F, TG_PARTE_PISO P " &
		  +"WHERE P.FORMATO = F.FORMATO AND p.flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql,ls_codigo,ls_data,'1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	//em_descripcion.text = ls_data
end if
end event

event modified;//String 	ls_origen, ls_desc
//
//ls_origen = this.text
//if ls_origen = '' or IsNull(ls_origen) then
//	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
//	return
//end if
//
//SELECT nombre INTO :ls_desc
//FROM origen
//WHERE cod_origen =:ls_origen;
//
//IF SQLCA.SQLCode = 100 THEN
//	Messagebox('Aviso', 'Codigo de Origen no existe')
//	return
//end if
//
////em_descripcion.text = ls_desc
//
end event

type st_1 from statictext within w_pr303_parte_piso
integer x = 2423
integer y = 28
integer width = 448
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Número de Parte a mostrar"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pr303_parte_piso
integer width = 1925
integer height = 152
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_pr303_parte_piso
integer x = 2921
integer y = 4
integer width = 489
integer height = 136
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

