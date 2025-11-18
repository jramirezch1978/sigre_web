$PBExportHeader$w_login.srw
forward
global type w_login from window
end type
type shl_version from statichyperlink within w_login
end type
type st_6 from statictext within w_login
end type
type ole_skin from olecustomcontrol within w_login
end type
type shl_computer_name from statichyperlink within w_login
end type
type st_5 from statictext within w_login
end type
type st_4 from statictext within w_login
end type
type shl_username from statichyperlink within w_login
end type
type st_3 from statictext within w_login
end type
type p_3 from picture within w_login
end type
type shl_cierre from statichyperlink within w_login
end type
type st_sesion from statictext within w_login
end type
type st_mensaje from statictext within w_login
end type
type pb_1 from picturebutton within w_login
end type
type st_2 from statictext within w_login
end type
type p_2 from picture within w_login
end type
type st_1 from statictext within w_login
end type
type cb_2 from commandbutton within w_login
end type
type cb_iniciar from commandbutton within w_login
end type
type lv_sistemas from listview within w_login
end type
type plb_empresas from picturelistbox within w_login
end type
type gb_1 from groupbox within w_login
end type
type gb_2 from groupbox within w_login
end type
type p_1 from picture within w_login
end type
type plb_3 from picturelistbox within w_login
end type
type gb_3 from groupbox within w_login
end type
end forward

global type w_login from window
integer width = 3255
integer height = 2236
boolean titlebar = true
string title = "Sistema Integral de Gestión de Recursos Empresariales [S.I.G.R.E.]"
string icon = "AppIcon!"
boolean center = true
windowanimationstyle openanimation = bottomroll!
integer animationtime = 500
event ue_process ( )
shl_version shl_version
st_6 st_6
ole_skin ole_skin
shl_computer_name shl_computer_name
st_5 st_5
st_4 st_4
shl_username shl_username
st_3 st_3
p_3 p_3
shl_cierre shl_cierre
st_sesion st_sesion
st_mensaje st_mensaje
pb_1 pb_1
st_2 st_2
p_2 p_2
st_1 st_1
cb_2 cb_2
cb_iniciar cb_iniciar
lv_sistemas lv_sistemas
plb_empresas plb_empresas
gb_1 gb_1
gb_2 gb_2
p_1 p_1
plb_3 plb_3
gb_3 gb_3
end type
global w_login w_login

type prototypes

end prototypes

type variables
String is_mod, is_empresa, is_usuario

Protected:
Dragobject	idrg_TopLeft	//Reference to the Top Left control
Dragobject	idrg_TopRight	//Reference to the Top Right control
Dragobject	idrg_Bottom	//Reference to the Bottom  control
Boolean		ib_Debug=False	//Debug mode
Long			il_HiddenColor=0	//Bar hidden color to match the window background
Constant Integer cii_BarThickness=20	//Bar Thickness
Constant Integer cii_WindowBorder=15//Window border to be used on all sides
Constant Integer cii_WindowTop = 81	//The virtual top of the window
Constant Integer cii_MinimunHeight = 400 //Mínima altura
Constant Integer cii_MinimunWidth = 400 //Mínimo ancho

//Datos genericos
string 				is_empresas		[]
str_empresas		istr_empresas	[]
n_cst_licensing 	invo_licensing
n_cst_osversion 	invo_osver
n_cst_inifile		invo_inifile


end variables

forward prototypes
public function boolean of_licensing (string as_empresa)
public function ws_strrespuesta of_checking ()
public function boolean of_cargar_empresas (string as_empresas[])
public function boolean of_cargar_empresas ()
public function boolean of_modulos_ (string as_empresa)
end prototypes

event ue_process();String ls_modulo, ls_ruta, ls_empresa, ls_run, ls_exe_file //, ls_Acceso, ls_ini
ws_strrespuesta ls_respuesta

try
	cb_iniciar.enabled = false
	gnvo_wait.of_mensaje("Por favor espere...")
	
	// Si selecciona empresas
	IF lv_sistemas.SelectedIndex() < 1 THEN
		gnvo_wait.of_close()
		MESSAGEBOX( "ERROR", "Debe Seleccionar algún módulo antes de empezar, por favor verificar")
		RETURN
	END IF
	
	IF plb_empresas.SelectedIndex() < 1 THEN
		gnvo_wait.of_close()
		MESSAGEBOX( "ERROR", "Debe Seleccionar Esquema de trabajo")
		RETURN
	END IF
	
	ls_ruta	  = plb_3.SelectedItem()
	ls_empresa = plb_empresas.SelectedItem()
	lv_sistemas.getitem(lv_sistemas.SelectedIndex(), 1, ls_modulo)
	
	//Valido si la empresa tiene acceso o no al sigre
	//if gs_name = 'Console' then
	//	gnvo_wait.of_mensaje("Validando Licencia " + ls_empresa + " ... ")
	//	if not this.of_licensing( ls_empresa ) then return
	//end if
	
	
	
	//valido modulo y empresa
//////////////////////////////////////////////	//COMENTADO EL 03 DE MAYO 2016 POR ALEX
			//	gnvo_wait.of_mensaje("Validando acceso al modulo ...")
			//	ls_respuesta = invo_licensing.of_validar_Modulo_Empresa(ls_empresa,ls_modulo)
			//	
			//	if not(ls_respuesta.isOk) then
			//		MessageBox('Error', 'No tiene acceso al módulo ' + upper(ls_modulo) + ' para su empresa, ' &
			//					+ 'por favor verifique o contacte con un representante.')
			//		return
			//	end if
/////////////////////////////////////////		//COMENTADO EL 03 DE MAYO 2016 POR ALEX


	//Verifico si el archivo ejecutable existe
	gnvo_wait.of_mensaje("Verificando que exista el modulo " + ls_modulo + " ...")
	ls_exe_file = ls_ruta + ls_modulo + ".exe"
	
	if not FileExists(ls_exe_file) then
		gnvo_wait.of_close()
		MessageBox('Error', 'El módulo ' + upper(ls_modulo) + ' no existe o no esta instalado para su empresa, ' &
					+ 'por favor verifique o contacte con un representante.')
		return
	end if
	
	ls_run =  ls_exe_file + " " + ls_empresa
	
	gnvo_wait.of_mensaje("Corriendo el módulo " + ls_modulo + " ...")
	run(ls_run)

catch(Exception ex)
	MessageBox('Error', 'Ha ocurrido una excepción, en el evento ue_process: ' + ex.getMessage(), Stopsign!)
	
finally
	gnvo_wait.of_close()
	
	cb_iniciar.enabled = true
	
end try

end event

public function boolean of_licensing (string as_empresa);try 
	//return invo_licensing.of_validar(as_empresa)
	return true
	
catch ( Exception ex )
	MessageBox("Error", "A ocurrido una exception: " + ex.getMessage())

end try


end function

public function ws_strrespuesta of_checking ();ws_strrespuesta lnvo_return
try 
	//is_usuario = invo_licensing.of_get_usuario( )
	
	//return invo_licensing.of_validar_usuario(is_usuario)
	
	return lnvo_return

catch ( Exception ex )
	MessageBox("Error", "A ocurrido una exception: " + ex.getMessage())
	

end try
end function

public function boolean of_cargar_empresas (string as_empresas[]);Long 		ll_num_emp, ll_j, ll_i
String	ls_empresa 

ll_num_emp = UpperBound(as_empresas)

if ll_num_emp = 0 then
	MessageBox('Error', 'El usuario ' + is_usuario + ' No tiene acceso a ninguna empresa. Por favor verifique!', StopSign!)
	return false
end if

// Carga las empresas
ll_i = 1
For ll_j = 1 to ll_num_emp  
	ls_empresa  = as_empresas[ll_j]
	If Trim(ls_empresa) <> '' then
		 plb_empresas.insertitem( ls_empresa, ll_j, 1)		
		 is_empresas [ll_i] = ls_empresa
		 ll_i ++
	 End if
next

return true
end function

public function boolean of_cargar_empresas ();Long 		ll_j, ll_num_emp, ll_i
String 	ls_empresa, ls_icono
Integer	li_icono

//Limpio el PictureListBox
plb_empresas.Reset()

ll_i = 1
ll_num_emp = Long(ProfileString(gs_inifile, "Num_Empresas", '1', "20"))

//MessageBox("Informacion", "Nro de empresa " + string(ll_num_emp))

For ll_j = 1 to ll_num_emp  
	ls_empresa = ProfileString(gs_inifile, "Empresas", string(ll_j), "")
	ls_icono 	= ProfileString(gs_inifile, "IcoEsq", string(ll_j), "AppIcon!")
	 
	//-- Esquemas
	If Trim(ls_empresa) <> '' then
		If not FileExists(ls_icono) then
			MessageBox('Error en archivo', 'No existe el archivo de ICONO ' + ls_icono + ", por favor verifique, " &
												  + "de lo contrario no se puede acceder a la EMPRESA " + ls_empresa, StopSign!)
		else
			
			li_icono = plb_empresas.AddPicture(ls_icono)  	
			plb_empresas.insertitem( ls_empresa, ll_j, li_icono)		
			is_empresas [ll_i] = ls_empresa
			ll_i ++
							
		end if
	end if

	 
	 
	 
Next
		
return true
end function

public function boolean of_modulos_ (string as_empresa);integer 				li_pict
ws_strrespuesta 	str_rpta
integer 				li_i, li_index

try
	gnvo_wait.of_mensaje("Cargando módulos para " + as_empresa + " ... ")
	yield()
	
	//str_rpta = 	invo_licensing.of_validar_Modulos_Por_Empresa(as_empresa)
	
	if upperBound(str_rpta.modulos) = 0 then 
		gnvo_wait.of_mensaje("No hay módulos para " + as_empresa + " ... ")
		return false
	end if
	
	//Agrego indice al arreglo de empresas
	li_index = UpperBound(istr_empresas)
	li_index ++
	
	istr_empresas[li_index].cod_empresa = as_empresa
	
	gnvo_wait.of_mensaje("Se estan cargando " + string(str_rpta.modulos) &
							 + " módulos para la empresa " + as_empresa + " ... ")
	yield()
	
	//Cargando módulos
	for li_i = 1 to UpperBound(str_rpta.modulos)
		istr_empresas[li_index].modulos[li_i].moduloid 		= str_rpta.modulos[li_i].moduloid
		istr_empresas[li_index].modulos[li_i].codigo 		= str_rpta.modulos[li_i].codigo
		istr_empresas[li_index].modulos[li_i].descripcion 	= str_rpta.modulos[li_i].descripcion
		istr_empresas[li_index].modulos[li_i].flag_acceso 	= str_rpta.modulos[li_i].flag_acceso
		istr_empresas[li_index].modulos[li_i].icono 			= str_rpta.modulos[li_i].icono
	next
	
	return true

catch(Exception ex)
	MessageBox("Error", "Ha ocurrido una excepcion en of_modulos(). Mensaje de Error: " + ex.getMessage(), StopSign!)
	return false
	
end try
end function

on w_login.create
this.shl_version=create shl_version
this.st_6=create st_6
this.ole_skin=create ole_skin
this.shl_computer_name=create shl_computer_name
this.st_5=create st_5
this.st_4=create st_4
this.shl_username=create shl_username
this.st_3=create st_3
this.p_3=create p_3
this.shl_cierre=create shl_cierre
this.st_sesion=create st_sesion
this.st_mensaje=create st_mensaje
this.pb_1=create pb_1
this.st_2=create st_2
this.p_2=create p_2
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_iniciar=create cb_iniciar
this.lv_sistemas=create lv_sistemas
this.plb_empresas=create plb_empresas
this.gb_1=create gb_1
this.gb_2=create gb_2
this.p_1=create p_1
this.plb_3=create plb_3
this.gb_3=create gb_3
this.Control[]={this.shl_version,&
this.st_6,&
this.ole_skin,&
this.shl_computer_name,&
this.st_5,&
this.st_4,&
this.shl_username,&
this.st_3,&
this.p_3,&
this.shl_cierre,&
this.st_sesion,&
this.st_mensaje,&
this.pb_1,&
this.st_2,&
this.p_2,&
this.st_1,&
this.cb_2,&
this.cb_iniciar,&
this.lv_sistemas,&
this.plb_empresas,&
this.gb_1,&
this.gb_2,&
this.p_1,&
this.plb_3,&
this.gb_3}
end on

on w_login.destroy
destroy(this.shl_version)
destroy(this.st_6)
destroy(this.ole_skin)
destroy(this.shl_computer_name)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.shl_username)
destroy(this.st_3)
destroy(this.p_3)
destroy(this.shl_cierre)
destroy(this.st_sesion)
destroy(this.st_mensaje)
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.p_2)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_iniciar)
destroy(this.lv_sistemas)
destroy(this.plb_empresas)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.p_1)
destroy(this.plb_3)
destroy(this.gb_3)
end on

event open;// Verifica estado de acceso
Long    					ll_j, ll_num_sis, ll_num_act, hWnd_skin, ll_num_emp
String  					ls_emp, ls_logo ,ls_icoe, ls_pict, ls_sis, ls_titulo, ls_dir, ls_icod, &
							ls_skin, ls_cod_usuario, ls_version, ls_edition, ls_csd, ls_pbvmname, &
							ls_uaclevel, ls_load_skin
Integer 					li_icono, li_pict, li_ran, li_i
Boolean 					lb_skin
application 			lnvo_app
ws_StrRespuesta		rpta



try
	
	gnvo_wait.of_mensaje("Cargando datos necesarios ...")
	
	invo_licensing = create n_cst_licensing
	invo_inifile 	= create n_cst_inifile
	
	shl_username.Text 		= gs_user_so
	shl_computer_name.Text 	= trim(gs_computer_name)
	
	if gnvo_api.is_remote_desktop() then
		shl_computer_name.Text += ' - Remote Desktop'
	else
		shl_computer_name.Text += ' - Desktop Console'
	end if
	
	gnvo_wait.of_mensaje("Cargando interface para licencia")
	
	//TEngo que ver que sistema operativo estoy usando
	invo_osver.of_GetOSVersion(ls_version, ls_edition, ls_csd)
	shl_version.text = ls_version + ' (' + String(invo_osver.of_GetOSBits()) + ' bits)'
	
	invo_inifile.of_set_inifile(gs_inifile)
	
	ls_load_skin		= invo_inifile.of_get_parametro("SKIN", "LOAD_SKIN", "1")
	
	//Aplico el skin
	if ls_load_skin = '1' then
		gnvo_wait.of_mensaje("Cargado Skin")
		hWnd_skin=Handle(W_Login)
		
		if not gnvo_api.is_remote_desktop() then
			ls_skin = gs_path + "\sigrehd.skn"
		else
			ls_skin = gs_path + "\sigrets.skn"
		end if

		if not ( &
			(trim(upper(ls_version)) = 'WINDOWS SERVER 2012 R2') or &
			(upper(ls_version) = 'WINDOWS 7' and String(invo_osver.of_GetOSBits())  = '64') ) then
		
			gnvo_wait.of_mensaje("Cargando skin")
			
			if FileExists(ls_skin) then
				gnvo_wait.of_mensaje("LoadSkin")
				W_Login.OLE_Skin.object.LoadSkin(ls_skin)
				
				gnvo_wait.of_mensaje("ApplySkin en hWnd_skin: " + string(hWnd_skin))
				W_Login.OLE_Skin.object.ApplySkin (hWnd_skin)
				
				gnvo_wait.of_mensaje("WindowColor")
				w_login.ole_skin.object.WindowColor()
			else
				if not FileExists(ls_skin) then
					MessageBox('Error', 'No existe el archivo skin ' + ls_skin + ', por favor verifique!', StopSign!)
					halt close
				end if
			end if
		end if
	end if
	
	
	lnvo_app = GetApplication()
	lnvo_app.Toolbartext=TRUE
	timer(0.2)

	gnvo_wait.of_mensaje("Toolbar cargado = true")

	ls_titulo  = ProfileString(gs_inifile, "Titulo", '1', "Sistema Integrado")
	ll_num_sis = Long(ProfileString(gs_inifile, "Num_Sist", '1', "20"))
	
	this.title = ls_titulo
	
	gnvo_wait.of_mensaje("Cargando Directorios ...")
	yield()
	
	For ll_j = 1 to ll_num_sis  
		 ls_dir	= ProfileString(gs_inifile, "Directorios", string(ll_j), "")
		 ls_icod = ProfileString(gs_inifile, "IcoDir", string(ll_j), "AppIcon!")
		 
		 //-- Directorios
		 If Trim(ls_dir) <> '' then
			 li_icono = plb_3.AddPicture(ls_icod)  	
			 plb_3.insertitem( ls_dir, ll_j, li_icono)	
		 End if
	Next
	
	//Lazo para leer empresas
	gnvo_wait.of_mensaje("Cargando Empresas ...")
	yield()
	
	//Por ahora todo arranca desde consola
	of_cargar_empresas()
	
	/*
	if gs_name = 'Console' then   
		
		//Cuando es ingreso de manera local, va a leer las empresas del archivo ini
		of_cargar_empresas()
			
	else  //acceso remoto
		
		rpta = of_checking()
		
		if rpta.isok then
			//Si es Ok, entonces leo simplemente del archivo ini
			of_cargar_empresas()
			
		else  //lee de la base
			if len(rpta.mensaje)>0 then
				
				MessageBox("Mensaje", rpta.mensaje)
				post event closequery()
				return
				
			else
				
				if not of_cargar_empresas(rpta.lista) then
					post event closequery()
				end if
				
				
			end if
		end if
	end if
	*/
	
	if UpperBound(is_empresas) = 0 then
		MessageBox('Error', 'No tiene acceso a ninguna empresa')
		post event closequery()
	end if
	
	//Recorriendo las empresas para cargar el módulo
	gnvo_wait.of_mensaje("Cargando módulos a las empresas ... ")
	yield()
	
//	for li_i = 1 to UpperBound(is_empresas)
//		this.of_modulos(is_empresas[li_i])
//	next
	
	//Levantando módulos de la primera empresa
	plb_empresas.selectitem(1)
	plb_empresas.event selectionchanged(plb_empresas.selectedindex( ))
	
	plb_3.selectitem(1)

catch(Exception ex)
	MessageBox('Error', 'Ha ocurrido una excepción en el evento Open: ' + ex.getMessage(), StopSign!)
	
finally
	destroy invo_inifile
	destroy invo_licensing
	gnvo_wait.of_close()
end try
end event

event close;destroy invo_licensing
end event

type shl_version from statichyperlink within w_login
integer x = 2414
integer y = 1956
integer width = 827
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 16777215
string text = "..."
boolean focusrectangle = false
end type

type st_6 from statictext within w_login
integer x = 1888
integer y = 1952
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Sistema Operativo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type ole_skin from olecustomcontrol within w_login
event skinevent ( oleobject source,  string eventname )
event render ( oleobject source,  oleobject screenbuffer,  long positionx,  long positiony )
event skintimer ( oleobject source,  long sourcehwnd,  long passedtime )
event click ( oleobject source )
event dblclick ( oleobject source )
event mousedown ( oleobject source,  integer button,  long ocx_x,  long ocx_y )
event mouseup ( oleobject source,  integer button,  long ocx_x,  long ocx_y )
event mousein ( oleobject source )
event mouseout ( oleobject source )
event mousemove ( oleobject source,  long ocx_x,  long ocx_y )
event scroll ( oleobject source,  long newpos )
event scrolltrack ( oleobject source,  long newpos )
integer x = 3008
integer y = 176
integer width = 146
integer height = 128
integer taborder = 70
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_login.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

type shl_computer_name from statichyperlink within w_login
integer x = 2414
integer y = 2084
integer width = 827
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 16777215
string text = "..."
boolean focusrectangle = false
end type

type st_5 from statictext within w_login
integer x = 1888
integer y = 2080
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Nombre PC :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_login
integer x = 1888
integer y = 2016
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Usuario S.O. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type shl_username from statichyperlink within w_login
integer x = 2414
integer y = 2020
integer width = 827
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 16777215
string text = "..."
boolean focusrectangle = false
end type

type st_3 from statictext within w_login
integer x = 2135
integer y = 1756
integer width = 379
integer height = 172
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Black"
long textcolor = 8388608
long backcolor = 16777215
string text = "SIGRE VERSION"
alignment alignment = right!
boolean focusrectangle = false
end type

type p_3 from picture within w_login
integer x = 2542
integer y = 1756
integer width = 512
integer height = 172
string picturename = "C:\SIGRE\resources\PNG\logo_2025.png"
boolean focusrectangle = false
end type

type shl_cierre from statichyperlink within w_login
boolean visible = false
integer x = 2505
integer y = 1648
integer width = 645
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 16777215
string text = "Cerrar sesión activa"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_sesion from statictext within w_login
integer x = 2505
integer y = 1468
integer width = 645
integer height = 136
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type st_mensaje from statictext within w_login
boolean visible = false
integer x = 2505
integer y = 1760
integer width = 645
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_login
integer x = 3095
integer width = 151
integer height = 92
integer taborder = 10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
boolean italic = true
boolean underline = true
string picturename = "C:\SIGRE\resources\Toolbar\minimizar.PNG"
string disabledname = "C:\SIGRE\resources\Toolbar\minimizar.PNG"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Minimiza la ventana"
end type

event clicked;parent.windowstate = Minimized!
end event

type st_2 from statictext within w_login
integer x = 1143
integer y = 2040
integer width = 745
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "Orgullosos de ser peruanos"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_2 from picture within w_login
integer x = 1143
integer y = 1740
integer width = 745
integer height = 280
string picturename = "C:\SIGRE\resources\JPG\marcaperu.jpg"
boolean focusrectangle = false
end type

type st_1 from statictext within w_login
integer x = 64
integer y = 2084
integer width = 864
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "Gestión de Recursos Empresariales"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_login
integer x = 2551
integer y = 1324
integer width = 558
integer height = 136
integer taborder = 60
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "&Salir"
end type

event clicked;Close(parent)
end event

type cb_iniciar from commandbutton within w_login
integer x = 2551
integer y = 1188
integer width = 558
integer height = 136
integer taborder = 50
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "&Iniciar"
end type

event clicked;setPointer(HourGlass!)

//this.enabled = false
//this.Text	 = 'Procesando...'
//st_mensaje.visible = true

//invo_wait.of_wait( true )

parent.event ue_process()

//invo_wait.of_wait( false )

//this.enabled = true
//this.Text	 = '&Iniciar'
//st_mensaje.visible = false

setPointer(Arrow!)


end event

type lv_sistemas from listview within w_login
integer x = 50
integer y = 136
integer width = 2373
integer height = 1548
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
boolean autoarrange = true
boolean fixedlocations = true
boolean hideselection = false
boolean oneclickactivate = true
boolean fullrowselect = true
boolean underlinecold = true
integer largepicturewidth = 32
long largepicturemaskcolor = 536870912
long smallpicturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event doubleclicked;parent.event ue_process()
end event

type plb_empresas from picturelistbox within w_login
integer x = 2501
integer y = 152
integer width = 658
integer height = 980
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean vscrollbar = true
boolean sorted = false
string item[] = {""}
borderstyle borderstyle = stylelowered!
integer itempictureindex[] = {0}
long picturemaskcolor = 134217747
end type

event selectionchanged;String 	ls_empresa, ls_dir, ls_icon
Long		ll_i, ll_index, ll_pict, ll_num_sis
Integer	li_icono

if index = 0 then return

gnvo_wait.of_mensaje("Procesando, por favor espere...")
yield()

lv_sistemas.deleteitems()

//Determino la empresa seleccionada
if gs_ws = "1" then
	ls_empresa 					= 	plb_empresas.SelectedItem();
	
	gnvo_wait.of_mensaje("Buscando módulos para empresa " + ls_empresa + " ...")
	yield()
	
	//for ll_i = 1 to UpperBound(istr_empresas)
	//	if trim(istr_empresas[ll_i].cod_empresa) = trim(ls_empresa) then
	//		ll_index = ll_i
	//		exit
	//	end if
	//next
	//
	//
	////gnvo_wait.of_mensaje(string(UpperBound(istr_empresas[ll_index].modulos)) &
	////					+  "Módulos encontrados para empresa " + ls_empresa &
	////					+ ", cargando ...")
	//
	//
	//for ll_i=1 to upperbound(istr_empresas[ll_index].modulos)
	//	
	//	if Trim(istr_empresas[ll_index].modulos[ll_i].codigo) <> '' then
	//		
	//		ll_pict = lv_sistemas.AddLargePicture(istr_empresas[ll_index].modulos[ll_i].icono)  	
	//		lv_sistemas.insertitem (ll_i, istr_empresas[ll_index].modulos[ll_i].codigo, ll_pict)
	//	
	//	end if
	//next
else
	ll_num_sis = Long(ProfileString(gs_inifile, "Num_Sist", '1', "20"))
	
	For ll_i = 1 to ll_num_sis  
		 ls_dir	= ProfileString(gs_inifile, "Sistemas", string(ll_i), "")
		 ls_icon = ProfileString(gs_inifile, "Ico_Sist", string(ll_i), "AppIcon!")
		 
		 //-- Directorios
		If Trim(ls_dir) <> '' then
			ll_pict = lv_sistemas.AddLargePicture(ls_icon)  	
			lv_sistemas.insertitem (ll_i, ls_dir, ll_pict)
		 End if
	Next
	
end if

gnvo_wait.of_close()

end event

type gb_1 from groupbox within w_login
integer x = 32
integer y = 52
integer width = 2409
integer height = 1656
integer taborder = 10
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "Aplicaciones"
end type

type gb_2 from groupbox within w_login
integer x = 2464
integer y = 84
integer width = 731
integer height = 1092
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "Esquema de trabajo"
borderstyle borderstyle = stylebox!
end type

type p_1 from picture within w_login
integer x = 64
integer y = 1740
integer width = 864
integer height = 336
boolean enabled = false
string picturename = "C:\SIGRE\resources\PNG\SIGRE 2025.png"
boolean focusrectangle = false
end type

type plb_3 from picturelistbox within w_login
boolean visible = false
integer x = 1984
integer y = 1732
integer width = 183
integer height = 108
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
boolean vscrollbar = true
boolean sorted = false
string item[] = {""}
borderstyle borderstyle = stylelowered!
integer itempictureindex[] = {0}
long picturemaskcolor = 134217747
end type

type gb_3 from groupbox within w_login
boolean visible = false
integer x = 1490
integer y = 1152
integer width = 192
integer height = 116
integer taborder = 20
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Directorio de Trabajo"
borderstyle borderstyle = stylebox!
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
06w_login.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
16w_login.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
