$PBExportHeader$w_help_desk.srw
forward
global type w_help_desk from window
end type
type st_contactos from statictext within w_help_desk
end type
type p_logo_sytco from picture within w_help_desk
end type
type st_vistas from statictext within w_help_desk
end type
type st_nuevos from statictext within w_help_desk
end type
type st_resueltos from statictext within w_help_desk
end type
type st_anulados from statictext within w_help_desk
end type
type st_sin_resolver from statictext within w_help_desk
end type
type tab_navigate from tab within w_help_desk
end type
type tabpage_principal from userobject within tab_navigate
end type
type sle_buscar from singlelineedit within tabpage_principal
end type
type st_cant_reg from statictext within tabpage_principal
end type
type st_cab_principal from statictext within tabpage_principal
end type
type dw_tickes from u_dw_abc within tabpage_principal
end type
type tabpage_principal from userobject within tab_navigate
sle_buscar sle_buscar
st_cant_reg st_cant_reg
st_cab_principal st_cab_principal
dw_tickes dw_tickes
end type
type tabpage_ver from userobject within tab_navigate
end type
type st_fec_adj from statictext within tabpage_ver
end type
type st_archivo from statictext within tabpage_ver
end type
type dw_details_arc_adjuntos from u_dw_abc within tabpage_ver
end type
type dw_desc_ticket from u_dw_abc within tabpage_ver
end type
type dw_details from u_dw_abc within tabpage_ver
end type
type dw_master from u_dw_abc within tabpage_ver
end type
type dw_details_files from u_dw_abc within tabpage_ver
end type
type st_rpta_otorgadas from statictext within tabpage_ver
end type
type ln_archivo from line within tabpage_ver
end type
type tabpage_ver from userobject within tab_navigate
st_fec_adj st_fec_adj
st_archivo st_archivo
dw_details_arc_adjuntos dw_details_arc_adjuntos
dw_desc_ticket dw_desc_ticket
dw_details dw_details
dw_master dw_master
dw_details_files dw_details_files
st_rpta_otorgadas st_rpta_otorgadas
ln_archivo ln_archivo
end type
type tab_navigate from tab within w_help_desk
tabpage_principal tabpage_principal
tabpage_ver tabpage_ver
end type
type r_menu from rectangle within w_help_desk
end type
type ln_1 from line within w_help_desk
end type
type p_cabecera from picture within w_help_desk
end type
type pb_agregar from picturebutton within w_help_desk
end type
type p_logo from picture within w_help_desk
end type
type pb_logout from picture within w_help_desk
end type
type st_logout from statictext within w_help_desk
end type
type st_menu_add from statictext within w_help_desk
end type
type st_add_ticket from statictext within w_help_desk
end type
type st_add_busqueda from statictext within w_help_desk
end type
type st_new_contacto from statictext within w_help_desk
end type
type ln_2 from line within w_help_desk
end type
end forward

global type w_help_desk from window
integer width = 5847
integer height = 2580
boolean titlebar = true
string title = "Untitled"
boolean resizable = true
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_contactos st_contactos
p_logo_sytco p_logo_sytco
st_vistas st_vistas
st_nuevos st_nuevos
st_resueltos st_resueltos
st_anulados st_anulados
st_sin_resolver st_sin_resolver
tab_navigate tab_navigate
r_menu r_menu
ln_1 ln_1
p_cabecera p_cabecera
pb_agregar pb_agregar
p_logo p_logo
pb_logout pb_logout
st_logout st_logout
st_menu_add st_menu_add
st_add_ticket st_add_ticket
st_add_busqueda st_add_busqueda
st_new_contacto st_new_contacto
ln_2 ln_2
end type
global w_help_desk w_help_desk

type prototypes

end prototypes

type variables
u_dw_abc	idw_tickets, idw_master, idw_details, idw_details_files, idw_desc_ticket, idw_details_arc_adjuntos /*, idw_usr_housing, &
				idw_usr_hos_emp, idw_cron_pagos, idw_usuarios, idw_venc_renta, idw_rpt_mensual, idw_versiones, &
				idw_versiones_modulo*/
constant int ii_right_padding = 60, ii_bottom_padding = 100
Integer ii_ticket_id//, ii_empresa_id, ii_cronograma_pago_id, ii_usuario_id, ii_mes, ii_anio
//String is_mensual_anual, is_ult_dig, is_bue_contrib
String is_smtpserver			= "mail.sytco.com.pe"
String is_smtpport				= "25"
String is_smtpuser				= "no_reply@sytco.com.pe"
String is_smtppassword		= "sytc012345"
String is_smtpenableSSL		= "true"

end variables

forward prototypes
public subroutine of_asign_dws ()
public subroutine of_new_ticket_rpta ()
public function integer of_set_numera ()
public function integer of_save_registro (datawindow adw_abc)
public subroutine of_activa_tab (integer ai_tab_new, integer ai_tab_old)
public subroutine of_cantidad_reg ()
public subroutine of_enviar_email (string as_email, string as_smtpserver, string as_smtpport, string as_smtpuser, string as_smtppassword, string as_smtpenablessl, string as_subject, string as_rpta_publica, string as_files[])
public function integer myuploadfiles_callback (string up_files[])
public subroutine of_ocultar_menu_add ()
public subroutine of_activa_busqueda ()
public subroutine of_view_image (integer ai_ticket_cap_pant_id)
public subroutine of_cuenta_registros ()
end prototypes

public subroutine of_asign_dws ();idw_tickets						= tab_navigate.tabpage_principal.dw_tickes
idw_master						= tab_navigate.tabpage_ver.dw_master
idw_details						= tab_navigate.tabpage_ver.dw_details
idw_details_files				= tab_navigate.tabpage_ver.dw_details_files
idw_desc_ticket				= tab_navigate.tabpage_ver.dw_desc_ticket
idw_details_arc_adjuntos	= tab_navigate.tabpage_ver.dw_details_arc_adjuntos
end subroutine

public subroutine of_new_ticket_rpta ();idw_master.Reset()
idw_master.event ue_Insert()
	
idw_master.ii_protect = 1
idw_master.of_protect()
	
idw_master.SetFocus()
idw_master.setColumn("ticket_id")

idw_details_files.Reset()

end subroutine

public function integer of_set_numera ();//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_nro
Integer	li_empresa_id

//Obtengo origen seleccionado
li_empresa_id 	 =	idw_master.object.empresa_id [1]

if gs_action = 'new_ticket' then

	Select ult_nro 
		into :ll_ult_nro 
	from num_ticket
	where empresa_id = :li_empresa_id for update;
	
	IF SQLCA.SQLCode = 100 then
		Insert into num_ticket (empresa_id, ult_nro)
			values( :li_empresa_id, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox("Error al iniciar el numerador" , "Error al insertar registro en num_ticket: " + ls_mensaje)
			return 0
		end if
		
		ll_ult_nro = 1
 	end if
	
	//Asigna numero a cabecera
	ls_nro = "TK" + String(li_empresa_id) + "-" + trim(string(ll_ult_nro, '00000'))
	
	idw_master.object.nro_ticket[idw_master.getrow()] = ls_nro
	
	//Incrementa contador
	Update num_ticket 
		set ult_nro = :ll_ult_nro + 1 
	 where empresa_id = :li_empresa_id;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al actualizar num_ticket', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = idw_master.object.nro_solicitud[idw_master.getrow()] 
end if

return 1
end function

public function integer of_save_registro (datawindow adw_abc);String 	ls_mensaje, ls_pathname, ls_nomb_corto, ls_nomb_lago
Long 		ll_row_count, ll_File 
BLOB 		lbl_data[], lbl_temp[] 
Integer	li_x

adw_abc.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al guardar', ls_mensaje)
	return 0
end if
COMMIT ;

//guarda archivos adjuntos
ll_row_count = idw_details_files.rowcount( )
if ll_row_count > 0 then
	FOR li_x = 1 to ll_row_count
		ls_pathname = ""
		ll_File = 0
		ls_pathname = idw_details_files.object.file_nomb_corto	[li_x]
		ll_File = FileOpen(ls_pathname, StreamMode!) 
		DO WHILE FileRead(ll_file,lbl_temp[li_x]) > 0 
			lbl_data[li_x] += lbl_temp[li_x] 
		LOOP 
		FileClose(ll_file) 
		ls_nomb_lago	= idw_details_files.object.file_nomb_largo	[li_x]
		ls_nomb_corto	= idw_details_files.object.file_nomb_corto	[li_x]
		INSERT INTO TICKET_CAPT_PANTALLA (TICKET_ID, FILE_NOMB_LARGO, FILE_NOMB_CORTO, IMAGEN)
		VALUES(:ii_ticket_id, :ls_nomb_lago, :ls_nomb_corto, :lbl_data[li_x]);
		if sqlca.sqlCode < 0 then
			ls_mensaje = sqlca.SQLErrText
			ROLLBACK;
			MessageBox('Error al guardar', ls_mensaje)
			return 0
		end if
		COMMIT;
	NEXT
end if
//fin guarda archivos adjuntos

return 1
end function

public subroutine of_activa_tab (integer ai_tab_new, integer ai_tab_old);if ai_tab_old = 1 then
	tab_navigate.tabpage_principal.enabled	= false
	tab_navigate.tabpage_ver.enabled			= true
	pb_agregar.x									= tab_navigate.x + 410
elseif ai_tab_old = 2 then
	tab_navigate.tabpage_principal.enabled	= true
	tab_navigate.tabpage_ver.enabled			= false
	tab_navigate.tabpage_ver.text 				= ""
	pb_agregar.x									= tab_navigate.x + 50
end if
tab_navigate.selectedtab = ai_tab_new
end subroutine

public subroutine of_cantidad_reg ();Long ll_row_count
ll_row_count = idw_tickets.rowcount( )
tab_navigate.tabpage_principal.st_cant_reg.text = String(ll_row_count) + " Registros"

end subroutine

public subroutine of_enviar_email (string as_email, string as_smtpserver, string as_smtpport, string as_smtpuser, string as_smtppassword, string as_smtpenablessl, string as_subject, string as_rpta_publica, string as_files[]);Long ll_result
#IF Defined PBDOTNET Then 
	MailSend.Program l_ClassLibrary1  
	l_ClassLibrary1 = create MailSend.Program 
	ll_result = l_ClassLibrary1.f_enviar(as_email, as_smtpserver, as_smtpport, as_smtpuser, as_smtppassword, is_smtpenableSSL, &
	as_subject, as_rpta_publica, as_files) 
#END IF 
end subroutine

public function integer myuploadfiles_callback (string up_files[]);Long ll_row_count
Integer i
try
	if trim(up_files[1]) = "" then return 0
	idw_details_files.event ue_Insert()
	idw_details_files.ii_protect = 0
	idw_details_files.of_protect()
	idw_details_files.SetFocus()
	idw_details_files.setColumn("ticket_cap_pant_id")
	ll_row_count = idw_details_files.rowcount( )
	idw_details_files.object.file_nomb_corto	[ll_row_count] = up_files[1]
	//for i = 1 to upperbound(up_files)
		//idw_details_files.object.file_nomb_largo	[ll_row_count] += "~r~n" + up_files[i]
	//next
	#if defined PBWEBFORM then
			idw_details_files.object.file_nomb_largo	[ll_row_count] = MapVirtualPath(up_files[1])
	#end if
	idw_details_files.ii_update = 1
	return 1
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion en función myuploadfiles_callback(). Mensaje: ' + ex.getMessage(), StopSign!)
	return 0
end try
end function

public subroutine of_ocultar_menu_add ();st_menu_add.visible 			= false
st_add_ticket.visible			= false
st_new_contacto.visible		= false
st_add_busqueda.visible		= false
tab_navigate.tabpage_principal.sle_buscar.visible			= false
tab_navigate.tabpage_principal.st_cab_principal.visible	= true
tab_navigate.tabpage_principal.st_cant_reg.visible		= true

end subroutine

public subroutine of_activa_busqueda ();//Coloreamos las opciones del menu_add
st_add_ticket.backcolor			= RGB(250,250,250)
st_add_ticket.textcolor			= RGB(167,167,167)
st_new_contacto.backcolor		= RGB(250,250,250)
st_new_contacto.textcolor		= RGB(167,167,167)
st_add_busqueda.backcolor		= RGB(230,230,230)
st_add_busqueda.textcolor		= RGB(0,0,0)

of_activa_tab( 1, 2)
idw_tickets.dataobject = "d_list_ticket_busqueda_tbl"
idw_tickets.settransobject(sqlca) 
if tab_navigate.tabpage_principal.sle_buscar.visible = true then
	if Trim(tab_navigate.tabpage_principal.sle_buscar.text) = "" then
		idw_tickets.retrieve( "$%&#")
	else
		idw_tickets.retrieve( tab_navigate.tabpage_principal.sle_buscar.text)
	end if
else
	idw_tickets.retrieve( "$%&#")
	tab_navigate.tabpage_principal.sle_buscar.text			= ""
end if

of_ocultar_menu_add( )
tab_navigate.tabpage_principal.sle_buscar.visible			= true
tab_navigate.tabpage_principal.st_cab_principal.visible	= false
tab_navigate.tabpage_principal.st_cant_reg.visible		= false
tab_navigate.tabpage_principal.sle_buscar.width			= idw_tickets.width - ii_right_padding * 2
//tab_navigate.tabpage_principal.sle_buscar.setfocus()
end subroutine

public subroutine of_view_image (integer ai_ticket_cap_pant_id);str_parametros sl_param

sl_param.int1	= ai_ticket_cap_pant_id
OpenWithParm( w_view_image, sl_param)
end subroutine

public subroutine of_cuenta_registros ();Long ll_cant_reg

//tickets nuevos
select count(*)
into :ll_cant_reg
from ticket
where flag_estado	= '1';
st_nuevos.text			= "Tickets nuevos                                    " + String(ll_cant_reg)

//tickets sin resolver
select count(*)
into :ll_cant_reg
from ticket
where flag_estado	= '2';
st_sin_resolver.text	= "Tickets sin resolver                             " + String(ll_cant_reg)

//tickets resueltos
select count(*)
into :ll_cant_reg
from ticket
where flag_estado	= '3';
st_resueltos.text		= "Tickets resueltos                                 " + String(ll_cant_reg)

//tickets anulados
select count(*)
into :ll_cant_reg
from ticket
where flag_estado	= '0';
st_anulados.text		= "Tickets anulados                                 " + String(ll_cant_reg)
end subroutine

on w_help_desk.create
this.st_contactos=create st_contactos
this.p_logo_sytco=create p_logo_sytco
this.st_vistas=create st_vistas
this.st_nuevos=create st_nuevos
this.st_resueltos=create st_resueltos
this.st_anulados=create st_anulados
this.st_sin_resolver=create st_sin_resolver
this.tab_navigate=create tab_navigate
this.r_menu=create r_menu
this.ln_1=create ln_1
this.p_cabecera=create p_cabecera
this.pb_agregar=create pb_agregar
this.p_logo=create p_logo
this.pb_logout=create pb_logout
this.st_logout=create st_logout
this.st_menu_add=create st_menu_add
this.st_add_ticket=create st_add_ticket
this.st_add_busqueda=create st_add_busqueda
this.st_new_contacto=create st_new_contacto
this.ln_2=create ln_2
this.Control[]={this.st_contactos,&
this.p_logo_sytco,&
this.st_vistas,&
this.st_nuevos,&
this.st_resueltos,&
this.st_anulados,&
this.st_sin_resolver,&
this.tab_navigate,&
this.r_menu,&
this.ln_1,&
this.p_cabecera,&
this.pb_agregar,&
this.p_logo,&
this.pb_logout,&
this.st_logout,&
this.st_menu_add,&
this.st_add_ticket,&
this.st_add_busqueda,&
this.st_new_contacto,&
this.ln_2}
end on

on w_help_desk.destroy
destroy(this.st_contactos)
destroy(this.p_logo_sytco)
destroy(this.st_vistas)
destroy(this.st_nuevos)
destroy(this.st_resueltos)
destroy(this.st_anulados)
destroy(this.st_sin_resolver)
destroy(this.tab_navigate)
destroy(this.r_menu)
destroy(this.ln_1)
destroy(this.p_cabecera)
destroy(this.pb_agregar)
destroy(this.p_logo)
destroy(this.pb_logout)
destroy(this.st_logout)
destroy(this.st_menu_add)
destroy(this.st_add_ticket)
destroy(this.st_add_busqueda)
destroy(this.st_new_contacto)
destroy(this.ln_2)
end on

event resize;of_asign_dws( )
p_cabecera.x	= 0
p_cabecera.y	= 0
p_cabecera.width 	= newwidth + 500
pb_logout.x			= newwidth - pb_logout.width
st_logout.x			= newwidth - pb_logout.width - 40
st_logout.y			= pb_logout.y + pb_logout.height

r_menu.height 			= newheight - r_menu.y - ii_bottom_padding
tab_navigate.width 	= newwidth - tab_navigate.x - ii_right_padding
tab_navigate.height 	= newheight - tab_navigate.y - ii_bottom_padding

idw_tickets.height		= tab_navigate.height - idw_tickets.y - ii_bottom_padding
idw_tickets.width		= tab_navigate.width - idw_tickets.x - ii_right_padding

idw_master.height		= tab_navigate.height - idw_master.y - ii_bottom_padding

idw_details.height		= tab_navigate.height - idw_details.y - ii_bottom_padding

idw_details_arc_adjuntos.width	= tab_navigate.width - idw_details_arc_adjuntos.x - ii_right_padding

pb_agregar.x			= tab_navigate.x + 50
pb_agregar.y			= tab_navigate.y

tab_navigate.tabpage_ver.ln_archivo.beginx		= idw_details_arc_adjuntos.x
tab_navigate.tabpage_ver.ln_archivo.endx		= idw_details_arc_adjuntos.x + idw_details_arc_adjuntos.width

of_cantidad_reg( )
end event

event open;r_menu.fillcolor						= RGB(250,250,250)
st_vistas.backcolor					= RGB(250,250,250)
st_sin_resolver.backcolor		= RGB(250,250,250)
st_resueltos.backcolor			= RGB(250,250,250)
st_anulados.backcolor			= RGB(250,250,250)
st_contactos.backcolor			= RGB(250,250,250)
st_menu_add.backcolor			= RGB(250,250,250)
st_new_contacto.backcolor		= RGB(250,250,250)
st_add_busqueda.backcolor		= RGB(250,250,250)
//ocultamos add_menu
st_menu_add.visible 			= false
st_add_ticket.visible			= false
st_new_contacto.visible		= false
st_add_busqueda.visible		= false

end event

type st_contactos from statictext within w_help_desk
integer x = 87
integer y = 932
integer width = 928
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 134217734
long backcolor = 67108864
string text = "Contactos"
boolean focusrectangle = false
end type

event clicked;Integer ll_row_count
tab_navigate.tabpage_principal.st_cab_principal.text = "Contactos"
idw_tickets.dataobject = "d_list_contactos_empresa_tbl"
idw_tickets.settransobject(sqlca) 
idw_tickets.retrieve( )
idw_tickets.SelectRow(0, False)

of_cantidad_reg( )
of_activa_tab( 1, 2)

//coloreamos
st_sin_resolver.backcolor	= RGB(250,250,250)
st_sin_resolver.textcolor		= RGB(167,167,167)
st_nuevos.backcolor			= RGB(250,250,250)
st_nuevos.textcolor			= RGB(167,167,167)
st_resueltos.backcolor		= RGB(250,250,250)
st_resueltos.textcolor			= RGB(167,167,167)
st_anulados.backcolor		= RGB(250,250,250)
st_anulados.textcolor			= RGB(167,167,167)
st_contactos.backcolor		= RGB(230,230,230)
st_contactos.textcolor			= RGB(0,0,0)

of_ocultar_menu_add( )
end event

type p_logo_sytco from picture within w_help_desk
integer width = 343
integer height = 200
string picturename = "C:\SIGRE\resources\PNG\opcionsytco2.png"
boolean focusrectangle = false
end type

type st_vistas from statictext within w_help_desk
integer x = 55
integer y = 268
integer width = 242
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vistas"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_nuevos from statictext within w_help_desk
integer x = 87
integer y = 424
integer width = 928
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 33554432
long backcolor = 134217750
string text = "Tickets nuevos"
boolean focusrectangle = false
end type

event clicked;Integer ll_row_count

tab_navigate.tabpage_principal.st_cab_principal.text = "Tickets nuevos"
idw_tickets.dataobject = "d_list_ticket_tbl"
idw_tickets.settransobject(sqlca) 
idw_tickets.retrieve( '1')
idw_tickets.SelectRow(0, False)

of_cantidad_reg( )
of_activa_tab( 1, 2)

//coloreamos
st_nuevos.backcolor			= RGB(230,230,230)
st_nuevos.textcolor			= RGB(0,0,0)
st_sin_resolver.backcolor	= RGB(250,250,250)
st_sin_resolver.textcolor		= RGB(167,167,167)
st_resueltos.backcolor		= RGB(250,250,250)
st_resueltos.textcolor			= RGB(167,167,167)
st_anulados.backcolor		= RGB(250,250,250)
st_anulados.textcolor			= RGB(167,167,167)
st_contactos.backcolor		= RGB(250,250,250)
st_contactos.textcolor			= RGB(167,167,167)

of_ocultar_menu_add( )

end event

type st_resueltos from statictext within w_help_desk
integer x = 87
integer y = 652
integer width = 928
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 134217734
long backcolor = 67108864
string text = "Tickets resueltos"
boolean focusrectangle = false
end type

event clicked;Integer ll_row_count
tab_navigate.tabpage_principal.st_cab_principal.text = "Tickets resueltos"
idw_tickets.dataobject = "d_list_ticket_tbl"
idw_tickets.settransobject(sqlca) 
idw_tickets.retrieve( '3')
idw_tickets.SelectRow(0, False)

of_cantidad_reg( )
of_activa_tab( 1, 2)

//coloreamos
st_sin_resolver.backcolor	= RGB(250,250,250)
st_sin_resolver.textcolor		= RGB(167,167,167)
st_nuevos.backcolor			= RGB(250,250,250)
st_nuevos.textcolor			= RGB(167,167,167)
st_resueltos.backcolor		= RGB(230,230,230)
st_resueltos.textcolor			= RGB(0,0,0)
st_anulados.backcolor		= RGB(250,250,250)
st_anulados.textcolor			= RGB(167,167,167)
st_contactos.backcolor		= RGB(250,250,250)
st_contactos.textcolor			= RGB(167,167,167)

of_ocultar_menu_add( )
end event

type st_anulados from statictext within w_help_desk
integer x = 87
integer y = 760
integer width = 928
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 134217734
long backcolor = 67108864
string text = "Tickets anulados"
boolean focusrectangle = false
end type

event clicked;Integer ll_row_count
tab_navigate.tabpage_principal.st_cab_principal.text = "Tickets anulados"
idw_tickets.dataobject = "d_list_ticket_tbl"
idw_tickets.settransobject(sqlca) 
idw_tickets.retrieve( '0')
idw_tickets.SelectRow(0, False)

of_cantidad_reg( )
of_activa_tab( 1, 2)

//coloreamos
st_sin_resolver.backcolor	= RGB(250,250,250)
st_sin_resolver.textcolor		= RGB(167,167,167)
st_nuevos.backcolor			= RGB(250,250,250)
st_nuevos.textcolor			= RGB(167,167,167)
st_resueltos.backcolor		= RGB(250,250,250)
st_resueltos.textcolor			= RGB(167,167,167)
st_anulados.backcolor		= RGB(230,230,230)
st_anulados.textcolor			= RGB(0,0,0)
st_contactos.backcolor		= RGB(250,250,250)
st_contactos.textcolor			= RGB(167,167,167)

of_ocultar_menu_add( )
end event

type st_sin_resolver from statictext within w_help_desk
integer x = 87
integer y = 540
integer width = 928
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 134217734
long backcolor = 67108864
string text = "Tickets sin resolver"
boolean focusrectangle = false
end type

event clicked;Integer ll_row_count

tab_navigate.tabpage_principal.st_cab_principal.text = "Tickets sin resolver"
idw_tickets.dataobject = "d_list_ticket_tbl"
idw_tickets.settransobject(sqlca) 
idw_tickets.retrieve( '2')
idw_tickets.SelectRow(0, False)

of_cantidad_reg( )
of_activa_tab( 1, 2)

//coloreamos
st_sin_resolver.backcolor	= RGB(230,230,230)
st_sin_resolver.textcolor		= RGB(0,0,0)
st_nuevos.backcolor			= RGB(250,250,250)
st_nuevos.textcolor			= RGB(167,167,167)
st_resueltos.backcolor		= RGB(250,250,250)
st_resueltos.textcolor			= RGB(167,167,167)
st_anulados.backcolor		= RGB(250,250,250)
st_anulados.textcolor			= RGB(167,167,167)
st_contactos.backcolor		= RGB(250,250,250)
st_contactos.textcolor			= RGB(167,167,167)

of_ocultar_menu_add( )

end event

type tab_navigate from tab within w_help_desk
integer x = 1051
integer y = 172
integer width = 4713
integer height = 2180
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_principal tabpage_principal
tabpage_ver tabpage_ver
end type

on tab_navigate.create
this.tabpage_principal=create tabpage_principal
this.tabpage_ver=create tabpage_ver
this.Control[]={this.tabpage_principal,&
this.tabpage_ver}
end on

on tab_navigate.destroy
destroy(this.tabpage_principal)
destroy(this.tabpage_ver)
end on

type tabpage_principal from userobject within tab_navigate
integer x = 18
integer y = 48
integer width = 4677
integer height = 2116
long backcolor = 16777215
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
sle_buscar sle_buscar
st_cant_reg st_cant_reg
st_cab_principal st_cab_principal
dw_tickes dw_tickes
end type

on tabpage_principal.create
this.sle_buscar=create sle_buscar
this.st_cant_reg=create st_cant_reg
this.st_cab_principal=create st_cab_principal
this.dw_tickes=create dw_tickes
this.Control[]={this.sle_buscar,&
this.st_cant_reg,&
this.st_cab_principal,&
this.dw_tickes}
end on

on tabpage_principal.destroy
destroy(this.sle_buscar)
destroy(this.st_cant_reg)
destroy(this.st_cab_principal)
destroy(this.dw_tickes)
end on

type sle_buscar from singlelineedit within tabpage_principal
boolean visible = false
integer x = 174
integer y = 116
integer width = 2661
integer height = 104
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 134217734
long backcolor = 16777215
end type

event modified;idw_tickets.retrieve( this.text)
end event

type st_cant_reg from statictext within tabpage_principal
integer x = 151
integer y = 136
integer width = 425
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217738
long backcolor = 16777215
string text = "..."
boolean focusrectangle = false
end type

type st_cab_principal from statictext within tabpage_principal
integer x = 151
integer y = 52
integer width = 2176
integer height = 120
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "..."
boolean focusrectangle = false
end type

type dw_tickes from u_dw_abc within tabpage_principal
integer x = 69
integer y = 296
integer width = 2853
integer height = 1152
integer taborder = 20
string dataobject = "d_list_ticket_tbl"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;Long ll_row_count

is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

tab_navigate.tabpage_principal.st_cab_principal.text = "Tickets sin resolver"
this.retrieve( '1')
this.SelectRow(0, False)

of_activa_tab( 1, 2)
of_cuenta_registros( )
end event

event buttonclicked;call super::buttonclicked;string 	ls_nro_ticket, ls_flag_estado
Integer	li_ticket_id, li_id
str_parametros sl_param

if lower(dwo.name) = 'b_ver' then
	idw_master.dataobject = "d_abc_ticket_respuesta_ff"
	idw_master.settransobject(sqlca) 
	idw_details.visible						= true
	idw_details_files.visible				= true
	idw_desc_ticket.visible				= false
	idw_details_arc_adjuntos.visible	= true
	tab_navigate.tabpage_ver.st_rpta_otorgadas.visible	= true
	tab_navigate.tabpage_ver.st_archivo.visible				= true
	tab_navigate.tabpage_ver.st_fec_adj.visible				= true
	tab_navigate.tabpage_ver.ln_archivo.visible				= true
	
	gs_action = 'new_ticket_rpta'
	ii_ticket_id 		= this.object.ticket_id 	[row]
	ls_nro_ticket	= this.object.nro_ticket	[row]
	of_activa_tab(2, 1)
	tab_navigate.tabpage_ver.text = ls_nro_ticket
	of_new_ticket_rpta( )
	idw_details.retrieve( ii_ticket_id)
	idw_details_arc_adjuntos.retrieve( ii_ticket_id)
	idw_details.SelectRow(0, False)
	idw_details_arc_adjuntos.SelectRow(0, False)
	
elseif lower(dwo.name) = 'b_eliminar' then
	li_ticket_id		= this.object.ticket_id		[row]
	ls_flag_estado	= this.object.flag_estado	[row]
	
	if MessageBox('Aviso', 'Deseas eliminar el registro ' + string(row) + ' con id ' + string(li_ticket_id) + '?', Information!, YesNo!, 2) = 2 then return
	
	update ticket 
	set flag_estado = '0'
	where ticket_id = :li_ticket_id;
	COMMIT;
	
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.retrieve( ls_flag_estado)
	of_cantidad_reg( )
	
elseif lower(dwo.name) = 'b_modif_contacto' then
	gs_action = "open"
	sl_param.int1	= this.object.email_empresa_id	[row]
	OpenWithParm( w_hd001_contacto_empresa, sl_param)
	this.retrieve( )
	
elseif lower(dwo.name) = 'b_eliminar_contacto' then
	li_id		= this.object.email_empresa_id	[row]

	if MessageBox('Aviso', 'Deseas eliminar el registro ' + string(row) + ' con id ' + string(li_ticket_id) + '?', Information!, YesNo!, 2) = 2 then return
	
	delete from contactos_empresa 
	where email_empresa_id = :li_id;
	COMMIT;
	
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.retrieve( )
	of_cantidad_reg( )
end if
end event

type tabpage_ver from userobject within tab_navigate
integer x = 18
integer y = 48
integer width = 4677
integer height = 2116
long backcolor = 16777215
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
st_fec_adj st_fec_adj
st_archivo st_archivo
dw_details_arc_adjuntos dw_details_arc_adjuntos
dw_desc_ticket dw_desc_ticket
dw_details dw_details
dw_master dw_master
dw_details_files dw_details_files
st_rpta_otorgadas st_rpta_otorgadas
ln_archivo ln_archivo
end type

on tabpage_ver.create
this.st_fec_adj=create st_fec_adj
this.st_archivo=create st_archivo
this.dw_details_arc_adjuntos=create dw_details_arc_adjuntos
this.dw_desc_ticket=create dw_desc_ticket
this.dw_details=create dw_details
this.dw_master=create dw_master
this.dw_details_files=create dw_details_files
this.st_rpta_otorgadas=create st_rpta_otorgadas
this.ln_archivo=create ln_archivo
this.Control[]={this.st_fec_adj,&
this.st_archivo,&
this.dw_details_arc_adjuntos,&
this.dw_desc_ticket,&
this.dw_details,&
this.dw_master,&
this.dw_details_files,&
this.st_rpta_otorgadas,&
this.ln_archivo}
end on

on tabpage_ver.destroy
destroy(this.st_fec_adj)
destroy(this.st_archivo)
destroy(this.dw_details_arc_adjuntos)
destroy(this.dw_desc_ticket)
destroy(this.dw_details)
destroy(this.dw_master)
destroy(this.dw_details_files)
destroy(this.st_rpta_otorgadas)
destroy(this.ln_archivo)
end on

type st_fec_adj from statictext within tabpage_ver
integer x = 4393
integer y = 60
integer width = 398
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "FECHA ADJUNTO"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_archivo from statictext within tabpage_ver
integer x = 3739
integer y = 60
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "ARCHIVO"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_details_arc_adjuntos from u_dw_abc within tabpage_ver
integer x = 3707
integer y = 128
integer width = 754
integer height = 1188
integer taborder = 20
string dataobject = "d_list_ticket_cap_pantalla_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

event clicked;call super::clicked;Integer	li_ticket_capt_pant_id
if row > 0 then
	li_ticket_capt_pant_id		= this.object.ticket_cap_pant_id	[row]
	of_view_image(li_ticket_capt_pant_id)
end if
end event

type dw_desc_ticket from u_dw_abc within tabpage_ver
boolean visible = false
integer x = 50
integer y = 944
integer width = 928
integer height = 184
integer taborder = 20
string dataobject = "d_list_desc_ticket_ff"
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event clicked;if lower(dwo.name) = 'ocultar_t' then
	idw_desc_ticket.visible = false
end if
end event

type dw_details from u_dw_abc within tabpage_ver
integer x = 978
integer y = 1240
integer width = 2725
integer height = 656
integer taborder = 20
string dataobject = "d_list_ticket_respuesta_ff"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

type dw_master from u_dw_abc within tabpage_ver
integer y = 32
integer width = 3703
integer height = 1000
integer taborder = 20
string dataobject = "d_abc_ticket_respuesta_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;String 	ls_cod_empresa, ls_flag_estado, ls_nro_ticket, ls_nom_solicitante, ls_nom_asignado, ls_desc_tipo_ticket, ls_desc_prioridad, ls_asunto, &
			ls_email
Date ld_fec_solicitado

if gs_action = 'new_ticket_rpta' then // si va a insertar un nuevo regitro para ticket_respuesta
	select e.cod_empresa, t.flag_estado, t.nro_ticket,
			ce.nombres || ' ' || ce.apellidos,
			u.nombre || ' ' || u.apellidos,
			tt.desc_tipo_ticket,
			p.desc_prioridad,
			t.asunto,
			t.fec_solicitado,
			ce.email
	into	:ls_cod_empresa, :ls_flag_estado, :ls_nro_ticket, :ls_nom_solicitante, :ls_nom_asignado, :ls_desc_tipo_ticket, :ls_desc_prioridad,
			:ls_asunto, :ld_fec_solicitado, :ls_email
	from ticket t,
			contactos_empresa ce,
			empresa e,
			usuarios u,
			tipo_ticket tt,
			prioridad p
	where t.solicitante			= ce.email_empresa_id
		and ce.empresa_id	= e.empresa_id
		and t.asignado_a    	= u.usuario_id
		and t.cod_tipo_ticket  = tt.cod_tipo_ticket
		and t.cod_prioridad	= p.cod_prioridad
		and t.ticket_id			= :ii_ticket_id;
	
	this.object.ticket_rpta_ticket_id				[al_row] = ii_ticket_id
	this.object.ticket_rpta_created_by			[al_row] = gi_user
	this.object.cod_empresa						[al_row] = ls_cod_empresa
	this.object.flag_estado						[al_row] = ls_flag_estado
	this.object.nro_ticket							[al_row] = ls_nro_ticket
	this.object.nom_solicitante					[al_row] = ls_nom_solicitante
	this.object.nom_asignado					[al_row] = ls_nom_asignado
	this.object.desc_tipo_ticket					[al_row] = ls_desc_tipo_ticket
	this.object.desc_prioridad					[al_row] = ls_desc_prioridad
	this.object.asunto								[al_row] = ls_asunto
	this.object.fec_solicitado						[al_row] = ld_fec_solicitado
	this.object.email								[al_row] = ls_email
	this.object.fec_rpta							[al_row] = gnvo_app.of_fecha_actual( )
	this.object.ticket_rpta_flag_tipo				[al_row] = '4'
	if ls_flag_estado = '0' or ls_flag_estado = '3' then
		this.object.b_enviar.enabled			= false
		this.object.b_adj_archivo	.enabled	=	false
	else
		this.object.b_enviar.enabled			= true
		this.object.b_adj_archivo	.enabled	=	true
	end if
elseif gs_action = 'new_ticket' then // si va a insertar un nuevo regitro para ticket
	this.object.flag_estado		[al_row] = '1'
	this.object.flag_privado		[al_row] = '0'
	this.object.created_by		[al_row] = gi_user
	this.object.fec_registro		[al_row] = gnvo_app.of_fecha_actual( )
	this.object.fec_solicitado		[al_row] = gnvo_app.of_fecha_actual( )
end if
end event

event clicked;call super::clicked;string 	ls_nro_ticket

if lower(dwo.name) = 'rpta_publica_t' then
	idw_master.object.rpta_publica_t.background.color = RGB(96,92,92)
	idw_master.object.rpta_publica_t.color = RGB(255,255,255)
	idw_master.object.nota_interna_t.background.color = RGB(228,226,227)
	this.object.rpta_publica.visible = true
	this.object.nota_interna.visible = false
elseif lower(dwo.name) = 'nota_interna_t' then
	idw_master.object.rpta_publica_t.background.color = RGB(228,226,227)
	idw_master.object.rpta_publica_t.color = RGB(0,0,0)
	idw_master.object.nota_interna_t.background.color = RGB(248,251,153)
	this.object.rpta_publica.visible = false
	this.object.nota_interna.visible = true
end if
end event

event buttonclicked;call super::buttonclicked;String 		ls_mensaje, ls_flag_estado, ls_email, ls_subject, ls_docname, ls_named, ls_rpta_publica, ls_nota_interna
Datetime 	ldt_fecha
Long 			ll_result, ll_row_count
String			ls_files[]
Integer 		li_value, li_x

str_parametros	lstr_param
if gs_action = "new_ticket_rpta" then
	if lower(dwo.name) = 'b_enviar' then
		if of_save_registro( idw_master) = 0 then return

		ls_flag_estado = this.object.flag_estado	[row]
		//si es tipo de respuesta es solucion entonces se marca el ticket como resuelto
		if this.object.ticket_rpta_flag_tipo[row] = '1' then
			ls_flag_estado = '3'
		else
			ls_flag_estado = '2'
		end if
		
		ldt_fecha = this.object.fec_rpta	[row]
		//actualizo el ticket
		update ticket 
		set modified_by	= :gi_user, 
			 fec_modified	= :ldt_fecha,
			 flag_estado		= :ls_flag_estado
		where ticket_id = :ii_ticket_id;
		
		COMMIT ;
		
		//Envio de email
		ls_rpta_publica	= this.object.rpta_publica [row]
		ls_nota_interna	= this.object.nota_interna [row]
		if (Trim(ls_rpta_publica) = "" or isNull(ls_rpta_publica)) and (Trim(ls_nota_interna) = "" or isNull(ls_nota_interna)) then
			MessageBox('Aviso', 'Debe ingresar al menos la respuesta publica o la nota interna o ambas', Information!)
			of_new_ticket_rpta( )
			return
		end if
		ls_email		= this.object.email		[row]
		ll_row_count = idw_details_files.rowcount( )
		FOR li_x = 1 to ll_row_count
			ls_files[li_x] = idw_details_files.object.file_nomb_largo [li_x]
		NEXT
		ls_subject	= "Soporte SIGRE - Help Desk Sytco"
		//Se le envia al solicitante solo si tiene respuesta publica
		if Trim(ls_rpta_publica) <> "" or not isNull(ls_rpta_publica) then
			of_enviar_email(ls_email, is_smtpserver, is_smtpport, is_smtpuser, is_smtppassword, is_smtpenableSSL, ls_subject, ls_rpta_publica, ls_files) 
		end if
		//Fin envio de email
		of_new_ticket_rpta( )
		idw_details.retrieve( ii_ticket_id)
		idw_details_arc_adjuntos.retrieve( ii_ticket_id)
		of_activa_tab(2, 1)
		MessageBox("Help Desk", "Mensaje enviado", Information!)
		of_cuenta_registros( )
	end if
	
	if lower(dwo.name) = 'b_ver_desc' then
		idw_desc_ticket.border	= false
		idw_desc_ticket.visible	= true
		idw_desc_ticket.width		= idw_details_files.width - 50
		idw_desc_ticket.x			= this.x + this.width - idw_desc_ticket.width
		idw_desc_ticket.y			= this.y + 185
		idw_desc_ticket.height	= tab_navigate.height - idw_details.height //200//idw_desc_ticket.x
		idw_desc_ticket.retrieve( ii_ticket_id)
	end if
	
	if lower(dwo.name) = 'b_adj_archivo' then
		//archivos aduntos
		 #if defined PBWEBFORM then
			UploadFiles("F:\", w_help_desk.BackColor, 1, false, "Seleccione un archivo (.jpg, .png) y haga click en Upload", ".jpg;.png", "myuploadfiles_callback", w_help_desk)
		#end if
	end if
elseif gs_action = "new_ticket" then
	if lower(dwo.name) = 'b_grabar' then
		if of_set_numera() = 0 then return
		if of_save_registro( idw_master) = 0 then return
		of_activa_tab(1, 2)
		st_sin_resolver.event clicked()
		of_cuenta_registros( )
	end if
end if
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event ue_display;call super::ue_display;boolean	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_email
Integer	li_codigo

this.AcceptText()
if gs_action = "new_ticket" then
	choose case lower(as_columna)
		case "cod_empresa"
			ls_sql = "select empresa_id as id_empresa, " &
					 + "cod_empresa as codigo_empresa " &
					 + "from empresa  " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.empresa_id		[al_row] = Integer(ls_codigo)
				this.object.cod_empresa		[al_row] = ls_data
				this.ii_update = 1
			end if
			
		case "solicitante"
			li_codigo = this.object.empresa_id		[al_row]
			if li_codigo = 0 or isnull(li_codigo) then return
			ls_sql = "select email_empresa_id as id_contacto, " &
					 + "nombres || ' ' || apellidos as nombre " &
					 + "from contactos_empresa  " &
					 + "where empresa_id = " + String(li_codigo)
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			li_codigo = Integer(ls_codigo)
			if ls_codigo <> '' then
				select email 
				into :ls_email 
				from contactos_empresa 
				where email_empresa_id = :li_codigo;

				this.object.solicitante				[al_row] = Integer(ls_codigo)
				this.object.nom_solicitante		[al_row] = ls_data
				this.object.email					[al_row] = ls_email
				this.ii_update = 1
			end if
			
		case "asignado_a"
			ls_sql = "select usuario_id as id_agente, " &
					 + "nombre || ' ' || apellidos as nombre_agente " &
					 + "from usuarios " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.asignado_a			[al_row] = Integer(ls_codigo)
				this.object.nom_asignado		[al_row] = ls_data
				this.ii_update = 1
			end if
			
		case "cod_tipo_ticket"
			ls_sql = "select cod_tipo_ticket as codigo, " &
					 + "desc_tipo_ticket as descripcion " &
					 + "from tipo_ticket " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cod_tipo_ticket		[al_row] = ls_codigo
				this.object.desc_tipo_ticket		[al_row] = ls_data
				this.ii_update = 1
			end if
			
		case "cod_prioridad"
			ls_sql = "select cod_prioridad as codigo, " &
					 + "desc_prioridad as descripcion " &
					 + "from prioridad " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cod_prioridad			[al_row] = ls_codigo
				this.object.desc_prioridad		[al_row] = ls_data
				this.ii_update = 1
			end if
	end choose
end if
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc, ls_email
Long 		ll_count
Integer	li_id, li_codigo

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)
if gs_action = "new_ticket" then
	CHOOSE CASE dwo.name
		CASE 'cod_empresa'
			
			// Verifica que codigo ingresado exista			
			select empresa_id
			into :li_id
			from empresa  
			where  cod_empresa = :data
				and flag_estado = '1';
				
			// Verifica que el registro exista o no
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "No existe empresa ingresada o no se encuentra activa, por favor verifique")
				this.object.empresa_id		[row] = ls_null
				this.object.cod_empresa		[row] = ls_null
				this.object.solicitante			[row] = ls_null
				this.object.nom_solicitante	[row] = ls_null
				this.object.email				[row]	= ls_null
				return 1
			end if
	
			this.object.empresa_id		[row] = li_id
		
		CASE 'solicitante'
			
			li_codigo = Integer(this.object.empresa_id	[row])			
			// Verifica que codigo ingresado exista			
			select  nombres || ' ' || apellidos,
					 email 
			into :ls_desc, :ls_email
			 from contactos_empresa
			 where email_empresa_id	= :data
			 	and empresa_id			= :li_codigo;
				
			// Verifica que el registro exista o no
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "No existe contacto ingresado o no se encuentra activo, por favor verifique")
				this.object.solicitante			[row] = ls_null
				this.object.nom_solicitante	[row] = ls_null
				this.object.email				[row]	= ls_null
				return 1
			end if
	
			this.object.nom_solicitante		[row] = ls_desc
			this.object.email					[row] = ls_email
		
		CASE "asignado_a"
			
			// Verifica que codigo ingresado exista
			select nombre || ' ' || apellidos
			into :ls_desc
			from usuarios
			where usuario_id	= :data
				and flag_estado = '1';
			
			// Verifica que el registro exista o no
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "No existe agente ingresado o no se encuentra activo, por favor verifique")
				this.object.asignado_a		[row] = ls_null
				this.object.nom_asignado	[row]	= ls_null
				return 1
			end if
	
			this.object.nom_asignado		[row] = ls_desc
		
		CASE "cod_tipo_ticket"
		
			// Verifica que codigo ingresado exista
			select desc_tipo_ticket as descripcion
			into	:ls_desc
			from tipo_ticket
			where  cod_tipo_ticket	= :data
				and flag_estado 		= '1';
					 
			// Verifica que el registro exista o no
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "No existe tipo de ticket ingresado o no se encuentra activo, por favor verifique")
				this.object.cod_tipo_ticket	[row] = ls_null
				this.object.desc_tipo_ticket	[row]	= ls_null
				return 1
			end if
	
			this.object.desc_tipo_ticket		[row] = ls_desc
		
		case "cod_prioridad"
			
			// Verifica que codigo ingresado exista
			select desc_prioridad as descripcion
			into :ls_desc
			from prioridad 
			where cod_prioridad	= :data
				and flag_estado = '1';
			
			// Verifica que el registro exista o no
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "No existe prioridad ingresada o no se encuentra activa, por favor verifique")
				this.object.cod_prioridad		[row] = ls_null
				this.object.desc_prioridad	[row]	= ls_null
				return 1
			end if
	
			this.object.desc_prioridad		[row] = ls_desc
			
	END CHOOSE
end if
end event

type dw_details_files from u_dw_abc within tabpage_ver
integer x = 978
integer y = 1028
integer width = 2725
integer height = 160
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_ticket_cat_pantalla"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event clicked;call super::clicked;Long ll_row

if lower(dwo.name) = 'eliminar_t' then
	ll_row = THIS.DeleteRow (row)
end if
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.ticket_id	[al_row] = ii_ticket_id
end event

type st_rpta_otorgadas from statictext within tabpage_ver
integer x = 1051
integer y = 1184
integer width = 562
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217734
long backcolor = 67108864
string text = "Respuestas otorgadas"
boolean focusrectangle = false
end type

type ln_archivo from line within tabpage_ver
long linecolor = 134217738
integer linethickness = 4
integer beginx = 3726
integer beginy = 120
integer endx = 4667
integer endy = 120
end type

type r_menu from rectangle within w_help_desk
long linecolor = 134217750
integer linethickness = 4
long fillcolor = 67108864
integer x = 41
integer y = 172
integer width = 1010
integer height = 1984
end type

type ln_1 from line within w_help_desk
long linecolor = 134217734
integer linethickness = 4
integer beginx = 41
integer beginy = 336
integer endx = 1056
integer endy = 336
end type

type p_cabecera from picture within w_help_desk
integer x = 1239
integer width = 5243
integer height = 264
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\cabecera2.png"
boolean focusrectangle = false
end type

type pb_agregar from picturebutton within w_help_desk
integer x = 1157
integer y = 52
integer width = 315
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "agregar"
long textcolor = 16777215
long backcolor = 134217734
end type

event clicked;//activamos controles menu_add
st_menu_add.visible 			= true
st_add_ticket.visible			= true
st_new_contacto.visible		= true
st_add_busqueda.visible		= true

st_menu_add.x	= this.x
st_menu_add.y	= this.y + this.height

st_add_ticket.x			= st_menu_add.x + 50
st_add_ticket.y			= st_menu_add.y + 100
st_new_contacto.x		= st_add_ticket.x
st_new_contacto.y		= st_add_ticket.y + st_add_ticket.height
st_add_busqueda.x	= st_new_contacto.x
st_add_busqueda.y	= st_new_contacto.y + st_new_contacto.height
end event

type p_logo from picture within w_help_desk
integer x = 338
integer width = 379
integer height = 212
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type pb_logout from picture within w_help_desk
integer x = 5015
integer y = 24
integer width = 142
integer height = 116
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\logout.png"
boolean focusrectangle = false
end type

event clicked;Close(parent)
end event

type st_logout from statictext within w_help_desk
integer x = 4992
integer y = 152
integer width = 206
integer height = 48
integer textsize = -5
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217734
long backcolor = 16777215
string text = "LOGOUT"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_menu_add from statictext within w_help_desk
integer x = 101
integer y = 1292
integer width = 942
integer height = 740
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217734
long backcolor = 67108864
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_add_ticket from statictext within w_help_desk
integer x = 178
integer y = 1440
integer width = 827
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long backcolor = 134217750
string text = "Ticket"
boolean focusrectangle = false
end type

event clicked;//Coloreamos las opciones del menu_add
st_add_ticket.backcolor			= RGB(230,230,230)
st_add_ticket.textcolor			= RGB(0,0,0)
st_new_contacto.backcolor		= RGB(250,250,250)
st_new_contacto.textcolor		= RGB(167,167,167)
st_add_busqueda.backcolor		= RGB(250,250,250)
st_add_busqueda.textcolor		= RGB(167,167,167)

idw_master.dataobject = "d_abc_ticket_ff"
idw_master.settransobject(sqlca) 
//activo el tab para insertar uno nuevo
tab_navigate.tabpage_ver.enabled = true
of_activa_tab(2, 1)
tab_navigate.tabpage_ver.text = "Nuevo Ticket"
gs_action = 'new_ticket' //Insertar nuevo registro para ticket
of_new_ticket_rpta( )
idw_details.retrieve( 0)
idw_details.visible						= false
idw_details_files.visible				= false
idw_desc_ticket.visible				= false
idw_details_arc_adjuntos.visible	= false
tab_navigate.tabpage_ver.st_rpta_otorgadas.visible	= false
tab_navigate.tabpage_ver.st_archivo.visible				= false
tab_navigate.tabpage_ver.st_fec_adj.visible				= false
tab_navigate.tabpage_ver.ln_archivo.visible				= false

//ocualtamos controles menu_add
of_ocultar_menu_add( )
end event

type st_add_busqueda from statictext within w_help_desk
integer x = 178
integer y = 1632
integer width = 827
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 134217734
long backcolor = 67108864
string text = "Busqueda"
boolean focusrectangle = false
end type

event clicked;of_activa_busqueda( )
end event

type st_new_contacto from statictext within w_help_desk
integer x = 178
integer y = 1540
integer width = 827
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 134217734
long backcolor = 67108864
string text = "Contacto"
boolean focusrectangle = false
end type

event clicked;String ls_dw
str_parametros sl_param

//Coloreamos las opciones del menu_add
st_add_ticket.backcolor			= RGB(250,250,250)
st_add_ticket.textcolor			= RGB(167,167,167)
st_new_contacto.backcolor		= RGB(230,230,230)
st_new_contacto.textcolor		= RGB(0,0,0)
st_add_busqueda.backcolor		= RGB(250,250,250)
st_add_busqueda.textcolor		= RGB(167,167,167)

//ocultamos las opciones de agregar
st_menu_add.visible 			= false
st_add_ticket.visible			= false
st_new_contacto.visible		= false
st_add_busqueda.visible		= false

gs_action = "new"
sl_param.int1	= 0
OpenWithParm( w_hd001_contacto_empresa, sl_param)
ls_dw = idw_tickets.DataObject
if trim(ls_dw) = "d_list_contactos_empresa_tbl" then
	idw_tickets.retrieve( )
	of_cantidad_reg( )
end if
end event

type ln_2 from line within w_help_desk
long linecolor = 134217728
integer linethickness = 4
integer beginx = 41
integer beginy = 900
integer endx = 1051
integer endy = 900
end type

