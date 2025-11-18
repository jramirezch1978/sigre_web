$PBExportHeader$w_fl310_bitacora.srw
forward
global type w_fl310_bitacora from w_abc_mastdet_smpl
end type
type uo_1 from u_rango_datetime within w_fl310_bitacora
end type
type st_nomb_nave from statictext within w_fl310_bitacora
end type
type st_1 from statictext within w_fl310_bitacora
end type
type sle_nave from singlelineedit within w_fl310_bitacora
end type
type pb_retrieve from picturebutton within w_fl310_bitacora
end type
end forward

global type w_fl310_bitacora from w_abc_mastdet_smpl
integer width = 3470
integer height = 2020
string title = "Registro de bitácoras (FL310)"
string menuname = "m_mto_smpl"
event ue_retrieve ( )
event ue_act_menu ( boolean ab_estado )
uo_1 uo_1
st_nomb_nave st_nomb_nave
st_1 st_1
sle_nave sle_nave
pb_retrieve pb_retrieve
end type
global w_fl310_bitacora w_fl310_bitacora

type variables
string is_parte, is_nave
long il_count
end variables

forward prototypes
public function boolean of_lista (string as_sql, ref string as_codigo, ref string as_data, string as_columna)
end prototypes

event ue_retrieve();datetime ldt_incio, ldt_final

ldt_incio = uo_1.of_get_fecha1()
ldt_final = uo_1.of_get_fecha2()
is_nave = trim(sle_nave.text)

if is_nave = '' or IsNull(is_nave) then
	MessageBox('ERROR', 'CODIGO DE NAVE ESTA EN BLANCO', StopSign!)
	return
end if

dw_master.retrieve(is_nave, ldt_incio, ldt_final)

dw_master.ii_protect = 0
dw_master.of_protect()
dw_detail.ii_protect = 0
dw_detail.of_protect()


this.event dynamic ue_act_menu(true)

end event

event ue_act_menu(boolean ab_estado);this.MenuId.item[1].item[1].item[2].enabled = ab_estado
this.MenuId.item[1].item[1].item[3].enabled = ab_estado
this.MenuId.item[1].item[1].item[4].enabled = ab_estado
this.MenuId.item[1].item[1].item[5].enabled = ab_estado

this.MenuId.item[1].item[1].item[2].visible = ab_estado
this.MenuId.item[1].item[1].item[3].visible = ab_estado
this.MenuId.item[1].item[1].item[4].visible = ab_estado
this.MenuId.item[1].item[1].item[5].visible = ab_estado


this.MenuId.item[1].item[1].item[2].ToolbarItemvisible = ab_estado
this.MenuId.item[1].item[1].item[3].ToolbarItemvisible = ab_estado
this.MenuId.item[1].item[1].item[4].ToolbarItemvisible = ab_estado
this.MenuId.item[1].item[1].item[5].ToolbarItemvisible = ab_estado
end event

public function boolean of_lista (string as_sql, ref string as_codigo, ref string as_data, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_codigo = trim(lstr_seleccionar.param1[1])
		as_data = string(lstr_seleccionar.param2[1])
	ELSE
		Messagebox('Flota', "DEBE SELECCIONAR ALGUN ITEM", StopSign!)
		as_data = ''
		as_codigo = ''
	end if
	return true
else
	return false
END IF
end function

on w_fl310_bitacora.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.uo_1=create uo_1
this.st_nomb_nave=create st_nomb_nave
this.st_1=create st_1
this.sle_nave=create sle_nave
this.pb_retrieve=create pb_retrieve
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.st_nomb_nave
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_nave
this.Control[iCurrent+5]=this.pb_retrieve
end on

on w_fl310_bitacora.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.st_nomb_nave)
destroy(this.st_1)
destroy(this.sle_nave)
destroy(this.pb_retrieve)
end on

event ue_open_pre;call super::ue_open_pre;string ls_data
str_parametros lstr_param

this.event dynamic ue_act_menu(false)

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

dw_master.ii_protect = 0
dw_detail.ii_protect = 0
dw_master.of_protect()         		// bloquear modificaciones 
dw_detail.of_protect()

ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
ii_consulta = 1                      // 1 = la lista de consulta es gobernada por el sistema de acceso
ii_access = 2								// 0 = menu (default), 1 = botones, 2 = menu + botones
ii_lec_mst = 0

SetNull(is_parte)
SetNull(is_nave)

if Isvalid(Message.PowerObjectParm)   then
	if Message.PowerObjectParm.ClassName() = 'str_parametros' THEN

		lstr_param = Message.PowerObjectParm

		if len(lstr_param.string1) > 0 then
			this.is_parte = lstr_param.string1
		end if
		
		if len(lstr_param.string2) > 0 then
			this.is_nave  = lstr_param.string2	
		
			sle_nave.text = this.is_nave
		
			select nomb_nave
				into :ls_data
			from tg_naves
			where nave = :this.is_nave;
			
			st_nomb_nave.text = ls_data
		
			this.event dynamic ue_retrieve()
		end if
	end if
end if

end event

event ue_modify;call super::ue_modify;dw_master.ii_update = 1 
dw_detail.ii_update = 1
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_update_pre;call super::ue_update_pre;string ls_tmp, ls_mensaje
Long 		ll_x, ll_row[]

ib_update_check = True

of_get_row_update(dw_master, ll_row[])

For ll_x = 1 TO UpperBound(ll_row)
//	Validar registro ll_x
	ls_tmp = dw_master.object.nave[ll_row[ll_x]]
	
	IF IsNull(ls_tmp) or ls_tmp = '' THEN
		MessageBox('ERROR', 'DEBE COLOCAR UN CODIGO DE NAVE', StopSign!  )
		ib_update_check = False
		exit
	END IF
	
	ls_tmp = dw_master.object.motivo_movimiento[ll_row[ll_x]]
	
	IF IsNull(ls_tmp) or ls_tmp = '' THEN
		MessageBox('ERROR', 'MOTIVO DE MOVIMIENTO ESTA EN BLANCO', StopSign!  )
		ib_update_check = False
		exit
	END IF

NEXT

if not ib_update_check then
	dw_master.ScrolltoRow(ll_row[ll_x])
	dw_master.SelectRow(0, false)
	dw_master.SelectRow(ll_row[ll_x], true)
	return
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_query_retrieve;this.event dynamic ue_retrieve()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fl310_bitacora
event ue_display ( string as_columna,  long al_row )
event ue_parte_zarpe ( long al_row,  string as_nave )
integer x = 0
integer y = 160
integer width = 3419
integer height = 960
integer taborder = 40
string dataobject = "d_bitacora_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
long ll_count
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "NAVE"
		
		ls_sql = "select tn.nomb_nave as nave, " &
				  + "tn.nave as codigo " &
				  + "from tg_naves tn " &
				  + "where flag_tipo_flota = 'P'"
				 
		lb_ret = parent.of_lista(ls_sql, ls_data, &
					ls_codigo, '1')
					
		this.object.nave[al_row] = ls_codigo
		this.object.nomb_nave[al_row] = ls_data
		
		this.ii_update = 1
		
	case "MOTIVO_MOVIMIENTO"

		ls_sql = "select descr_situacion as motivo_movimiento, " &
				 + "motivo_movimiento as codigo " &
				 + "from fl_motivo_movimiento " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = parent.of_lista(ls_sql, ls_data, &
					ls_codigo, '1')
		
		this.object.motivo_movimiento[al_row] = ls_codigo
		this.object.descr_situacion[al_row] = ls_data
		
		this.ii_update = 1

		
end choose
end event

event dw_master::ue_parte_zarpe(long al_row, string as_nave);if IsNull(is_Parte) then
	
	select parte_pesca
		into :is_parte
	from fl_parte_de_pesca
	where nave_real = :as_nave
	  and fecha_hora_arribo is null;
	  
	if SQLCA.SQLCode = 100 then
		SetNull(is_parte)
		MessageBox('FLOTA', 'NO HAY PARTE DE PESCA ' &
				+ 'ABIERTO PARA LA NAVE: ' + as_nave + ', ' &
				+ 'SE PROCEDE A COLOCARLO COMO VEDA ' &
				+ 'O VARADERO', StopSign!)

	end if
end if

this.object.parte_pesca[al_row] = is_parte


end event

event dw_master::constructor;call super::constructor;ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
idw_det = dw_detail
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

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_master::itemchanged;call super::itemchanged;long ll_row
string ls_columna, ls_cadena, ls_code, ls_desc, ls_parte_pesca
datetime ldt_fecha_hora_reg

this.AcceptText()

ls_columna = dwo.name
ll_row = this.GetRow()

SetNull(ls_desc)

choose case ls_columna
	case 'motivo_movimiento'
		ls_code = this.object.motivo_movimiento[ll_row]
		
		select descr_situacion 
			into :ls_desc 
			from fl_motivo_movimiento
			where motivo_movimiento = :ls_code;
		
		if IsNull(ls_desc) or ls_desc='' then
			messagebox('Flota','NO EXISTE MOTIVO DE TRASLADO '+trim(ls_code),StopSign!)
			SetNull(ls_code)
			SetNull(ls_desc)
			this.object.motivo_movimiento[ll_row] = ls_code
			this.object.descr_situacion[ll_row] = ls_desc
			return 1
		else
			this.object.motivo_movimiento[ll_row] = ls_code
			this.object.descr_situacion[ll_row] = ls_desc
		end if
end choose
end event

event dw_master::ue_output;call super::ue_output;if al_row > 0 then
	THIS.EVENT ue_retrieve_det(al_row)
end if

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;DateTime ldt_fecha
string ls_codigo, ls_data, ls_mensaje

//create or replace function usf_fl_numera_bitacora (
//       as_origen in string) return varchar2 

if IsNull(is_nave) or is_nave = '' then
	MessageBox('FLOTA', 'IS_NAVE ESTA EN BLANCO', StopSign!)
	return
end if

DECLARE usf_fl_numera_bitacora PROCEDURE FOR
	usf_fl_numera_bitacora( :gs_origen );

EXECUTE usf_fl_numera_bitacora;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usf_fl_numera_bitacora: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH usf_fl_numera_bitacora INTO :ls_codigo;
CLOSE usf_fl_numera_bitacora;

ldt_fecha = DateTime(Today(), Now())

this.object.registro_bitacora	[al_row] = ls_codigo
this.object.fecha_hora_reg		[al_row] = ldt_fecha
this.object.origen				[al_row] = gs_origen

this.object.horas_recorrido	[al_row] = 0.00
this.object.distancia_puerto	[al_row] = 0.00
this.object.velocidad			[al_row] = 0.00

this.event ue_parte_zarpe(al_row, is_nave)


select nomb_nave
	into :ls_data
from tg_naves
where nave = :is_nave;
	
this.object.nave[al_row] 		= is_nave
this.object.nomb_nave[al_row] = ls_data 


end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fl310_bitacora
event ue_display ( string as_columna,  long al_row )
integer x = 5
integer y = 1128
integer width = 3419
integer height = 568
integer taborder = 50
string dataobject = "d_bitacora_calas_tbl"
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean lb_ret
integer li_cadena
string ls_codigo, ls_data
string ls_sql

choose case lower(as_columna)
	case 'zona_pesca'
		ls_sql = "select zp.descr_zona as nombre, " &
				 + "zp.zona_pesca as codigo " &
				 + "from tg_zonas_pesca zp " &
				 + "where zp.flag_estado = '1'"
				 
		lb_ret = of_lista( ls_sql, ls_data, &
				ls_codigo, '1')

		this.object.zona_pesca[al_row] = ls_codigo
		this.object.descr_zona[al_row] = ls_data
				
	case 'especie'
		ls_sql = "select te.descr_especie as descripcion, " &
				 + "te.especie as codigo " &
				 + "from tg_especies te " &
				 + "where te.flag_tipo_matprim = 'H' " &
				 + "and te.flag_estado = '1'"
				 
		lb_ret = of_lista( ls_sql, ls_data, &
				ls_codigo, '1')

		this.object.especie[al_row] 			= ls_codigo
		this.object.descr_especie[al_row] 	= ls_data

	case 'unidad_peso'
		ls_sql = "select und as codigo_unidad, " &
			    + "desc_unidad as descripcion_unidad " &
				 + "from unidad " 
				 
		lb_ret = of_lista( ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.unidad_peso[al_row] = ls_codigo
		end if

	case 'profundidad_unid'
		ls_sql = "select und as codigo_unidad, " &
			    + "desc_unidad as descripcion_unidad " &
				 + "from unidad " 
				 
		lb_ret = of_lista( ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.profundidad_unid[al_row] = ls_codigo
		end if
		
	case 'temperatura_und'
		ls_sql = "select und as codigo_unidad, " &
			    + "desc_unidad as descripcion_unidad " &
				 + "from unidad " 
				 
		lb_ret = of_lista( ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.temperatura_und[al_row] = ls_codigo
		end if
end choose
end event

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst = dw_master
idw_det = dw_detail
end event

event dw_detail::itemchanged;call super::itemchanged;long ll_row
string ls_columna, ls_zona, ls_descr_zona, ls_especie, ls_descr_especie

ll_row = this.getrow()

ls_columna = dwo.name
this.AcceptText()

choose case ls_columna
	case 'zona_pesca'
		ls_zona = this.object.zona_pesca[ll_row]
		SetNull (ls_descr_zona)
		select tzp.descr_zona
			into :ls_descr_zona
			from tg_zonas_pesca tzp 
			where tzp.zona_pesca = :ls_zona;
		if IsNull(ls_descr_zona) then
			ls_zona = ''
			ls_descr_zona = ''
			this.object.zona_pesca[ll_row] = ls_zona
			this.object.descr_zona[ll_row] = ls_descr_zona
			messagebox('Flota','No se encontró la zona de pesca ingresada',StopSign!)
			return 1
		end if
		this.object.descr_zona[ll_row] = ls_descr_zona
	case 'especie'
		ls_especie = this.object.especie[ll_row]
		SetNull (ls_descr_especie)
		select te.descr_especie
			into :ls_descr_especie
			from tg_especies te 
			where te.especie = :ls_especie;
		
		if IsNull(ls_descr_especie) then
			ls_especie = ''
			ls_descr_especie = ''
			this.object.especie[ll_row] = ls_especie
			this.object.tg_especies_descr_especie[ll_row] = ls_descr_especie
			messagebox('Flota','No se encontró la especie ingresada',StopSign!)
			return 1
		end if
		this.object.tg_especies_descr_especie[ll_row] = ls_descr_especie
end choose
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
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

event dw_detail::ue_insert_pre;call super::ue_insert_pre;long ll_nro_cala

if al_row = 1 then
	ll_nro_cala = 1
else
	ll_nro_cala = long(this.object.nro_cala[al_row - 1])
	ll_nro_cala ++
end if

this.object.nro_cala[al_row] = ll_nro_cala
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type uo_1 from u_rango_datetime within w_fl310_bitacora
integer x = 41
integer y = 28
integer taborder = 10
boolean bringtotop = true
end type

event constructor;call super::constructor;integer li_mes, li_anho, li_mes_sig, li_anho_sig
datetime ldt_first_day, ldt_last_day

li_mes = month(today())
li_anho = year(today())

if li_mes = 12 then
	li_mes_sig = 1
	li_anho_sig = li_anho + 1
else
	li_anho_sig = li_anho
	li_mes_sig = li_mes + 1
end if
ldt_first_day = datetime(date(li_anho, li_mes, 1),time('00:00:00'))
ldt_last_day = datetime(RelativeDate(date(li_anho_sig,li_mes_sig,1),-1),time('23:59:59'))
/////////////////////////////////////////////////////////////////////
of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(ldt_first_day, ldt_last_day) // para seatear el titulo del boton
of_set_rango_inicio(datetime(date('01/01/1900'),time('00:00:00'))) // rango inicial
of_set_rango_fin(datetime(date('31/12/2999'),time('23:59:59'))) // rango final
end event

on uo_1.destroy
call u_rango_datetime::destroy
end on

event ue_output;call super::ue_output;parent.event dynamic ue_retrieve()
end event

type st_nomb_nave from statictext within w_fl310_bitacora
integer x = 2245
integer y = 20
integer width = 731
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_fl310_bitacora
integer x = 1714
integer y = 32
integer width = 206
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Nave:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nave from singlelineedit within w_fl310_bitacora
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 1934
integer y = 20
integer width = 293
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
integer limit = 10
integer accelerator = 110
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_desp_naves()
end event

event ue_desp_naves();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
       + "FROM TG_NAVES " &
		 + "WHERE FLAG_TIPO_FLOTA= 'P'"
				 
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
	Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
	return
end if
		
st_nomb_nave.text = ls_data		
this.text	 		= ls_codigo
parent.is_nave		= ls_codigo
parent.event ue_retrieve()
end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_desp_naves()	
end if
end event

event modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

select nomb_nave
	into :ls_data
from tg_naves
where nave = :ls_codigo
  and flag_tipo_flota = 'P';
		
if ls_data = ""  or IsNull(ls_data) then
	Messagebox('Error', "CODIGO DE NAVE NO EXISTE O NO ES UNA NAVE PROPIA", StopSign!)
	this.text = ''
	st_nomb_nave.text = ''
	dw_master.Reset()
	dw_detail.reset()
	parent.event dynamic ue_act_menu(false)
	return
end if
		
st_nomb_nave.text = ls_data
parent.is_nave		= ls_codigo

parent.event dynamic ue_retrieve()
end event

type pb_retrieve from picturebutton within w_fl310_bitacora
integer x = 3077
integer y = 16
integer width = 123
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Retrieve!"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;parent.event dynamic ue_retrieve()
end event

