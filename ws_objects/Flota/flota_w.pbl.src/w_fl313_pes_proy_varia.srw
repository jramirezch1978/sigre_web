$PBExportHeader$w_fl313_pes_proy_varia.srw
forward
global type w_fl313_pes_proy_varia from w_abc_master_smpl
end type
type dw_1 from u_dw_abc within w_fl313_pes_proy_varia
end type
type dw_2 from u_dw_abc within w_fl313_pes_proy_varia
end type
type sle_nave from singlelineedit within w_fl313_pes_proy_varia
end type
type st_1 from statictext within w_fl313_pes_proy_varia
end type
type cb_1 from commandbutton within w_fl313_pes_proy_varia
end type
type sle_year from singlelineedit within w_fl313_pes_proy_varia
end type
type st_2 from statictext within w_fl313_pes_proy_varia
end type
type st_nave from statictext within w_fl313_pes_proy_varia
end type
end forward

global type w_fl313_pes_proy_varia from w_abc_master_smpl
integer width = 3305
integer height = 2120
string title = "Variación de las Proyecciones (FL313)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
dw_1 dw_1
dw_2 dw_2
sle_nave sle_nave
st_1 st_1
cb_1 cb_1
sle_year sle_year
st_2 st_2
st_nave st_nave
end type
global w_fl313_pes_proy_varia w_fl313_pes_proy_varia

type variables

end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nave, long al_year)
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from NUM_FL_PESCA_PROY_VAR
	where cod_origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE NUM_FL_PESCA_PROY_VAR IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into NUM_FL_PESCA_PROY_VAR(cod_origen, ult_nro)
		values( :gs_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_FL_PESCA_PROY_VAR
	where cod_origen = :gs_origen for update;
	
	update NUM_FL_PESCA_PROY_VAR
		set ult_nro = ult_nro + 1
	where cod_origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_variacion[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
end if

return 1
end function

public subroutine of_retrieve (string as_nave, long al_year);dw_1.retrieve(as_nave,al_year)
dw_2.retrieve(as_nave,al_year)
dw_1.visible = true
dw_2.visible = true
end subroutine

on w_fl313_pes_proy_varia.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.dw_1=create dw_1
this.dw_2=create dw_2
this.sle_nave=create sle_nave
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_year=create sle_year
this.st_2=create st_2
this.st_nave=create st_nave
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.sle_nave
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.sle_year
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_nave
end on

on w_fl313_pes_proy_varia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.sle_nave)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_year)
destroy(this.st_2)
destroy(this.st_nave)
end on

event ue_open_pre;call super::ue_open_pre;//im_1.m_cortar.visible = false

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente

dw_master.of_protect()         		// bloquear modificaciones 
end event

event ue_dw_share;// Ancestor Script has been Override
//no debe hacer el retrieve
end event

event ue_modify;// Ancestor Script has been Override
end event

event ue_update;date 		ld_hoy
string 	ls_code
integer 	li_ano, li_mes, li_cantidad, &
			li_mes_act, li_ano_act
long 		ll_row

Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

ll_row 		= dw_master.GetRow()

ls_code 		= dw_master.object.nave[ll_row]
li_ano 		= dw_master.object.ano[ll_row]
li_mes 		= dw_master.object.mes[ll_row]
li_cantidad = dw_master.object.cantidad[ll_row]
ld_hoy 		= Date(f_fecha_actual())

li_ano_act 	= year(ld_hoy)
li_mes_act	= month(ld_hoy)

if Isnull(ls_code) or ls_code = '' then
	MessageBox('Aviso', 'Código de la nave en blanco', StopSign!)
	dw_master.setcolumn ('nave')
	return
end if

if Isnull(li_mes) then
	MessageBox('Aviso', 'Mes en blanco', StopSign!)
	dw_master.setcolumn ('mes')
	return
end if

if Isnull(li_ano) then
	MessageBox('Aviso', 'Año en blanco', StopSign!)
	dw_master.setcolumn ('ano')
	return
end if

if li_cantidad <= 0 or IsNull(li_cantidad) then 
	messagebox('Flota', 'No puede ingresar una variacion menor o igual a 0', StopSign!)
	dw_master.setcolumn ('cantidad')
	return
end if

/////////////////////////////////////////////////////////////////////////////////
THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	//in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_1.retrieve(ls_code,li_ano)
	dw_2.retrieve(ls_code,li_ano)
	is_action='open'

END IF
end event

event ue_insert;//// Ancestor Script has been Override
Long  ll_row

idw_1.Reset()

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event resize;// Ancestor Script has been Override
dw_master.width  	= newwidth  - dw_master.x - 10
dw_1.width			= newwidth  - dw_1.x - 10
dw_2.width			= newwidth  - dw_2.x - 10
dw_2.height 		= newheight - dw_2.y - 10
end event

event closequery;// Ancestor Script has been Override
THIS.Event ue_close_pre()
THIS.EVENT ue_update_request()

Destroy	im_1

of_close_sheet()

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = FALSE

dw_master.of_set_flag_replicacion()

if of_set_numera() = 0 then return

ib_update_check = TRUE


end event

type dw_master from w_abc_master_smpl`dw_master within w_fl313_pes_proy_varia
event ue_display ( string as_columna,  long al_row )
integer y = 100
integer width = 2501
integer height = 552
string dataobject = "d_pesca_proy_varia_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::ue_display(string as_columna, long al_row);integer 	li_mes, li_ano
string 	ls_sql, ls_codigo, ls_descr
boolean 	lb_ret

choose case lower(as_columna)
	case 'nave'
		ls_sql = "select nave as codigo_emb, " &
				 + "nomb_nave as descripcion " &
				 + "from vw_fl_nave_proy_pesca " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_descr, '1')
							
		if ls_codigo = '' then return
		
		if f_max_ano_mes( ls_codigo, li_ano, li_mes ) = false then return
		
		this.object.nave		[al_row]		= ls_codigo
		this.object.nomb_nave[al_row] 	= ls_descr
		this.object.cod_usr	[al_row] 	= gs_user
		this.object.mes		[al_row] 	= li_mes
		this.object.ano		[al_row] 	= li_ano
		
		dw_1.retrieve(ls_codigo,li_ano)
		dw_2.retrieve(ls_codigo,li_ano)
		dw_1.visible = true
		dw_2.visible = true
end choose

end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail


end event

event dw_master::itemchanged;call super::itemchanged;integer 	li_desc, li_mes, li_ano, li_cuenta, li_mes_act, li_ano_act
string 	ls_code, ls_desc, ls_columna, ls_cadena, ls_nave, ls_select, &
			ls_date, ls_sql, ls_fec_act, ls_fec_ing, ls_null
date 		ld_fecha, ld_hoy
Boolean	lb_ret

SetNull(ls_null)
ls_columna = lower(dwo.name)
this.AcceptText()
ls_code = trim(this.object.nave[row])

IF ls_columna = 'mes' or ls_columna = 'ano' then
	ld_hoy = Today()
	
	li_ano 		= this.object.ano[row]
	li_ano_act  = year(ld_hoy)
	
	li_mes 		= this.object.mes[row]
	li_mes_act 	= month(ld_hoy)
	
	ls_fec_act = string(li_ano_act, '0000') + string(li_mes_act,'00')
	ls_fec_ing = string(li_ano, '0000') + string(li_mes,'00')
	
	if ls_fec_ing < ls_fec_act then
		MessageBox('Aviso','No puede registrar variaciones para periodos ' &
			+ 'anteriores al periodo actual',StopSign! )
			
		f_max_ano_mes( ls_code, li_ano, li_mes)
		
		this.object.ano[row] = li_ano
		this.object.mes[row] = li_mes
		return 1
	end if
end if

choose case ls_columna
	case 'nave'
		
		SetNull(ls_desc)
		select nomb_nave 
			into :ls_desc 
		from vw_fl_nave_proy_pesca 
		where nave = :ls_code;
		
		if SQLCA.SQLCode = 100 then
			messagebox('Flota','No existe ningún registro de ' &
				+ '~r~nproyeccion para la nave '+ls_code, StopSign!)
			this.object.nave[row] = ls_code
		end if
		
		this.object.nomb_nave_t.text = ls_desc
		
		f_max_ano_mes( ls_code, li_ano, li_mes)
		
		this.object.ano[row] = li_ano
		this.object.mes[row] = li_mes
		
		dw_1.Retrieve(ls_code,li_ano)
		dw_1.Retrieve(ls_code,li_ano)
		return 2
		
	case 'ano'
		li_ano = this.object.ano[row]
		li_mes = this.object.mes[row]
		li_cuenta = 0
		
		select count(*) 
			into :li_cuenta
		from fl_pesca_proy fpp 
		where fpp.nave = :ls_code
		  and fpp.ano  = :li_ano 
		  and fpp.mes  = :li_mes;
		  
		if li_cuenta <> 1 then
			MessageBox('Flota','No existe registro para el año ' &
					+ string(li_ano) + ' y mes ' + string(li_mes) &
					+ ', para la nave ' + ls_nave, StopSign!)
					
			select max(ano) 
				into :li_ano
			from fl_pesca_proy fpp 
			where fpp.nave = :ls_code
			  and fpp.mes 	= :li_mes;
				
			this.object.ano[row] = li_ano
			
			return 1
		end if
		
		dw_1.Retrieve(ls_code,li_ano)
		dw_2.Retrieve(ls_code,li_ano)
		
	case 'mes'
		li_ano = this.object.ano[row]
		li_mes = this.object.mes[row]
		li_cuenta = 0
		
		select count(fpp.nave) 
			into :li_cuenta
		from fl_pesca_proy fpp 
		where fpp.nave = :ls_code
		  and fpp.ano = :li_ano 
		  and fpp.mes  = :li_mes;
		  
		if li_cuenta <> 1 then
			MessageBox('Flota','No existe registro para el año ' &
				+ string(li_ano) + ' y mes ' + string(li_mes) &
				+ ', para la nave ' + ls_nave, StopSign!)
			select max(mes) 
				into :li_mes 
			from fl_pesca_proy fpp 
			where fpp.nave = :ls_code
			  and fpp.ano = :li_ano;
			
			this.object.mes[row] = li_mes
			return 1
		end if
		
end choose
end event

event dw_master::itemfocuschanged;call super::itemfocuschanged;this.AcceptText()
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_master::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
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

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer 	li_desc, li_mes, li_ano
string 	ls_cadena, ls_codigo, ls_descr, ls_sql
boolean	lb_ret

ls_sql = "select nave as codigo_emb, " &
		 + "nomb_nave as descripcion " &
		 + "from vw_fl_nave_proy_pesca " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_descr, '1')
					
if ls_codigo = '' then
	this.event dynamic ue_delete()
	dw_1.Reset()
	dw_2.Reset()
	return
end if

al_row = this.GetRow()

if f_max_ano_mes( ls_codigo, li_ano, li_mes ) = false then
	return
end if

this.object.nave		[al_row] = ls_codigo
this.object.nomb_nave[al_row] = ls_descr
this.object.cod_usr	[al_row] = gs_user
this.object.mes		[al_row] = li_mes
this.object.ano		[al_row] = li_ano
this.object.fecha		[al_row]	= f_fecha_actual()

dw_1.retrieve(ls_codigo,li_ano)
dw_2.retrieve(ls_codigo,li_ano)
is_action = 'new'


end event

event dw_master::itemerror;call super::itemerror;return 1
end event

type dw_1 from u_dw_abc within w_fl313_pes_proy_varia
integer y = 664
integer width = 2501
integer height = 588
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pesca_proy_var_crt"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type dw_2 from u_dw_abc within w_fl313_pes_proy_varia
integer y = 1268
integer width = 2501
integer height = 520
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pesca_proy_varia_grf"
boolean livescroll = false
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type sle_nave from singlelineedit within w_fl313_pes_proy_varia
event doble_click pbm_lbuttondblclk
integer x = 832
integer y = 12
integer width = 302
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event doble_click;string 	ls_sql, ls_codigo, ls_descr
boolean 	lb_ret
ls_sql = "select nave as codigo_emb, " &
		 + "nomb_nave as descripcion " &
		 + "from vw_fl_nave_proy_pesca " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_descr, '1')
							
if ls_codigo = '' then return
		
this.text = ls_codigo
st_nave.text = ls_descr

end event

event modified;string ls_codigo, ls_descr

ls_codigo = this.text 

select nomb_nave
	into :ls_descr
from tg_naves
where nave = :ls_codigo;

if SQLCA.SQLCode = 100 then
	this.text = ''
	MessageBox('Error', 'Codigo de nave no existe')
	return
end if

st_nave.text = ls_descr
end event

type st_1 from statictext within w_fl313_pes_proy_varia
integer x = 480
integer y = 20
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Embarcación"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_fl313_pes_proy_varia
integer x = 1874
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
string text = "Consultar"
end type

event clicked;String 	ls_nave
Long		ll_year

ls_nave = sle_nave.text
ll_year = Long(sle_year.text)

of_retrieve(ls_nave, ll_year)
end event

type sle_year from singlelineedit within w_fl313_pes_proy_varia
integer x = 201
integer y = 12
integer width = 256
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_fl313_pes_proy_varia
integer x = 55
integer y = 20
integer width = 142
integer height = 56
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

type st_nave from statictext within w_fl313_pes_proy_varia
integer x = 1152
integer y = 12
integer width = 681
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

