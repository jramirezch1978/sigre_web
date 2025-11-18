$PBExportHeader$w_pr312_parte_piso_quick.srw
forward
global type w_pr312_parte_piso_quick from w_abc_master_smpl
end type
type tab_det from tab within w_pr312_parte_piso_quick
end type
type tp_1 from userobject within tab_det
end type
type em_control from editmask within tp_1
end type
type st_2 from statictext within tp_1
end type
type em_hora from editmask within tp_1
end type
type st_1 from statictext within tp_1
end type
type dw_det from u_dw_abc within tp_1
end type
type pb_3 from picturebutton within tp_1
end type
type pb_1 from picturebutton within tp_1
end type
type pb_2 from picturebutton within tp_1
end type
type tp_1 from userobject within tab_det
em_control em_control
st_2 st_2
em_hora em_hora
st_1 st_1
dw_det dw_det
pb_3 pb_3
pb_1 pb_1
pb_2 pb_2
end type
type tp_2 from userobject within tab_det
end type
type dw_obs from u_dw_abc within tp_2
end type
type tp_2 from userobject within tab_det
dw_obs dw_obs
end type
type tp_3 from userobject within tab_det
end type
type dw_tinc from u_dw_abc within tp_3
end type
type dw_tuso from u_dw_abc within tp_3
end type
type tp_3 from userobject within tab_det
dw_tinc dw_tinc
dw_tuso dw_tuso
end type
type tab_det from tab within w_pr312_parte_piso_quick
tp_1 tp_1
tp_2 tp_2
tp_3 tp_3
end type
type st_3 from statictext within w_pr312_parte_piso_quick
end type
end forward

global type w_pr312_parte_piso_quick from w_abc_master_smpl
integer width = 3877
integer height = 2480
string title = "Registro de Lecturas Por Parte de Piso(PR312) "
string menuname = "m_mantto_smpl"
windowstate windowstate = maximized!
tab_det tab_det
st_3 st_3
end type
global w_pr312_parte_piso_quick w_pr312_parte_piso_quick

type variables
string is_nro_parte, is_title, is_autor
end variables

on w_pr312_parte_piso_quick.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.tab_det=create tab_det
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_det
this.Control[iCurrent+2]=this.st_3
end on

on w_pr312_parte_piso_quick.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_det)
destroy(this.st_3)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0

//dw_zona_descarga.settransobject(sqlca)
tab_det.tp_1.dw_det.settransobject(sqlca)
tab_det.tp_2.dw_obs.settransobject(sqlca)
tab_det.tp_3.dw_tuso.settransobject(sqlca)
tab_det.tp_3.dw_tinc.settransobject(sqlca)

//dw_zona_descarga.of_protect()
tab_det.tp_1.dw_det.of_protect()
tab_det.tp_2.dw_obs.of_protect()
tab_det.tp_3.dw_tuso.of_protect()
tab_det.tp_3.dw_tinc.of_protect()

is_title = this.title

select u.nombre
	into :is_autor
	from usuario u 
	where trim(u.cod_usr) = trim(:gs_user);
	
is_autor = mid(upper(trim(is_autor)), 1, 30)
end event

event resize;//override
//dw_master.width  = newwidth  - dw_master.x - 10

tab_det.width  = newwidth  - tab_det.x - 10
tab_det.height = newheight - tab_det.y - 10

tab_det.tp_1.dw_det.width  = newwidth  - tab_det.tp_1.dw_det.x - 50
tab_det.tp_1.dw_det.height = newheight - tab_det.tp_1.dw_det.y - 500

tab_det.tp_2.dw_obs.width  = newwidth  - tab_det.tp_2.dw_obs.x - 50
tab_det.tp_2.dw_obs.height = newheight - tab_det.tp_2.dw_obs.y - 500

tab_det.tp_3.dw_tuso.width  = newwidth  - tab_det.tp_3.dw_tuso.x - 50

tab_det.tp_3.dw_tinc.width  = newwidth  - tab_det.tp_3.dw_tinc.x - 50
tab_det.tp_3.dw_tinc.height = newheight - tab_det.tp_3.dw_tinc.y - 500


end event

event ue_query_retrieve;string ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_cod_maquina

ls_sql = 'select nro_parte as numero, parte_fmt as formato, parte_desc as descripcion, parte_fecha as fecha from vw_pr_parte_piso_fmt'

f_lista_4ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, '1')

if isnull(ls_return1) or trim (ls_return1) = '' then return

dw_master.reset( )
//dw_zona_descarga.reset( )
tab_det.tp_1.dw_det.reset( ) 
tab_det.tp_2.dw_obs.reset( )
tab_det.tp_3.dw_tuso.reset( )
tab_det.tp_3.dw_tinc.reset( )

if dw_master.retrieve(ls_return1) <> 1 then return

//dw_zona_descarga.retrieve(ls_return1) 
tab_det.tp_1.dw_det.retrieve(ls_return1, 1, 1)
tab_det.tp_2.dw_obs.retrieve(ls_return1)

if tab_det.tp_3.dw_tuso.retrieve(ls_return1) < 1 then return

tab_det.tp_3.dw_tuso.selectrow( 0 , false )
tab_det.tp_3.dw_tuso.scrolltorow( 1 )
tab_det.tp_3.dw_tuso.setrow( 1 )
tab_det.tp_3.dw_tuso.selectrow( 1 , true )

ls_cod_maquina = tab_det.tp_3.dw_tuso.object.cod_maquina[1]

tab_det.tp_3.dw_tinc.retrieve(ls_return1, ls_cod_maquina)
end event

event ue_retrieve_list;call super::ue_retrieve_list;this.event ue_query_retrieve( )
end event

event ue_modify;call super::ue_modify;tab_det.tp_1.dw_det.of_protect()
end event

event ue_update;//override
long ll_master
Boolean  lbo_ok = TRUE
String	ls_msg, ls_nro_parte

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	tab_det.tp_1.dw_det.of_create_log()
	tab_det.tp_2.dw_obs.of_create_log()
	tab_det.tp_3.dw_tuso.of_create_log()
	tab_det.tp_3.dw_tinc.of_create_log()
END IF

ll_master = dw_master.getrow( )
if ll_master > 0 then
	ls_nro_parte = dw_master.object.nro_parte[ll_master]
	if isnull(ls_nro_parte) or trim(ls_nro_parte) = '' then

		select trim(:gs_origen) || trim(lpad(to_char(nvl(max(substr(pp.nro_parte, 3, 8)), 0) + 1), 8, '0'))
			into :ls_nro_parte
			from tg_parte_piso pp
			where substr(pp.nro_parte, 1, 2) = trim(:gs_origen);
		 
		 dw_master.object.nro_parte[ll_master] = ls_nro_parte
	end if
end if


IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	tab_det.tp_1.dw_det.ii_update = 1 THEN
	IF tab_det.tp_1.dw_det.Update(true, false) = -1 then		// Grabacion del Detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	tab_det.tp_2.dw_obs.ii_update = 1 THEN
	IF tab_det.tp_2.dw_obs.Update(true, false) = -1 then		// Grabacion del Detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	tab_det.tp_3.dw_tuso.ii_update = 1 THEN
	IF tab_det.tp_3.dw_tuso.Update(true, false) = -1 then		// Grabacion del Detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	tab_det.tp_3.dw_tinc.ii_update = 1 THEN
	IF tab_det.tp_3.dw_tinc.Update(true, false) = -1 then		// Grabacion del Detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
		tab_det.tp_1.dw_det.of_save_log()
		tab_det.tp_2.dw_obs.of_save_log()
		tab_det.tp_3.dw_tuso.of_save_log()
		tab_det.tp_3.dw_tinc.of_save_log()
	END IF

END IF

IF lbo_ok THEN
	
	COMMIT using SQLCA;
	
	dw_master.ii_update = 0
	tab_det.tp_1.dw_det.ii_update = 0
	tab_det.tp_2.dw_obs.ii_update = 0
	tab_det.tp_3.dw_tuso.ii_update = 0
	tab_det.tp_3.dw_tinc.ii_update = 0

	dw_master.il_totdel = 0
	tab_det.tp_1.dw_det.il_totdel = 0
	tab_det.tp_2.dw_obs.il_totdel = 0
	tab_det.tp_3.dw_tuso.il_totdel = 0
	tab_det.tp_3.dw_tinc.il_totdel = 0
	
	dw_master.ResetUpdate()
	tab_det.tp_1.dw_det.ResetUpdate()
	tab_det.tp_2.dw_obs.ResetUpdate()
	tab_det.tp_3.dw_tuso.ResetUpdate()
	tab_det.tp_3.dw_tinc.ResetUpdate()
	
END IF

end event

event ue_update_request;//override
Integer li_msg_result

IF dw_master.ii_update = 1 or tab_det.tp_1.dw_det.ii_update = 1 or tab_det.tp_2.dw_obs.ii_update = 1 or tab_det.tp_3.dw_tuso.ii_update = 1 or tab_det.tp_3.dw_tinc.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		THIS.EVENT ue_update()
	END IF
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_pr312_parte_piso_quick
integer y = 68
integer width = 3707
integer height = 604
string dataobject = "d_ap_pp_quick_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
ii_ck[1] = 1
is_dwform = 'form'
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_sql, ls_col, ls_return1, ls_return2, ls_nro_parte
long ll_cuenta, ll_detail

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'formato'
		
		ls_nro_parte = this.object.nro_parte[row]
		
		select count(*)
			into :ll_cuenta
			from tg_parte_piso_det 
			where trim(nro_parte) = trim(:ls_nro_parte);

		ll_detail = tab_det.tp_1.dw_det.rowcount( )
		
		if ll_cuenta > 0 or ll_detail > 0 then
			messagebox(parent.title, 'No puede modificar el formato si ya se han ingresado lecturas')
			return
		end if
		
		ls_sql = "select formato as codigo, descripcion as nombre from tg_fmt_med_act where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.formato[row] = ls_return1
		this.object.descripcion[row] = ls_return2
		this.ii_update = 1
	case 'turno'
		ls_sql = "select turno as codigo, descripcion as nombre from turno where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.turno[row] = ls_return1
		this.object.turno_descripcion[row] = ls_return2
		this.ii_update = 1
		
		case 'tipo'
		ls_sql = "select cod_planta as codigo, desc_planta as descripcion from tg_plantas where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.tipo[row] = ls_return1
		this.object.desc_planta[row] = ls_return2
		this.ii_update = 1
		
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_sql, ls_return1, ls_return2

this.object.fecha_parte[al_row] 	= f_fecha_actual()
this.object.fecha_reg[al_row] 	= f_fecha_actual()
this.object.cod_usr[al_row] 		= gs_user
this.object.p_logo.filename 		= gs_logo

ls_sql = "select formato as codigo, descripcion as nombre from tg_fmt_med_act where flag_estado = '1'"
f_lista(ls_sql, ls_return1, ls_return2, '2')

if isnull(ls_return1) or trim(ls_return1) = '' then return
this.object.formato[al_row] = ls_return1
this.object.descripcion[al_row] = ls_return2

end event

event dw_master::itemchanged;call super::itemchanged;string ls_sql, ls_col, ls_return1, ls_return2, ls_nro_parte
long ll_cuenta, ll_detail

ls_col = lower(trim(string(dwo.name)))

this.accepttext( )

choose case ls_col
	case 'formato'
		
		ls_nro_parte = this.object.nro_parte[row]
		
		select count(*)
			into :ll_cuenta
			from tg_parte_piso_det 
			where trim(nro_parte) = trim(:ls_nro_parte);

		ll_detail = tab_det.tp_1.dw_det.rowcount( )
		
		if ll_cuenta > 0 or ll_detail > 0 then
			messagebox(parent.title, 'No puede modificar el formato si ya se han ingresado lecturas')
			return
		end if
		
		select formato, descripcion 
			into :ls_return1, :ls_return2
			from tg_fmt_med_act 
			where flag_estado = '1'
				and trim(formato) = trim(:data);
			
		if sqlca.sqlcode <> 0 then
			messagebox(parent.title, 'No se encuentra el formato ingresado')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.formato[row] = ls_return1
		this.object.descripcion[row] = ls_return2
		
		return 2
		
	case 'turno'
		select turno, descripcion
			into :ls_return1, :ls_return2
			from turno 
			where flag_estado = '1'
				and trim(turno) = trim(:data);
		
		if sqlca.sqlcode <> 0 then
			messagebox(parent.title, 'No se encuentra el turno ingresado')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.turno[row] = ls_return1
		this.object.turno_descripcion[row] = ls_return2
		
		return 2
		
case 'tipo'
		select cod_planta, desc_planta
			into :ls_return1, :ls_return2
			from tg_plantas 
			where flag_estado = '1'
				and trim(cod_planta) = trim(:data);
		
		if sqlca.sqlcode <> 0 then
			messagebox(parent.title, 'Planta no Existe o no se ha Definido')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.tipo[row] = ls_return1
		this.object.desc_planta[row] = ls_return2
		
		return 2

end choose
end event

type tab_det from tab within w_pr312_parte_piso_quick
event ue_update ( )
event ue_modify ( )
integer x = 23
integer y = 724
integer width = 3698
integer height = 1212
integer taborder = 20
boolean bringtotop = true
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
tp_3 tp_3
end type

event ue_update();parent.event ue_update_request( )
end event

event ue_modify();parent.event ue_modify( )
end event

on tab_det.create
this.tp_1=create tp_1
this.tp_2=create tp_2
this.tp_3=create tp_3
this.Control[]={this.tp_1,&
this.tp_2,&
this.tp_3}
end on

on tab_det.destroy
destroy(this.tp_1)
destroy(this.tp_2)
destroy(this.tp_3)
end on

type tp_1 from userobject within tab_det
event ue_update ( )
event ue_modify ( )
integer x = 18
integer y = 112
integer width = 3662
integer height = 1084
long backcolor = 79741120
string text = "Lecturas por hora / control"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom041!"
long picturemaskcolor = 536870912
em_control em_control
st_2 st_2
em_hora em_hora
st_1 st_1
dw_det dw_det
pb_3 pb_3
pb_1 pb_1
pb_2 pb_2
end type

event ue_update();parent.event ue_update()
end event

event ue_modify();parent.event ue_modify( )
end event

on tp_1.create
this.em_control=create em_control
this.st_2=create st_2
this.em_hora=create em_hora
this.st_1=create st_1
this.dw_det=create dw_det
this.pb_3=create pb_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.Control[]={this.em_control,&
this.st_2,&
this.em_hora,&
this.st_1,&
this.dw_det,&
this.pb_3,&
this.pb_1,&
this.pb_2}
end on

on tp_1.destroy
destroy(this.em_control)
destroy(this.st_2)
destroy(this.em_hora)
destroy(this.st_1)
destroy(this.dw_det)
destroy(this.pb_3)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type em_control from editmask within tp_1
integer x = 1115
integer y = 56
integer width = 165
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
end type

type st_2 from statictext within tp_1
integer x = 608
integer y = 72
integer width = 494
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Número de Control:"
boolean focusrectangle = false
end type

type em_hora from editmask within tp_1
integer x = 425
integer y = 56
integer width = 165
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
end type

type st_1 from statictext within tp_1
integer x = 5
integer y = 72
integer width = 416
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hora de Lectura:"
boolean focusrectangle = false
end type

type dw_det from u_dw_abc within tp_1
integer x = 18
integer y = 136
integer width = 3639
integer height = 924
integer taborder = 20
string dataobject = "d_ap_pp_det_quick_ff"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert;//override
return -1
end event

event ue_insert_pre;//override
end event

type pb_3 from picturebutton within tp_1
string tag = "Cargar Lecturas"
integer x = 1381
integer y = 32
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Retrieve!"
alignment htextalign = left!
end type

event clicked;long ll_master, ll_detail
string ls_nro_parte, ls_msg
integer li_hora, li_control, li_msg

parent.event ue_update( )

if tab_det.tp_1.dw_det.ii_protect = 1 then parent.event ue_modify( )

ll_master = dw_master.getrow( )

if ll_master < 1 then return

ls_nro_parte = dw_master.object.nro_parte[ll_master]

if isnull(ls_nro_parte) or trim(ls_nro_parte) = '' then
	messagebox(is_title, 'No hay ningún formato de parte de piso definido')
	return
end if

li_hora = integer(tab_det.tp_1.em_hora.text)

li_control = integer(tab_det.tp_1.em_control.text)

tab_det.tp_1.dw_det.retrieve(ls_nro_parte, li_hora, li_control)
end event

type pb_1 from picturebutton within tp_1
string tag = "Agregar todas las lecturas"
integer x = 1504
integer y = 32
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "AlignBottom!"
alignment htextalign = left!
end type

event clicked;long ll_master, ll_detail
string ls_nro_parte, ls_msg
integer li_hora, li_control, li_msg

parent.event ue_update( )

if tab_det.tp_1.dw_det.ii_protect = 1 then parent.event ue_modify( )

ll_master = dw_master.getrow( )

if ll_master < 1 then return

ls_nro_parte = dw_master.object.nro_parte[ll_master]

if isnull(ls_nro_parte) or trim(ls_nro_parte) = '' then
	messagebox(is_title, 'No hay ningún formato de parte de piso definido')
	return
end if

li_hora = integer(tab_det.tp_1.em_hora.text)

li_control = integer(tab_det.tp_1.em_control.text)

ll_detail = tab_det.tp_1.dw_det.retrieve(ls_nro_parte, li_hora, li_control)

if ll_detail > 1 then
	messagebox(is_title, 'El parte de piso tiene al menos una lectura. Elimínelas')
	return
end if

//declare pb_parte_piso_det_fill procedure for 
//	usp_pr_parte_piso_det_quick(:ls_nro_parte, :li_control, :li_hora);
//
//execute pb_parte_piso_det_fill;
//fetch pb_parte_piso_det_fill into :li_msg, :ls_msg;
//close pb_parte_piso_det_fill;
//
if li_msg = 1 then
	messagebox(is_title, ls_msg)
	return
end if

ll_detail = tab_det.tp_1.dw_det.retrieve(ls_nro_parte, li_hora, li_control)

if ll_detail < 1 then
	messagebox(is_title, 'Se ha creado el detalle del parte de piso, pero no se ha podido mostrar.  Rintente por favor')
	return
end if

/*LONG 		ll_master, ll_detail
STRING	ls_nro_parte, ls_msg
INTEGER 	li_hora, li_control, li_msg

Parent.event ue_update( )

IF tab_det.tp_1.dw_det.ii_protect = 1 then
	parent.event ue_modify( )

ll_master = dw_master.getrow( )

if ll_master < 1 then return

ls_nro_parte = dw_master.object.nro_parte[ll_master]

if isnull(ls_nro_parte) or trim(ls_nro_parte) = '' then
	messagebox(is_title, 'Aùn no se ha definido el Parte de Piso, ¡ Porda')
	return
end if

li_hora = integer(tab_det.tp_1.em_hora.text)

li_control = integer(tab_det.tp_1.em_control.text)

ll_detail = tab_det.tp_1.dw_det.retrieve(ls_nro_parte, li_hora, li_control)

if ll_detail > 1 then
	messagebox(is_title, 'El parte de piso tiene al menos una lectura. Elimínelas')
	return
end if

declare pb_parte_piso_det_fill procedure for 
	usp_pr_parte_piso_det_quick(:ls_nro_parte, :li_control, :li_hora);

execute pb_parte_piso_det_fill;
fetch pb_parte_piso_det_fill into :li_msg, :ls_msg;
close pb_parte_piso_det_fill;

if li_msg = 1 then
	messagebox(is_title, ls_msg)
	return
end if

ll_detail = tab_det.tp_1.dw_det.retrieve(ls_nro_parte, li_hora, li_control)

if ll_detail < 1 then
	messagebox(is_title, 'Se ha creado el detalle del parte de piso, pero no se ha podido mostrar.  Rintente por favor')
	return
end if*/
end event

type pb_2 from picturebutton within tp_1
string tag = "Elminar Todas las Lecturas"
integer x = 1632
integer y = 28
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "AlignTop!"
alignment htextalign = left!
end type

event clicked;long ll_det, ll_row

ll_det = tab_det.tp_1.dw_det.rowcount( )

if ll_det < 1 then return

if messagebox(is_title, '¿Está seguro que desea eliminar TODO el detalle mostrado?', Question!, YesNo!, 2) = 2 then return

for ll_row = ll_det to 1 step -1
	tab_det.tp_1.dw_det.scrolltorow(ll_row)
	tab_det.tp_1.dw_det.setrow(ll_row)
	tab_det.tp_1.dw_det.selectrow(ll_row, true)
	tab_det.tp_1.dw_det.deleterow(ll_row)
next

tab_det.tp_1.dw_det.ii_update = 1
end event

type tp_2 from userobject within tab_det
integer x = 18
integer y = 112
integer width = 3662
integer height = 1084
long backcolor = 79741120
string text = "Observaciones / Acciones Correctivas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "OutputStop!"
long picturemaskcolor = 536870912
dw_obs dw_obs
end type

on tp_2.create
this.dw_obs=create dw_obs
this.Control[]={this.dw_obs}
end on

on tp_2.destroy
destroy(this.dw_obs)
end on

type dw_obs from u_dw_abc within tp_2
integer width = 2510
integer taborder = 20
string dataobject = "d_ap_pp_obs_quick_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'
is_dwform = 'tabular'
ii_ck[1] = 1

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;integer li_item
long ll_rows, ll_master
string ls_nro_parte

ll_master = dw_master.getrow( )

if ll_master < 1 then
	messagebox(is_title, 'No se puede insertar una observación sin número de parte')
   this.event ue_delete( )
	return
end if

ls_nro_parte = dw_master.object.nro_parte[ll_master]

ll_rows = this.rowcount( )

if ll_rows < 2 then
	li_item = 1
else
	li_item = this.object.item[ll_rows - 1] + 1
end if

this.object.nro_parte[al_row] = ls_nro_parte
this.object.item[al_row] = li_item
this.object.autor[al_row] = is_autor
end event

type tp_3 from userobject within tab_det
integer x = 18
integer y = 112
integer width = 3662
integer height = 1084
long backcolor = 79741120
string text = "Tiempo de Uso de Equipos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom063!"
long picturemaskcolor = 536870912
dw_tinc dw_tinc
dw_tuso dw_tuso
end type

on tp_3.create
this.dw_tinc=create dw_tinc
this.dw_tuso=create dw_tuso
this.Control[]={this.dw_tinc,&
this.dw_tuso}
end on

on tp_3.destroy
destroy(this.dw_tinc)
destroy(this.dw_tuso)
end on

type dw_tinc from u_dw_abc within tp_3
integer y = 800
integer width = 3328
integer height = 300
integer taborder = 30
string dataobject = "d_ap_pp_tinc_quick_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'
is_dwform = 'tabular'
ii_ck[1] = 1

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2
ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'cod_incidencia'
		ls_sql = "select cod_incidencia as codigo, desc_incidencia as descripcion from incidencias_dma where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cod_incidencia[row] = ls_return1
		this.object.desc_incidencia[row] = ls_return2
		this.ii_update = 1
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;integer li_item
string ls_nro_parte, ls_cod_maquina, ls_sql, ls_return1, ls_return2
long ll_tuso, ll_rows

ll_tuso = tab_det.tp_3.dw_tuso.getrow( )

if ll_tuso < 1 then
	messagebox(is_title, 'No se puede insertar una incidencia sin haber insertado primer la máquina')
   this.event ue_delete( )
	return
end if

ls_nro_parte = tab_det.tp_3.dw_tuso.object.nro_parte[ll_tuso]
ls_cod_maquina = tab_det.tp_3.dw_tuso.object.cod_maquina[ll_tuso]

if isnull(ls_nro_parte) or trim(ls_nro_parte) = '' or isnull(ls_cod_maquina) or trim(ls_cod_maquina) = '' then
	messagebox(is_title, 'No se puede insertar una incidencia sin haber insertado primer la máquina')
   this.event ue_delete( )
	return
end if

ll_rows = this.rowcount( )

if ll_rows < 2 then
	li_item = 1
else
	li_item = this.object.item[ll_rows - 1] + 1
end if

ls_sql = "select cod_incidencia as codigo, desc_incidencia as descripcion from incidencias_dma where flag_estado = '1'"		

f_lista(ls_sql, ls_return1, ls_return2, '2')

	
this.object.item[al_row] = li_item
this.object.nro_parte[al_row] = ls_nro_parte
this.object.cod_maquina[al_row] = ls_cod_maquina
this.object.hora_inicio[al_row] = datetime(today(), now())
this.object.hora_fin[al_row] = datetime(today(), now())
this.object.autor[al_row] = is_autor
this.object.cod_incidencia[al_row] = ls_return1
this.object.desc_incidencia[al_row] = ls_return2
end event

event itemchanged;call super::itemchanged;string ls_col, ls_sql, ls_return1, ls_return2
ls_col = lower(trim(string(dwo.name)))

this.accepttext( )

choose case ls_col
	case 'cod_incidencia'
		select cod_incidencia, desc_incidencia 
			into :ls_return1, :ls_return2
			from incidencias_dma 
			where flag_estado = '1'
				and trim(cod_incidencia) = trim(:data);
				
		if sqlca.sqlcode <> 0 then
			messagebox(is_title, 'No existe la incidencia ingresada')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.cod_incidencia[row] = ls_return1
		this.object.desc_incidencia[row] = ls_return2
		
		return 2
end choose
end event

type dw_tuso from u_dw_abc within tp_3
integer width = 3342
integer height = 796
integer taborder = 20
string dataobject = "d_ap_pp_tuso_quick_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'
is_dwform = 'tabular'
ii_ck[1] = 1

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'cod_maquina'
		ls_sql = "select cod_maquina as codigo, desc_maq as descripcion from maquina where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		this.object.cod_maquina[row] = ls_return1
		this.object.desc_maq[row] = ls_return2
		
		this.ii_update = 1
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nro_parte
long ll_master

ll_master = dw_master.getrow( )

if ll_master < 1 then
	messagebox(is_title, 'No se puede insertar una máquina sin número de parte')
   this.event ue_delete( )
	return
end if

ls_nro_parte = dw_master.object.nro_parte[ll_master]

if isnull(ls_nro_parte) or trim(ls_nro_parte) = '' then
	messagebox(is_title, 'No se puede insertar una máquina sin número de parte')
   this.event ue_delete( )
	return
end if

this.object.nro_parte[al_row] = ls_nro_parte
this.object.hora_encendido[al_row] = datetime(today(), now())
this.object.hora_apagado[al_row] = datetime(today(), now())
end event

event rowfocuschanged;call super::rowfocuschanged;string ls_nro_parte, ls_cod_maquina

ls_nro_parte = this.object.nro_parte[currentrow]
ls_cod_maquina = this.object.cod_maquina[currentrow]

tab_det.tp_3.dw_tinc.retrieve(ls_nro_parte, ls_cod_maquina)
end event

event itemchanged;call super::itemchanged;string ls_col, ls_sql, ls_return1, ls_return2

ls_col = dwo.name

this.accepttext( )

choose case ls_col
	case 'cod_maquina'
		
		select cod_maquina, desc_maq
			into :ls_return1, :ls_return2
			from maquina
			where flag_estado = '1'
				and trim(cod_maquina) = trim(:data);
		
		if sqlca.sqlcode <> 0 then
			messagebox(is_title, 'No existe máquina')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.cod_maquina[row] = ls_return1
		this.object.desc_maq[row] = ls_return2
		
		return 2
end choose
end event

type st_3 from statictext within w_pr312_parte_piso_quick
integer width = 3712
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217737
long backcolor = 134217729
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

