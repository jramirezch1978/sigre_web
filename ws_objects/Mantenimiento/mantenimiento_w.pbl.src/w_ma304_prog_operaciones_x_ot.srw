$PBExportHeader$w_ma304_prog_operaciones_x_ot.srw
forward
global type w_ma304_prog_operaciones_x_ot from w_abc
end type
type cb_2 from commandbutton within w_ma304_prog_operaciones_x_ot
end type
type st_1 from statictext within w_ma304_prog_operaciones_x_ot
end type
type sle_programa from singlelineedit within w_ma304_prog_operaciones_x_ot
end type
type cb_1 from commandbutton within w_ma304_prog_operaciones_x_ot
end type
type dw_detail from u_dw_abc within w_ma304_prog_operaciones_x_ot
end type
type dw_master from u_dw_abc within w_ma304_prog_operaciones_x_ot
end type
type gb_1 from groupbox within w_ma304_prog_operaciones_x_ot
end type
end forward

global type w_ma304_prog_operaciones_x_ot from w_abc
integer width = 3131
integer height = 1868
string title = "Programacion de Operaciones (MA304)"
string menuname = "m_abc_master_list"
cb_2 cb_2
st_1 st_1
sle_programa sle_programa
cb_1 cb_1
dw_detail dw_detail
dw_master dw_master
gb_1 gb_1
end type
global w_ma304_prog_operaciones_x_ot w_ma304_prog_operaciones_x_ot

type variables
String is_accion
end variables

on w_ma304_prog_operaciones_x_ot.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_list" then this.MenuID = create m_abc_master_list
this.cb_2=create cb_2
this.st_1=create st_1
this.sle_programa=create sle_programa
this.cb_1=create cb_1
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_programa
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.dw_detail
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.gb_1
end on

on w_ma304_prog_operaciones_x_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.sle_programa)
destroy(this.cb_1)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;String ls_nro_prog

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)


idw_1 = dw_master              				   // asignar dw corriente
dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado


	
	
SELECT pr.programa
  INTO :ls_nro_prog
  FROM programa_trabajo_rh pr
 WHERE rowid IN (SELECT max(rowid) FROM programa_trabajo_rh);	
 
 
IF Not(Isnull(ls_nro_prog) OR Trim(ls_nro_prog) = '') THEN
	dw_master.Retrieve(ls_nro_prog)
	dw_detail.Retrieve(ls_nro_prog)
ELSE
	TriggerEvent('ue_insert')
END IF
end event

event ue_insert();call super::ue_insert;Long  ll_row

IF idw_1 = dw_detail  THEN
	RETURN
END IF

TriggerEvent ('ue_update_request')
dw_master.Reset()
dw_detail.Reset()

ll_row = idw_1.Event ue_insert()


IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

is_accion = 'new'
end event

event ue_update();Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN



IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF



IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	IF is_accion = 'new' THEN is_accion = 'fileopen'
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_update_pre();call super::ue_update_pre;String ls_nro_programa
Long   ll_inicio


IF is_accion = 'new' THEN
	SELECT Max(TO_NUMBER(programa))
	  INTO :ls_nro_programa
	  FROM programa_trabajo_rh ;

	IF Isnull(ls_nro_programa) OR Trim(ls_nro_programa) = '' THEN ls_nro_programa = '0'
	
	ls_nro_programa = Trim(String(Double(ls_nro_programa) + 1))
	
	dw_master.object.programa [1] = ls_nro_programa
ELSE
	ls_nro_programa = dw_master.object.programa [1]
END IF



FOR ll_inicio = 1 TO dw_detail.Rowcount()
	 dw_detail.object.programa [ll_inicio] = ls_nro_programa
NEXT

end event

event ue_retrieve_list();call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
sg_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_programa_rh_tbl'
sl_param.titulo = 'Programaciones '
sl_param.field_ret_i[1] = 1


OpenWithParm( w_search, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve(sl_param.field_ret[1])
	dw_detail.Retrieve(sl_param.field_ret[1])
	TriggerEvent ('ue_modify')
END IF
end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event resize;dw_detail.width  = newwidth  - dw_detail.x
dw_detail.height = newheight - dw_detail.y
end event

type cb_2 from commandbutton within w_ma304_prog_operaciones_x_ot
integer x = 2642
integer y = 84
integer width = 329
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubica"
end type

event clicked;String ls_programa
Long ll_count

ls_programa = TRIM(sle_programa.text)

IF isnull(ls_programa) THEN
	messagebox('Aviso','Digite programa de operaciones a buscar')
ELSE
	
	SELECT count(*) INTO :ll_count FROM PROGRAMA_TRABAJO_RH 
	WHERE PROGRAMA = :ls_programa ;
	
	IF ll_count > 0 THEN
		dw_master.Retrieve(ls_programa)
		dw_detail.Retrieve(ls_programa)
	ELSE
		MessageBox('Aviso', 'Programa de operaciones no existe')
	END IF
END IF


end event

type st_1 from statictext within w_ma304_prog_operaciones_x_ot
integer x = 1819
integer y = 104
integer width = 334
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Programa:"
boolean focusrectangle = false
end type

type sle_programa from singlelineedit within w_ma304_prog_operaciones_x_ot
integer x = 2194
integer y = 84
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
borderstyle borderstyle = styleshadowbox!
end type

type cb_1 from commandbutton within w_ma304_prog_operaciones_x_ot
integer x = 2107
integer y = 284
integer width = 590
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Recuperar Operaciones"
end type

event clicked;Long ll_inicio ,ll_row ,ll_row_master
str_seleccionar lstr_seleccionar 


ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN
	Messagebox('Aviso','Debe Ingresar Información en la Cabecera')	
	Return
END IF

Open(w_abc_help_oper_x_ot)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	FOR ll_inicio = 1 TO UpperBound(lstr_seleccionar.param6)
		 dw_detail.ii_update = 1
		 ll_row = dw_detail.InsertRow(0)	
		 dw_detail.object.oper_sec        [ll_row] = lstr_seleccionar.paramdc1 [ll_inicio]
		 dw_detail.object.fecha_ini_estim [ll_row] = lstr_seleccionar.paramdt2 [ll_inicio]
		 dw_detail.object.nro_pers_estim  [ll_row] = lstr_seleccionar.paramdc3 [ll_inicio]
		 dw_detail.object.cantidad_estim  [ll_row] = lstr_seleccionar.paramdc4 [ll_inicio]
		 dw_detail.object.cod_labor       [ll_row] = lstr_seleccionar.param5   [ll_inicio]
		 dw_detail.object.cod_maquina     [ll_row] = lstr_seleccionar.param6   [ll_inicio]

		 
	NEXT
END IF

end event

type dw_detail from u_dw_abc within w_ma304_prog_operaciones_x_ot
integer x = 32
integer y = 424
integer width = 3040
integer height = 1244
integer taborder = 20
string dataobject = "d_abc_programa_trabajo_rh_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = dw_master
idw_det  = dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_codigo 

Accepttext()

SetNull(ls_codigo)

CHOOSE CASE dwo.name
		 CASE 'proveedor'
				SELECT Count(*)
				  INTO :ll_count
				  FROM proveedor
				 WHERE (proveedor = :data ) ;
				 
				 IF ll_count = 0 THEN
					 This.Object.proveedor [row] = ls_codigo
					 Messagebox('Aviso','Debe Ingresar un Proveedor Valido , Verifique!')
					 Return 1
				 END IF
				 
		 CASE 'cod_maquina'	
				SELECT Count(*)
				  INTO :ll_count
				  FROM maquina
				 WHERE (cod_maquina = :data ) ;
				 
 				 IF ll_count = 0 THEN
					 This.Object.cod_maquina [row] = ls_codigo
					 Messagebox('Aviso','Debe Ingresar una Maquina Valida , Verifique!')
					 Return 1
				 END IF

		 CASE 'cod_implemento'	
				SELECT Count(*)
				  INTO :ll_count
				  FROM maquina
				 WHERE (cod_maquina = :data ) ;
				 
 				 IF ll_count = 0 THEN
					 This.Object.cod_implemento [row] = ls_codigo
					 Messagebox('Aviso','Debe Ingresar un Implemento Valido , Verifique!')
					 Return 1
				 END IF

		
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'proveedor'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO,'&
						      				+'PROVEEDOR.NOM_PROVEEDOR AS DESCRIPCION_PROVEDOR '&     	
									 		   +'FROM PROVEEDOR '
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'proveedor',lstr_seleccionar.param1[1])
				END IF
				
		 CASE 'cod_maquina'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO,'&
						      				+'MAQUINA.DESC_MAQ AS DESCRIPCION_MAQUINA '&     	
									 		   +'FROM MAQUINA '
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])
				END IF
				
		 CASE 'cod_implemento'	
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO,'&
						      				+'MAQUINA.DESC_MAQ AS DESCRIPCION_IMPLEMENTO '&     	
									 		   +'FROM MAQUINA '
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_implemento',lstr_seleccionar.param1[1])
				END IF
END CHOOSE


end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

type dw_master from u_dw_abc within w_ma304_prog_operaciones_x_ot
integer x = 32
integer y = 36
integer width = 1463
integer height = 356
string dataobject = "d_abc_programa_trabajo_rh_cab_tbl"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master // dw_master
idw_det  = dw_detail	// dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;This.Object.fecha			[al_row] = f_fecha_actual ()
This.Object.cod_usr		[al_row] = gs_user
This.Object.flag_estado [al_row] = '1'


end event

type gb_1 from groupbox within w_ma304_prog_operaciones_x_ot
integer x = 1765
integer y = 24
integer width = 1266
integer height = 216
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 255
long backcolor = 67108864
string text = "Ubica documento"
end type

