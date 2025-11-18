$PBExportHeader$w_pt317_proy_hrs_obrero.srw
forward
global type w_pt317_proy_hrs_obrero from w_abc_mastdet_smpl
end type
type em_ano from editmask within w_pt317_proy_hrs_obrero
end type
type st_1 from statictext within w_pt317_proy_hrs_obrero
end type
type cb_consultar from commandbutton within w_pt317_proy_hrs_obrero
end type
type cb_1 from commandbutton within w_pt317_proy_hrs_obrero
end type
type st_2 from statictext within w_pt317_proy_hrs_obrero
end type
type em_tcambio from editmask within w_pt317_proy_hrs_obrero
end type
type cb_2 from commandbutton within w_pt317_proy_hrs_obrero
end type
end forward

global type w_pt317_proy_hrs_obrero from w_abc_mastdet_smpl
integer width = 2587
integer height = 1816
string title = "Proyectos Horas Obrero (w_pt317)"
string menuname = "m_mantenimiento_sl"
event ue_retrieve ( )
event ue_copiar_mes ( )
event ue_act_tcambio ( )
event ue_procesar ( )
em_ano em_ano
st_1 st_1
cb_consultar cb_consultar
cb_1 cb_1
st_2 st_2
em_tcambio em_tcambio
cb_2 cb_2
end type
global w_pt317_proy_hrs_obrero w_pt317_proy_hrs_obrero

type variables
string is_soles, is_dolares, is_TIPO_TRAB_OBRERO
end variables

forward prototypes
public subroutine of_set_modify ()
public function integer of_act_monto (long al_row, long al_row_master)
end prototypes

event ue_retrieve();integer 	li_year
Decimal	ldc_tcambio

if em_ano.text = '' then
	MessageBox('Aviso', 'Debes ingresar un año válido')
end if

this.event ue_update_request( )

li_year = integer(em_ano.text)

dw_master.retrieve(li_year)

if dw_master.RowCount( ) > 0 then
	ldc_tcambio = Dec(dw_master.object.tipo_cambio[1])
	if ldc_tcambio = 0 or IsNull(ldc_tcambio) then
		SELECT NVL(t.cmp_dol_prom,0)
		 	into :ldc_tcambio
		FROM (SELECT *
				  FROM calendario 
				  ORDER BY fecha DESC) t
		WHERE ROWNUM = 1;
	end if
	em_tcambio.text = string(ldc_tcambio)
	if ldc_tcambio > 0 and not IsNull(ldc_tcambio) then
		this.event ue_act_tcambio( )
	end if;
end if
end event

event ue_copiar_mes();string 	ls_trab1, ls_trab2, ls_mensaje
Integer	li_mes1, li_mes2, li_count, li_year
Decimal	ldc_tcambio, ldc_sueldo
str_parametros lstr_param

ldc_tcambio = Dec(em_tcambio.text)

if ldc_tcambio = 0 or IsNull(ldc_tcambio) then
	MessageBox('Aviso', 'Debe Indicar algun Tipo de cambio')
	return
end if

if dw_master.GetRow() = 0 then
	MessageBox('Aviso', 'Debe seleccionar primero al trabajador Origen')
	return
end if

if dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
	MessageBox('Aviso', 'Debe primero grabar los cambios')
	return
end if

lstr_param.string1 = dw_master.object.cod_trabajador[dw_master.GetRow()]
lstr_param.string2 = dw_master.object.nom_trabajador[dw_master.GetRow()]
lstr_param.int1	 = Integer(em_ano.text)

openwithparm(w_get_datos_copia, lstr_param)

if IsNull(Message.Powerobjectparm) or Not IsValid(Message.Powerobjectparm) then return

lstr_param = Message.Powerobjectparm

if lstr_param.titulo = 'n' then return

ls_trab1 = lstr_param.string1
ls_trab2 = lstr_param.string2
li_mes1 	= lstr_param.int1
li_mes2 	= lstr_param.int2
li_year	= integer(em_ano.text)

//Verifico si existen datos de origen

select count(*)
  into :li_count
from prsp_proy_hrs_obrero_det
where ano = :li_year
  and cod_trabajador = :ls_trab1
  and mes between :li_mes1 and :li_mes2;

if li_count = 0 then
	MessageBox('Aviso', 'No existen datos de origen')
	return
end if

//Verifico si el trabajador de destino existe

select count(*)
  into :li_count
from prsp_proy_hrs_obrero
where ano = :li_year
  and cod_trabajador = :ls_trab1;

if li_count = 0 then
	MessageBox('Aviso', 'No existe Trabajador destino, por favor verifica')
	return
end if

ldc_sueldo	= Dec(dw_master.object.sueldo[dw_master.GetRow()])

//Elimino los datos del destino
delete prsp_proy_hrs_obrero_det
where ano = :li_year
  and cod_trabajador = :ls_trab2
  and mes between :li_mes2 and :li_mes2;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en delete', ls_mensaje)
	return
end if

//Ahora inserto los datos indicados
insert into prsp_proy_hrs_obrero_det(
	ano, cod_trabajador, mes, tipo_hora, cod_moneda, cant_horas,
	monto)
select :li_year, :ls_trab2, mes, tipo_hora, :is_dolares,
	cant_horas, 
	:ldc_sueldo/:ldc_tcambio
from 	prsp_proy_hrs_obrero_det
where ano = :li_year
  and cod_trabajador = :ls_trab1
  and mes between :li_mes1 and :li_mes2;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en insert', ls_mensaje)
	return
end if

commit;

MessageBox('Aviso', 'Proceso realizado satisfactoriamente')
end event

event ue_act_tcambio();Long ll_i
decimal ldc_tcambio
ldc_tcambio = Dec(em_tcambio.text)
if ldc_tcambio = 0 or IsNull(ldc_tcambio) then return

for ll_i = 1 to dw_master.RowCount( )
	if Dec(dw_master.object.tipo_cambio[ll_i]) = 0 or IsNull(dw_master.object.tipo_cambio[ll_i]) then
		dw_master.object.tipo_cambio[ll_i] = ldc_tcambio
		dw_master.ii_update = 1
	end if
	
next
end event

event ue_procesar();Long 		ll_i, ll_j
Integer	li_year
string	ls_trabajador
string 	ls_mon_orig, ls_mon_dest
decimal	ldc_sueldo, ldc_monto, ldc_factor, ldc_horas, ldc_tcambio

li_year = Integer(em_ano.text)

for ll_i = 1 to dw_master.Rowcount( )
	dw_master.SelectRow(0, False)
	dw_master.SelectRow(ll_i, True)
	ls_trabajador = dw_master.object.cod_trabajador[ll_i]
	dw_detail.retrieve(li_year, ls_trabajador )
	for ll_j = 1 to dw_detail.RowCount( )
		of_act_monto( ll_j, ll_i )
		dw_detail.ii_update = 1
	next
	this.event ue_update( )
next

end event

public subroutine of_set_modify ();//Año
dw_master.Modify("ano.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_master.Modify("ano.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")

//Codigo de trabajador
dw_master.Modify("cod_trabajador.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_master.Modify("cod_trabajador.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")

//Cencos
dw_master.Modify("cencos.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_master.Modify("cencos.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")

//Centro de Beneficio
dw_master.Modify("centro_benef.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_master.Modify("centro_benef.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")

//Tipo de Compromiso
dw_master.Modify("flag_tipo_compromiso.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_master.Modify("flag_tipo_compromiso.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")

//Mes
dw_detail.Modify("mes.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_detail.Modify("mes.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")

//Tipo Hora
dw_detail.Modify("tipo_hora.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_detail.Modify("tipo_hora.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")

//Cod_moneda
dw_detail.Modify("cod_moneda.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_detail.Modify("cod_moneda.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")

//cant_horas
dw_detail.Modify("cant_horas.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_detail.Modify("cant_horas.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")

//monto
dw_detail.Modify("monto.Protect ='1~tIf(flag_estado = ~~'2~~',1,0)'")
dw_detail.Modify("monto.Background.color ='1~tIf(flag_estado = ~~'2~~', RGB(192,192,192),RGB(255,255,255))'")


end subroutine

public function integer of_act_monto (long al_row, long al_row_master);string 	ls_mon_orig, ls_mon_dest
decimal	ldc_sueldo, ldc_monto, ldc_factor, ldc_horas, ldc_tcambio

dw_master.AcceptText()
dw_detail.AcceptText()

if dw_master.GetRow() = 0 then
	MessageBox('Aviso', 'No hay registros en la cabecera')
	return 0
end if

ls_mon_orig = dw_master.object.cod_moneda[al_row_master]
ldc_sueldo	= Dec(dw_master.object.sueldo[al_row_master])
ls_mon_dest	= dw_detail.object.cod_moneda[al_row]
ldc_factor 	= Dec(dw_detail.object.factor[al_row])
ldc_horas	= Dec(dw_detail.object.cant_horas[al_row])
ldc_tcambio = Dec(em_tcambio.text)

if ldc_tcambio = 0 or IsNull(ldc_tcambio) then 
	MessageBox('Aviso', 'Debe Ingresar un Tipo de Cambio válido')
	return 0
end if

ldc_monto = ldc_sueldo/240 * ldc_horas * ldc_factor

if ls_mon_orig <> ls_mon_dest then
	if ls_mon_orig = is_soles then
		ldc_monto = ldc_monto/ldc_tcambio
	elseif ls_mon_orig = is_dolares then
		ldc_monto = ldc_monto * ldc_tcambio
	end if
end if
	
dw_detail.object.monto[al_row] = ldc_monto

return 1
end function

on w_pt317_proy_hrs_obrero.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.em_ano=create em_ano
this.st_1=create st_1
this.cb_consultar=create cb_consultar
this.cb_1=create cb_1
this.st_2=create st_2
this.em_tcambio=create em_tcambio
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_consultar
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.em_tcambio
this.Control[iCurrent+7]=this.cb_2
end on

on w_pt317_proy_hrs_obrero.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_1)
destroy(this.cb_consultar)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.em_tcambio)
destroy(this.cb_2)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

select cod_soles, cod_dolares
	into :is_soles, :is_dolares
from logparam
where reckey = '1';

select TIPO_TRAB_OBRERO
  into :is_tipo_trab_obrero
  from rrhhparam
 where reckey = '1';

ii_lec_mst = 0   //hace que no se haga el retrieve del dw_master
end event

event ue_modify;call super::ue_modify;if dw_master.ii_protect = 0 then
	of_set_modify()
end if
end event

event ue_insert;//Ancestor Override
Long  	ll_row
Decimal	ldc_tcambio

ldc_tcambio = dec(em_tcambio.text)

if ldc_tcambio = 0 or IsNull(ldc_tcambio) then
	MessageBox('Aviso', 'Debe Indicar Tipo de Cambio previamente')
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pt317_proy_hrs_obrero
event ue_display ( string as_columna,  long al_row )
integer y = 180
integer width = 1975
integer height = 776
string dataobject = "d_abc_proy_hrs_obrero_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_cencos, &
			ls_desc_cencos, ls_cebe, ls_desc_cebe, ls_sueldo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_trabajador"
		ls_sql = "SELECT a.cod_trabajador AS codigo_trabajador, " &
				  + "a.nom_trabajador as nombre_trabajador, " &
				  + "cc.cencos as codigo_cencos, " &
				  + "cc.desc_cencos as descripcion_cencos, " &
				  + "cb.centro_benef as centro_beneficio, " &
				  + "cb.desc_centro as desc_centro_beneficio, " &
				  + "usf_pto_get_sueldo_fijo(a.cod_trabajador) as sueldo " &
				  + "FROM vw_pr_trabajador a, " &
				  + "centros_costo cc, " &
				  + "centro_beneficio cb " &
				  + "where cc.cencos (+) = a.cencos " &
				  + "and cb.centro_benef (+) = a.centro_benef " &
				  + "and tipo_trabajador = '" + is_tipo_trab_obrero + "'"

						 
		lb_ret = f_lista_7ret(ls_sql, ls_codigo, ls_data, ls_cencos, &
						ls_desc_cencos, ls_cebe, ls_desc_cebe, ls_sueldo, '2')
		
		if ls_codigo <> '' then
			this.object.cod_trabajador	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			this.object.cencos			[al_row] = ls_cencos
			this.object.desc_cencos		[al_row] = ls_desc_cencos
			this.object.centro_benef	[al_row] = ls_cebe
			this.object.desc_centro		[al_row] = ls_desc_cebe
			this.object.sueldo			[al_row] = dec(ls_sueldo)
			this.ii_update = 1
		end if
		
		return
		
	case "cencos"
		ls_sql = "SELECT cencos AS codigo_cencos, " &
				  + "desc_cencos as descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "where flag_estado = '1'"
						 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

	case "centro_benef"
		ls_sql = "SELECT centro_benef AS centro_beneficio, " &
				  + "desc_centro as descripcion_centro_beneficio " &
				  + "FROM centro_beneficio " &
				  + "where flag_estado = '1'"
						 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.usr_registra	[al_row] = gs_user
this.object.ano				[al_row] = integer(string(f_fecha_actual(), 'yyyy'))
this.object.flag_estado		[al_row] = '1'
this.object.cod_moneda		[al_row] = is_soles
this.object.flag_tipo_compromiso[al_row] = 'C'

of_set_modify()
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que recibimos del master
ii_dk[2] = 2 	      // columnas que recibimos del master



end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_null, ls_cencos, ls_desc_cencos, ls_cebe, ls_desc_cebe
decimal	ldc_sueldo, ldc_null

SetNull(ls_null)
SetNull(ldc_null)

this.AcceptText()

choose case lower(dwo.name)
	case "cod_trabajador"
		
		select 	a.nom_trabajador, cc.cencos, 
					cc.desc_cencos, cb.centro_benef, 
					cb.desc_centro, 
					usf_pto_get_sueldo_fijo(a.cod_trabajador)
			into 	:ls_data, :ls_cencos, :ls_desc_cencos, 
					:ls_cebe, :ls_desc_cebe, :ldc_sueldo
		from 	vw_pr_trabajador 	a,
				centros_costo		cc,
				centro_beneficio	cb
		where cc.cencos (+) = a.cencos
		  and cb.centro_benef (+) = a.centro_benef
		  and a.cod_trabajador = :data
		  and a.flag_estado = '1'
		  and a.tipo_trabajador = :is_tipo_trab_obrero ;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Trabajador no existe, no está activo o no corresponde a un trabajador de tipo OBRERO", StopSign!)
			this.object.cod_trabajador	[row] = ls_null
			this.object.nom_trabajador	[row] = ls_null
			this.object.cencos			[row] = ls_null
			this.object.desc_cencos		[row] = ls_null
			this.object.centro_benef	[row] = ls_null
			this.object.desc_centro		[row] = ls_null
			this.object.sueldo			[row] = ldc_null
			return 1
		end if

		this.object.nom_trabajador	[row] = ls_data
		this.object.cencos			[row] = ls_cencos
		this.object.desc_cencos		[row] = ls_desc_cencos
		this.object.centro_benef	[row] = ls_cebe
		this.object.desc_centro		[row] = ls_desc_cebe
		this.object.sueldo			[row] = ldc_sueldo
		
	case "cencos"
		select desc_cencos
			into :ls_data
		from 	centros_costo
		where cencos = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Centro de Costo no existe o no está activo", StopSign!)
			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
		end if

		this.object.desc_cencos		[row] = ls_data
		
	case "centro_benef"
		select desc_centro
			into :ls_data
		from 	centro_beneficio
		where centro_benef = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Centro de Beneficio no existe o no está activo", StopSign!)
			this.object.centro_benef	[row] = ls_null
			this.object.desc_centro		[row] = ls_null
			return 1
		end if

		this.object.desc_centro		[row] = ls_data
		
end choose
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)


end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pt317_proy_hrs_obrero
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 964
integer width = 1979
integer height = 652
string dataobject = "d_proy_hrs_obreros_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_factor
decimal	ldc_null
Long 		ll_row_master

this.AcceptText()

ll_row_master = dw_master.GetRow()

choose case lower(as_columna)
		
	case "tipo_hora"
		ls_sql = "SELECT tipo_hora AS tipo_hora, " &
				  + "DESC_TIPO_HORA AS DESC_TIPO_HORA, " &
				  + "to_char(factor) as factor " &
				  + "FROM prsp_factor_tipo_hora " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_factor, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_hora		[al_row] = ls_codigo
			this.object.DESC_TIPO_HORA	[al_row] = ls_data
			this.object.factor			[al_row] = dec(ls_factor)
			of_act_monto(al_row, ll_row_master)
			this.ii_update = 1
		end if
		
		return

	case "cod_moneda"
		ls_sql = "SELECT cod_moneda AS codigo_moneda, " &
				  + "descripcion AS descripcion_moneda " &
				  + "FROM moneda " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_moneda				[al_row] = ls_codigo
			of_act_monto(al_row, ll_row_master)
			this.ii_update = 1
		end if
		
		return

end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master



end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::itemchanged;call super::itemchanged;string 	ls_data, ls_null
decimal	ldc_factor, ldc_null
Long 		ll_row_master

SetNull(ls_null)
SetNull(ldc_null)

this.AcceptText()

ll_row_master = dw_master.GetRow()

choose case lower(dwo.name)
	case "tipo_hora"
		select desc_tipo_hora, factor
			into :ls_data, :ldc_factor
		from prsp_factor_tipo_hora
		where tipo_hora = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Tipo de Hora no existe o no está activo", StopSign!)
			this.object.tipo_hora		[row] = ls_null
			this.object.desc_tipo_hora	[row] = ls_null
			this.object.factor			[row] = ldc_null
			return 1
		end if

		this.object.desc_tipo_hora	[row] = ls_data
		this.object.factor			[row] = ldc_factor
		of_act_monto(row, ll_row_master)
		
	case "cod_moneda"
		
		select descripcion
			into :ls_data
		from moneda
		where cod_moneda = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Moneda no existe o no está activo", StopSign!)
			this.object.cod_moneda	[row] = ls_null
			return 1
		end if
		
		of_act_monto(row, ll_row_master)
		
	case "cant_horas"
		of_act_monto(row, ll_row_master)
end choose


end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;of_set_modify()
this.object.flag_estado [al_row] = dw_master.object.flag_estado[dw_master.GetRow()]
this.object.cod_moneda 	[al_row] = is_dolares

if al_row > 1 then
	this.object.mes[al_row] = this.object.mes[al_row - 1]
end if

this.SetColumn('mes')
end event

type em_ano from editmask within w_pt317_proy_hrs_obrero
integer x = 201
integer y = 48
integer width = 297
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

event constructor;this.text = string(f_fecha_Actual(), 'yyyy')
end event

type st_1 from statictext within w_pt317_proy_hrs_obrero
integer x = 41
integer y = 56
integer width = 160
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type cb_consultar from commandbutton within w_pt317_proy_hrs_obrero
integer x = 1312
integer y = 48
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Consultar"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type cb_1 from commandbutton within w_pt317_proy_hrs_obrero
integer x = 2016
integer y = 48
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copiar Datos"
end type

event clicked;parent.dynamic event ue_copiar_mes()
end event

type st_2 from statictext within w_pt317_proy_hrs_obrero
integer x = 521
integer y = 60
integer width = 160
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "T.C.:"
boolean focusrectangle = false
end type

type em_tcambio from editmask within w_pt317_proy_hrs_obrero
integer x = 686
integer y = 52
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = decimalmask!
string mask = "###,###.0000"
end type

event modified;parent.event ue_act_tcambio( )
end event

type cb_2 from commandbutton within w_pt317_proy_hrs_obrero
integer x = 1664
integer y = 48
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;parent.event ue_procesar( )
end event

