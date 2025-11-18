$PBExportHeader$w_ma014_plant_operacion.srw
forward
global type w_ma014_plant_operacion from w_abc
end type
type dw_lista_master from u_dw_list_tbl within w_ma014_plant_operacion
end type
type dw_lista_ord_trab from u_dw_list_tbl within w_ma014_plant_operacion
end type
type dw_master from u_dw_abc within w_ma014_plant_operacion
end type
type dw_detail from u_dw_abc within w_ma014_plant_operacion
end type
type dw_detdet from u_dw_abc within w_ma014_plant_operacion
end type
end forward

global type w_ma014_plant_operacion from w_abc
integer x = 5
integer y = 4
integer width = 3415
integer height = 1948
string title = "Plantillas de operaciones de producción (MA014)"
string menuname = "m_abc_plant_prod"
dw_lista_master dw_lista_master
dw_lista_ord_trab dw_lista_ord_trab
dw_master dw_master
dw_detail dw_detail
dw_detdet dw_detdet
end type
global w_ma014_plant_operacion w_ma014_plant_operacion

type variables
Integer  ii_colnum_dd2, ii_colnum_d2
DatawindowChild idw_child
long il_row
string is_corr_corte, is_cod_origen, is_nro_orden
end variables

forward prototypes
public subroutine wf_art_x_labor_eje (string as_cod_labor)
end prototypes

public subroutine wf_art_x_labor_eje (string as_cod_labor);String ls_cod_art,ls_nom_articulo,ls_und
Long   ll_row,ll_count

DO WHILE dw_detdet.Rowcount() > 0 
	dw_detdet.deleterow(0)
	dw_detdet.ii_update = 1
LOOP


SELECT Count(*)
  INTO :ll_count
  FROM labor_insumo lb ,articulo art
 WHERE (lb.cod_art = art.cod_art  ) AND
		 (cod_labor  = :as_cod_labor) ;

/*Declaración de Cursor*/
DECLARE Mat_labor CURSOR FOR
		  SELECT lb.cod_art,art.nom_articulo,art.und
		  	 FROM labor_insumo lb ,articulo art
			WHERE (lb.cod_art = art.cod_art  ) AND
			      (cod_labor  = :as_cod_labor) ;


/*Abrir Cursor*/		  	
OPEN Mat_labor ;
	
DO 				/*Recorro Cursor*/	
FETCH Mat_labor INTO :ls_cod_art,:ls_nom_articulo,:ls_und ;
IF sqlca.sqlcode = 100 THEN EXIT
/**Inserción de Registros**/ 
	 dw_detdet.TriggerEvent('ue_insert')
	 ll_row = dw_detdet.il_row
	 dw_detdet.object.cod_art               [ll_row] = ls_cod_art
	 dw_detdet.object.articulo_nom_articulo [ll_row] = ls_nom_articulo
	 dw_detdet.object.articulo_und          [ll_row] = ls_und


	 
	 
LOOP WHILE TRUE
	
CLOSE Mat_labor ; /*Cierra Cursor*/



end subroutine

on w_ma014_plant_operacion.create
int iCurrent
call super::create
if this.MenuName = "m_abc_plant_prod" then this.MenuID = create m_abc_plant_prod
this.dw_lista_master=create dw_lista_master
this.dw_lista_ord_trab=create dw_lista_ord_trab
this.dw_master=create dw_master
this.dw_detail=create dw_detail
this.dw_detdet=create dw_detdet
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista_master
this.Control[iCurrent+2]=this.dw_lista_ord_trab
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.dw_detdet
end on

on w_ma014_plant_operacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista_master)
destroy(this.dw_lista_ord_trab)
destroy(this.dw_master)
destroy(this.dw_detail)
destroy(this.dw_detdet)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(SQLCA)
dw_detdet.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_lista_master.SettransObject(SQLCA)
dw_lista_ord_trab.SetTransObject(SQLCA)
dw_lista_master.of_share_lista(dw_master)
dw_master.Retrieve()

idw_1 = dw_master                    // asignar dw corriente
dw_detdet.BorderStyle = StyleRaised! // indicar dw_detdet como no activado
dw_detail.BorderStyle = StyleRaised! // indicar dw_detail como no activado

//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)

// Numero de columnas para llaves de dw_detdet y dw_detail
ii_colnum_dd2 = 1
ii_colnum_d2  = 6

// bloquear modificaciones
dw_master.of_protect()         
dw_detdet.of_protect()
dw_detail.of_protect()

// Lectura de lista  de Corr Corte
dw_lista_ord_trab.Retrieve()


dw_detail.Getchild( "cod_ejecutor", idw_child )
idw_child.settransobject(sqlca)

of_position_window(0,0)

//Help
ii_help = 11


end event

event ue_modify;call super::ue_modify;idw_1.of_protect()
dw_master.of_column_protect("cod_plantilla")
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detdet.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detdet.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_detdet.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion de Plantilla","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion de Movimientos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	dw_detdet.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detdet.Update() = -1 then		// Grabacion del detdet
		lbo_ok = FALSE
		messagebox("Error en Grabacion de Operaciones","Se ha procedido al rollback",exclamation!)
	END IF

END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detdet.ii_update = 0
	dw_detail.ii_update = 0
	
ELSE 
	ROLLBACK USING SQLCA;
END IF	
end event

event ue_insert();call super::ue_insert;Long  ll_row

IF idw_1 = dw_detdet AND dw_detail.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado Operacion")
	RETURN
END IF

IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado Plantilla")
	RETURN
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF



end event

event ue_dw_share;call super::ue_dw_share;dw_lista_master.of_share_lista(dw_master)
end event

event ue_print;String      ls_cadena
Str_cns_pop lstr_cns_pop

IF idw_1.getrow() = 0 THEN RETURN

ls_cadena = idw_1.Object.cod_plantilla[idw_1.getrow()]

IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN RETURN

lstr_cns_pop.arg[1] = ls_cadena
lstr_cns_pop.arg[2] = gs_user
lstr_cns_pop.arg[3] = gs_empresa
lstr_cns_pop.arg[4] = ''

lstr_cns_pop.dataobject = 'd_rpt_plant_operaciones_campo_ff'
lstr_cns_pop.title = 'Plantilla de Operaciones por campo'
lstr_cns_pop.width  = 3650
lstr_cns_pop.height = 1950

OpenSheetWithParm(w_rpt_pop, lstr_cns_pop, This, 2, Layered!)





end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10

dw_detdet.width  = newwidth  - dw_detdet.x - 10
dw_detdet.height = newheight - dw_detdet.y - 10
dw_lista_ord_trab.height = newheight - dw_lista_ord_trab.y - 10

end event

event ue_update_pre();call super::ue_update_pre;//--VERIFICACION Y ASIGNACION OPERACIONES
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//--VERIFICACION Y ASIGNACION OPERACIONES
IF f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//--VERIFICACION Y ASIGNACION ARTICULOS
IF f_row_Processing( dw_detdet, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF




end event

type dw_lista_master from u_dw_list_tbl within w_ma014_plant_operacion
integer x = 9
integer y = 12
integer width = 1467
integer height = 440
boolean bringtotop = true
string dataobject = "d_plant_prod_list_tbl"
end type

event dragdrop;call super::dragdrop;string ls_plant_fuente, ls_plant_destino
integer li_confirma
IF row = 0 THEN RETURN
//source = variable que identifica de que objeto viene el drop
CHOOSE CASE source
	CASE dw_master
      ls_plant_destino = dw_lista_master.object.cod_plantilla[dw_lista_master.GetRow()]
      ls_plant_fuente  = dw_master.object.cod_plantilla[Row]
      This.scrolltorow(row)
      This.selectrow(0,FALSE)
      dw_lista_master.selectrow(row,TRUE)
	   li_confirma = messagebox("Mensaje", "Usted ha seleccionado lo siguiente:~r~n"+"~r~n"+&
      								"Plantilla Destino: "+ls_plant_fuente +"~r~n"+"~r~n"+&
										"Plantilla Fuente : "+ls_plant_Destino+"~r~n",Exclamation!, OkCancel!) 
      IF li_confirma = 1 THEN
	      DECLARE usp_c_p_p_oper PROCEDURE FOR USP_COPIAR_PLANT_PROD_OPER(  
         :ls_plant_destino,:ls_plant_fuente);
	      execute usp_c_p_p_oper;	
	      IF SQLCA.sqlcode = -1 THEN
            Messagebox("Error","Copia no se ha realizado satisfactoriamente")
	      END IF	
		END IF	
//	CASE dw_lista_ord_trab
//      ls_plant_destino  = dw_lista_master.object.cod_plantilla[dw_lista_master.GetRow()]
//		ls_plant_fuente   = is_corr_corte
//      This.scrolltorow(row)
//      This.selectrow(0,FALSE)
//      dw_lista_ord_trab.selectrow(row,TRUE)
//	   dw_lista_master.selectrow(row,TRUE)
//      li_confirma = messagebox("Mensaje", "Usted ha seleccionado lo siguiente:~r~n"+"~r~n"+&
//										"Operación Fuente (Nº Corte): "+ls_plant_fuente +"~r~n"+"~r~n"+&
//        								"Plantilla Destino  (edG)   : "+ls_plant_Destino+"~r~n",Exclamation!, OkCancel!) 
//      IF li_confirma = 1 THEN
//	       DECLARE usp_c_p_p_oper2 PROCEDURE FOR USP_COPIAR_OPER_PLANT_PROD(  
//                  :ls_plant_fuente, :ls_plant_destino);
//         	      execute usp_c_p_p_oper2;	
//	       IF SQLCA.sqlcode = -1 THEN 
//             Messagebox("Error","Copia no se ha realizado satisfactoriamente")
//          END IF	
//      END IF	
END CHOOSE
end event

event dragwithin;call super::dragwithin;IF row = il_row THEN RETURN

dw_lista_master.selectrow(il_row,FALSE)
dw_lista_master.selectrow(row,TRUE)	
il_row = row

end event

event constructor;call super::constructor;THIS.EVENT POST ue_val_param()

//ii_ss = 0 			// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1         // columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle


end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

dw_master.ScrollToRow(al_row)
dw_master.il_row = al_row

end event

event ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;Long ll_nro_operacion

Parent.TriggerEvent('ue_update_request')
dw_detail.retrieve(aa_id[1])

IF dw_detail.Rowcount() > 0 THEN
	ll_nro_operacion = dw_detail.object.nro_operacion [1]
	dw_detdet.retrieve(aa_id[1],ll_nro_operacion)
ELSE
	dw_detdet.reset()
END IF	

end event

event itemerror;call super::itemerror;Return 1
end event

type dw_lista_ord_trab from u_dw_list_tbl within w_ma014_plant_operacion
integer x = 14
integer y = 1268
integer width = 1280
integer height = 472
integer taborder = 50
string dragicon = "H:\Source\ICO\row2.ico"
boolean bringtotop = true
string dataobject = "d_ord_trabaj_plantilla_tbl"
end type

event clicked;call super::clicked;IF row = 0 THEN RETURN

is_cod_origen = dw_lista_ord_trab.GetItemString(row,"cod_origen")
is_nro_orden = dw_lista_ord_trab.GetItemString(row,"nro_orden")
this.drag(begin!)

end event

event constructor;call super::constructor;ii_ck[1] = 1          // columnas de lectrua de este dw
end event

event itemerror;call super::itemerror;Return 1
end event

type dw_master from u_dw_abc within w_ma014_plant_operacion
integer x = 1495
integer y = 12
integer width = 1591
integer height = 440
integer taborder = 40
string dragicon = "H:\Source\ico\row2.ico"
boolean bringtotop = true
string dataobject = "d_plant_prod_ff"
end type

event constructor;call super::constructor; is_mastdet = 'md'       // 'm' = master sin detalle (default), 'd' =  detalle,
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'tabular'  // tabular, grid, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  = dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
this.drag(begin!)

end event

event itemerror;call super::itemerror;Return 1
end event

type dw_detail from u_dw_abc within w_ma014_plant_operacion
integer x = 14
integer y = 468
integer width = 3328
integer height = 800
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_plant_prod_oper_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'dd'      // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  // tabular, grid, form (default)
 
ii_ck[1] = 1		// columnas de lectrua de este dw
ii_rk[1] = 9 	   // columnas que recibimos del master
ii_dk[1] = 9 	   // columnas que se pasan al detalle
ii_dk[2] = 1

idw_mst  = dw_master
idw_det  = dw_detdet
end event

event clicked;call super::clicked;String ls_filter,ls_cod_labor

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

CHOOSE CASE dwo.name
		 CASE 'cod_ejecutor'
				ls_cod_labor = This.Object.cod_labor[row]
				ls_filter = "cod_labor = '" + ls_cod_labor + "'"
				idw_child.Setfilter(ls_filter)
				idw_child.filter()	
END CHOOSE



end event

event itemchanged;call super::itemchanged;String ls_cod_labor, ls_desc_labor, ls_precedencia, ls_und, ls_filter,&
		 ls_ejecutor
String ls_resultado, ls_columna		 
Long   ll_count

Accepttext()

CHOOSE CASE dwo.name
		 CASE "cod_labor"
				
	  			ls_cod_labor = data
		      SELECT desc_labor, und
			    INTO :ls_desc_labor,   
     	    			:ls_und  
			    FROM labor  
			   WHERE (cod_labor = :ls_cod_labor);
	
	  			IF Isnull(ls_desc_labor) OR Trim(ls_desc_labor) = '' THEN
		  			Messagebox('Aviso','Codigo de Labor No Existe Verifique',StopSign!)
		  			This.Object.cod_labor[row] = ''
		  			This.Object.desc_operacion[row] = ''
		  			This.Object.labor_und[row] = ''
		  			Return 1
	  			ELSE
		  			This.SetItem(row,"desc_operacion",ls_desc_labor)
		  			This.SetItem(row,"labor_und",ls_und)
     	  			ls_filter = "cod_labor = '" + ls_cod_labor + "'"
	  	  			idw_child.Setfilter(ls_filter)
     	  			idw_child.filter()	
     			END IF
	  
	  			// Capturando el ejecutor
     			SELECT Count(*)
		 		  INTO :ll_count
		 		  FROM labor_ejecutor
		       WHERE (cod_labor = :ls_cod_labor) ;
				 		 
	  			IF ll_count = 1 THEN
		  			SELECT cod_ejecutor
			 		  INTO :ls_ejecutor
			 		  FROM labor_ejecutor
					 WHERE (cod_labor = :ls_cod_labor) ;	
					
		  			This.object.cod_ejecutor [row] = ls_ejecutor
		  
	   		END IF
				
				/*Inserto Articulos*/
				wf_art_x_labor_eje (ls_cod_labor)
	  
		CASE "cantidad"  // Pasar de horas a decimales
			  IF pos( data, ':' ) > 0 Then  // Esta en Formato horario
      		  
      		  ls_columna = dwo.Name 
		        ls_resultado = f_conv_hr_dec(data) 
      		  THIS.SetItem(row, ls_columna, Dec(ls_resultado)) 
      		  THIS.SetText(ls_resultado)
      		  RETURN 2
			  END IF

			  	
END CHOOSE		

end event

event ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)




end event

event ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;// Bloqueado para que no pregunte a cada rato
//Parent.TriggerEvent('ue_update_request')
dw_detdet.retrieve(aa_id[1], aa_id[2])
end event

event ue_insert_pre;call super::ue_insert_pre;This.SetItem ( al_row, 'plant_prod_oper_flag_pre', 'I')
This.SetItem ( al_row, 'plant_prod_oper_flag_dias_inicio', 'F')
end event

event itemerror;Return 1

end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot,ls_filter,ls_cod_labor,ls_ejecutor
str_seleccionar lstr_seleccionar
Long   ll_count

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cod_labor'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT LABOR.COD_LABOR AS CODIGO, '&   
										      +'LABOR.DESC_LABOR AS DESCRIPCION, '&
												+'LABOR.UND AS UNIDAD '&
												+'FROM LABOR '
												
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					ls_cod_labor = lstr_seleccionar.param1[1]
					Setitem(row,'cod_labor',lstr_seleccionar.param1[1])
				   SetItem(row,'desc_operacion',lstr_seleccionar.param2[1])
				   SetItem(row,"labor_und",lstr_seleccionar.param3[1])
				   ls_filter = "cod_labor = '" + lstr_seleccionar.param1[1] + "'"
					idw_child.Setfilter(ls_filter)
				   idw_child.filter()	
				END IF
				
				SELECT Count(*)
				  INTO :ll_count
				  FROM labor_ejecutor
				 WHERE (cod_labor = :ls_cod_labor) ;
				 		 
				IF ll_count = 1 THEN
					SELECT cod_ejecutor
				    INTO :ls_ejecutor
				    FROM labor_ejecutor
				   WHERE (cod_labor = :ls_cod_labor) ;	
					
					This.object.cod_ejecutor [row] = ls_ejecutor
				END IF
				
				/*Inserto Articulos*/
				wf_art_x_labor_eje (ls_cod_labor)
				
END CHOOSE


end event

type dw_detdet from u_dw_abc within w_ma014_plant_operacion
integer x = 1312
integer y = 1268
integer width = 2030
integer height = 472
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_plant_prod_mov_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'       // 'm' = master sin detalle (default), 'd' =  detalle,
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  // tabular, grid, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 4 	      // columnas que recibimos del master
ii_rk[2] = 5

idw_mst  = dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;Accepttext()

String ls_desc_art, ls_und,ls_cod_art,ls_cod_labor

setnull(ls_cod_art)

CHOOSE CASE dwo.name
	    CASE 'cod_art'
				ls_cod_labor = dw_detail.object.cod_labor [dw_detail.getrow()]

				
				SELECT a.desc_art ,
						 a.und
				  INTO :ls_desc_art,:ls_und	 	 
				  FROM articulo a,labor_insumo l
				 WHERE ((a.cod_art     = l.cod_art     )) AND
					     (a.flag_estado = '1'           )  AND
					     (l.cod_labor   = :ls_cod_labor )  AND
						  (a.cod_art	  = :data         ) ;
				

				
				IF Isnull(ls_desc_art) OR Trim(ls_desc_art) = '' THEN
					Messagebox('Aviso','Codigo de Articulo No Valido',StopSign!)
					This.Object.cod_art					[row] = ls_cod_art
					This.Object.articulo_nom_articulo[row] = ''
					This.Object.articulo_und			[row] = ''
					Return 1
				ELSE
					This.SetItem(row,"articulo_nom_articulo", ls_desc_art)
					This.SetItem(row,"articulo_und", ls_und)
				END IF
		

END CHOOSE
end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot,ls_cod_labor
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cod_art'

				ls_cod_labor = dw_detail.object.cod_labor [dw_detail.getrow()]
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_MTT_ART_X_LABOR.COD_ART AS CODIGO, '&   
												 +'VW_MTT_ART_X_LABOR.DESC_ART AS DESCRIPCION, '&   
												 +'VW_MTT_ART_X_LABOR.UND AS UNIDAD '&   
												 +'FROM  VW_MTT_ART_X_LABOR '&
												 +'WHERE VW_MTT_ART_X_LABOR.COD_LABOR = '+"'"+ls_cod_labor+"'"    

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					
					Setitem(row,'cod_art',lstr_seleccionar.param1[1])
					Setitem(row,'articulo_nom_articulo',lstr_seleccionar.param2[1])
					Setitem(row,'articulo_und',lstr_seleccionar.param3[1])
				END IF
END CHOOSE


end event

