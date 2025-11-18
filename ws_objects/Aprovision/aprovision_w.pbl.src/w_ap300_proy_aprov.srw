$PBExportHeader$w_ap300_proy_aprov.srw
forward
global type w_ap300_proy_aprov from w_abc
end type
type dw_graph from datawindow within w_ap300_proy_aprov
end type
type em_year from editmask within w_ap300_proy_aprov
end type
type st_1 from statictext within w_ap300_proy_aprov
end type
type dw_master from u_dw_abc within w_ap300_proy_aprov
end type
end forward

global type w_ap300_proy_aprov from w_abc
integer width = 3145
integer height = 2048
string title = "Proyeccion de Aprovisionamiento (AP300)"
string menuname = "m_mantto_smpl"
event ue_menu ( boolean ab_estado )
dw_graph dw_graph
em_year em_year
st_1 st_1
dw_master dw_master
end type
global w_ap300_proy_aprov w_ap300_proy_aprov

type variables
integer li_carga_nuevo
end variables

forward prototypes
public subroutine of_carga_graph (integer ai_ano, string as_especie, string as_origen)
end prototypes

event ue_menu(boolean ab_estado);//this.MenuId.item[1].item[1].item[2].enabled = ab_estado
//this.MenuId.item[1].item[1].item[3].enabled = ab_estado
//this.MenuId.item[1].item[1].item[4].enabled = ab_estado
//this.MenuId.item[1].item[1].item[5].enabled = ab_estado
//
//this.MenuId.item[1].item[1].item[2].visible = ab_estado
//this.MenuId.item[1].item[1].item[3].visible = ab_estado
//this.MenuId.item[1].item[1].item[4].visible = ab_estado
//this.MenuId.item[1].item[1].item[5].visible = ab_estado
//
//
//this.MenuId.item[1].item[1].item[2].ToolbarItemvisible = ab_estado
//this.MenuId.item[1].item[1].item[3].ToolbarItemvisible = ab_estado
//this.MenuId.item[1].item[1].item[4].ToolbarItemvisible = ab_estado
//this.MenuId.item[1].item[1].item[5].ToolbarItemvisible = ab_estado
//
end event

public subroutine of_carga_graph (integer ai_ano, string as_especie, string as_origen);long ll_cuenta

declare graf_proy procedure for
	usp_ap_graf_proy (:ai_ano, :as_especie, :as_origen);
execute graf_proy;
fetch graf_proy into :ll_cuenta;
dw_graph.reset( )
if ll_cuenta >= 1 then
	dw_graph.retrieve( )
end if
close graf_proy;
end subroutine

on w_ap300_proy_aprov.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.dw_graph=create dw_graph
this.em_year=create em_year
this.st_1=create st_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_graph
this.Control[iCurrent+2]=this.em_year
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_master
end on

on w_ap300_proy_aprov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_graph)
destroy(this.em_year)
destroy(this.st_1)
destroy(this.dw_master)
end on

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_graph.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query

dw_master.of_protect()         		// bloquear modificaciones 

ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

em_year.text = string(Today(), 'yyyy')

Event ue_query_retrieve()

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_graph.width  = newwidth  - dw_graph.x - 10
//dw_master.height = newheight - dw_master.y - 10
dw_graph.height = newheight - dw_graph.y - 10
end event

event ue_query_retrieve;string ls_especie, ls_origen
integer li_year



li_year = integer(em_year.text)
THIS.EVENT ue_update_request()
if li_year = 0 then
	MessageBox(this.title, 'Ingrese un año', StopSign!)
	return
end if

idw_query.Retrieve(li_year)

dw_master.ii_protect = 0
dw_master.of_protect()

li_carga_nuevo = 1

if dw_master.rowcount( ) <= 0 then return

dw_master.setrow(1)
dw_master.scrolltorow(1)
dw_master.selectrow(1,true)

li_year = dw_master.object.ano[1]
ls_especie = trim(dw_master.object.especie[1])
ls_origen = trim(dw_master.object.origen[1])

of_carga_graph(li_year, ls_especie, ls_origen)

this.event dynamic ue_menu(true)
end event

event open;call super::open;this.event dynamic ue_menu(false)

MenuId.item[1].item[1].item[1].enabled = false
MenuId.item[1].item[1].item[1].visible = false
MenuId.item[1].item[1].item[1].ToolbarItemvisible = false

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

ib_update_check = TRUE
THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
	   Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

dw_graph.retrieve(integer(em_year.text))
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_master, "tabular") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE
end event

type dw_graph from datawindow within w_ap300_proy_aprov
integer y = 1092
integer width = 3008
integer height = 412
integer taborder = 30
string title = "none"
string dataobject = "d_proy_aprovis_grf"
boolean border = false
boolean livescroll = true
end type

type em_year from editmask within w_ap300_proy_aprov
event ue_keyup pbm_keyup
integer x = 933
integer y = 24
integer width = 334
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

event ue_keyup;If Key = KeyEnter! or Key=KeyTab! Then
	parent.event ue_query_retrieve()
end if
end event

type st_1 from statictext within w_ap300_proy_aprov
integer x = 475
integer y = 36
integer width = 439
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese el año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_ap300_proy_aprov
event ue_display ( string as_columna,  long al_row )
integer y = 116
integer width = 3026
integer height = 976
integer taborder = 20
string dataobject = "d_proy_aprovis_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_insert_pre;call super::ue_insert_pre;integer li_year, li_mes
string ls_flag_zd, ls_flag_prov, ls_codigo, ls_data, &
       ls_und_peso, ls_desc_peso

li_year = integer(em_year.text)

this.object.ano[al_row] 	           = li_year
this.object.origen[al_row]            = gs_origen
this.object.cod_usr[al_row]           = gs_user
this.object.cantidad_real[al_row]     = 0.00
this.object.cantidad_estimada[al_row] = 0.00

if al_row > 1 then
	ls_flag_zd   = this.object.flag_zona_descarga [al_row - 1]
	ls_flag_prov = this.object.flag_proveedor[al_row - 1]
	li_mes       = Integer(this.object.mes[al_row - 1])
	ls_codigo    = this.object.especie[al_row - 1]
	ls_und_peso  = this.object.unidad_peso[al_row -1]
	ls_desc_peso = this.object.desc_unidad[al_row -1]
	
	if li_mes + 1 > 12 then
		li_mes = li_mes - 1
	end if
	
	SetNull(ls_data)
	select descr_especie
		into :ls_data
	 from tg_especies
	 where especie = :ls_codigo;
	
	This.object.flag_zona_descarga[al_row] = ls_flag_zd
	This.object.flag_proveedor[al_row]     = ls_flag_prov
	this.object.mes[al_row]                = li_mes + 1
	this.object.especie[al_row]            = ls_codigo
	this.object.unidad_peso[al_row]        = ls_und_peso
	this.object.desc_unidad[al_row]        = ls_desc_peso
	this.object.descr_especie[al_row]      = ls_data
	
else

	this.object.flag_proveedor    [al_row] = ''
	this.object.flag_zona_descarga[al_row] = ''
	
end if

This.SetColumn(6)
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

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string ls_column, ls_sql, ls_return1, ls_return2, ls_return3
ls_column = lower(string(dwo.name))
choose case ls_column
	case 'unidad_peso'
		ls_sql = 'select und as codigo, desc_unidad as descripcion from unidad'
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return 2
		this.object.desc_unidad[row] = ls_return2
		this.object.unidad_peso[row] = ls_return1
	case 'especie'
		ls_sql = 'select flag_tipo as tipo, especie as codigo, descr_especie as descripcion from vw_ap_matprim_tipo'
		f_lista_3ret(ls_sql, ls_return1, ls_return2, ls_return3, '3')
		if isnull(ls_return2) or trim(ls_return2) = '' then return 2
		this.object.especie[row] = ls_return2
		this.object.descr_especie[row] = ls_return3
end choose
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

event itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_estado
string ls_zondes, ls_provee, ls_undton
boolean lb_ok

this.AcceptText()

if row <= 0 then
	return
end if

lb_ok = true
choose case upper(dwo.name)
	case "ESPECIE"
		
		ls_codigo = this.object.especie[row]

		SetNull(ls_data)
		select descr_especie, flag_estado
			into :ls_data, :ls_estado
		from tg_especies
		where especie = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('APROVISIONAMIENTO', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
			lb_ok = false
		end if

		if ls_estado <> '1' and lb_ok then
			Messagebox('APROVISIONAMIENTO', "CODIGO DE ESPECIE NO ESTA ACTIVA", StopSign!)
			lb_ok = false
		end if

		if lb_ok = false then
			SetNull(ls_codigo)
			this.object.especie[row] = ls_codigo
			this.object.descr_especie[row] = ls_codigo
			return 1
		end if


		this.object.descr_especie[row] = ls_data
		
	case "COD_ETAPA"
		
		ls_codigo = this.object.cod_etapa[row]

		SetNull(ls_data)
		select desc_etapa
			into :ls_data
		from labor_etapa
		where cod_etapa = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('APROVISIONAMIENTO', "CODIGO DE ETAPA NO EXISTE", StopSign!)
			lb_ok = false
		end if
		
		if lb_ok = false then
			SetNull(ls_codigo)
			this.object.cod_etapa[row] = ls_codigo
			this.object.desc_etapa[row] = ls_codigo
			return 1
		end if

		this.object.desc_etapa[row] = ls_data

	case "UNIDAD_PESO"
		
		ls_codigo = this.object.unidad_peso[row]

		SetNull(ls_data)
		select desc_unidad
			into :ls_data
		from unidad
		where und = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('APROVISIONAMIENTO', "CODIGO DE UNIDAD NO EXISTE", StopSign!)
			lb_ok = false
		end if
		
		if lb_ok = false then
			SetNull(ls_codigo)
			this.object.unidad_peso[row] = ls_codigo
			this.object.descr_unidad[row] = ls_codigo
			return 1
		end if

		this.object.desc_unidad[row] = ls_data
		
	case "FLAG_PROVEEDOR", "FLAG_ZONA_DESCARGA"
		
		ls_zondes = this.object.flag_zona_descarga[row]
		ls_provee = this.object.flag_proveedor[row]
		
		if ls_zondes = 'C' and ls_provee = 'F' then
			
			SetNull(ls_undton)
			
			select und_tonelada
				into :ls_undton
			from tg_parametro
			where origen = :gs_origen;
			
			SetNull(ls_data)
			select desc_unidad
				into :ls_data
			from unidad
			where und = :ls_undton;
			
			this.object.unidad_peso[row] = ls_undton
			this.object.desc_unidad[row] = ls_data
		else
			
			SetNull(ls_data)
			this.object.unidad_peso[row] = ls_data
			this.object.desc_unidad[row] = ls_data
			
		end if

end choose

end event

event rowfocuschanging;call super::rowfocuschanging;string ls_especie_old, ls_especie_new, ls_origen_old, ls_origen_new
integer li_ano_old, li_ano_new
long ll_cuenta

if li_carga_nuevo = 1 then
	li_carga_nuevo = 0
	return
end if

if currentrow <= 0 or newrow <= 0 then return

ls_especie_old = this.object.especie[currentrow]
ls_especie_new = this.object.especie[newrow]

li_ano_old = this.object.ano[currentrow]
li_ano_new = this.object.ano[newrow]

ls_origen_old = this.object.origen[currentrow]
ls_origen_new = this.object.origen[newrow]

if ls_especie_old = ls_especie_new and li_ano_old = li_ano_new and ls_origen_old = ls_origen_new then return

of_carga_graph(li_ano_new, ls_especie_new, ls_origen_new)
end event

