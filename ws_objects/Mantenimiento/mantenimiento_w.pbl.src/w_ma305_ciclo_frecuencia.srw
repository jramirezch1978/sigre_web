$PBExportHeader$w_ma305_ciclo_frecuencia.srw
forward
global type w_ma305_ciclo_frecuencia from w_abc
end type
type st_2 from statictext within w_ma305_ciclo_frecuencia
end type
type sle_ot_adm from singlelineedit within w_ma305_ciclo_frecuencia
end type
type dw_articulos from u_dw_abc within w_ma305_ciclo_frecuencia
end type
type dw_labores from u_dw_abc within w_ma305_ciclo_frecuencia
end type
type dw_frecuencia from u_dw_abc within w_ma305_ciclo_frecuencia
end type
type st_1 from statictext within w_ma305_ciclo_frecuencia
end type
type sle_desc_maq from singlelineedit within w_ma305_ciclo_frecuencia
end type
type sle_cod_maq from singlelineedit within w_ma305_ciclo_frecuencia
end type
end forward

global type w_ma305_ciclo_frecuencia from w_abc
integer width = 2930
integer height = 1992
string title = "Frecuencia de Mantenimiento (MA305)"
string menuname = "m_mantto_smpl"
st_2 st_2
sle_ot_adm sle_ot_adm
dw_articulos dw_articulos
dw_labores dw_labores
dw_frecuencia dw_frecuencia
st_1 st_1
sle_desc_maq sle_desc_maq
sle_cod_maq sle_cod_maq
end type
global w_ma305_ciclo_frecuencia w_ma305_ciclo_frecuencia

type variables
string 	is_und_hrs
boolean 	ib_retrieve
end variables

forward prototypes
public function boolean of_set_numera (ref string as_ult_nro)
end prototypes

public function boolean of_set_numera (ref string as_ult_nro);String	ls_mensaje

//create or replace function usf_mt_prog_mnt(
//       asi_origen in origen.cod_origen%TYPE
//) return varchar2 is

DECLARE usf_mt_prog_mnt PROCEDURE FOR
	usf_mt_prog_mnt( :gs_origen );

EXECUTE usf_mt_prog_mnt;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION usf_mt_prog_mnt: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(as_ult_nro)
	return FALSE
END IF

FETCH usf_mt_prog_mnt INTO :as_ult_nro;
CLOSE usf_mt_prog_mnt;

return TRUE

end function

on w_ma305_ciclo_frecuencia.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_2=create st_2
this.sle_ot_adm=create sle_ot_adm
this.dw_articulos=create dw_articulos
this.dw_labores=create dw_labores
this.dw_frecuencia=create dw_frecuencia
this.st_1=create st_1
this.sle_desc_maq=create sle_desc_maq
this.sle_cod_maq=create sle_cod_maq
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_ot_adm
this.Control[iCurrent+3]=this.dw_articulos
this.Control[iCurrent+4]=this.dw_labores
this.Control[iCurrent+5]=this.dw_frecuencia
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_desc_maq
this.Control[iCurrent+8]=this.sle_cod_maq
end on

on w_ma305_ciclo_frecuencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_ot_adm)
destroy(this.dw_articulos)
destroy(this.dw_labores)
destroy(this.dw_frecuencia)
destroy(this.st_1)
destroy(this.sle_desc_maq)
destroy(this.sle_cod_maq)
end on

event ue_query_retrieve;// Ancestor Script has been Override
string ls_cod_maq

ls_cod_maq = trim(sle_cod_maq.Text)

if ls_cod_maq = '' or IsNull(ls_cod_maq) then
	MessageBox('Aviso', 'Codigo de Maquina no definido', StopSign!)
	return
end if

this.event ue_update_request()

dw_labores.reset( )
dw_articulos.reset( )
dw_frecuencia.reset( )
	
if dw_frecuencia.retrieve(ls_cod_maq) > 0 then 
	dw_frecuencia.selectrow( 1, true)
	dw_frecuencia.setrow(1)
	dw_frecuencia.scrolltorow(1)
end if
ib_retrieve = true
end event

event resize;call super::resize;dw_frecuencia.width  = newwidth  - dw_frecuencia.x - 10

dw_labores.width = newwidth/2 - dw_labores.x - 10
dw_labores.height = newheight - dw_labores.y - 10

dw_articulos.X = newwidth/2 + 10
dw_articulos.width = newwidth - dw_articulos.x - 10
dw_articulos.height = newheight - dw_articulos.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_frecuencia.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_labores.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_articulos.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_frecuencia              				// asignar dw corriente
idw_1.SetFocus()
idw_1.of_protect()         		// bloquear modificaciones 
ib_retrieve = false

select und_hr
	into :is_und_hrs
from prod_param
where reckey = '1';

if is_und_hrs = '' or IsNull(is_und_hrs) then
	MessageBox('Aviso', 'No ha definido la unidad horas en prod_param', StopSign!)
	return
end if


end event

event ue_insert;call super::ue_insert;Long  ll_row
string ls_cod_maq

ls_cod_maq = trim(sle_cod_maq.text)

if ls_cod_maq = '' or IsNull(ls_cod_maq) then
	MessageBox('Aviso', 'Codigo de Maquina no definido', StopSign!)
	return
end if

if ib_retrieve = false then
	MessageBox('Aviso', 'No ha recuperado informacion del Codigo de Maquina', StopSign!)
	return
end if

if idw_1 <> dw_frecuencia then
	MessageBox('Aviso', 'No esta permitido ingresar registros', StopSign!)
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_frecuencia.ii_update = 1 OR &
	dw_articulos.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_frecuencia.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = false
Long ll_i
string ls_prog_mnt

if f_row_processing( dw_articulos, 'tabular') = false then
	return
end if

if f_row_processing( dw_frecuencia, 'tabular') = false then
	return
end if

for ll_i = 1 to dw_frecuencia.RowCount()
	if IsNull(dw_frecuencia.object.prog_mnt[ll_i]) &
		or dw_frecuencia.object.prog_mnt[ll_i] = '' then
		
		if of_set_numera (ls_prog_mnt) = false then return
		
		dw_frecuencia.object.prog_mnt[ll_i] = ls_prog_mnt
		
	end if
next

ib_update_check = true


dw_frecuencia.of_set_flag_replicacion( )
dw_articulos.of_set_flag_replicacion( )
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_frecuencia.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF dw_frecuencia.ii_update = 1 THEN
	IF dw_frecuencia.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		MessageBox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_articulos.ii_update = 1 THEN
	IF dw_articulos.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		MessageBox("Error en Grabacion Articulo","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_frecuencia.ii_update = 0
	dw_articulos.ii_update = 0	
END IF
end event

event ue_modify;call super::ue_modify;dw_frecuencia.of_protect()
dw_articulos.of_protect()
dw_frecuencia.Modify("ultimo_mnt.Protect='1if(isRowNew(), 1, 0)'")


end event

type st_2 from statictext within w_ma305_ciclo_frecuencia
integer x = 2039
integer y = 68
integer width = 238
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT ADM"
boolean focusrectangle = false
end type

type sle_ot_adm from singlelineedit within w_ma305_ciclo_frecuencia
event dobleclick pbm_lbuttondblclk
integer x = 2322
integer y = 56
integer width = 352
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_sql, ls_return1, ls_return2

ls_sql = "select distinct a.ot_adm as cod_ot_adm, " &
		 + "a.descripcion as desc_ot_adm " &
		 + "from ot_administracion a, " &
     	 + "ot_adm_usuario    b " &
		 + "where a.ot_adm = b.ot_adm " &
		 + "and b.cod_usr = '" + gs_user + "'"
				 
f_lista(ls_sql, ls_return1, ls_return2, '2')

if isnull(ls_return1) or trim(ls_return1) = '' then return

this.text = ls_return1

end event

event modified;//string ls_codigo, ls_return1, ls_return2
//
//ls_codigo = trim(this.text)
//
//if ls_codigo = '' or IsNull(ls_codigo) then return
//
//select cod_maquina, desc_maq 
//	into :ls_return1, :ls_return2
//	from maquina
//	where flag_estado = '1'
//		and cod_maquina = :ls_codigo;
//
//if sqlca.sqlcode = 100 then 
//	setnull(ls_return1)
//	setnull(ls_return2)
//	messagebox(parent.title, 'Máquina no encotrada')
//end if
//
//sle_cod_maq.text = ls_return1
//sle_desc_maq.text = ls_return2
//
//ib_retrieve = false
//
//if sqlca.sqlcode = 0 then parent.event ue_query_retrieve()

end event

type dw_articulos from u_dw_abc within w_ma305_ciclo_frecuencia
integer x = 1426
integer y = 1072
integer width = 1234
integer height = 668
integer taborder = 50
string dataobject = "d_list_articulo_x_labor_plantilla_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type dw_labores from u_dw_abc within w_ma305_ciclo_frecuencia
integer y = 1072
integer width = 1417
integer height = 660
integer taborder = 60
string dataobject = "d_list_labor_plantilla_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_articulos.Retrieve(this.object.cod_plantilla[currentrow], long(this.object.nro_operacion[currentrow]))
end event

type dw_frecuencia from u_dw_abc within w_ma305_ciclo_frecuencia
event ue_display ( string as_columna,  long al_row )
integer y = 152
integer width = 2665
integer height = 912
integer taborder = 40
string dataobject = "d_ciclo_frecuencia_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_frecuencia
//idw_det  =  				// dw_detail






end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string 	ls_cod_maq, ls_desc_und
decimal	ldc_ind_med

ls_cod_maq = trim(sle_cod_maq.text)

if ls_cod_maq = '' or IsNull(ls_cod_maq) then
	MessageBox('Aviso', 'Codigo de Maquina no definido', StopSign!)
	return
end if

select desc_unidad
	into :ls_desc_und
from unidad
where und = :is_und_hrs;

select ind_act_acumulada
into :ldc_ind_med
from maquina
where cod_maquina = :ls_cod_maq;


this.object.origen		[al_row] = gs_origen
this.object.cod_maquina	[al_row] = ls_cod_maq
this.object.tipo_ciclo	[al_row] = 'F'
this.object.flag_estado	[al_row] = '1'
this.object.frecuencia  [al_row] = 0
this.object.und			[al_row] = is_und_hrs
this.object.desc_unidad	[al_row] = ls_desc_und
this.object.ultimo_mnt	[al_row] = 0.000
this.object.fecha_ultimo_mnt	[al_row] = Today()
this.object.margen		[al_row] = 0.000
this.object.punto_aviso	[al_row] = 0.000
this.object.prom_dia		[al_row] = 8
this.object.reprogr		[al_row] = 0.00
this.object.ind_med_actual [al_row] = ldc_ind_med
end event

event doubleclicked;call super::doubleclicked;string 	ls_col, ls_return1, ls_return2, &
			ls_cod_plantilla, ls_ot_adm

this.AcceptText()
If this.ii_protect = 1 or row < 1 then RETURN

ls_col = lower(trim(string(dwo.name)))
boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tmp, ls_where
Long		ll_i

choose case ls_col
		
	case "cod_plantilla"
		
		ls_ot_adm = sle_ot_adm.text
		
		if IsNull(ls_ot_adm) or ls_ot_adm = '' then
			MessageBox('Aviso', 'Debe Indicar un ot_adm')
			return 
		end if
		
		ls_sql = "select cod_plantilla as codigo, " &
				 + "desc_plantilla as descripcion, " &
				 + "ot_adm as cod_ot_adm " &
				 + "from plant_prod " &
				 + "where ot_adm = '" + ls_ot_adm + "' " &
				 + "and flag_estado = '1'"
				 
		ls_where = ""
		
		if this.RowCount() > 1 then
			
			for ll_i = 1 to this.RowCount()
				ls_cod_plantilla = trim(this.object.cod_plantilla[ll_i])
				if not isnull(ls_cod_plantilla) and trim(ls_cod_plantilla) <> '' then
					ls_where = ls_where + " and cod_plantilla <> '" + ls_cod_plantilla + "'"
				end if
			next
		end if
		
		ls_sql = ls_sql + ls_where 
		
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if trim(ls_return1) = '' or isnull(ls_return1) then return
		this.object.cod_plantilla	[row] = ls_return1
		this.object.desc_plantilla	[row] = ls_return2
		
		dw_labores.reset( )
		
		if dw_labores.retrieve(ls_return1) > 0 then
			dw_labores.setrow(1)
			dw_labores.scrolltorow(1)
			dw_labores.selectrow( 1, true)
		end if
		
		this.ii_update = 1
		
	case "und"
		
		ls_sql = "select und as codigo, " &
			    + "desc_unidad as descripcion " &
				 + "from unidad" 
				 
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if trim(ls_return1) = '' or isnull(ls_return1) then return

		this.object.und			[row] = ls_codigo
		this.object.desc_unidad	[row] = ls_data
		
		this.ii_update = 1

end choose


end event

event keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

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

event rowfocuschanged;call super::rowfocuschanged;il_row = Currentrow              // fila corriente
this.SelectRow(0, False)
this.SelectRow(currentrow, True)

if currentrow <= 0 then return

dw_articulos.reset( )
dw_labores.reset( )
if dw_labores.Retrieve(this.object.cod_plantilla[currentrow]) > 0 then
	dw_labores.scrolltorow(1)
	dw_labores.setrow(1)
	dw_labores.selectrow(1,true)
end if

end event

event itemchanged;call super::itemchanged;string ls_return1, ls_return2
this.AcceptText()

choose case lower(dwo.name)
	case "cod_plantilla"
		
		select pp.cod_plantilla, pp.desc_plantilla
			into :ls_return1, :ls_return2
		from 	plant_prod pp
			inner join ot_adm_usuario oau on pp.ot_adm = oau.ot_adm 
		where pp.flag_estado = '1'
		  and oau.cod_usr = :gs_user
		  and pp.cod_plantilla = :data;
		

		if sqlca.sqlcode = 100 then
			setnull(ls_return1)
			setnull(ls_return2)
			messagebox(parent.title, 'Plantilla ni válida')
		end if
		
		this.object.cod_plantilla[row] = ls_return1
		this.object.desc_plantilla[row] = ls_return2	
		
	case "und"
		
		select und, desc_unidad 
			into :ls_return1, :ls_return2
			from unidad
			where und = :data;
		
		if sqlca.sqlcode = 100 then
			setnull(ls_return1)
			setnull(ls_return2)
			messagebox(parent.title, 'Unidad ni válida')
		end if
		
		this.object.und [row] = ls_return1
		this.object.desc_und [row] = ls_return2
		
		return 2
		
end choose
end event

event buttonclicked;call super::buttonclicked;string ls_docname, ls_named
integer li_value, li_row
sg_parametros sl_param

This.AcceptText()
If this.ii_protect = 1 then RETURN

li_row = this.GetRow()

choose case lower(dwo.name)
	case "b_1"
		sl_param.string1 = sle_ot_adm.text
		
		if IsNUll(sl_param.string1) or sl_param.string1 = '' then
			MessageBox('Alerta', 'Debe Definir un OT_ADM')
			return
		end if
		
		OpenWithParm(w_copia_plant_prod, sl_param)
		
		if IsNull(Message.PowerObjectParm) or &
			Not IsValid(Message.PowerObjectParm) then return
			
		sl_param = Message.PowerObjectParm
		
		if sl_param.titulo = 'n' then return		
		
		this.object.cod_plantilla [row] = sl_param.string1
		this.object.desc_plantilla[row] = sl_param.string2
		
		dw_articulos.reset( )
		dw_labores.reset( )
		if dw_labores.Retrieve(sl_param.string1) > 0 then
			dw_labores.scrolltorow(1)
			dw_labores.setrow(1)
			dw_labores.selectrow(1,true)
		end if
end choose
end event

type st_1 from statictext within w_ma305_ciclo_frecuencia
integer y = 68
integer width = 448
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Maquinaria o Equipo"
boolean focusrectangle = false
end type

type sle_desc_maq from singlelineedit within w_ma305_ciclo_frecuencia
integer x = 818
integer y = 56
integer width = 1211
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_cod_maq from singlelineedit within w_ma305_ciclo_frecuencia
event dobleclick pbm_lbuttondblclk
integer x = 457
integer y = 56
integer width = 352
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_sql, ls_return1, ls_return2

ls_sql = "select cod_maquina as codigo, " &
		 + "desc_maq as descripcion " &
		 + "from maquina " &
		 + "where flag_estado = '1'"
				 
f_lista(ls_sql, ls_return1, ls_return2, '2')

if isnull(ls_return1) or trim(ls_return1) = '' then return

this.text = ls_return1
sle_desc_maq.text = ls_return2

parent.event ue_query_retrieve()
end event

event modified;string ls_codigo, ls_return1, ls_return2

ls_codigo = trim(this.text)

if ls_codigo = '' or IsNull(ls_codigo) then return

select cod_maquina, desc_maq 
	into :ls_return1, :ls_return2
	from maquina
	where flag_estado = '1'
		and cod_maquina = :ls_codigo;

if sqlca.sqlcode = 100 then 
	setnull(ls_return1)
	setnull(ls_return2)
	messagebox(parent.title, 'Máquina no encotrada')
end if

sle_cod_maq.text = ls_return1
sle_desc_maq.text = ls_return2

ib_retrieve = false

if sqlca.sqlcode = 0 then parent.event ue_query_retrieve()

end event

