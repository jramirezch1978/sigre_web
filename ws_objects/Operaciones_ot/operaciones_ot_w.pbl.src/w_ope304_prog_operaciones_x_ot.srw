$PBExportHeader$w_ope304_prog_operaciones_x_ot.srw
forward
global type w_ope304_prog_operaciones_x_ot from w_abc
end type
type pb_2 from picturebutton within w_ope304_prog_operaciones_x_ot
end type
type cb_2 from commandbutton within w_ope304_prog_operaciones_x_ot
end type
type cb_1 from commandbutton within w_ope304_prog_operaciones_x_ot
end type
type sle_4 from singlelineedit within w_ope304_prog_operaciones_x_ot
end type
type sle_3 from singlelineedit within w_ope304_prog_operaciones_x_ot
end type
type rb_4 from radiobutton within w_ope304_prog_operaciones_x_ot
end type
type rb_3 from radiobutton within w_ope304_prog_operaciones_x_ot
end type
type sle_ejec from singlelineedit within w_ope304_prog_operaciones_x_ot
end type
type sle_cod_ejec from singlelineedit within w_ope304_prog_operaciones_x_ot
end type
type st_1 from statictext within w_ope304_prog_operaciones_x_ot
end type
type sle_2 from singlelineedit within w_ope304_prog_operaciones_x_ot
end type
type sle_1 from singlelineedit within w_ope304_prog_operaciones_x_ot
end type
type st_2 from statictext within w_ope304_prog_operaciones_x_ot
end type
type uo_1 from u_ingreso_rango_fechas within w_ope304_prog_operaciones_x_ot
end type
type rb_2 from radiobutton within w_ope304_prog_operaciones_x_ot
end type
type rb_1 from radiobutton within w_ope304_prog_operaciones_x_ot
end type
type dw_operaciones from u_dw_abc within w_ope304_prog_operaciones_x_ot
end type
type pb_1 from picturebutton within w_ope304_prog_operaciones_x_ot
end type
type dw_master from u_dw_abc within w_ope304_prog_operaciones_x_ot
end type
type tab_1 from tab within w_ope304_prog_operaciones_x_ot
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail_rh from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail_rh dw_detail_rh
end type
type tabpage_2 from userobject within tab_1
end type
type dw_detail_maq from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_detail_maq dw_detail_maq
end type
type tab_1 from tab within w_ope304_prog_operaciones_x_ot
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type gb_1 from groupbox within w_ope304_prog_operaciones_x_ot
end type
type gb_4 from groupbox within w_ope304_prog_operaciones_x_ot
end type
type gb_2 from groupbox within w_ope304_prog_operaciones_x_ot
end type
end forward

global type w_ope304_prog_operaciones_x_ot from w_abc
integer width = 3703
integer height = 2212
string title = "Programación de Orden de Trabajo (OPE304)"
string menuname = "m_master_lista_anular_prog"
event ue_anular ( )
pb_2 pb_2
cb_2 cb_2
cb_1 cb_1
sle_4 sle_4
sle_3 sle_3
rb_4 rb_4
rb_3 rb_3
sle_ejec sle_ejec
sle_cod_ejec sle_cod_ejec
st_1 st_1
sle_2 sle_2
sle_1 sle_1
st_2 st_2
uo_1 uo_1
rb_2 rb_2
rb_1 rb_1
dw_operaciones dw_operaciones
pb_1 pb_1
dw_master dw_master
tab_1 tab_1
gb_1 gb_1
gb_4 gb_4
gb_2 gb_2
end type
global w_ope304_prog_operaciones_x_ot w_ope304_prog_operaciones_x_ot

type variables
String is_accion
String is_nro_orden []
end variables

event ue_anular();Long ll_row_master

ll_row_master = dw_master.getrow()

IF is_accion = 'new' OR ll_row_master = 0 THEN RETURN

IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail_rh.ii_update = 1 OR &
   tab_1.tabpage_2.dw_detail_maq.ii_update = 1 THEN
	Messagebox('Aviso','Tiene Grabaciones Pendientes Verifique!')
	Return
END IF

dw_master.object.flag_estado [ll_row_master] = '0'
dw_master.ii_update = 1
end event

on w_ope304_prog_operaciones_x_ot.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista_anular_prog" then this.MenuID = create m_master_lista_anular_prog
this.pb_2=create pb_2
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_4=create sle_4
this.sle_3=create sle_3
this.rb_4=create rb_4
this.rb_3=create rb_3
this.sle_ejec=create sle_ejec
this.sle_cod_ejec=create sle_cod_ejec
this.st_1=create st_1
this.sle_2=create sle_2
this.sle_1=create sle_1
this.st_2=create st_2
this.uo_1=create uo_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_operaciones=create dw_operaciones
this.pb_1=create pb_1
this.dw_master=create dw_master
this.tab_1=create tab_1
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_4
this.Control[iCurrent+5]=this.sle_3
this.Control[iCurrent+6]=this.rb_4
this.Control[iCurrent+7]=this.rb_3
this.Control[iCurrent+8]=this.sle_ejec
this.Control[iCurrent+9]=this.sle_cod_ejec
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.sle_2
this.Control[iCurrent+12]=this.sle_1
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.uo_1
this.Control[iCurrent+15]=this.rb_2
this.Control[iCurrent+16]=this.rb_1
this.Control[iCurrent+17]=this.dw_operaciones
this.Control[iCurrent+18]=this.pb_1
this.Control[iCurrent+19]=this.dw_master
this.Control[iCurrent+20]=this.tab_1
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_4
this.Control[iCurrent+23]=this.gb_2
end on

on w_ope304_prog_operaciones_x_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_4)
destroy(this.sle_3)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.sle_ejec)
destroy(this.sle_cod_ejec)
destroy(this.st_1)
destroy(this.sle_2)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.uo_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_operaciones)
destroy(this.pb_1)
destroy(this.dw_master)
destroy(this.tab_1)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_detail_rh.SetTransObject(sqlca)
tab_1.tabpage_2.dw_detail_maq.SetTransObject(sqlca)
dw_operaciones.SetTransObject(sqlca)



idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_detail_rh.BorderStyle = StyleRaised!			// indicar dw_detail como no activado



of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
//ii_consulta = 1                      // 1 = la lista de consulta es gobernada por el sistema de acceso
//ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones
end event

event resize;
dw_operaciones.width  = newwidth  - dw_operaciones.x - 10


tab_1.width  = newwidth  - tab_1.x - 30
tab_1.height = newheight - tab_1.y - 30

tab_1.tabpage_1.dw_detail_rh.width   = newwidth  - tab_1.tabpage_1.dw_detail_rh.x - 90
tab_1.tabpage_2.dw_detail_maq.width  = newwidth  - tab_1.tabpage_2.dw_detail_maq.x - 90
tab_1.tabpage_1.dw_detail_rh.height  = newheight - tab_1.tabpage_1.dw_detail_rh.y - 1450
tab_1.tabpage_2.dw_detail_maq.height = newheight - tab_1.tabpage_2.dw_detail_maq.y - 1450
end event

event ue_insert;Long  ll_row




IF idw_1  = dw_master THEN //cabecera de programa 
	is_accion = 'new'
	TriggerEvent('ue_update_request')
	IF ib_update_check = FALSE THEN RETURN	
	dw_master.reset()
	tab_1.tabpage_1.dw_detail_rh.reset()
	tab_1.tabpage_2.dw_detail_maq.reset()
ELSE
	RETURN
	
END IF



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail_rh.ii_update = 1 OR tab_1.tabpage_2.dw_detail_maq.ii_update = 1) THEN
	li_msg_result = MessageBox('Actualizaciones Pendientes', 'Grabamos', Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent('ue_update')
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail_rh.ii_update = 0
		tab_1.tabpage_2.dw_detail_maq.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;String ls_nro_prog
Long   ll_row_master,ll_inicio
dwItemStatus ldis_status
Datetime ldt_f_inicio


//invocar objeto de numeracion de parte
nvo_numeradores_varios lnvo_numeradores_varios
lnvo_numeradores_varios    = CREATE nvo_numeradores_varios
//


ll_row_master = dw_master.Getrow()


if ll_row_master = 0 THEN RETURN


if f_row_Processing( dw_master, "form") <> true then	

	ib_update_check = False	
	return
else
	ib_update_check = True
end if


if f_row_Processing( tab_1.tabpage_1.dw_detail_rh, "tabular") <> true then	
	tab_1.SelectedTab = 1
	ib_update_check = False	
	return
else
	ib_update_check = True
end if

if f_row_Processing( tab_1.tabpage_2.dw_detail_maq, "tabular") <> true then	
	tab_1.SelectedTab = 2
	ib_update_check = False	
	return
else
	ib_update_check = True
end if

//RECUPERO NRO DE PARTE
ls_nro_prog = dw_master.Object.programa [ll_row_master]

IF is_accion = 'new' THEN
	IF lnvo_numeradores_varios.uf_num_manten_prog(gs_origen,ls_nro_prog) = FALSE THEN
		ib_update_check = False	
		RETURN
	ELSE
		dw_master.Object.programa [ll_row_master] = ls_nro_prog
	END IF
END IF

//messagebox('Numerador',ls_nro_prog)

FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail_rh.Rowcount()
	 ldis_status  = tab_1.tabpage_1.dw_detail_rh.GetItemStatus(ll_inicio,0,Primary!)
	 ldt_f_inicio = tab_1.tabpage_1.dw_detail_rh.Object.fecha_ini_estimada [ll_inicio]
	 
	 //asigno nro de programa anuevo registro
	 IF ldis_status = NewModified! THEN
		 tab_1.tabpage_1.dw_detail_rh.Object.programa [ll_inicio] = ls_nro_prog
	 END IF
	 
	 //valida fecha de inicio
	 IF Isnull(ldt_f_inicio) OR Trim(String(ldt_f_inicio)) = '00000000' THEN
		 Messagebox('Aviso','Debe Colocar Fecha de Inicio de Item de Programación de Maquina')	
		 tab_1.SelectedTab = 1
		 tab_1.tabpage_1.dw_detail_rh.Scrolltorow(ll_inicio)
		 tab_1.tabpage_1.dw_detail_rh.Setcolumn('fecha_ini_estimada')
		 ib_update_check = False
		 Return
	 END IF

NEXT

FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_detail_maq.Rowcount()
	 ldis_status = tab_1.tabpage_2.dw_detail_maq.GetItemStatus(ll_inicio,0,Primary!)
	 
	 //asigno nro de programa anuevo registro
	 IF ldis_status = NewModified! THEN
		 tab_1.tabpage_2.dw_detail_maq.Object.programa [ll_inicio] = ls_nro_prog
	 END IF
	 //valida fecha de inicio
	 ldt_f_inicio = tab_1.tabpage_2.dw_detail_maq.Object.fecha_ini_estimada [ll_inicio]
	 
	 IF Isnull(ldt_f_inicio) OR Trim(String(ldt_f_inicio)) = '00000000' THEN
		 Messagebox('Aviso','Debe Colocar Fecha de Inicio de Item de Programación de Maquina')	
		 tab_1.SelectedTab = 2
		 tab_1.tabpage_2.dw_detail_maq.Scrolltorow(ll_inicio)
		 tab_1.tabpage_2.dw_detail_maq.Setcolumn('fecha_ini_estimada')
		 ib_update_check = False
		 Return
	 END IF
NEXT

dw_master.of_set_flag_replicacion()
tab_1.tabpage_1.dw_detail_rh.of_set_flag_replicacion()
tab_1.tabpage_2.dw_detail_maq.of_set_flag_replicacion()


Destroy lnvo_numeradores_varios
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
tab_1.tabpage_1.dw_detail_rh.AcceptText()
tab_1.tabpage_2.dw_detail_maq.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK ;
	RETURN
END IF	

IF tab_1.tabpage_2.dw_detail_maq.ii_update = 1 THEN
	IF tab_1.tabpage_2.dw_detail_maq.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
      Rollback ;
		Messagebox("Error en Grabacion Detalle de Maquina","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_1.dw_detail_rh.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_detail_rh.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
      Rollback ;
		Messagebox("Error en Grabacion Detalle de Recursos Humanos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
      Rollback ;
		Messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail_rh.ii_update = 0
	tab_1.tabpage_2.dw_detail_maq.ii_update = 0
	is_accion = 'fileopen'
END IF
end event

event ue_retrieve_list;//
// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = "d_abc_lista_programa_trabajo_tbl"
sl_param.titulo  = "Programa de Orden de Trabajo"
sl_param.tipo    = "1S"
sl_param.string1 = gs_user
sl_param.field_ret_i[1] = 1


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.retrieve(sl_param.field_ret[1])
	tab_1.tabpage_1.dw_detail_rh.retrieve(sl_param.field_ret[1])
	tab_1.tabpage_2.dw_detail_maq.retrieve(sl_param.field_ret[1])
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail_rh.ii_update  = 0
	tab_1.tabpage_2.dw_detail_maq.ii_update = 0
	
	TriggerEvent ('ue_modify')
END IF

end event

event ue_modify;Long   ll_row_master
String ls_flag_estado

ll_row_master = dw_master.getrow()
IF ll_row_master  = 0 THEN RETURN

ls_flag_estado = dw_master.object.flag_estado [ll_row_master]

IF ls_flag_estado = '0' THEN // ANULADO
	dw_master.ii_protect = 0
	tab_1.tabpage_1.dw_detail_rh.ii_protect = 0
	tab_1.tabpage_2.dw_detail_maq.ii_protect = 0
	
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail_rh.of_protect()
	tab_1.tabpage_2.dw_detail_maq.of_protect()
	
ELSE
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail_rh.of_protect()
	tab_1.tabpage_2.dw_detail_maq.of_protect()
	
END IF
end event

event ue_delete;Long  ll_row

//override

IF idw_1 = dw_master  THEN RETURN

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_print;call super::ue_print;String  ls_programa
Str_cns_pop lstr_cns_pop

//Verificacion de Nro de Orden
ls_programa = dw_master.GetItemString(1, 'programa')

IF is_accion = 'new' THEN RETURN

lstr_cns_pop.arg[1] = ls_programa

// Abre ventana para imprimir
OpenSheetWithParm(w_ope304_prog_operaciones_rpt, lstr_cns_pop, this, 2, Layered!)

end event

type pb_2 from picturebutton within w_ope304_prog_operaciones_x_ot
integer x = 1394
integer y = 92
integer width = 247
integer height = 92
integer taborder = 60
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
string text = "Aprueba"
string picturename = "H:\Source\BMP\find_ot_SMALL.bmp"
end type

event clicked;String ls_ot_adm, ls_programa, ls_nro_aprob, ls_msj_err, ls_tipo, ls_codigo
Long ll_count, ll_reg
str_parametros lstr_rep


ls_ot_adm = dw_master.object.ot_adm[dw_master.GetRow()]

//Verificar si es aprobador
SELECT count(*)
  INTO :ll_count
  FROM ot_adm_aprob_req o, ot_adm_usuario ou
 WHERE (o.ot_adm=ou.ot_adm and
        o.cod_usr=ou.cod_usr) and
       (o.ot_adm = :ls_ot_adm) and
       (o.cod_usr = :gs_user) ;

IF ll_count=0 THEN
	MessageBox('Aviso','Usuario no autorizado a aprobar programa')
	Return
END IF 

ls_programa = TRIM( dw_master.object.programa[dw_master.GetRow()] )

IF ISNULL(ls_programa) OR ls_programa='' THEN
	MessageBox('Aviso','Programa no existe o falta grabarlo')
	Return
END IF 

ls_nro_aprob = TRIM( dw_master.object.nro_aprob[dw_master.GetRow()] )

IF NOT ISNULL(ls_nro_aprob) OR ls_nro_aprob<>'' THEN
	MessageBox('Aviso','Programa ya esta aprobado')
	Return
END IF 

// Grabar informacion en tt_ope_aprobacion_ot (solo los no aprobados)
IF tab_1.tabpage_1.dw_detail_rh.RowCount() = 0 THEN
	MessageBox('Aviso','No existen operaciones pendientes')
	Return
END IF

SELECT count(*) 
  INTO :ll_count 
  FROM programa_trabajo_det_rh p, operaciones o 
 WHERE p.oper_sec=o.oper_sec and 
       p.programa = :ls_programa and
       o.flag_estado='3' and 
       o.nro_aprob is null ;


IF ll_count=0 THEN
	MessageBox('Aviso','No existen operaciones pendientes de aprobar')
	Return
END IF 

// aprobacion de programa 
DECLARE pb_usp_ope_aprueba_programa PROCEDURE FOR 
		usp_ope_aprueba_programa(:ls_programa, 
										 :gs_origen, 
								  	    :gs_user, 
								  	    '2', 
								       :ls_ot_adm );
EXECUTE pb_usp_ope_aprueba_programa ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error pb_usp_ope_aprueba_programa',ls_msj_err)
	Return
end if

FETCH pb_usp_ope_aprueba_programa INTO :ls_nro_aprob ;

CLOSE pb_usp_ope_aprueba_programa ;

dw_master.object.nro_aprob[dw_master.GetRow()] = ls_nro_aprob 

//cb_procesar.enabled= true
Messagebox('Aviso', 'Aprobación ha concluido satisfactoriamente')

end event

type cb_2 from commandbutton within w_ope304_prog_operaciones_x_ot
integer x = 731
integer y = 448
integer width = 110
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar


lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = "SELECT EJECUTOR.COD_EJECUTOR AS CODIGO, "&   
										 +"EJECUTOR.DESCRIPCION AS DESCRIPCION " &
										 +"FROM EJECUTOR " &

												 
												  	
				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_cod_ejec.text = lstr_seleccionar.param1[1]
	sle_ejec.text 		= lstr_seleccionar.param2[1]
END IF

end event

type cb_1 from commandbutton within w_ope304_prog_operaciones_x_ot
integer x = 731
integer y = 376
integer width = 110
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar


lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = "SELECT CENTROS_COSTO.CENCOS AS CODIGO, "&   
										 +"CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION " &
										 +"FROM CENTROS_COSTO " &
										 +"WHERE CENTROS_COSTO.FLAG_ESTADO = '" +'1'+"'"
												 
												  	
				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_1.text = lstr_seleccionar.param1[1]
	sle_2.text = lstr_seleccionar.param2[1]
END IF

end event

type sle_4 from singlelineedit within w_ope304_prog_operaciones_x_ot
integer x = 2194
integer y = 1012
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 16777215
string text = "No Programada"
borderstyle borderstyle = stylelowered!
end type

type sle_3 from singlelineedit within w_ope304_prog_operaciones_x_ot
integer x = 1701
integer y = 1012
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 255
string text = "Programada"
borderstyle borderstyle = stylelowered!
end type

type rb_4 from radiobutton within w_ope304_prog_operaciones_x_ot
integer x = 576
integer y = 280
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ejecutor"
end type

event clicked;sle_1.enabled=false
sle_cod_ejec.enabled=true

end event

type rb_3 from radiobutton within w_ope304_prog_operaciones_x_ot
integer x = 64
integer y = 280
integer width = 425
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo"
boolean checked = true
end type

event clicked;sle_1.enabled=true
sle_cod_ejec.enabled=false

end event

type sle_ejec from singlelineedit within w_ope304_prog_operaciones_x_ot
integer x = 850
integer y = 448
integer width = 763
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type sle_cod_ejec from singlelineedit within w_ope304_prog_operaciones_x_ot
event ue_tecla pbm_keydown
integer x = 457
integer y = 448
integer width = 265
integer height = 60
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;
IF key = keyEnter! THEN
	String ls_ejecutor,ls_desc_ejec
	long   ll_count
	
	ls_ejecutor = sle_cod_ejec.text
	
	select count(*) into :ll_count from ejecutor where cod_ejecutor = :ls_ejecutor ;
	
	IF ll_count > 0 THEN
		select descripcion into :ls_desc_ejec from ejecutor where cod_ejecutor = :ls_ejecutor	;
		
		sle_ejec.text = ls_desc_ejec
		uo_1.setfocus()
	ELSE
		Messagebox('Aviso','Ejecutor No Existe , Verifique!')
		SetNull(ls_desc_ejec)
		sle_cod_ejec.text = ls_desc_ejec
		sle_ejec.text 		= ls_desc_ejec
		Return
	END IF

	
	
end if
end event

type st_1 from statictext within w_ope304_prog_operaciones_x_ot
integer x = 101
integer y = 448
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ejecutor :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_2 from singlelineedit within w_ope304_prog_operaciones_x_ot
integer x = 850
integer y = 376
integer width = 763
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type sle_1 from singlelineedit within w_ope304_prog_operaciones_x_ot
event ue_tecla_enter pbm_keydown
integer x = 457
integer y = 376
integer width = 265
integer height = 60
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

forward prototypes
global function long ue_tecla_enter (keycode key, unsignedlong keyflags)
end prototypes

event ue_tecla_enter;
IF key = keyEnter! THEN
	String ls_cencos,ls_desc_cencos
	long   ll_count
	
	ls_cencos = sle_1.text
	
	select count(*) into :ll_count from centros_costo where cencos = :ls_cencos ;
	
	IF ll_count > 0 THEN
		select desc_cencos into :ls_desc_cencos from centros_costo where cencos = :ls_cencos	;
		sle_2.text = ls_desc_cencos 
		uo_1.setfocus()
	ELSE
		Messagebox('Aviso','Centro de Costo No Existe , Verifique!')
		SetNull(ls_desc_cencos)
		sle_1.text = ls_desc_cencos
		sle_2.text = ls_desc_cencos
		Return
	END IF
	
	
end if
end event

global function long ue_tecla_enter (keycode key, unsignedlong keyflags);
IF key = keyEnter! THEN
	String ls_cencos,ls_desc_cencos
	Long   ll_count
	
	ls_cencos = sle_1.text
	
	select count(*) into :ll_count from centros_costo where cencos = :ls_cencos ;
	
	IF ll_count > 0 THEN
		select desc_cencos into :ls_desc_cencos from centros_costo where cencos = :ls_cencos ;	
		sle_2.text = ls_desc_cencos 
	ELSE
		SetNull(ls_desc_cencos)
		sle_2.text = ls_desc_cencos
	END IF
	
	
end if
return 1
end function

type st_2 from statictext within w_ope304_prog_operaciones_x_ot
integer x = 50
integer y = 376
integer width = 393
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_ope304_prog_operaciones_x_ot
integer x = 59
integer y = 600
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type rb_2 from radiobutton within w_ope304_prog_operaciones_x_ot
integer x = 512
integer y = 128
integer width = 370
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mecanizada"
end type

event clicked;tab_1.Selectedtab = 2
end event

type rb_1 from radiobutton within w_ope304_prog_operaciones_x_ot
integer x = 59
integer y = 128
integer width = 434
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mano de Obra"
boolean checked = true
end type

event clicked;tab_1.Selectedtab = 1
end event

type dw_operaciones from u_dw_abc within w_ope304_prog_operaciones_x_ot
integer x = 1705
integer y = 32
integer width = 1911
integer height = 932
integer taborder = 0
string dragicon = "H:\Source\ICO\unlink.ICO"
string dataobject = "d_operaciones_x_ot_programacion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw


idw_mst  = dw_master

end event

event doubleclicked;call super::doubleclicked;Drag(Begin!)
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

type pb_1 from picturebutton within w_ope304_prog_operaciones_x_ot
integer x = 974
integer y = 92
integer width = 247
integer height = 92
integer taborder = 40
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
string text = "Buscar"
string picturename = "H:\Source\BMP\find_ot_SMALL.bmp"
end type

event clicked;String ls_tip_labor,ls_cencos_rsp,ls_fecha_inicio,ls_fecha_final,ls_ejec


ls_cencos_rsp = sle_1.text	
ls_ejec		  = sle_cod_ejec.text


//verificación de fechas
ls_fecha_inicio = String(uo_1.of_get_fecha1(),'yyyymmdd')
ls_fecha_final  = String(uo_1.of_get_fecha2(),'yyyymmdd')


IF Isnull(ls_fecha_inicio) OR Trim(ls_fecha_inicio) = '00000000' THEN
	Messagebox('Aviso','Debe Ingresar Alguna Fecha Inicial')	
	RETURN
END IF	

IF Isnull(ls_fecha_final)  OR Trim(ls_fecha_final)  = '00000000' THEN
	Messagebox('Aviso','Debe Ingresar Alguna Fecha Final')	
	RETURN
END IF



IF rb_1.checked THEN
	ls_tip_labor = 'O' //MANUAL
ELSEIF rb_2.checked THEN
	ls_tip_labor = 'M' //MECANIZADA
END IF


IF rb_3.checked THEN //CENTRO DE COSTO
	IF Isnull(ls_cencos_rsp) OR Trim(ls_cencos_rsp) = '' THEN
		Messagebox('Aviso','Debe Ingresar Algun Centro de Costo ,Verifique!')
		sle_1.Setfocus()
		Return	
	END IF
	
	dw_operaciones.dataobject = 'd_operaciones_x_ot_programacion_tbl'
	dw_operaciones.SettransObject(sqlca)
	dw_operaciones.Retrieve(ls_tip_labor,ls_cencos_rsp,ls_fecha_inicio,ls_fecha_final)	
	
ELSEIF rb_4.checked THEN //EJECUTOR
	IF Isnull(ls_ejec) OR Trim(ls_ejec) = '' THEN
		Messagebox('Aviso','Debe Ingresar Algun Ejecutor ,Verifique!')
		sle_cod_ejec.Setfocus()
		Return	
	END IF
	
	dw_operaciones.dataobject = 'd_operaciones_x_ot_programacion_ejec_tbl'
	dw_operaciones.SettransObject(sqlca)
	dw_operaciones.Retrieve(ls_tip_labor,ls_ejec,ls_fecha_inicio,ls_fecha_final)
	
	
END IF




end event

type dw_master from u_dw_abc within w_ope304_prog_operaciones_x_ot
integer x = 14
integer y = 732
integer width = 1641
integer height = 432
integer taborder = 50
string dataobject = "d_abc_programa_trabajo_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail_rh
end event

event ue_insert_pre;call super::ue_insert_pre;This.object.cod_usr    [al_row] = gs_user
This.object.fecha      [al_row] = f_fecha_actual()
This.object.flag_estado[al_row] = '1'

end event

event itemchanged;call super::itemchanged;String ls_descripcion

Accepttext()

CHOOSE CASE dwo.name
	    CASE 'ot_adm'
				SELECT descripcion
				  INTO :ls_descripcion
				  FROM vw_cam_usr_adm
				 WHERE (cod_usr = :gs_user) ;
				
				IF Isnull(ls_descripcion) OR Trim(ls_descripcion) = '' THEN
					SetNull(ls_descripcion)
					Messagebox('Aviso','Administracion No Existe , Verifique')
					This.object.ot_adm      [row] = ls_descripcion
					This.object.descripcion [row] = ls_descripcion
					Return 1
				ELSE
					This.object.descripcion [row] = ls_descripcion
				END IF
END CHOOSE

end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String ls_adm,ls_name,ls_prot
str_seleccionar lstr_seleccionar


ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

This.Accepttext()


CHOOSE CASE dwo.name
		 CASE 'ot_adm'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_CAM_USR_ADM.OT_ADM AS CODIGO, '&   
												 +'VW_CAM_USR_ADM.DESCRIPCION  AS DESCRIPCION  '&   
												 +'FROM  VW_CAM_USR_ADM '&
												 +'WHERE VW_CAM_USR_ADM.COD_USR = '+"'"+gs_user+"'"    	

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'ot_adm',lstr_seleccionar.param1[1])
					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
END CHOOSE
end event

event itemerror;call super::itemerror;RETURN 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from tab within w_ope304_prog_operaciones_x_ot
integer x = 9
integer y = 1208
integer width = 3534
integer height = 844
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3497
integer height = 716
long backcolor = 79741120
string text = " Recursos Humanos"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "Custom076!"
long picturemaskcolor = 536870912
dw_detail_rh dw_detail_rh
end type

on tabpage_1.create
this.dw_detail_rh=create dw_detail_rh
this.Control[]={this.dw_detail_rh}
end on

on tabpage_1.destroy
destroy(this.dw_detail_rh)
end on

type dw_detail_rh from u_dw_abc within tabpage_1
integer x = 14
integer y = 4
integer width = 3479
integer height = 660
integer taborder = 20
string dataobject = "d_abc_programa_rh_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1 // columnas de lectura de este dw
ii_ck[2] = 2 
ii_rk[1] = 1 // columnas que recibimos del master


idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail_rh
end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_codigo,ls_nombre

Accepttext()
CHOOSE CASE dwo.name
		 CASE 'cod_trabajador'
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM maestro
				 WHERE (cod_trabajador = :data) ;
			   
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.object.cod_trabajador[row] = ls_codigo
					This.object.nombre        [row] = ls_codigo
					RETURN 1
				ELSE
					SELECT Trim(m.apel_paterno)||' '||Trim(m.apel_materno)||' '||Trim(m.nombre1)
					  INTO :ls_nombre	
					  FROM maestro m
					 WHERE (cod_trabajador = :data) ;
					 
					 This.object.nombre [row] = ls_nombre
					 
				END IF
		 CASE 'proveedor'
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM codigo_relacion
				 WHERE (cod_relacion = :data) ;
				 
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.object.cod_trabajador[row] = ls_codigo
					RETURN 1
				END IF
				
END CHOOSE

end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String ls_adm,ls_name,ls_prot
str_seleccionar lstr_seleccionar
Datawindow ldw

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

This.Accepttext()


CHOOSE CASE dwo.name
		 CASE	'fecha_ini_estimada'
				ldw = this
				f_call_calendar(ldw,dwo.name,dwo.coltype,row)
		 CASE 'proveedor'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = "SELECT CODIGO_RELACION.COD_RELACION AS PROVEEDOR, "&   
												 +"CODIGO_RELACION.NOMBRE as DESCRIPCION " &
												 +"FROM CODIGO_RELACION " 
												  	
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'proveedor',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
				
		 CASE 'cod_trabajador'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = "SELECT MAESTRO.COD_TRABAJADOR AS CODIGO, "&   
												 +"Trim(MAESTRO.APEL_PATERNO)||' '||Trim(MAESTRO.APEL_MATERNO)||' '||Trim(MAESTRO.NOMBRE1) as NOMBRE_APELLIDOS " &
												 +"FROM  MAESTRO " 
												  	
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_trabajador',lstr_seleccionar.param1[1])
					Setitem(row,'nombre',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
END CHOOSE
end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long    ll_row
Integer li_item

ll_row = This.RowCount()

IF ll_row = 1 THEN 
	li_item = 0
ELSE
	li_item = GetItemNumber(ll_row - 1,'item')
END IF

This.object.item 					 [al_row] = li_item + 1
This.object.flag_resp_oper_sec [al_row] = '0' //no responsable del oper_sec
This.object.prioridad          [al_row] = 'N' //NORMAL
end event

event dragdrop;Dragobject  ldo_control
Long		   ll_inicio,ll_row,ll_found,ll_row_master
String      ls_oper_sec,ls_flag_estado
Decimal {2} ldc_avance_proy,ldc_avance_real,ldc_cant_proy,ldc_cant_real,ldc_avance_prog,ldc_cant_prog
DataWindow ldw_drag


		
ll_row_master = dw_master.Getrow()		
IF ll_row_master = 0 THEN RETURN		
ls_flag_estado = dw_master.object.flag_estado [ll_row_master]

dw_master.il_row = ll_row_master
IF ls_flag_estado = '0' THEN RETURN

ldo_control = DraggedObject()

IF ldo_control.typeof() = Datawindow! THEN  //valido que el drag provenga de un dw
	
	ldw_drag = ldo_control
	IF ldw_drag.dataobject = 'd_operaciones_x_ot_programacion_tbl' OR ldw_drag.dataobject = 'd_operaciones_x_ot_programacion_ejec_tbl' THEN //y sea de operaciones 
		

	   //filtro operaciones marcadas
		ldw_drag.Setfilter("flag_mov = "+"'"+"1"+"'")
		ldw_drag.Filter()
		
		IF ldw_drag.Rowcount() > 0 THEN //si existe registros marcados
			FOR ll_inicio = 1 TO ldw_drag.Rowcount() 
				 ls_oper_sec = ldw_drag.object.oper_sec   [ll_inicio]
				 //verificacion de oper_sec
				 ll_found = This.Find("oper_sec = "+"'"+ls_oper_sec+"'",1,This.Rowcount())
				 
				 IF ll_found = 0 THEN //oper_sec no existe
					 ll_row = This.Event ue_insert()
					 
				    ldc_avance_proy = ldw_drag.object.avance_esperado [ll_inicio]
					 ldc_avance_real = ldw_drag.object.avance_esperado [ll_inicio]
					 
					 ldc_cant_proy	  = ldw_drag.object.cant_proyect    [ll_inicio]
					 ldc_cant_real   = ldw_drag.object.cant_real	      [ll_inicio]
					 
					 //cantidad
					 IF Isnull(ldc_cant_proy) THEN ldc_cant_proy = 0.00
					 IF Isnull(ldc_cant_real) THEN ldc_cant_real = 0.00
					 //avance
					 IF Isnull(ldc_avance_proy) THEN ldc_avance_proy = 0.00
					 IF Isnull(ldc_avance_real) THEN ldc_avance_real = 0.00
					 
 					 ldc_avance_prog  = ldc_avance_proy - ldc_avance_real   //
					 ldc_cant_prog    = ldc_cant_proy   - ldc_cant_real    //
					 
			
					 This.object.oper_sec           [ll_row] = ldw_drag.object.oper_sec     [ll_inicio]
					 This.object.proveedor          [ll_row] = ldw_drag.object.proveedor    [ll_inicio]
					 This.object.fecha_ini_estimada [ll_row] = ldw_drag.object.fec_inicio   [ll_inicio]
					 This.object.cod_labor			  [ll_row] = ldw_drag.object.cod_labor    [ll_inicio]					 
					 This.object.cod_maquina		  [ll_row] = ldw_drag.object.cod_maquina  [ll_inicio]
					 This.object.nro_orden			  [ll_row] = ldw_drag.object.nro_orden    [ll_inicio]
					 This.object.avance_etimado     [ll_row] = ldc_avance_prog
					 This.object.cantidad_estimada  [ll_row] = ldc_cant_prog
					 This.object.nro_personas_adic  [ll_row] = ldw_drag.object.nro_personas [ll_inicio]	
					 
					 
				 ELSE
					 Messagebox('Aviso','Secuencia de Operación Nº '+ls_oper_sec+' ya Existe en la Programación ')
				 END IF	
			NEXT


		END IF
	END IF
END IF

ldw_drag.Setfilter("")
ldw_drag.Filter()
ldw_drag.SetSort("fec_inicio asc")
ldw_drag.Sort()


end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3497
integer height = 716
long backcolor = 79741120
string text = " Maquinaria"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "CreateLibrary!"
long picturemaskcolor = 536870912
dw_detail_maq dw_detail_maq
end type

on tabpage_2.create
this.dw_detail_maq=create dw_detail_maq
this.Control[]={this.dw_detail_maq}
end on

on tabpage_2.destroy
destroy(this.dw_detail_maq)
end on

type dw_detail_maq from u_dw_abc within tabpage_2
integer x = 14
integer y = 4
integer width = 3479
integer height = 664
integer taborder = 20
string dataobject = "d_programa_maquina_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1		// columnas de lectura de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	   // columnas que recibimos del master
ii_dk[1] = 1 	   // columnas que se pasan al detalle

idw_mst = dw_master
idw_det = tab_1.tabpage_2.dw_detail_maq
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_codigo

Accepttext()
CHOOSE CASE dwo.name
		 CASE 'proveedor'
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM codigo_relacion
				 WHERE (cod_relacion = :data) ;
				 
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.object.cod_trabajador[row] = ls_codigo
					RETURN 1
				END IF
		 CASE 'cod_maquina'
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM maquina
				 WHERE (cod_maquina = :data) ;
			   
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.object.cod_maquina[row] = ls_codigo
					RETURN 1
				END IF
		 CASE 'cod_operador'
		
				SELECT Count(*)
				  INTO :ll_count
				  FROM maestro
				 WHERE (cod_trabajador = :data) ;
			   
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.object.cod_operador[row] = ls_codigo
					RETURN 1
				END IF
				
END CHOOSE



end event

event ue_insert_pre;call super::ue_insert_pre;Long    ll_row
Integer li_item

ll_row = This.RowCount()

IF ll_row = 1 THEN 
	li_item = 0
ELSE
	li_item = Getitemnumber(ll_row - 1,'item')
END IF

This.object.item [al_row] = li_item + 1
end event

event doubleclicked;IF row = 0 THEN RETURN

String ls_adm,ls_name,ls_prot
str_seleccionar lstr_seleccionar
Datawindow ldw

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

This.Accepttext()


CHOOSE CASE dwo.name
		 CASE	'fecha_ini_estimada'
				ldw = this
				f_call_calendar(ldw,dwo.name,dwo.coltype,row)
		 CASE 'proveedor'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = "SELECT CODIGO_RELACION.COD_RELACION AS PROVEEDOR, "&   
												 +"CODIGO_RELACION.NOMBRE as DESCRIPCION " &
												 +"FROM CODIGO_RELACION " 
												  	
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'proveedor',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF				
		 CASE 'cod_maquina'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = "SELECT MAQUINA.COD_MAQUINA AS CODIGO, "&   
												 +"MAQUINA.DESC_MAQ as DESCRIPCION " &
												 +"FROM MAQUINA " 
												  	
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
				
		 CASE 'cod_operador'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = "SELECT MAESTRO.COD_TRABAJADOR AS CODIGO, "&   
												 +"Trim(MAESTRO.APEL_PATERNO)||' '||Trim(MAESTRO.APEL_MATERNO)||' '||Trim(MAESTRO.NOMBRE1) as NOMBRE_APELLIDOS " &
												 +"FROM  MAESTRO " 
												  	
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_operador',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
END CHOOSE
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event dragdrop;call super::dragdrop;Dragobject  ldo_control
Long		   ll_inicio,ll_row,ll_found,ll_row_master
String      ls_oper_sec,ls_flag_estado
Decimal {2} ldc_avance_proy,ldc_cant_proy,ldc_avance_real,ldc_avance_prog,ldc_cant_real,ldc_cant_prog
DataWindow ldw_drag

		
ll_row_master = dw_master.Getrow()		
IF ll_row_master = 0 THEN RETURN		
ls_flag_estado = dw_master.object.flag_estado [ll_row_master]

IF ls_flag_estado = '0' THEN RETURN		

ldo_control = DraggedObject()

IF ldo_control.typeof() = Datawindow! THEN  //valido que el drag provenga de un dw
	
	ldw_drag = ldo_control
	IF ldw_drag.dataobject = 'd_operaciones_x_ot_programacion_tbl' OR ldw_drag.dataobject = 'd_operaciones_x_ot_programacion_ejec_tbl' THEN //y sea de operaciones 	
	   //filtro operaciones marcadas
		ldw_drag.Setfilter("flag_mov = "+"'"+"1"+"'")
		ldw_drag.Filter()
		
		IF ldw_drag.Rowcount() > 0 THEN //si existe registros marcados
			FOR ll_inicio = 1 TO ldw_drag.Rowcount() 
				 ls_oper_sec = ldw_drag.object.oper_sec   [ll_inicio]
				 //verificacion de oper_sec
				 ll_found = This.Find("oper_sec = "+"'"+ls_oper_sec+"'",1,This.Rowcount())
				 
				 IF ll_found = 0 THEN //oper_sec no existe
					 ll_row = This.Event ue_insert()
					 
					 ldc_avance_proy = ldw_drag.object.avance_esperado [ll_inicio]
					 ldc_avance_real = ldw_drag.object.avance_actual [ll_inicio]
					 ldc_cant_proy	  = ldw_drag.object.cant_proyect    [ll_inicio]
					 ldc_cant_real   = ldw_drag.object.cant_real	      [ll_inicio]
					 
					 //cantidad
					 IF Isnull(ldc_cant_proy) THEN ldc_cant_proy = 0.00
					 IF Isnull(ldc_cant_real) THEN ldc_cant_real = 0.00
					 //avance
					 IF Isnull(ldc_avance_proy) THEN ldc_avance_proy = 0.00
					 IF Isnull(ldc_avance_real) THEN ldc_avance_real = 0.00
					 
 					 ldc_avance_prog  = abs(ldc_avance_proy - ldc_avance_real) // Has avanzadas
					 ldc_cant_prog    = abs(ldc_cant_proy   - ldc_cant_real)   // Cantidad avanzada
			
					 This.object.oper_sec           [ll_row] = ldw_drag.object.oper_sec        [ll_inicio]
					 This.object.proveedor          [ll_row] = ldw_drag.object.proveedor       [ll_inicio]
					 This.object.fecha_ini_estimada [ll_row] = ldw_drag.object.fec_inicio      [ll_inicio]
					 This.object.avance_etimado     [ll_row] = ldc_avance_prog
					 This.object.cantidad_estimada  [ll_row] = ldc_cant_prog
					 
					 
				 ELSE
					 Messagebox('Aviso','Secuencia de Operación Nº '+ls_oper_sec+' ya Existe en la Programación ')
				 END IF	
			NEXT


		END IF
	END IF
END IF

ldw_drag.Setfilter("")
ldw_drag.Filter()
ldw_drag.SetSort("fec_inicio asc")
ldw_drag.Sort()
end event

type gb_1 from groupbox within w_ope304_prog_operaciones_x_ot
integer x = 46
integer y = 68
integer width = 869
integer height = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Labor"
end type

type gb_4 from groupbox within w_ope304_prog_operaciones_x_ot
integer x = 41
integer y = 204
integer width = 1605
integer height = 372
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

type gb_2 from groupbox within w_ope304_prog_operaciones_x_ot
integer y = 8
integer width = 1691
integer height = 708
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos de Busqueda de Operaciones"
end type

