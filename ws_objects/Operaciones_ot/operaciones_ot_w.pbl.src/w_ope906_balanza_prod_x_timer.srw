$PBExportHeader$w_ope906_balanza_prod_x_timer.srw
forward
global type w_ope906_balanza_prod_x_timer from w_prc
end type
type cb_2 from commandbutton within w_ope906_balanza_prod_x_timer
end type
end forward

global type w_ope906_balanza_prod_x_timer from w_prc
integer width = 1595
integer height = 528
string title = "Transferencia de Balanza (OPE905)"
string menuname = "m_salir"
cb_2 cb_2
end type
global w_ope906_balanza_prod_x_timer w_ope906_balanza_prod_x_timer

type variables


end variables

forward prototypes
public subroutine wf_data_acces (string as_fecha)
end prototypes

public subroutine wf_data_acces (string as_fecha);String   ls_tarjeta ,ls_producto,ls_fecha,ls_hora ,ls_msj_err,ls_nada
Datetime ld_fecha_hora 
Date		ld_fecha
Decimal {3} ldc_peso 
Long        ll_bal,ll_count,ll_contador
Boolean		lb_ret = true
transaction atr_obj

atr_obj = create transaction


ld_fecha = Date(as_fecha)
// Profile acces_bal
atr_obj.DBMS = "ODBC"
atr_obj.AutoCommit = False
atr_obj.DBParm = "ConnectString='DSN=balanza'"




Connect  using atr_obj;

IF atr_obj.sqlcode <> 0 THEN
   MessageBox ("No Pude Conectar a la Base de Datos de Balanza", atr_obj.sqlerrtext)
//	li_rc = -1
END IF

//inicializacion de variable
ll_contador = 0


/*Armar Cadena de Documentos x Grupo de retenciones*/
DECLARE c_datos CURSOR FOR  
 SELECT fecha,hora,codprd,codtjt,peso,numblz
   FROM balanza
  WHERE fecha = :as_fecha using atr_obj ;
  
OPEN c_datos ;
DO
// Lee datos de cursor
FETCH c_datos into :ls_fecha ,:ls_hora ,:ls_producto ,:ls_tarjeta,:ldc_peso,:ll_bal ;
	

IF atr_obj.SQLCODE = 100 THEN EXIT
	// Continua proceso
	
	ls_tarjeta  = Trim(ls_tarjeta)
	ls_producto = Trim(ls_producto)
	
	ld_fecha_hora = Datetime(Date(ls_fecha), time(ls_hora))
	
	ll_contador = ll_contador + 1
	Setmicrohelp(trim(string(ll_contador)))
	
	Insert Into tt_ope_psj_blz
	(codtjt,codprd,fecha,peso,codblz)
	Values
	(:ls_tarjeta,:ls_producto,:ld_fecha_hora,:ldc_peso,:ll_bal ) using sqlca ;
	
	IF SQLCA.SQLCode = -1 THEN 
		lb_ret = FALSE
		ls_msj_err = SQLCA.SQLErrText
		GOTO SALIDA
	END IF
	
	
	LOOP WHILE TRUE
CLOSE c_datos ;




//ejecuta procedimiento de pesjae_balanza
DECLARE PB_usp_ope_pesaje_balanza PROCEDURE FOR usp_ope_pesaje_balanza
(:ls_nada);
EXECUTE pb_usp_ope_pesaje_balanza ;
	
IF SQLCA.SQLCode = -1 THEN 
   MessageBox("SQL error", SQLCA.SQLErrText)
	lb_ret = FALSE
	GOTO SALIDA		
END IF

//ejecuta procedimeinto de asigancion de labores
DECLARE PB_usp_ope_dist_trab_dstjo PROCEDURE FOR usp_ope_dist_trab_dstjo
(:ld_fecha,:gs_origen,:gs_user);
EXECUTE pb_usp_ope_dist_trab_dstjo ;
	
IF SQLCA.SQLCode = -1 THEN 
   MessageBox("SQL error", SQLCA.SQLErrText)
	lb_ret = FALSE
	GOTO SALIDA		
END IF




SALIDA:

if lb_ret then
	Commit using sqlca ;
	Messagebox('Aviso','Grabacion Satisfactoria!')
else
	Rollback using sqlca ;
	Messagebox('Aviso',ls_msj_err)
end if


disConnect  using atr_obj;


end subroutine

on w_ope906_balanza_prod_x_timer.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
end on

on w_ope906_balanza_prod_x_timer.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
end on

event timer;call super::timer;Date ld_fecha

ld_fecha = today()


Messagebox('LD_FECHA',String(ld_fecha))


end event

event activate;call super::activate;Timer(10)
end event

event open;call super::open;//SetWindowPos (Handle (This), HWND_TOPMOST, 0,2856,0,0, SWP_NOACTIVATE + SWP_SHOWWINDOW + SWP_NOMOVE + SWP_NOSIZE) 
environment env
GetEnvironment (env)
//ScreenWidth  = env.ScreenWidth
//ScreenHeight = env.ScreenHeight

end event

type cb_2 from commandbutton within w_ope906_balanza_prod_x_timer
boolean visible = false
integer x = 1042
integer y = 96
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;//String   ls_cadena_input ,ls_filename ,ls_fecha ,ls_hora ,ls_ruta	,ls_fecha_proceso ,&
//			ls_tarjeta		 ,ls_producto ,ls_nada
//Datetime ld_fecha_hora
//Date		ld_fecha
//Boolean	lb_ret = TRUE
//Long     ll_contador,ll_pri_pos,ll_seg_pos,ll_ter_pos,ll_cua_pos,ll_qui_pos,ll_sex_pos,&
//			ll_bal
//Integer  li_file_open,li_file_read
//Decimal  {3} ldc_peso
//
//
//
//
//SetPointer(hourglass!)
//
//ls_ruta		     = 'C:\balanza_pisco\'
//ls_filename      = String(uo_1.of_get_fecha(),'YYYYMMDD')+'.txt'
//ls_fecha_proceso = String(uo_1.of_get_fecha(),'YYYY/MM/DD')
//ld_fecha			  = uo_1.of_get_fecha()
//li_file_open     = FileOpen(ls_ruta + ls_filename,LineMode!, Read!, Shared!)
//
//
//
//if li_file_open = -1 then
//	FileClose(li_file_open)
//
//	Return
//end if
//
//
//li_file_read = FileRead(li_file_open,ls_cadena_input)
//
//
//Do While li_file_read <> -100
//	if Not(Isnull(ls_cadena_input) or trim(ls_cadena_input) = '') then
//		
//		ll_pri_pos  = Pos(ls_cadena_input,",",1)
//		ls_fecha	   = Mid(ls_cadena_input,2,( (ll_pri_pos - 2) -2) + 1)
//		ll_seg_pos  = Pos(ls_cadena_input,",",ll_pri_pos + 1)
//		ls_hora	   = Mid(ls_cadena_input,ll_pri_pos + 2,(ll_seg_pos -2 ) - (ll_pri_pos + 2) + 1 )	
//		ll_ter_pos  = Pos(ls_cadena_input,",",ll_seg_pos + 1)
//		ls_tarjeta  = Mid(ls_cadena_input,ll_seg_pos + 2,(ll_ter_pos -2 ) - (ll_seg_pos + 2) + 1 )
//		ll_cua_pos  = Pos(ls_cadena_input,",",ll_ter_pos + 1)
//		ls_producto = Mid(ls_cadena_input,ll_ter_pos + 2,(ll_cua_pos -2 ) - (ll_ter_pos + 2) + 1 )	
//		ll_qui_pos  = Pos(ls_cadena_input,",",ll_cua_pos + 1)
//		ll_bal 		= Long(Mid(ls_cadena_input,ll_cua_pos + 2,(ll_qui_pos -2 ) - (ll_cua_pos + 2) + 1 )	)
//		ll_sex_pos  = Len(ls_cadena_input)
//		ldc_peso 	= dec(Mid(ls_cadena_input,ll_qui_pos + 2,(ll_sex_pos -1 ) - (ll_qui_pos + 2) + 1 )	)
//		
//		
//		ld_fecha_hora = Datetime(Date(ls_fecha), time(ls_hora))
//		
//		ll_contador = ll_contador + 1
//		Parent.setmicrohelp(trim(string(ll_contador)))
//		
//		 Insert Into tt_ope_psj_blz
//		 (codtjt,codprd,fecha,peso,codblz )
//		 Values
//		 (:ls_tarjeta ,:ls_producto ,:ld_fecha_hora ,:ldc_peso ,:ll_bal );
//		 
//		 IF SQLCA.SQLCode = -1 THEN 
//			 MessageBox("SQL error", SQLCA.SQLErrText)
// 			 lb_ret = FALSE
//			 GOTO SALIDA
//
//		 END IF
//		
//	end if	
//	
//	
//	
//
//	
//	//leo archivo texto
//	li_file_read = FileRead(li_file_open,ls_cadena_input)
//	
//Loop	
//
////ejecuta procedimiento de pesjae_balanza
//DECLARE PB_usp_ope_pesaje_balanza PROCEDURE FOR usp_ope_pesaje_balanza
//(:ls_nada);
//EXECUTE pb_usp_ope_pesaje_balanza ;
//	
//IF SQLCA.SQLCode = -1 THEN 
//   MessageBox("SQL error", SQLCA.SQLErrText)
//	lb_ret = FALSE
//	GOTO SALIDA		
//END IF
//
////ejecuta procedimeinto de asigancion de labores
//DECLARE PB_usp_ope_dist_trab_dstjo PROCEDURE FOR usp_ope_dist_trab_dstjo
//(:ld_fecha,:gs_origen,:gs_user);
//EXECUTE pb_usp_ope_dist_trab_dstjo ;
//	
//IF SQLCA.SQLCode = -1 THEN 
//   MessageBox("SQL error", SQLCA.SQLErrText)
//	lb_ret = FALSE
//	GOTO SALIDA		
//END IF
//
//
//SALIDA:
//
//
//IF lb_ret then
//	Commit ;
//	Messagebox('Aviso','Proceso se Culmino Satisfactoriamente')
//ELSE
//	Rollback ;
//END IF
//
//SetPointer(Arrow!)
end event

