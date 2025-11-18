$PBExportHeader$w_pt313_pry_datos.srw
forward
global type w_pt313_pry_datos from w_abc
end type
type pb_1 from u_pb_descripcion within w_pt313_pry_datos
end type
type tab_pry from tab within w_pt313_pry_datos
end type
type tabpage_gen from userobject within tab_pry
end type
type pb_6 from u_pb_calendario within tabpage_gen
end type
type pb_5 from u_pb_calendario within tabpage_gen
end type
type pb_4 from u_pb_calendario within tabpage_gen
end type
type pb_3 from u_pb_calendario within tabpage_gen
end type
type pb_2 from u_pb_descripcion within tabpage_gen
end type
type dw_master from u_dw_abc within tabpage_gen
end type
type tabpage_gen from userobject within tab_pry
pb_6 pb_6
pb_5 pb_5
pb_4 pb_4
pb_3 pb_3
pb_2 pb_2
dw_master dw_master
end type
type tabpage_obj from userobject within tab_pry
end type
type dw_obj3 from u_dw_abc within tabpage_obj
end type
type st_3 from statictext within tabpage_obj
end type
type dw_obj2 from u_dw_abc within tabpage_obj
end type
type st_1 from statictext within tabpage_obj
end type
type dw_obj1 from u_dw_abc within tabpage_obj
end type
type st_2 from statictext within tabpage_obj
end type
type tabpage_obj from userobject within tab_pry
dw_obj3 dw_obj3
st_3 st_3
dw_obj2 dw_obj2
st_1 st_1
dw_obj1 dw_obj1
st_2 st_2
end type
type tabpage_doc from userobject within tab_pry
end type
type dw_doc from u_dw_abc within tabpage_doc
end type
type tabpage_doc from userobject within tab_pry
dw_doc dw_doc
end type
type tab_pry from tab within w_pt313_pry_datos
tabpage_gen tabpage_gen
tabpage_obj tabpage_obj
tabpage_doc tabpage_doc
end type
type dw_pry from u_dw_abc within w_pt313_pry_datos
end type
end forward

global type w_pt313_pry_datos from w_abc
integer width = 2455
integer height = 2036
string title = "Proyecto - Datos (PT313)"
string menuname = "m_mantenimiento_cl"
pb_1 pb_1
tab_pry tab_pry
dw_pry dw_pry
end type
global w_pt313_pry_datos w_pt313_pry_datos

type variables
String is_tipcst_mo, is_tip_cst_equipo, is_tipcst_material,&
		 is_tipcst_servicio, is_tipcst_otro
String is_tipfc_beneficio, is_tipfc_inversion, is_tipfc_amortizacion,&
		 is_tipfc_cfijo, is_tipfc_cvar, is_tipfc_lcred
		 
Datawindow idw_master, idw_obj1, idw_obj2, idw_obj3, idw_doc
end variables

on w_pt313_pry_datos.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.pb_1=create pb_1
this.tab_pry=create tab_pry
this.dw_pry=create dw_pry
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.tab_pry
this.Control[iCurrent+3]=this.dw_pry
end on

on w_pt313_pry_datos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.tab_pry)
destroy(this.dw_pry)
end on

event ue_open_pre;call super::ue_open_pre;//Valores de los parametros
select tipo_gasto_mo      , tipo_gasto_equipo  , tipo_gasto_material,
		 tipo_gasto_servicio, tipo_gasto_otro    ,
		 tipo_fc_beneficio  , tipo_fc_inversion  , tipo_fc_amortizacion,
		 tipo_fc_costo_fijo , tipo_fc_costo_var  , tipo_fc_linea_cred
  into :is_tipcst_mo      , :is_tip_cst_equipo , :is_tipcst_material,
		 :is_tipcst_servicio, :is_tipcst_otro    ,
		 :is_tipfc_beneficio, :is_tipfc_inversion, :is_tipfc_amortizacion,
		 :is_tipfc_cfijo    , :is_tipfc_cvar     , :is_tipfc_lcred
  from pry_param
 where reckey = '1';
 
idw_master = tab_pry.tabpage_gen.dw_master
idw_obj1   = tab_pry.tabpage_obj.dw_obj1
idw_obj2   = tab_pry.tabpage_obj.dw_obj2
idw_obj3   = tab_pry.tabpage_obj.dw_obj3
idw_doc	  = tab_pry.tabpage_doc.dw_doc

idw_1 = dw_pry
idw_obj1.BorderStyle = StyleRaised!
idw_obj2.BorderStyle = StyleRaised!
idw_obj3.BorderStyle = StyleRaised!
idw_doc.BorderStyle = StyleRaised!

dw_pry.of_protect()
tab_pry.tabpage_gen.dw_master.of_protect()
tab_pry.tabpage_obj.dw_obj1.of_protect()
tab_pry.tabpage_obj.dw_obj2.of_protect()
tab_pry.tabpage_obj.dw_obj3.of_protect()
tab_pry.tabpage_doc.dw_doc.of_protect()

dw_pry.Object.cod_usr[dw_pry.GetRow()]=gs_user
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

idw_master.AcceptText()
idw_obj1.AcceptText()
idw_obj2.AcceptText()
idw_obj3.AcceptText()
idw_doc.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF tab_pry.tabpage_gen.dw_master.ii_update = 1 THEN
	IF idw_master.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Datos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	tab_pry.tabpage_obj.dw_obj1.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_obj1.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Objetivos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	tab_pry.tabpage_obj.dw_obj2.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_obj2.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Objetivos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	tab_pry.tabpage_obj.dw_obj3.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_obj3.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Objetivos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	tab_pry.tabpage_doc.dw_doc.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_doc.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Objetivos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	tab_pry.tabpage_gen.dw_master.ii_update = 0
	tab_pry.tabpage_obj.dw_obj1.ii_update = 0
	tab_pry.tabpage_obj.dw_obj2.ii_update = 0
	tab_pry.tabpage_obj.dw_obj3.ii_update = 0
	tab_pry.tabpage_doc.dw_doc.ii_update = 0
	
END IF
end event

event ue_update_pre;call super::ue_update_pre;// Numera documento
Long 		ll_long, ll_ult_nro
Integer li_size, li_obj, li_i, li_max_itm, li_itm
string	ls_mensaje
String ls_nro_pry

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_obj1, "tabular") <> true then	return

//if dw_detail.rowcount() = 0 then 
	//messagebox( "Atencion", "No se grabara el documento, falta detalle")
	//return
//end if

////////
ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
If Len(Trim(ls_nro_pry))=0 or IsNull(ls_nro_pry) then
	//Crear un Codigo Correlativo de Proyecto
	Select Max(To_Number(SubStr(nro_proyecto,3,8))) into :ll_ult_nro
	  from proyecto
	 where SubStr(nro_proyecto,1,2)=:gs_origen;
	
	If IsNull(ll_ult_nro) then
		ls_nro_pry = gs_origen+fill("0",7)+"1"
	else
		li_size = len(String(ll_ult_nro+1))
		ls_nro_pry = gs_origen+fill("0",10-(li_size+2))+String(ll_ult_nro+1)
	end if
	
	dw_pry.Object.nro_proyecto[dw_pry.GetRow()] = ls_nro_pry
	idw_master.Object.nro_proyecto[idw_master.GetRow()] = ls_nro_pry
	idw_master.Object.nombre_proy[idw_master.GetRow()] = dw_pry.Object.nombre_proy[dw_pry.GetRow()]
	idw_master.Object.alcance[idw_master.GetRow()] = dw_pry.Object.alcance[dw_pry.GetRow()]
	idw_master.Object.cod_usr[idw_master.GetRow()] = dw_pry.Object.cod_usr[dw_pry.GetRow()]
	idw_master.Object.flag_estado[idw_master.GetRow()] = dw_pry.Object.flag_estado[dw_pry.GetRow()]
	li_obj = 1
	for li_i = 1 to idw_obj1.RowCount()
		idw_obj1.Object.nro_proyecto[li_i] = ls_nro_pry
		idw_obj1.Object.nro_objetivo[li_i] = li_obj
		li_obj = li_obj + 1
	next
	
	for li_i = 1 to idw_obj2.RowCount()
		idw_obj2.Object.nro_proyecto[li_i] = ls_nro_pry
		idw_obj2.Object.nro_objetivo[li_i] = li_obj
		li_obj = li_obj + 1
	next

	for li_i = 1 to idw_obj3.RowCount()
		idw_obj3.Object.nro_proyecto[li_i] = ls_nro_pry
		idw_obj3.Object.nro_objetivo[li_i] = li_obj
		li_obj = li_obj + 1
	next
	
	for li_i = 1 to idw_doc.RowCount()
		idw_doc.Object.nro_proyecto[li_i] = ls_nro_pry
		idw_doc.Object.nro_item_doc[li_i] = li_i
	next
else//Ya tiene Numero de Proyecto
	//Dw Documentos
	Select nvl(max(nro_item_doc),0) into :li_max_itm
	from pry_doc_tecnica where nro_proyecto = :ls_nro_pry;
	li_itm = li_max_itm+1
	for li_i = 1 to idw_doc.RowCount()
		If IsNull(idw_doc.Object.nro_item_doc[li_i]) then
			idw_doc.Object.nro_proyecto[li_i] = ls_nro_pry
			idw_doc.Object.nro_item_doc[li_i] = li_itm
			li_itm = li_itm + 1
		end if
	next
	
	//Dw Objetivos
	SetNull(li_max_itm)
	Select nvl(max(nro_objetivo),0) into :li_max_itm
	  from pry_objetivo where nro_proyecto = :ls_nro_pry;
	li_itm = li_max_itm+1
	for li_i = 1 to idw_obj1.RowCount()
		If IsNull(idw_obj1.Object.nro_objetivo[li_i]) then
			idw_obj1.Object.nro_proyecto[li_i] = ls_nro_pry
			idw_obj1.Object.nro_objetivo[li_i] = li_itm
			li_itm = li_itm + 1
		end if
	next
	for li_i = 1 to idw_obj2.RowCount()
		If IsNull(idw_obj2.Object.nro_objetivo[li_i]) then
			idw_obj2.Object.nro_proyecto[li_i] = ls_nro_pry
			idw_obj2.Object.nro_objetivo[li_i] = li_itm
			li_itm = li_itm + 1
		end if
	next
	for li_i = 1 to idw_obj3.RowCount()
		If IsNull(idw_obj3.Object.nro_objetivo[li_i]) then
			idw_obj3.Object.nro_proyecto[li_i] = ls_nro_pry
			idw_obj3.Object.nro_objetivo[li_i] = li_itm
			li_itm = li_itm + 1
		end if
	next	
	
end if

ib_update_check = true

//idw_master.of_set_flag_replicacion()
//idw_obj1.of_set_flag_replicacion()

/*
Asigna numero a detalle
dw_master.object.nro_oc[dw_master.getrow()] = ls_nro
for j = 1 to dw_detail.RowCount()	
	dw_detail.object.nro_doc[j] = ls_nro	
next*/
//return 1
end event

event ue_list_open;call super::ue_list_open;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = 'd_abc_lista_proyecto_tbl'
sl_param.titulo  = 'Proyecto'
//sl_param.tipo    = '1SQL'
//sl_param.string1 =  ' WHERE (...')    '&


sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	//dw_pry.reset()
	//dw_pry.InsertRow(0)
	dw_pry.Retrieve(sl_param.field_ret[1])
	idw_master.Retrieve(sl_param.field_ret[1])
	idw_obj1.Retrieve(sl_param.field_ret[1])
	idw_obj2.Retrieve(sl_param.field_ret[1])
	idw_obj3.Retrieve(sl_param.field_ret[1])
	idw_doc.Retrieve(sl_param.field_ret[1])
	TriggerEvent ('ue_modify')
END IF
end event

event ue_modify;call super::ue_modify;dw_pry.of_protect()
tab_pry.tabpage_gen.dw_master.of_protect()
tab_pry.tabpage_obj.dw_obj1.of_protect()
tab_pry.tabpage_obj.dw_obj2.of_protect()
tab_pry.tabpage_obj.dw_obj3.of_protect()
tab_pry.tabpage_doc.dw_doc.of_protect()

end event

event ue_insert;call super::ue_insert;Long  ll_row

//THIS.Event ue_delete_pos(ll_row)
If idw_1 = dw_pry then
	TriggerEvent("ue_update_request")
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (tab_pry.tabpage_gen.dw_master.ii_update = 1 OR tab_pry.tabpage_obj.dw_obj1.ii_update = 1 OR tab_pry.tabpage_obj.dw_obj2.ii_update = 1 OR tab_pry.tabpage_obj.dw_obj3.ii_update = 1 OR tab_pry.tabpage_doc.dw_doc.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		tab_pry.tabpage_gen.dw_master.ii_update = 0
		tab_pry.tabpage_obj.dw_obj1.ii_update = 0
		tab_pry.tabpage_obj.dw_obj2.ii_update = 0
		tab_pry.tabpage_obj.dw_obj3.ii_update = 0
		tab_pry.tabpage_doc.dw_doc.ii_update = 0	
	END IF
END IF


end event

type pb_1 from u_pb_descripcion within w_pt313_pry_datos
integer x = 2089
integer y = 208
integer width = 96
integer height = 84
integer taborder = 50
end type

event clicked;call super::clicked;string ls_obs
string 	ls_columna
long 		ll_row 

dw_pry.AcceptText()
If dw_pry.Describe("alcance.Protect") = '1' then RETURN

ls_obs = dw_pry.object.alcance[dw_pry.GetRow()]

openwithparm(w_rsp_descripcion,ls_obs)

if not isnull(Message.StringParm) then
	
	dw_pry.object.alcance[dw_pry.GetRow()] = trim(Message.StringParm)
	idw_master.object.alcance[idw_master.GetRow()] = trim(Message.StringParm)
	tab_pry.tabpage_gen.dw_master.ii_update = 1
	
end if
end event

event mousemove;//Override

end event

type tab_pry from tab within w_pt313_pry_datos
integer x = 27
integer y = 416
integer width = 2359
integer height = 1424
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_gen tabpage_gen
tabpage_obj tabpage_obj
tabpage_doc tabpage_doc
end type

on tab_pry.create
this.tabpage_gen=create tabpage_gen
this.tabpage_obj=create tabpage_obj
this.tabpage_doc=create tabpage_doc
this.Control[]={this.tabpage_gen,&
this.tabpage_obj,&
this.tabpage_doc}
end on

on tab_pry.destroy
destroy(this.tabpage_gen)
destroy(this.tabpage_obj)
destroy(this.tabpage_doc)
end on

type tabpage_gen from userobject within tab_pry
integer x = 18
integer y = 112
integer width = 2322
integer height = 1296
long backcolor = 79741120
string text = "Generales"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom041!"
long picturemaskcolor = 536870912
string powertiptext = "Datos Generales del Proyecto"
pb_6 pb_6
pb_5 pb_5
pb_4 pb_4
pb_3 pb_3
pb_2 pb_2
dw_master dw_master
end type

on tabpage_gen.create
this.pb_6=create pb_6
this.pb_5=create pb_5
this.pb_4=create pb_4
this.pb_3=create pb_3
this.pb_2=create pb_2
this.dw_master=create dw_master
this.Control[]={this.pb_6,&
this.pb_5,&
this.pb_4,&
this.pb_3,&
this.pb_2,&
this.dw_master}
end on

on tabpage_gen.destroy
destroy(this.pb_6)
destroy(this.pb_5)
destroy(this.pb_4)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.dw_master)
end on

type pb_6 from u_pb_calendario within tabpage_gen
integer x = 1733
integer y = 524
integer width = 96
integer height = 88
integer taborder = 50
end type

event constructor;call super::constructor;idw_fecha = tab_pry.tabpage_gen.dw_master
Is_campo_fecha = "fecha_inicio_proy"
il_row = 1
end event

event clicked;call super::clicked;tab_pry.tabpage_gen.dw_master.ii_update = 1
end event

type pb_5 from u_pb_calendario within tabpage_gen
integer x = 1733
integer y = 432
integer width = 96
integer height = 88
integer taborder = 40
end type

event constructor;call super::constructor;idw_fecha = tab_pry.tabpage_gen.dw_master
Is_campo_fecha = "fecha_aprobacion"
il_row = 1
end event

event clicked;call super::clicked;tab_pry.tabpage_gen.dw_master.ii_update = 1
end event

type pb_4 from u_pb_calendario within tabpage_gen
integer x = 1733
integer y = 340
integer width = 96
integer height = 88
integer taborder = 30
end type

event constructor;call super::constructor;idw_fecha = tab_pry.tabpage_gen.dw_master
Is_campo_fecha = "fecha_revision"
il_row = 1
end event

event clicked;call super::clicked;tab_pry.tabpage_gen.dw_master.ii_update = 1
end event

type pb_3 from u_pb_calendario within tabpage_gen
integer x = 1733
integer y = 244
integer width = 96
integer height = 88
integer taborder = 20
end type

event constructor;call super::constructor;idw_fecha = tab_pry.tabpage_gen.dw_master
Is_campo_fecha = "fecha_presentacion"
il_row = 1
end event

event clicked;call super::clicked;tab_pry.tabpage_gen.dw_master.ii_update = 1
end event

type pb_2 from u_pb_descripcion within tabpage_gen
integer x = 1810
integer y = 68
integer width = 96
integer height = 84
integer taborder = 50
end type

event clicked;call super::clicked;string ls_obs

ls_obs = idw_master.object.definicion[idw_master.GetRow()]

openwithparm(w_rsp_descripcion,ls_obs)

if not isnull(Message.StringParm) then
	
	idw_master.object.definicion[idw_master.GetRow()] = trim(Message.StringParm)
	tab_pry.tabpage_gen.dw_master.ii_update = 1
	
end if
end event

event mousemove;//Override

end event

type dw_master from u_dw_abc within tabpage_gen
event ue_display ( string as_columna,  long al_row )
integer x = 9
integer y = 40
integer width = 2267
integer height = 1068
integer taborder = 40
string dataobject = "d_abc_proyecto_datos"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cat_art, ls_cod_art, ls_proveedor
str_parametros sl_param

choose case lower(as_columna)
	case "cencos"
		ls_sql = "SELECT cencos AS centro_costo, " &
				  + "desc_cencos AS desc_cencos from centros_costo "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			idw_master.object.cencos[al_row]=ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			tab_pry.tabpage_gen.dw_master.ii_update = 1
		end if
	case "nro_ot"		
		sl_param.dw1     = 'd_abc_lista_orden_trabajo_x_usr_tbl'
		sl_param.titulo  = 'Orden de Trabajo'
		sl_param.tipo    = '1SQL'
		sl_param.string1 =  ' WHERE ("VW_OPE_OT_X_ADM_TOD"."USUARIO" = '+"'"+gs_user+"'"+')    '&
								 +'ORDER BY "VW_OPE_OT_X_ADM_TOD"."FEC_SOLICITUD" DESC  '
		
		
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2
		
		OpenWithParm( w_lista, sl_param)
		
		sl_param = Message.PowerObjectParm
		IF sl_param.titulo <> 'n' THEN	
			idw_master.object.nro_ot[al_row]     = sl_param.field_ret_i[1] = 1			
		END IF		
end choose
end event

event constructor;call super::constructor;SetTransObject(sqlca)
InsertRow(0)
is_mastdet = 'md'
is_dwform = 'form'
il_row = 1

ii_ck[1] = 1
ii_dk[1] = 1
idw_mst  = dw_master

end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

type tabpage_obj from userobject within tab_pry
integer x = 18
integer y = 112
integer width = 2322
integer height = 1296
long backcolor = 79741120
string text = "Objetivos y Metas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom087!"
long picturemaskcolor = 536870912
string powertiptext = "Objetivos y metas del proyecto"
dw_obj3 dw_obj3
st_3 st_3
dw_obj2 dw_obj2
st_1 st_1
dw_obj1 dw_obj1
st_2 st_2
end type

on tabpage_obj.create
this.dw_obj3=create dw_obj3
this.st_3=create st_3
this.dw_obj2=create dw_obj2
this.st_1=create st_1
this.dw_obj1=create dw_obj1
this.st_2=create st_2
this.Control[]={this.dw_obj3,&
this.st_3,&
this.dw_obj2,&
this.st_1,&
this.dw_obj1,&
this.st_2}
end on

on tabpage_obj.destroy
destroy(this.dw_obj3)
destroy(this.st_3)
destroy(this.dw_obj2)
destroy(this.st_1)
destroy(this.dw_obj1)
destroy(this.st_2)
end on

type dw_obj3 from u_dw_abc within tabpage_obj
event ue_det_agregar ( )
event ue_det_eliminar ( )
integer x = 27
integer y = 856
integer width = 2071
integer height = 308
integer taborder = 60
string dataobject = "d_pry_objetivo3"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert;//Override
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
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
END IF

RETURN ll_row
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event buttonclicked;call super::buttonclicked;string ls_obs

ls_obs = this.object.objetivo[row]

openwithparm(w_rsp_descripcion,ls_obs)

if not isnull(Message.StringParm) then
	
	this.object.objetivo[row] = trim(Message.StringParm)
	this.ii_update = 1
	
end if		
end event

type st_3 from statictext within tabpage_obj
integer x = 27
integer y = 792
integer width = 928
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "3. Indicador de seguimiento"
boolean focusrectangle = false
end type

type dw_obj2 from u_dw_abc within tabpage_obj
event ue_det_agregar ( )
event ue_det_eliminar ( )
integer x = 27
integer y = 464
integer width = 2071
integer height = 308
integer taborder = 50
string dataobject = "d_pry_objetivo2"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert;//Override
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
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
END IF

RETURN ll_row
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event buttonclicked;call super::buttonclicked;string ls_obs

ls_obs = this.object.objetivo[row]

openwithparm(w_rsp_descripcion,ls_obs)

if not isnull(Message.StringParm) then
	
	this.object.objetivo[row] = trim(Message.StringParm)
	this.ii_update = 1
	
end if		
end event

type st_1 from statictext within tabpage_obj
integer x = 27
integer y = 404
integer width = 928
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "2. Resultados específicos"
boolean focusrectangle = false
end type

type dw_obj1 from u_dw_abc within tabpage_obj
event ue_det_agregar ( )
event ue_det_eliminar ( )
integer x = 27
integer y = 80
integer width = 2071
integer height = 308
integer taborder = 40
string dataobject = "d_pry_objetivo1"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
//ParentWindow.PostEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
//is_tabla = 'CLIENTES'						// nombre de tabla para el Log
end event

event ue_insert;//Override
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
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
END IF

RETURN ll_row
end event

event buttonclicked;call super::buttonclicked;string ls_obs

ls_obs = this.object.objetivo[row]

openwithparm(w_rsp_descripcion,ls_obs)

if not isnull(Message.StringParm) then
	
	this.object.objetivo[row] = trim(Message.StringParm)
	this.ii_update = 1
	
end if		

end event

type st_2 from statictext within tabpage_obj
integer x = 27
integer y = 16
integer width = 928
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "1. Identificación de área de mejora"
boolean focusrectangle = false
end type

type tabpage_doc from userobject within tab_pry
integer x = 18
integer y = 112
integer width = 2322
integer height = 1296
long backcolor = 79741120
string text = "Archivos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom039!"
long picturemaskcolor = 536870912
string powertiptext = "Archivos del proyectos"
dw_doc dw_doc
end type

on tabpage_doc.create
this.dw_doc=create dw_doc
this.Control[]={this.dw_doc}
end on

on tabpage_doc.destroy
destroy(this.dw_doc)
end on

type dw_doc from u_dw_abc within tabpage_doc
event ue_det_agregar ( )
event ue_det_eliminar ( )
integer x = 14
integer y = 20
integer width = 2290
integer height = 1268
integer taborder = 40
string dataobject = "d_abc_pry_doc_tecnica"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert;//Override
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
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
END IF

RETURN ll_row
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event buttonclicked;call super::buttonclicked;Integer li_row, li_value
String ls_docname, ls_named
This.AcceptText()
If this.ii_protect = 1 then RETURN

li_row = this.GetRow()

choose case upper(dwo.name)
	case "B_2"

		li_value = GetFileOpenName("Select File", &
			 + ls_docname, ls_named, "DOC", &
    		 + "Doc Files (*.DOC),*.DOC," &
			 + "PDF Files (*.PDF),*.PDF," &
    		 + "All Files (*.*), *.*")//, &
    		//"C:\Program Files\Sybase", 18)
		IF li_value = 1 THEN 
			this.object.ruta_archivo[li_row] = ls_docname
			this.ii_update = 1
		END IF

	case "B_1"
		string ls_obs
		
		ls_obs = this.object.desc_documento[row]
		
		openwithparm(w_rsp_descripcion,ls_obs)
		
		if not isnull(Message.StringParm) then
			
			this.object.desc_documento[row] = trim(Message.StringParm)
			this.ii_update = 1
			
		end if		

end choose
end event

type dw_pry from u_dw_abc within w_pt313_pry_datos
event ue_display ( string as_columna,  long al_row )
integer x = 23
integer y = 20
integer width = 2185
integer height = 376
string dataobject = "d_abc_proyecto"
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cat_art, ls_cod_art, ls_proveedor
str_parametros sl_param

choose case lower(as_columna)
		
	case "cod_usr"
		ls_sql = "SELECT cod_usr AS codigo_usuario, " &
				  + "nombre AS nombre_usuario from usuario "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_usr		[al_row] = ls_codigo
			idw_master.object.cod_usr[al_row]=ls_codigo
			this.object.nombre	[al_row] = ls_data
			tab_pry.tabpage_gen.dw_master.ii_update = 1
		end if

	case "cencos"
		ls_sql = "SELECT cencos AS centro_costo, " &
				  + "desc_cencos AS desc_cencos from centros_costo "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			idw_master.object.cencos[al_row]=ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			tab_pry.tabpage_gen.dw_master.ii_update = 1
		end if
				
end choose
end event

event constructor;call super::constructor;SetTransObject(sqlca)
//is_mastdet = 'md'
InsertRow(0)
ii_ck[1] = 1
end event

event ue_insert;call super::ue_insert;//Override
long ll_row
this.Reset()
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
	//IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
	idw_master.Reset()
	idw_master.InsertRow(0)
	idw_obj1.Reset()
	idw_obj2.Reset()
	idw_obj3.Reset()
	idw_doc.Reset()
END IF

RETURN ll_row

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_delete;//Override
String ls_nro_pry
Long ll_row

ls_nro_pry = dw_pry.object.nro_proyecto[dw_pry.GetRow()]

If IsNull(ls_nro_pry) or Len(Trim(ls_nro_pry))=0 then
	MessageBox("Aviso","No se puede eliminar. No existe ningun proyecto seleccionado")
	Return 0
end if

ib_insert_mode = False

IF MessageBox(title, "Esta Seguro de Eliminar el Proyecto?", Question!, YesNo!, 2) <> 1 THEN
	RETURN 0
END IF

Delete from proyecto
where nro_proyecto = :ls_nro_pry;
If f_valida_transaccion(sqlca) = False then GoTo error_bd


dw_pry.TriggerEvent("ue_insert")
//IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle
//
//IF ll_row = 1 THEN
//	ll_row = THIS.DeleteRow (0)
//	IF ll_row = -1 then
//		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
//	ELSE
//		il_totdel ++
//		ii_update = 1								// indicador de actualizacion pendiente
//		THIS.Event Post ue_delete_pos()
//	END IF
//END IF
Commit;
Return 0

error_bd:
MessageBox(title,"Se ha procedido al RollBack")
RETURN 0
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

