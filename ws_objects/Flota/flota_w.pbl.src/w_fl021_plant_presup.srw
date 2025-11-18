$PBExportHeader$w_fl021_plant_presup.srw
forward
global type w_fl021_plant_presup from w_abc_mastdet_smpl
end type
end forward

global type w_fl021_plant_presup from w_abc_mastdet_smpl
integer width = 3072
integer height = 1788
string title = "Plantilla de Ratios Presupuestales (FL021)"
string menuname = "m_mto_smpl"
end type
global w_fl021_plant_presup w_fl021_plant_presup

forward prototypes
public function boolean of_validar_plant_det (string as_cencos, string as_cntaprsp, string as_plantilla)
end prototypes

public function boolean of_validar_plant_det (string as_cencos, string as_cntaprsp, string as_plantilla);string ls_cencos, ls_cntaprsp, ls_mensaje
long ll_row
integer li_ok

if IsNull(as_cencos) or trim(as_cencos) = '' &
	or IsNull(as_cntaprsp) or trim(as_cntaprsp) = '' then
	return true
end if
for ll_row = 1 to dw_detail.RowCount()
	ls_cencos 	= trim( dw_detail.object.cencos[ll_row] )
	ls_cntaprsp = trim( dw_detail.object.cnta_prsp[ll_row] )
	if trim(ls_cencos) = trim(as_cencos) &
		and trim(ls_cntaprsp) = trim(as_cntaprsp) then
		
		return false
		
	end if

next

//create or replace procedure USP_FL_VALIDA_PLANT_DET(
//		asi_cencos 		in centros_costo.cencos%TYPE, 
//    asi_cntaprsp 	in presupuesto_cuenta.cnta_prsp%TYPE, 
//    asi_plant 		in fl_plant_presup.cod_fl_plantilla%TYPE,
//   	aso_mensaje 	out varchar2,
//    aio_ok      	out number) is

DECLARE USP_FL_VALIDA_PLANT_DET PROCEDURE FOR
	USP_FL_VALIDA_PLANT_DET( :as_cencos, 
		:as_cntaprsp, :as_plantilla );

EXECUTE USP_FL_VALIDA_PLANT_DET;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_VALIDA_PLANT_DET: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

FETCH USP_FL_VALIDA_PLANT_DET INTO :ls_mensaje, :li_ok;
CLOSE USP_FL_VALIDA_PLANT_DET;

if li_ok <> 1 then
	MessageBox('Error de validacion', ls_mensaje, StopSign!)	
	return false
end if

return true


end function

on w_fl021_plant_presup.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl021_plant_presup.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;Long 		ll_x, ll_row[]
string	ls_cencos, ls_cntaprsp
decimal  ln_ratio

of_get_row_update(dw_detail, ll_row[])

ib_update_check = true

For ll_x = 1 TO UpperBound(ll_row)
	//Validar registro ll_x
	ls_cencos 	= trim( dw_detail.object.cencos[ll_row[ll_x]] )
	ls_cntaprsp = trim( dw_detail.object.cnta_prsp[ll_row[ll_x]] )
	ln_ratio		= dec( dw_detail.object.ratio[ll_row[ll_x]] )
	
	
	IF IsNull(ls_cencos) or ls_cencos = '' THEN
		MessageBox('ERROR', 'DETALLE: CENTRO DE COSTO ESTA VACIO', StopSign!  )
		ib_update_check = False
		exit
	END IF
	
	IF IsNull(ls_cntaprsp) or ls_cntaprsp = '' THEN
		MessageBox('ERROR', 'DETALLE: CUENTA PRESUPUESTAL ESTA VACIO', StopSign!  )
		ib_update_check = False
		exit
	END IF
	
	IF IsNull(ln_ratio) or ln_ratio = 0.00 THEN
		MessageBox('ERROR', 'DETALLE: EL RATIO NO DEBE SER CERO', StopSign!  )
		ib_update_check = False
		exit
	END IF

NEXT

if not ib_update_check then
	dw_detail.SelectRow(0, false)
	dw_detail.SelectRow(ll_row[ll_x], true)
	dw_detail.SetRow(ll_row[ll_x])
	dw_detail.SetFocus()
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE		// Para guardar un log de los cambios realizados
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fl021_plant_presup
integer width = 3008
integer height = 588
string dataobject = "d_plant_presup_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_insert;call super::ue_insert;integer li_row
string  ls_codigo
date ld_fecha

DECLARE pb_usf_cod_plant_presup PROCEDURE FOR
USF_COD_PLANT_PRESUP( :gs_origen );

EXECUTE pb_usf_cod_plant_presup;

IF SQLCA.sqlcode = -1 THEN
	MessageBox('SQL error', SQLCA.SQLErrText)	
	Rollback ;
	Return -1
END IF

FETCH pb_usf_cod_plant_presup INTO :ls_codigo ;
CLOSE pb_usf_cod_plant_presup ;

ld_fecha = Today()

li_row = this.GetRow()
this.object.origen[li_row] 	  				= gs_origen
this.object.cod_fl_plantilla[li_row] 		= ls_codigo
this.object.Fecha_registro[li_row] 			= ld_fecha
this.object.Fecha_inicio_vigencia[li_row] = ld_fecha
this.object.Fecha_fin_vigencia[li_row] 	= ld_fecha

return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_imagen
long ll_row, ll_count

this.AcceptText()
ll_row = this.GetRow()
choose case upper(dwo.name)
	case "UNID"
		
		ls_codigo = this.object.unid[ll_row]
		
		SetNull(ls_data)
		select desc_unidad
			into :ls_data
		from unidad
		where und = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "UNIDAD DE MEDIDA NO EXISTE", StopSign!)
			return 1
		end if
		
		this.object.desc_unidad[ll_row] = ls_data

end choose

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_codigo, ls_data, ls_sql
long ll_row, ll_count
integer li_i
str_seleccionar lstr_seleccionar

this.AcceptText()
ll_row = this.GetRow()
If this.Describe(dwo.Name + ".protect") = '1' then RETURN

choose case upper(dwo.name)
		
	case "UNID"

		ls_sql = "SELECT UND AS CODIGO, " &
				 + "DESC_UNIDAD AS DESCRIPCION " &
             + "FROM UNIDAD"	
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = lstr_seleccionar.param2[1]
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UNA UNIDAD DE MEDIDA", StopSign!)
			return 1
		end if

		this.object.desc_unidad[ll_row] 	= ls_data		
		this.object.unid[ll_row] 	  		= ls_codigo

end choose

end event

event dw_master::constructor;call super::constructor;ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
		
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fl021_plant_presup
event ue_display ( string as_columna,  long al_row )
integer y = 612
integer width = 3003
integer height = 928
string dataobject = "d_plant_presup_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = StyleRaised!
end type

event dw_detail::ue_display(string as_columna, long al_row);string ls_codigo, ls_data, ls_sql, ls_plantilla, ls_cencos
long ll_count
integer li_i
str_seleccionar lstr_seleccionar

this.AcceptText()
choose case upper(as_columna)
		
	case "CNTA_PRSP"

		ls_sql = "SELECT CNTA_PRSP AS CODIGO, " &
				 + "DESCRIPCION AS CUENTA_PRESUP " &
             + "FROM PRESUPUESTO_CUENTA"	
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = lstr_seleccionar.param2[1]
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UNA CUENTA PRESUPUESTAL", StopSign!)
			return
		end if
		
		ls_cencos 	 = trim( this.object.cencos[al_row] )
		ls_plantilla = trim( this.object.cod_fl_plantilla[al_row] )
		
		if not parent.of_validar_plant_det( ls_cencos, ls_codigo, ls_plantilla ) then 
			MessageBox('Error', 'CUENTA PRESUPUESTAL YA ESTA ASIGNADA A OTRA PLANTILLA', StopSign! )
			this.object.cnta_prsp[al_row] = ''
			return 
		end if


		this.object.descr_cuenta[al_row] 	= ls_data		
		this.object.cnta_prsp[al_row] 	  	= ls_codigo

	case "CENCOS"

		ls_sql = "SELECT CENCOS AS CODIGO, " &
				 + "DESC_CENCOS AS CUENTA_PRESUP " &
             + "FROM CENTROS_COSTO " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = lstr_seleccionar.param2[1]
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE CENTRO DE COSTO", StopSign!)
			return
		end if
		
		ls_cencos 	 = ls_codigo
		ls_codigo	 = trim( this.object.cnta_prsp[al_row] )
		ls_plantilla = trim( this.object.cod_fl_plantilla[al_row] )
		
		if not parent.of_validar_plant_det( ls_cencos, ls_codigo, ls_plantilla ) then 
			MessageBox('Error', 'CENTRO DE COSTOS YA ESTA ASIGNADO A OTRA PLANTILLA', StopSign! )
			this.object.cnta_prsp[al_row] = ''
			return 
		end if

		this.object.desc_cencos[al_row] 	= ls_data		
		this.object.cencos[al_row] 	  	= ls_cencos

end choose

end event

event dw_detail::constructor;call super::constructor;//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 	dw_master
idw_det  =  dw_detail
end event

event dw_detail::itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_imagen, ls_plantilla
string ls_cencos
string ls_estado
long ll_row, ll_count

this.AcceptText()
ll_row = this.GetRow()
choose case upper(dwo.name)
	case "CNTA_PRSP"
		
		ls_codigo = this.object.cnta_prsp[ll_row]
		
		SetNull(ls_data)
		select descripcion
			into :ls_data
		from presupuesto_cuenta
		where cnta_prsp = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "CUENTA PRESUPUESTAL NO EXISTE", StopSign!)
			this.object.cnta_prsp[ll_row] = ''
			this.SetColumn(2)
			return 2
		end if

		ls_cencos 	 = trim( this.object.cencos[ll_row] )
		ls_plantilla = trim( this.object.cod_fl_plantilla[ll_row] )
		
		if not parent.of_validar_plant_det( ls_cencos, ls_codigo, ls_plantilla ) then 
			MessageBox('Error', 'CUENTAS PRESUPUESTAL YA FUE ASIGNADA', StopSign! )
			this.object.cnta_prsp[ll_row] = ''
			this.SetColumn(2)
			return 2
		end if

		this.object.descr_cuenta[ll_row] = ls_data

	case "CENCOS"
		
		ls_codigo = this.object.cencos[ll_row]
		
		SetNull(ls_data)
		select desc_cencos, flag_estado
			into :ls_data, :ls_estado
		from centros_costo
		where cencos = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "CENTRO DE COSTO NO EXISTE", StopSign!)
			return 1
		end if
		
		if ls_estado <> '1' then
			Messagebox('Error', "CENTRO DE COSTO NO ESTA ACTIVO", StopSign!)
			this.object.cnta_prsp[ll_row] = ''
			this.SetColumn(3)
			return 2
		end if
		
		ls_cencos 	 = ls_codigo
		ls_codigo    = trim( this.object.cnta_prsp[ll_row] )
		ls_plantilla = trim( this.object.cod_fl_plantilla[ll_row] )
		
		if not parent.of_validar_plant_det( ls_cencos, ls_codigo, ls_plantilla ) then 
			MessageBox('Error', 'CENTRO DE COSTO  YA FUE ASIGNADO', StopSign! )
			this.object.cencos[ll_row] = ''
			this.SetColumn(3)
			return 2
		end if

		this.object.desc_cencos[ll_row] = ls_data

end choose

end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_codigo, ls_data, ls_sql, ls_columna
long ll_row, ll_count
integer li_i, li_ano, li_mes
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = this.GetRow()
if ll_row <= 0 then
	return
end if
ls_columna = upper(dwo.name)

this.event ue_display(ls_columna, ll_row)

end event

event dw_detail::keydwn;call super::keydwn;string ls_columna, ls_cadena
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
	 	this.event ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;string 	ls_cencos, ls_desc_cencos
long 		ll_item
if al_row > 1 then
	ls_cencos = trim( this.object.cencos[al_row - 1] )
	ll_item	 = long( this.object.item[al_row - 1] )
	
	select desc_cencos
		into :ls_desc_cencos
	from centros_costo
	where cencos = :ls_cencos;
	
	this.object.item[al_row] 			= ll_item +1
	this.object.cencos[al_row] 		= ls_cencos
	this.object.desc_cencos[al_row] 	= ls_desc_cencos
	this.object.ratio[al_row] 			= 0.0
	
end if
end event

