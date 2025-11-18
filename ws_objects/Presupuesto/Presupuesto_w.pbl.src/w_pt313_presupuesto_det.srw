$PBExportHeader$w_pt313_presupuesto_det.srw
forward
global type w_pt313_presupuesto_det from w_abc_master_smpl
end type
type st_1 from statictext within w_pt313_presupuesto_det
end type
type em_year from editmask within w_pt313_presupuesto_det
end type
type st_2 from statictext within w_pt313_presupuesto_det
end type
type em_cencos from editmask within w_pt313_presupuesto_det
end type
type st_3 from statictext within w_pt313_presupuesto_det
end type
type em_cnta from editmask within w_pt313_presupuesto_det
end type
type cb_cencos from commandbutton within w_pt313_presupuesto_det
end type
type cb_cnta from commandbutton within w_pt313_presupuesto_det
end type
type cb_1 from commandbutton within w_pt313_presupuesto_det
end type
type cb_2 from commandbutton within w_pt313_presupuesto_det
end type
end forward

global type w_pt313_presupuesto_det from w_abc_master_smpl
integer width = 2834
integer height = 1596
string title = "Detalle del Presupuesto Inicial (PT313)"
string menuname = "m_mantenimiento_cl"
st_1 st_1
em_year em_year
st_2 st_2
em_cencos em_cencos
st_3 st_3
em_cnta em_cnta
cb_cencos cb_cencos
cb_cnta cb_cnta
cb_1 cb_1
cb_2 cb_2
end type
global w_pt313_presupuesto_det w_pt313_presupuesto_det

type variables
Integer 	ii_year
string	is_cencos, is_cnta_prsp
Long		il_rows[], il_index
Decimal	idc_prc_cmp_ref

end variables

forward prototypes
public function integer of_set_numera ()
public function integer of_retrieve ()
public subroutine of_set_modify ()
public function integer of_limpiar ()
public function integer of_copiar_n_veces ()
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_long, ll_nro, ll_row, ll_count, ll_i
string	ls_mensaje, ls_nro, ls_null

SetNull(ls_null)

if dw_master.GetRow() = 0 then return 1

select count(*)
  into :ll_count
from num_presupuesto_det
where origen = :gs_origen;

if ll_count = 0 then
	Insert into num_presupuesto_det (origen, ult_nro)
	values( :gs_origen, 1);
			
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
			
	ll_nro = 1
else
	Select ult_nro 
		into :ll_nro 
	from num_presupuesto_det
	where origen = :gs_origen for update;
end if

il_index = 0

for ll_row = 1 to dw_master.RowCount()
	ls_nro = dw_master.object.nro_Asignacion [ll_row]
	
	if ls_nro = '' or IsNull(ls_nro) then
		// Asigna numero a cabecera
		ls_nro = String(ll_nro)	
		ll_long = 10 - len( TRIM(gs_origen))
		ls_nro = TRIM(gs_origen) + f_llena_caracteres('0',Trim(ls_nro),ll_long) 		
		
		// Incrementa contador
		ll_nro ++
		il_index ++
	
		dw_master.object.nro_asignacion[ll_row] = ls_nro
		il_rows[il_index] = ll_row
	end if

next

Update num_presupuesto_det 
	set ult_nro = :ll_nro 
 where origen = :gs_origen;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	of_limpiar()
	MessageBox('Aviso', ls_mensaje)
	return 0
end if

return 1
end function

public function integer of_retrieve ();//dw_master.Retrieve(ii_year, is_Cencos, is_cnta_prsp)
dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_master.retrieve(ii_year, is_Cencos, is_cnta_prsp )
return 1
end function

public subroutine of_set_modify ();string ls_nro_programa

//Cencos
dw_master.Modify("cencos.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("cencos.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Cnta Prsp
dw_master.Modify("cnta_prsp.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("cnta_prsp.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Cod_art
dw_master.Modify("cod_art.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("cod_art.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Servicio
dw_master.Modify("servicio.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("servicio.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Cantidad
dw_master.Modify("cantidad.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("cantidad.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Precio Unit
dw_master.Modify("costo_unit.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("costo_unit.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Mes
dw_master.Modify("mes_corresp.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("mes_corresp.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Comentarios
dw_master.Modify("comentario.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("comentario.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Fecha
dw_master.Modify("fecha.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("fecha.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Año
dw_master.Modify("ano.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("ano.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Tipo de Trabajador
dw_master.Modify("tipo_trabajador.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("tipo_trabajador.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Centro de Beneficio
dw_master.Modify("centro_benef.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("centro_benef.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

//Situacion Trabajador
dw_master.Modify("situa_trabaj.Protect ='1~tIf(IsNull(flag),1,0)'")
dw_master.Modify("situa_trabaj.Background.color ='1~tIf(IsNull(flag), RGB(192,192,192),RGB(255,255,255))'")

end subroutine

public function integer of_limpiar ();Long ll_i
String ls_null
SetNull(ls_null)

for ll_i = 1 to il_index
	dw_master.object.nro_asignacion[il_rows[ll_i]] = ls_null
next

return 1
end function

public function integer of_copiar_n_veces ();Long 	ll_nro_copias, ll_i, ll_row2, ll_row1
str_parametros lstr_param

if dw_master.GetRow() = 0 then 
	MessageBox('Error', 'Debe Seleccionar una fila')
	return 0
end if

ll_row1 = dw_master.GetRow()

if dw_master.object.flag_proceso[ll_row1] = 'A' then
	MessageBox('AViso', 'No puede duplicar un registro generado automáticamente')
	return 0
end if


Open(w_nro_copias)
if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return 0

lstr_param = Message.PowerObjectParm
if lstr_param.titulo = 'n' then return 0

ll_nro_copias = lstr_param.long1

for ll_i = 1 to ll_nro_copias
	ll_row2 = dw_master.event ue_insert()
	if ll_row2 > 0 then
		dw_master.object.ano 				[ll_row2] = dw_master.object.ano					[ll_row1]
		dw_master.object.cencos 			[ll_row2] = dw_master.object.cencos				[ll_row1]
		dw_master.object.desc_cencos 		[ll_row2] = dw_master.object.desc_cencos		[ll_row1]
		dw_master.object.cnta_prsp 		[ll_row2] = dw_master.object.cnta_prsp			[ll_row1]
		dw_master.object.desc_cnta_prsp 	[ll_row2] = dw_master.object.desc_cnta_prsp	[ll_row1]
		dw_master.object.servicio	 		[ll_row2] = dw_master.object.servicio			[ll_row1]
		dw_master.object.desc_servicio	[ll_row2] = dw_master.object.desc_servicio	[ll_row1]
		dw_master.object.cod_art 			[ll_row2] = dw_master.object.cod_art			[ll_row1]
		dw_master.object.desc_art 			[ll_row2] = dw_master.object.desc_art			[ll_row1]
		dw_master.object.und 				[ll_row2] = dw_master.object.und					[ll_row1]
		dw_master.object.cantidad 			[ll_row2] = 0
		dw_master.object.costo_unit 		[ll_row2] = 0
		dw_master.object.comentario 		[ll_row2] = dw_master.object.comentario		[ll_row1]
		dw_master.object.centro_benef		[ll_row2] = dw_master.object.centro_benef		[ll_row1]
		dw_master.object.desc_centro		[ll_row2] = dw_master.object.desc_centro		[ll_row1]
		dw_master.object.cod_origen		[ll_row2] = dw_master.object.cod_origen		[ll_row1]
		dw_master.object.tipo_trabajador	[ll_row2] = dw_master.object.tipo_trabajador	[ll_row1]
		dw_master.object.desc_tipo_trabajador	[ll_row2] = dw_master.object.desc_tipo_trabajador	[ll_row1]
		dw_master.object.situa_trabaj				[ll_row2] = dw_master.object.situa_trabaj				[ll_row1]
		dw_master.object.desc_situa_trabaj		[ll_row2] = dw_master.object.desc_situa_trabaj		[ll_row1]
		
		dw_master.ii_update = 1
	end if
next

dw_master.SetColumn('mes_corresp')
dw_master.SetFocus()

return 1
end function

on w_pt313_presupuesto_det.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.st_1=create st_1
this.em_year=create em_year
this.st_2=create st_2
this.em_cencos=create em_cencos
this.st_3=create st_3
this.em_cnta=create em_cnta
this.cb_cencos=create cb_cencos
this.cb_cnta=create cb_cnta
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_year
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_cencos
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_cnta
this.Control[iCurrent+7]=this.cb_cencos
this.Control[iCurrent+8]=this.cb_cnta
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.cb_2
end on

on w_pt313_presupuesto_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.st_2)
destroy(this.em_cencos)
destroy(this.st_3)
destroy(this.em_cnta)
destroy(this.cb_cencos)
destroy(this.cb_cnta)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
ib_log = TRUE

select NVL(precio_cmp_ref, -1)
	into :idc_prc_cmp_ref
from logparam
where reckey = '1';
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then		
	return
end if

if of_set_numera() = 0 then return

ib_update_check = True

dw_master.of_set_flag_replicacion()
end event

event ue_update;//Ancestor Overrding
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	//em_year
	of_retrieve()
else
	of_limpiar()
END IF

end event

event ue_modify;dw_master.of_protect()

if dw_master.ii_protect = 0 then
	of_set_modify()
end if
end event

event ue_insert;call super::ue_insert;of_set_modify()

end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_lista_presupuesto_partida"
sl_param.titulo = "Partidas"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	// Se ubica la cabecera
	
	ii_year 		= Long(sl_param.field_ret[1])
	is_cencos	= sl_param.field_ret[2]
	is_cnta_prsp= sl_param.field_ret[3]

	em_year.text 	= string(ii_year)
	em_cencos.text = is_cencos
	em_cnta.text	= is_cnta_prsp
	
	dw_master.Retrieve(ii_year, is_cencos, is_cnta_prsp)
END IF
end event

event ue_delete;//Ancestor Overrding

if dw_master.GetRow() = 0 then return

if dw_master.object.flag_proceso[dw_master.GetRow()] = 'A' then
	MessageBox('AViso', 'No puede eliminar un registro generado automáticamente')
	return
end if

Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_pt313_presupuesto_det
event ue_display ( string as_columna,  long al_row )
integer y = 124
integer width = 2743
integer height = 1260
string dataobject = "d_abc_presupuesto_det_tbl_x"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, &
			ls_null, ls_servicio, ls_und, ls_subcateg, &
			ls_cnta_prsp,ls_cod_art
			
Decimal	ldc_precio

this.AcceptText()
SetNull(ls_null)

choose case lower(as_columna)
		
	case "cencos"
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "where flag_estado = '1' " &
  				  + "order by cencos " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "centro_benef"
		ls_sql = "SELECT centro_benef AS centro_beneficio, " &
				  + "desc_centro AS descripcion_centro " &
				  + "FROM centro_beneficio " &
				  + "where flag_estado = '1' " &
  				  + "order by centro_benef " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro		[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'tipo_trabajador'
		ls_sql = "SELECT tipo_trabajador AS codigo_tipo, " &
				  + "DESC_TIPO_TRA AS descripcion_tipo " &
				  + "FROM tipo_trabajador " &
				  + "WHERE flag_estado = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_trabajador		[al_row] = ls_codigo
			this.object.desc_tipo_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if		

	case 'situa_trabaj'
		ls_sql = "SELECT SITUA_TRABAJ AS situacion_trabajador, " &
				  + "DESC_SIT_TRAB AS descripcion_situacion_trabajador " &
				  + "FROM situacion_trabajador " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.situa_trabaj		[al_row] = ls_codigo
			this.object.desc_situa_trabaj	[al_row] = ls_data
			this.ii_update = 1
		end if		

	case "cnta_prsp"
			ls_servicio = this.object.servicio [AL_row]
			ls_cod_art  = this.object.cod_art  [AL_row]
		
			if ((trim(ls_servicio) = '' or isNull(ls_servicio)) and (trim(ls_cod_art) = '' or isNull(ls_cod_art))) then
				ls_sql = "SELECT cnta_prsp AS CODIGO_cnta_prsp, " &
						  + "descripcion AS descripcion_cnta_prsp " &
						  + "FROM presupuesto_cuenta " &
						  + "where flag_estado = '1' " &
						  + "order by cnta_prsp " 
			elseif not((trim(ls_servicio) = '' or isNull(ls_servicio)) and (trim(ls_cod_art) = '' or isNull(ls_cod_art))) then
				MessageBox('Aviso', 'No puede seleccionar la cnta_prsp ya que ha elegido un tipo de servicio y tambien un articulo,Verifique')
				return				
			end if
		
		
		ls_sql = "SELECT cnta_prsp AS CODIGO_cnta_prsp, " &
				  + "descripcion AS descripcion_cnta_prsp " &
				  + "FROM presupuesto_cuenta " &
				  + "where flag_estado = '1' " &
  				  + "order by cnta_prsp " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_art"
		
		ls_sql = "SELECT cod_art AS CODIGO_articulo, " &
				  + "desc_art AS descripcion_articulo, " &
				  + "und AS unidad_articulo " &
				  + "FROM articulo " &
				  + "where flag_estado = '1' " &
				  + "and flag_inventariable = '1' " &
  				  + "order by cod_art " 

				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und, '1')
		
		//Obtengo el precio de ultima compra (si hubiera)
		select costo_ult_compra
			into :ldc_precio
		from articulo
		where cod_art = :ls_codigo;
		
		if IsNull(ldc_precio) then ldc_precio = idc_prc_cmp_ref

		if ldc_precio = idc_prc_cmp_ref then
			select USF_CMP_ULT_PREC_COTIZ(:ls_codigo)
			  into :ldc_precio
			  from dual;
			  
			if ldc_precio <= 0 then
				MessageBox('Aviso', 'Articulo ' + ls_codigo &
					+ ' no tiene precio de ultima compra y no ' &
					+ 'tiene cotizacion alguna, Por favor verifique')
				return
			end if
			
		end if

		if ls_codigo <> '' then
			this.object.cod_Art		[al_row] = ls_codigo
			this.object.desc_art		[al_row] = ls_data
			this.object.und			[al_row] = ls_und
			this.object.costo_unit	[al_row] = ldc_precio
				
			this.ii_update = 1
		end if
		
	case "servicio"
		
		ls_sql = "SELECT servicio AS CODIGO_servicio, " &
				  + "descripcion AS descripcion_servicio, " &
				  + "COD_SUB_CAT AS sub_categoria " &
				  + "FROM servicios " &
				  + "where flag_estado = '1' " &
  				  + "order by servicio " 

				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_subcateg, '1')
		
		if ls_codigo <> '' then
			this.object.servicio			[al_row] = ls_codigo
			this.object.desc_servicio	[al_row] = ls_data
			
			if ls_subcateg <> '' then
				select a.CNTA_PRSP_EGRESO, pc.descripcion
					into :ls_cnta_prsp, :ls_data
				from 	articulo_sub_Categ a,
						presupuesto_cuenta pc
				where pc.cnta_prsp = a.cnta_prsp_egreso
				  and a.COD_SUB_CAT = :ls_subcateg;
				
				if SQLCA.SQlCode = 100 then
					MessageBox('Aviso', 'Subcategoria no existe o no tiene una cuenta presupuestal de egreso asignado')
					return
				end if
				
				this.object.cnta_prsp		[al_row] = ls_cnta_prsp
				this.object.desc_cnta_prsp	[al_row] = ls_data
				
			end if
			this.ii_update = 1
			
		end if

end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_desc
this.object.cod_usr		[al_row] = gs_user
this.object.flag_proceso[al_row] = 'M'
this.object.fecha			[al_row] = date(f_fecha_Actual())
this.object.flag			[al_row] = '1'
this.object.cod_origen 	[al_row] = gs_origen

this.object.ano			[al_row] = ii_year

select desc_cencos
	into :ls_desc
from centros_costo
where cencos = :is_cencos;

this.object.cencos			[al_row] = is_cencos
this.object.desc_cencos		[al_row] = ls_desc

select descripcion
	into :ls_desc
from presupuesto_cuenta
where cnta_prsp = :is_cnta_prsp;

this.object.cnta_prsp		[al_row] = is_cnta_prsp
this.object.desc_cnta_prsp	[al_row] = ls_desc
end event

event dw_master::ue_delete;// Ancestor Script Overriding
long ll_row = 1

if this.object.flag_proceso[this.GetRow()] = 'A' then
	MessageBox('Aviso', 'No puedes borrar un registro generado de manera Automática')
	return 0
end if

ib_insert_mode = False

ll_row = THIS.DeleteRow (0)
IF ll_row = -1 then
	messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
ELSE
	il_totdel ++
	ii_update = 1								// indicador de actualizacion pendiente
	THIS.Event Post ue_delete_pos()
END IF

RETURN ll_row
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

if this.object.flag_proceso[row] = 'A' then
	MessageBox('Aviso', 'No puedes modificar un registro generado de manera automática')
	return
end if

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;boolean 	lb_ret
string 	ls_desc		 ,ls_codigo		,ls_almacen	, &
			ls_null		 ,ls_servicio	,ls_und		, &
			ls_subcateg	 ,ls_cnta_prsp ,ls_cod_art
Decimal	ldc_precio

this.AcceptText()
SetNull(ls_null)

choose case lower(dwo.name)
	 case "cencos"
			select desc_cencos into :ls_desc
			  from centros_costo 
			 where cencos = :data and flag_estado = '1' ;

	
			IF SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Centro de Costo no existe no esta activo')
				this.object.cencos 		[row] = ls_null
				this.object.desc_cencos [row] = ls_null
				return
			end if
	
			this.object.desc_cencos	[row] = ls_desc
		
	case "cnta_prsp"
			ls_servicio = this.object.servicio [row]
			ls_cod_art  = this.object.cod_art  [row]
		
			if ((trim(ls_servicio) = '' or isNull(ls_servicio)) and (trim(ls_cod_art) = '' or isNull(ls_cod_art))) then
				MessageBox('Aviso', 'No puede seleccionar la cnta_prsp ya que no ha elegido un tipo de servicio ni ningun articulo ,Verifique')
				return
			elseif not((trim(ls_servicio) = '' or isNull(ls_servicio)) and (trim(ls_cod_art) = '' or isNull(ls_cod_art))) then
				MessageBox('Aviso', 'No puede seleccionar la cnta_prsp ya que ha elegido un tipo de servicio y tambien un articulo,Verifique')
				return
				
			end if
			
		
		SELECT descripcion 
			into :ls_desc
		FROM presupuesto_cuenta 
		where cnta_prsp = :data
		  and flag_estado = '1';
		

		IF SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Cuenta presupuestal no existe no esta activo')
			this.object.cnta_prsp 		[row] = ls_null
			this.object.desc_cnta_prsp [row] = ls_null
			return
		end if
		
		this.object.desc_cnta_prsp	[row] = ls_desc
		
	case "cod_art"
		
		SELECT desc_art, und
			into :ls_desc, :ls_und
	  	FROM articulo 
		where flag_estado = '1'
		  and flag_inventariable = '1'
		  and cod_art = :data;
		  
		IF SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Codigo de articulo no existe, no esta activo')
			this.object.cod_art 	[row] = ls_null
			this.object.desc_art [row] = ls_null
			this.object.und 		[row] = ls_null
			return
		end if
		
		this.object.desc_art	[row] = ls_desc
		this.object.und		[row] = ls_und
			
		//Obtengo el precio de ultima compra (si hubiera)
		select costo_ult_compra
			into :ldc_precio
		from articulo
		where cod_art = :ls_codigo;
		
		if IsNull(ldc_precio) then ldc_precio = 0
		
		this.object.precio_unit[row] = ldc_precio
				
	case "servicio"
		
		SELECT descripcion, COD_SUB_CAT 
			into :ls_desc, :ls_subcateg
		FROM servicios 
		where flag_estado = '1'
		  and servicio = :data;

		IF SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Codigo de articulo no existe no esta activo')
			this.object.servicio 		[row] = ls_null
			this.object.desc_servicio 	[row] = ls_null
			return
		end if
				 
		this.object.desc_servicio	[row] = ls_desc
			
		if ls_subcateg <> '' then
			select a.CNTA_PRSP_EGRESO, pc.descripcion
				into :ls_cnta_prsp, :ls_desc
			from 	articulo_sub_Categ a,
					presupuesto_cuenta pc
			where pc.cnta_prsp = a.cnta_prsp_egreso
			  and a.COD_SUB_CAT = :ls_subcateg;
			
			if SQLCA.SQlCode = 100 then
				MessageBox('Aviso', 'Subcategoria no existe o no tiene una cuenta presupuestal de egreso asignado')
				return
			end if
			
			this.object.cnta_prsp		[row] = ls_cnta_prsp
			this.object.desc_cnta_prsp	[row] = ls_desc
			
		end if

	 case "centro_benef"
			select desc_centro 
				into :ls_desc
			  from centro_beneficio 		cb
			 where cb.centro_benef = :data 
			   and flag_estado = '1' ;

	
			IF SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Centro de Beneficio no existe no esta activo')
				this.object.cetro_benef	[row] = ls_null
				this.object.desc_centro [row] = ls_null
				return
			end if
	
			this.object.desc_cencos	[row] = ls_desc

	case 'tipo_trabajador'
			select DESC_TIPO_TRA 
				into :ls_desc
			  from tipo_trabajador
			 where tipo_trabajador = :data 
			   and flag_estado = '1' ;

	
			IF SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Tipo de Trabajador no existe no esta activo')
				this.object.tipo_trabajador	[row] = ls_null
				this.object.desc_tipo_trabajador [row] = ls_null
				return
			end if
	
			this.object.desc_tipo_trabajador	[row] = ls_desc
			
	case 'situa_trabaj'
			select DESC_SIT_TRAB 
				into :ls_desc
			  from situacion_trabajador
			 where SITUA_TRABAJ = :data;
	
			IF SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Tipo de Trabajador no existe no esta activo')
				this.object.situa_trabaj		[row] = ls_null
				this.object.desc_situa_trabaj [row] = ls_null
				return
			end if
	
			this.object.desc_situa_trabaj	[row] = ls_desc
			
end choose
end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

type st_1 from statictext within w_pt313_presupuesto_det
integer x = 23
integer y = 20
integer width = 142
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_pt313_presupuesto_det
integer x = 178
integer y = 8
integer width = 210
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_2 from statictext within w_pt313_presupuesto_det
integer x = 416
integer y = 20
integer width = 325
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Costo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cencos from editmask within w_pt313_presupuesto_det
integer x = 750
integer y = 8
integer width = 302
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_3 from statictext within w_pt313_presupuesto_det
integer x = 1138
integer y = 20
integer width = 320
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuenta Pres.:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cnta from editmask within w_pt313_presupuesto_det
integer x = 1477
integer y = 12
integer width = 343
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_cencos from commandbutton within w_pt313_presupuesto_det
integer x = 1065
integer y = 8
integer width = 73
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_year

ls_year = trim(em_year.text)

if ls_year = '' or IsNull(ls_year) then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

ls_sql = "select distinct b.cencos as codigo_cencos, " &
		 + "b.desc_cencos as descripcion_cencos " &
		 + "from presupuesto_partida a, " &
		 + "centros_costo b " &
		 + "where a.cencos = b.cencos " &
		 + "and a.ano = " + ls_year
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_cencos.text = ls_codigo
end if

end event

type cb_cnta from commandbutton within w_pt313_presupuesto_det
integer x = 1833
integer y = 8
integer width = 73
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_year, ls_cencos

ls_year = trim(em_year.text)

if ls_year = '' or IsNull(ls_year) then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

ls_cencos = trim(em_cencos.text)

if ls_cencos = '' or IsNull(ls_cencos) then
	MessageBox('Aviso', 'Debe especificar un centro de costo')
	return
end if

ls_sql = "select distinct b.cnta_prsp as codigo_cnta_prsp, " &
		 + "b.descripcion as descripcion_cnta_prsp " &
		 + "from presupuesto_partida a, " &
		 + "presupuesto_cuenta b " &
		 + "where a.cnta_prsp = b.cnta_prsp " &
		 + "and a.cencos = '" + ls_cencos + "' " &
		 + "and a.ano = " + ls_year
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

if ls_codigo <> '' then
	em_cnta.text = ls_codigo
end if
end event

type cb_1 from commandbutton within w_pt313_presupuesto_det
integer x = 1934
integer y = 12
integer width = 261
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;if em_year.text = '' then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

if em_cencos.text = '' then
	MessageBox('Aviso', 'Debe especificar un Centro de Costo')
	return
end if

if em_cnta.text = '' then
	MessageBox('Aviso', 'Debe especificar una Cuenta Presupuestal')
	return
end if

ii_year 			= Integer(em_year.text)
is_cencos 		= em_cencos.text
is_cnta_prsp 	= em_cnta.text

of_retrieve()

end event

type cb_2 from commandbutton within w_pt313_presupuesto_det
integer x = 2213
integer y = 12
integer width = 389
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copiar n Veces"
end type

event clicked;of_copiar_n_veces()

end event

