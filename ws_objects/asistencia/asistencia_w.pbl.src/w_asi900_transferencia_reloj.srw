$PBExportHeader$w_asi900_transferencia_reloj.srw
forward
global type w_asi900_transferencia_reloj from w_prc
end type
type uo_1 from u_ingreso_fecha within w_asi900_transferencia_reloj
end type
type hpb_1 from hprogressbar within w_asi900_transferencia_reloj
end type
type cb_1 from commandbutton within w_asi900_transferencia_reloj
end type
type gb_1 from groupbox within w_asi900_transferencia_reloj
end type
end forward

global type w_asi900_transferencia_reloj from w_prc
integer width = 2016
integer height = 684
string title = "Transferencia de Archivo Texto (ASI900)"
string menuname = "m_proceso"
uo_1 uo_1
hpb_1 hpb_1
cb_1 cb_1
gb_1 gb_1
end type
global w_asi900_transferencia_reloj w_asi900_transferencia_reloj

on w_asi900_transferencia_reloj.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.uo_1=create uo_1
this.hpb_1=create hpb_1
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.hpb_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_asi900_transferencia_reloj.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.hpb_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type uo_1 from u_ingreso_fecha within w_asi900_transferencia_reloj
integer x = 69
integer y = 136
integer taborder = 30
end type

event constructor;call super::constructor;of_set_label('Fecha : ') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

type hpb_1 from hprogressbar within w_asi900_transferencia_reloj
integer x = 27
integer y = 416
integer width = 1925
integer height = 68
end type

type cb_1 from commandbutton within w_asi900_transferencia_reloj
integer x = 1591
integer y = 52
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Integer  li_file_open,li_file_read
String   ls_cadena_input ,ls_filename ,ls_cod_reloj ,ls_cod_tarjeta  ,ls_tipo_mov      ,&
		   ls_fecha			,ls_hora 	 ,ls_ruta		,ls_fecha_proceso ,ls_cod_trabajador,&
			ls_msj_err
Long     ll_contador,ll_inicio,ll_inicio_count
Datetime ld_fecha_hora
Date		ld_fecha
Boolean	lb_ret = TRUE

ls_ruta		     = 'G:\PERSONAL\RRHH\'
ls_filename      = String(uo_1.of_get_fecha(),'YYYYMMDD')+'.txt'
ls_fecha_proceso = String(uo_1.of_get_fecha(),'YYYY/MM/DD')
ld_fecha			  = uo_1.of_get_fecha()
li_file_open     = FileOpen(ls_ruta + ls_filename,LineMode!, Read!, Shared!)

messagebox('asd', 'hola')

if li_file_open = -1 then
	FileClose(li_file_open)
	Return
end if


li_file_read = FileRead(li_file_open,ls_cadena_input)


Do While li_file_read <> -100

	ls_cod_tarjeta = Mid(ls_cadena_input,5,14 )
	ls_fecha			= Mid(ls_cadena_input,22,10)
	ls_hora			= Mid(ls_cadena_input,33,8 )

	ll_contador = ll_contador + 1
	
	
	//insertar registro si registro pertence al dia
	if ls_fecha = ls_fecha_proceso then
		ld_fecha_hora = Datetime(Date(Mid(ls_fecha,9,2)+'/'+Mid(ls_fecha,6,2)+'/'+Mid(ls_fecha,1,4))	, time(ls_hora))
		
		/*buscar codigo de trabajador*/
		SELECT cod_trabajador
		  INTO :ls_cod_trabajador
        FROM rrhh_asigna_trjt_reloj
       WHERE (cod_tarjeta = :ls_cod_tarjeta ) and 
		 		 (flag_estado = '1'				  ) ;


	   if sqlca.sqlcode = 100 then
			//grabar en log_diario con errores
		else
			//ACTUALIZA INFORMACION
			Update rrhh_reloj_transferencia
			   Set texto = :ls_cadena_input
		    Where (cod_trabajador = :ls_cod_trabajador ) and
			 		 (fecha			  = :ld_fecha_hora 	  ) ;
			
			if sqlca.sqlnrows = 0 then
				Insert Into rrhh_reloj_transferencia
				(cod_trabajador,fecha,texto)
				Values
				(:ls_cod_trabajador,:ld_fecha_hora,:ls_cadena_input);
			
				IF SQLCA.SQLCode = -1 THEN 
					ls_msj_err = SQLCA.SQLErrText
		      	MessageBox('Sql Error', ls_msj_err)
	    			lb_ret = FALSE
				END IF                                  
			end if
			
		end if
		
	END IF
	
	//leo archivo texto
	li_file_read = FileRead(li_file_open,ls_cadena_input)
	
Loop	


IF lb_ret then
	Commit ;
	Messagebox('Aviso','Proceso se Culmino Satisfactoriamente')
ELSE
	Rollback ;
END IF


end event

type gb_1 from groupbox within w_asi900_transferencia_reloj
integer x = 27
integer y = 20
integer width = 1445
integer height = 368
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fecha a Recuperar"
end type

