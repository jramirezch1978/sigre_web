$PBExportHeader$w_base.srw
forward
global type w_base from window
end type
type p_pie from picture within w_base
end type
type ole_skin from olecustomcontrol within w_base
end type
end forward

global type w_base from window
integer width = 2533
integer height = 1704
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 16777215
p_pie p_pie
ole_skin ole_skin
end type
global w_base w_base

type variables
Integer  ii_x = 1, ii_help, ii_list = 0, ii_error = 0
window   iw_sheet[]
menu		im_1
String	is_niveles
DateTime idt_fec_login

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
end variables

forward prototypes
public subroutine of_position_window (integer ai_x, integer ai_y)
public subroutine of_center_window ()
public subroutine of_center_up_window (integer ai_x)
public function integer of_new_sheet (str_cns_pop astr_1)
public subroutine of_activa_skin ()
public function boolean of_access ()
public function boolean of_login_objeto ()
public function boolean of_logout_objeto ()
end prototypes

public subroutine of_position_window (integer ai_x, integer ai_y);THIS.x = ai_x
THIS.y = ai_y
end subroutine

public subroutine of_center_window ();Long ll_x, ll_y


ll_x = ( w_main.workSpaceWidth()/2) - (THIS.Width/2)  
ll_y = ( w_main.WorkSpaceHeight()/2) - (THIS.Height/2)

of_position_window( ll_x, ll_y)	
end subroutine

public subroutine of_center_up_window (integer ai_x);Long ll_x, ll_y, ll_h

ll_h = (ai_x/100) * w_main.WorkSpaceHeight()

ll_x = (w_main.workSpaceWidth()/2) - (THIS.Width/2)  
ll_y = (w_main.WorkSpaceHeight()/2) - (THIS.Height/2) - ll_h 

of_position_window( ll_x, ll_y)
end subroutine

public function integer of_new_sheet (str_cns_pop astr_1);Integer 			li_rc
//w_abc_pop		lw_sheet_abc
w_cns_pop		lw_sheet_cns
w_rpt_pop		lw_sheet_rpt
w_grf_pop		lw_sheet_grf
w_cns_rtn_pop	lw_sheet_rtn

CHOOSE CASE Upper(astr_1.Tipo_Cascada)
	CASE 'A' // ABC
		//li_rc = OpenSheetWithParm(lw_sheet_abc, astr_1, this, 0, Original!)
		ii_x ++
		//iw_sheet[ii_x]  = lw_sheet_abc	
	CASE 'R' // Reporte
		li_rc = OpenSheetWithParm(lw_sheet_rpt, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_rpt
	CASE 'G' // Grafico
		li_rc = OpenSheetWithParm(lw_sheet_grf, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_grf
	CASE 'T' // Consulta con Retorno
		li_rc = OpenSheetWithParm(lw_sheet_rtn, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_rtn
	CASE ELSE // Consulta
		li_rc = OpenSheetWithParm(lw_sheet_cns, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_cns
END CHOOSE

RETURN li_rc     						//	Valores de Retorno: 1 = exito, -1 = error
end function

public subroutine of_activa_skin ();String 	ls_mensaje
Long		ll_i
staticText lst_1

IF LEN(Trim(gnvo_app.is_skin)) > 0 and gnvo_app.ib_skin THEN
	Long hWnd
	hWnd=Handle(W_main)
	IF FileExists(gnvo_app.is_skin) then
		ole_skin.object.LoadSkin(gnvo_app.is_skin)
		OLE_Skin.object.ApplySkin (hWnd)
		
		for ll_i = 1 to Upperbound(this.Control)
			if this.Control[ll_i].ClassName() = "statictext" then
				lst_1 = this.Control[ll_i]
				lst_1.backColor = this.backcolor
			end if
		next
		
	end if
END IF
end subroutine

public function boolean of_access ();// Funcion de Control de Acceso a Ventanas
// Argumentos:	as_usuario	codigo del usuario
//					as_objeto	objeto a validar el acceso
//					as_empresa  empresa para filtrar los roles del usuario
//             as_niveles  retorna los niveles de acceso al objeto

String 	ls_mensaje, ls_objeto
String	ls_iu, ls_eu, ls_mu, ls_cu, ls_au, ls_nu, ls_gu, ls_pu, ls_ru
String   ls_ig, ls_eg, ls_mg, ls_cg, ls_ag, ls_ng, ls_gg, ls_pg, ls_rg
Boolean 	lbo_retorno = FALSE 
Integer	li_x, li_regs
Long		ll_rc

if IsNull(gnvo_log) or not isValid(gnvo_log) then
	gnvo_log = create n_cst_errorlogging
end if

//Obtengo el nombre del objeto
ls_objeto = this.ClassName()

if gnvo_app.ib_new_struct then
	SELECT objeto
		INTO :ls_objeto 
	FROM CNF_OBJETO_SIST
	WHERE objeto = :ls_objeto; 
else
	SELECT objeto
		INTO :ls_objeto 
	FROM OBJETO_SIS
	WHERE objeto = :ls_objeto; 
end if

IF SQLCA.SQLCode = -1 THEN
	ls_mensaje = gnvo_log.of_mensajeDB("Ha ocurrido un error al momento de obtener datos de CNF_OBJETO_SIST")
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_ShowMessageDialog(ls_mensaje)
	return false
END IF

IF SQLCA.SQLCode = 100 THEN		// si el objeto no se encuentra no tiene control de acceso
	lbo_retorno = TRUE
	is_niveles = 'IEMCGPANR'
	
ELSE
	
	SELECT NVL(flag_insertar,'0'), 	NVL(flag_eliminar,'0'), 
			 NVL(flag_modificar,'0'), 	NVL(flag_consultar,'0'),
			 NVL(flag_grabar,'0'), 		NVL(flag_imprimir,'0'),
			 NVL(flag_anular,'0'), 		NVL(flag_cancelar,'0'),
			 NVL(flag_procesar,'0')
	INTO 	:ls_iu, 				:ls_eu, 
			:ls_mu, 				:ls_cu, 
			:ls_gu, 				:ls_pu,
			:ls_au, 				:ls_nu,
			:ls_ru
	FROM cnf_acceso_obj_empresa
	WHERE cod_usr = :gnvo_app.is_user 
	  AND objeto  = :ls_objeto 
	  and empresa = :gnvo_app.invo_empresa.is_empresa;   

	IF SQLCA.SQLCode = 0 THEN 	lbo_retorno = TRUE

	SELECT 	NVL(MAX(b.flag_insertar),'0'), 	NVL(MAX(b.flag_eliminar),'0'), 
			 	NVL(MAX(b.flag_modificar),'0'), 	NVL(MAX(b.flag_consultar),'0'),
			 	NVL(MAX(b.flag_grabar),'0'), 		NVL(MAX(b.flag_imprimir),'0'),
			 	NVL(MAX(b.flag_anular),'0'), 		NVL(MAX(b.flag_cancelar),'0'),
			 	NVL(MAX(b.flag_procesar),'0'), 	COUNT(*)
	  INTO 	:ls_ig, 									:ls_eg,   
				:ls_mg, 									:ls_cg,
				:ls_gg,									:ls_pg,
				:ls_ag, 									:ls_ng, 
				:ls_rg,									:li_regs
	  FROM  	CNF_ACCESO_ROL_EMPRESA A, 
				cnf_rol_obj B
	 WHERE A.ROL = B.ROL 
		and A.COD_USR = :gnvo_app.is_user
		AND B.OBJETO = :ls_objeto 
		and A.empresa = :gnvo_app.invo_empresa.is_empresa  ;
	
	IF li_regs > 0 THEN 	lbo_retorno = TRUE
	
	// Crear String con los niveles especificos de acceso
	IF lbo_retorno = TRUE THEN
		is_niveles = ''
		IF ls_iu = '1' OR ls_ig = '1' THEN is_niveles = is_niveles + 'I'	//Insertar
		IF ls_eu = '1' OR ls_eg = '1' THEN is_niveles = is_niveles + 'E'	//Elimiar 
		IF ls_mu = '1' OR ls_mg = '1' THEN is_niveles = is_niveles + 'M'	//Modificar
		IF ls_cu = '1' OR ls_cg = '1' THEN is_niveles = is_niveles + 'C'	//Consultar
		IF ls_gu = '1' OR ls_gg = '1' THEN is_niveles = is_niveles + 'G'	//Grabar
		IF ls_pu = '1' OR ls_pg = '1' THEN is_niveles = is_niveles + 'P'	//Imprimir
		IF ls_au = '1' OR ls_ag = '1' THEN is_niveles = is_niveles + 'A'	//Anular
		IF ls_nu = '1' OR ls_ng = '1' THEN is_niveles = is_niveles + 'N'	//Cancelar
		IF ls_ru = '1' OR ls_rg = '1' THEN is_niveles = is_niveles + 'R'	//Procesar

		// Grabar en Log_Objeto
		IF gnvo_app.ib_log_objeto and lbo_retorno THEN
			this.of_login_objeto( )
		END IF

	ELSE
		ls_mensaje = "Acceso Denegado ~r~n" + &
						 "Objeto: " + ls_objeto + "~r~n" + &
						 "Usuario: " + gnvo_app.is_user
						 
		gnvo_log.of_errorlog(ls_mensaje)
		gnvo_app.of_ShowMessageDialog(ls_mensaje)
	END IF

END IF


RETURN lbo_retorno

end function

public function boolean of_login_objeto ();String ls_objeto 

ls_objeto = this.ClassName()

idt_fec_login = f_fecha_actual(0)

if gnvo_app.ib_new_struct then
	INSERT INTO HIS_LOG_OBJETO ( OBJETO, FECHA_INI, COD_USR )  
		  VALUES ( :ls_objeto, :idt_fec_login, :gnvo_app.is_user )  ;
else
	INSERT INTO LOG_OBJETO ( OBJETO, FECHA, COD_USR )  
		  VALUES ( :ls_objeto, :idt_fec_login, :gnvo_app.is_user )  ;
end if

if gnvo_app.of_valida_transaccion( "Error al insertar registro en HIS_LOG_OBJETO", SQLCA) then
	COMMIT;
	return true
else
	return false
end if
			
return true
end function

public function boolean of_logout_objeto ();String 	ls_objeto 
DateTime ldt_fec_logout

ls_objeto = this.ClassName()

ldt_fec_logout = f_fecha_actual(1)

if gnvo_app.ib_new_struct then
	update HIS_LOG_OBJETO
		set FECHA_FIN = :ldt_fec_logout
	where objeto = :ls_objeto
	  and fecha_ini = :idt_fec_login
	  and cod_usr = :gnvo_app.is_user;
else
	update LOG_OBJETO
		set FECHA_FIN = :ldt_fec_logout
	where objeto  = :ls_objeto
	  and fecha   = :idt_fec_login
	  and cod_usr = :gnvo_app.is_user;
end if
	
if gnvo_app.of_valida_transaccion( "Error al insertar registro en HIS_LOG_OBJETO", SQLCA) then
	COMMIT;
	return true
else
	return false
end if
			
return true
end function

on w_base.create
this.p_pie=create p_pie
this.ole_skin=create ole_skin
this.Control[]={this.p_pie,&
this.ole_skin}
end on

on w_base.destroy
destroy(this.p_pie)
destroy(this.ole_skin)
end on

event open;//Aplico los skin
if gnvo_app.ib_skin then
	this.of_activa_skin( )
end if
end event

event resize;p_pie.width = newwidth - p_pie.x - this.cii_WindowBorder
p_pie.y 		= newheight - p_pie.height - this.cii_windowborder

end event

type p_pie from picture within w_base
integer x = 5
integer y = 1328
integer width = 2487
integer height = 268
string picturename = "C:\SIGRE\resources\JPG\pie_botones_3.jpg"
boolean focusrectangle = false
end type

type ole_skin from olecustomcontrol within w_base
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
integer x = 2267
integer y = 84
integer width = 146
integer height = 128
integer taborder = 10
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_base.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
08w_base.bin 
2C00000e00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000ffd2097001cade7700000003000004800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000021c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000030944d16c4389d0f485a02a98b39e5a5900000000ffd2097001cade77ffd2097001cade77000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000090000021c000000000000000100000002000000030000000400000005000000060000000700000008fffffffe0000000a0000000b0000000c0000000d0000000e0000000f0000001000000011fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
28ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000001000000020000000a0000001a005f006d007300620072007400750041006800740072006f000400000000000000240000006d00000062005f007400730044007200730065007200630070006900690074006e006f000400000000000000240000006d00000062005f0074007300410072007000700069006c0061006300690074006e006f0004000000000000000e0000006d0000006e005f007500480000006500000008000000040000000000000018005f006d00610042006b0063006f0043006f006c00000072000000070000000318ffffff6d00000046005f0072006f00430065006c006f0072006f00070000000300000000000000001a0000006d00000050005f006e0061006c0065006f0043006f006c00000072000000070000000322ece9d86d00000050005f006e0061006c00650065005400740078006f0043006f006c00000072000000070000000300000000000000001e005f006d00410062007000700079006c006f0043006f006c0073007200060000000200000000000000000024005f006d005300620069006b0043006e0069006c006e00650041007400650072000000610000000600000002000200010000000000030000000000000000000000010000000200000002000000160000006d00000062005f00740073004e0072006d006100000065000000040000000000000014005f006d0073006200720074006100540000006700000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000020000000a0000001a005f006d007300620072007400750041006800740072006f000400000000000000240000006d00000062005f007400730044007200730065007200630070006900690074006e006f000400000000000000240000006d00000062005f0074007300410072007000700069006c0061006300690074006e006f0004000000000000000e0000006d0000006e005f007500480000006500000008000000040000000000000018005f006d00610042006b0063006f0043006f006c00000072000000070000000318ffffff6d00000046005f0072006f00430065006c006f0072006f00070000000300000000000000001a0000006d00000050005f006e0061006c0065006f0043006f006c00000072000000070000000322ece9d86d00000050005f006e0061006c00650065005400740078006f0043006f006c00000072000000070000000300000000000000001e005f006d00410062007000700079006c006f0043006f006c0073007200060000000200000000000000000024005f006d005300620069006b0043006e0069006c006e00650041007400650072000000610000000600000002000200010000000000030000000000000000000000010000000200000002000000160000006d00000062005f00740073004e0072006d006100000065000000040000000000000014005f006d007300620072007400610054000000670000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
18w_base.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
