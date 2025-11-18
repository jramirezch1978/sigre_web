$PBExportHeader$w_ve315_exportaciones.srw
forward
global type w_ve315_exportaciones from w_abc
end type
type cb_2 from commandbutton within w_ve315_exportaciones
end type
type tab_1 from tab within w_ve315_exportaciones
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_detail_det from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_detail_det dw_detail_det
end type
type tab_1 from tab within w_ve315_exportaciones
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type st_1 from statictext within w_ve315_exportaciones
end type
type sle_1 from singlelineedit within w_ve315_exportaciones
end type
type cb_1 from commandbutton within w_ve315_exportaciones
end type
type dw_master from u_dw_abc within w_ve315_exportaciones
end type
end forward

global type w_ve315_exportaciones from w_abc
integer width = 4558
integer height = 2600
string title = "Exportaciones (VE315)"
string menuname = "m_mtto_lista"
cb_2 cb_2
tab_1 tab_1
st_1 st_1
sle_1 sle_1
cb_1 cb_1
dw_master dw_master
end type
global w_ve315_exportaciones w_ve315_exportaciones

type variables
String 	is_accion
u_dw_abc	idw_detail, idw_caracteristicas

end variables

forward prototypes
public subroutine of_retrieve (string as_nro_embarque)
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_retrieve (string as_nro_embarque);String ls_embarque,ls_nro_lote

dw_master.retrieve (as_nro_embarque)
idw_detail.retrieve (as_nro_embarque)
	
if idw_detail.Rowcount() > 0 then
	ls_embarque = idw_detail.object.nro_embarque [1]
	ls_nro_lote	= idw_detail.object.nro_lote		[1]
		
	idw_caracteristicas.Retrieve(ls_embarque,ls_nro_lote)
		
	idw_detail.il_row = idw_detail.Getrow()
	
end if
	
dw_master.il_row = dw_master.Rowcount()
is_accion = 'fileopen'
end subroutine

public subroutine of_asigna_dws ();idw_detail 			  = tab_1.tabpage_1.dw_detail
idw_caracteristicas = tab_1.tabpage_2.dw_detail_det

end subroutine

on w_ve315_exportaciones.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
this.cb_2=create cb_2
this.tab_1=create tab_1
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.dw_master
end on

on w_ve315_exportaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.tab_1)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event resize;call super::resize;of_asigna_dws()

//dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width  = tab_1.tabpage_1.width  - idw_detail.x - 10
idw_detail.height = tab_1.tabpage_1.height - idw_detail.y - 10

idw_caracteristicas.width  = tab_1.tabpage_2.width  - idw_caracteristicas.x - 10
idw_caracteristicas.height = tab_1.tabpage_2.height - idw_caracteristicas.y - 10

end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_caracteristicas.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente


of_position_window(0,0)       			// Posicionar la ventana en forma fija


end event

event ue_insert;call super::ue_insert;Long  ll_row




choose case idw_1
	case	dw_master
		TriggerEvent('ue_update_request')
		IF ib_update_check = false then return
		dw_master.Reset()
		idw_detail.Reset()
		idw_caracteristicas.Reset()
		is_accion = 'new'
		
	case idw_detail
		IF dw_master.Getrow( ) = 0 THEN RETURN				
		
	case idw_caracteristicas 
		IF idw_detail.Getrow( ) = 0 THEN RETURN
				
end choose
	


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
idw_detail.AcceptText()
idw_caracteristicas.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	RETURN
END IF	

if ib_log then
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_caracteristicas.of_create_log()
end if


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
	   Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_detail.ii_update = 1 THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_caracteristicas.ii_update = 1 THEN
	IF idw_caracteristicas.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

if lbo_ok and ib_log then
	lbo_ok = dw_master.of_save_log()
	lbo_ok = idw_detail.of_save_log()
	lbo_ok = idw_caracteristicas.of_save_log()
end if


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update		= 0
	idw_detail.ii_update 	 = 0
	idw_caracteristicas.ii_update = 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_caracteristicas.ResetUpdate()


	is_accion = 'fileopen'
	
	f_mensaje("Cambios Realizados se han guardado satisfactoriamente", "")
else
	rollback;
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR idw_detail.ii_update = 1 OR idw_caracteristicas.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_detail.ii_update = 0
		idw_caracteristicas.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;String 	ls_cod_origen ,ls_nro_embarque ,ls_nro_lote ,ls_nro_ov ,ls_cod_caract ,&
		 	ls_cod_art		,ls_cod_templa	  ,ls_und_emb
Decimal 	ldc_cant_emb
Long   	ll_row_master ,ll_inicio
dwItemStatus ldis_status

ib_update_check = true

nvo_numeradores lnvo_numeradores
lnvo_numeradores = CREATE nvo_numeradores

ll_row_master =  dw_master.getrow()

if ll_row_master = 0 then return

ls_cod_origen   = gs_origen
ls_nro_embarque = dw_master.object.nro_embarque [ll_row_master]
ls_nro_ov		 = dw_master.object.nro_ov			[ll_row_master]


ib_update_check = True

IF Isnull(ls_nro_ov) or Trim(ls_nro_ov) = '' THEN
	Messagebox('Aviso','Nro de Orden de Venta No Debe Ser Nulo')	
	ib_update_check = false
	Return
END IF

//Verificación de Data en Detalle de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
END IF

//Verificación de Data en Detalle de Documento
IF f_row_Processing( idw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
END IF

//Verificación de Data en Detalle de Documento
IF f_row_Processing( idw_caracteristicas, "tabular") <> true then	
	ib_update_check = False	
	return
END IF


IF is_accion = 'anular' THEN //ANULO TRANSACION
	destroy lnvo_numeradores
	Return
END IF


if is_accion = 'new' then
	SetNull(ls_nro_embarque)
		
	IF	lnvo_numeradores.uf_num_embarque(ls_cod_origen,ls_nro_embarque) = FALSE THEN
		ib_update_check = False	
		Return
	END IF

	dw_master.object.nro_embarque [ll_row_master] = ls_nro_embarque	
else
	ls_nro_embarque = dw_master.object.nro_embarque [ll_row_master]
end if	


//ver detalle
//asignar nro de embarque en lote cuando registro sea nuevo
For ll_inicio = 1 to idw_detail.Rowcount()
	 idw_detail.object.nro_embarque [ll_inicio] = ls_nro_embarque
Next	

//asignar nro de embarque en carateristicas de lote cuando registro sea nuevo
For ll_inicio = 1 to idw_caracteristicas.Rowcount()
	 idw_caracteristicas.object.nro_embarque [ll_inicio] = ls_nro_embarque
Next	

end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
String ls_embarque, ls_nro_item

str_parametros sl_param


TriggerEvent('ue_update_request')
IF ib_update_check = false then return

sl_param.dw1    = 'd_ve_lista_embarque_tbl'
sl_param.titulo = 'EMBARQUES'
sl_param.field_ret_i[1] = 1	//Nro Embarque

OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	dw_master.retrieve(sl_param.field_ret[1])
	idw_detail.retrieve(sl_param.field_ret[1])
	
	if idw_detail.Rowcount() > 0 then
		ls_embarque = idw_detail.object.nro_embarque [1]
		ls_nro_item	= idw_detail.object.nro_item		[1]
		
		idw_caracteristicas.Retrieve(ls_embarque,ls_nro_item)
		
		idw_detail.il_row = idw_detail.Getrow()
	end if
	
	dw_master.il_row = dw_master.Rowcount()
	is_accion = 'fileopen'
END IF
end event

type cb_2 from commandbutton within w_ve315_exportaciones
integer x = 2309
integer y = 40
integer width = 878
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copiar Detalle de Orden de Venta"
end type

event clicked;String 	ls_nro_ov,ls_cod_art,ls_und, ls_und2, ls_nro_lote, ls_desc_art
Long   	ll_row
Decimal	ldc_cant, ldc_cant_und2

if dw_master.Rowcount() = 0 then return

ls_nro_ov = dw_master.object.nro_ov [dw_master.Rowcount()]

if Isnull(ls_nro_ov) Or Trim(ls_nro_ov) = '' then
	Messagebox('Aviso','Debe Ingresar Una Orden de Venta')
	Return
end if	


DECLARE Amp_venta CURSOR FOR
SELECT AMP.COD_ART, 
       A.DESC_ART,
       SUM(AM.CANT_PROCESADA) AS CANT_PROCESADA,
       A.UND , 
       SUM(AM.CANT_PROC_UND2) AS CANT_PROC_UND2,
       A.UND2,
       AM.NRO_LOTE
  FROM ARTICULO_MOV_PROY AMP,
       ARTICULO          A,
       ARTICULO_MOV      AM
 WHERE AMP.COD_ART  = A.COD_ART   
   AND AMP.TIPO_DOC = (SELECT DOC_OV FROM LOGPARAM WHERE RECKEY = '1')
   AND AM.ORIGEN_MOV_PROY = AMP.COD_ORIGEN
   and am.nro_mov_proy    = AMP.NRO_MOV
   AND AMP.NRO_DOC  = :ls_nro_ov  
GROUP BY AMP.COD_ART, 
       A.DESC_ART,
       A.UND , 
       A.UND2,
       AM.NRO_LOTE
ORDER BY AM.NRO_LOTE, AMP.COD_ART;
		 
OPEN Amp_venta ;	

DO 				/*Recorro Cursor*/	
	FETCH Amp_venta INTO :ls_cod_art, :ls_desc_art, :ldc_cant, :ls_und, :ldc_cant_und2, :ls_und2, :ls_nro_lote;

	IF sqlca.sqlcode = 100 THEN EXIT
		
	ll_row = idw_detail.event ue_insert()
	if ll_row > 0 then
		idw_detail.ii_update = 1
		idw_detail.object.cod_art  		[ll_row]  = ls_cod_art
		idw_detail.object.desc_art  		[ll_row]  = ls_desc_art
		idw_detail.object.cant_emb 		[ll_row]  = ldc_cant
		idw_detail.object.und  				[ll_row]  = ls_und
		idw_detail.object.cant_emb_und2 	[ll_row]  = ldc_cant_und2
		idw_detail.object.und2 				[ll_row]  = ls_und2
		idw_detail.object.cod_templa		[ll_row]  = ls_nro_lote
		idw_detail.object.flag_estado 	[ll_row] = '1'
	end if

LOOP WHILE TRUE

CLOSE Amp_venta ;	

end event

type tab_1 from tab within w_ve315_exportaciones
integer x = 2354
integer y = 160
integer width = 2158
integer height = 2248
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean perpendiculartext = true
tabposition tabposition = tabsonright!
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

event selectionchanged;String ls_nro_item, ls_nro_embarque

if newindex = 2 and oldindex = 1 then
	if idw_detail.Getrow() <> 0 then
		if idw_detail.ii_update = 1 then
			Messagebox('Aviso','Grabe Cambios de Lote ,Verifique!')
			tab_1.SelectedTab = 1
		else
			ls_nro_embarque = idw_detail.object.nro_embarque [idw_detail.Getrow()]
			ls_nro_item		 = idw_detail.object.nro_item		 [idw_detail.Getrow()]
			idw_caracteristicas.Retrieve(ls_nro_embarque, ls_nro_item)
		end if
		
	else
		Messagebox('Aviso','Debe Seleccionar un Nro de Lote ,Verifique!')
	end if
	
elseif newindex = 1 and oldindex = 2 then	
	
	 if idw_caracteristicas.ii_update = 1 then
		 Messagebox('Aviso','Grabe Cambios de Caracteristicas de Lote ,Verifique!')
		 tab_1.SelectedTab = 2
	 end if
	 
end if

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 1746
integer height = 2216
long backcolor = 79741120
string text = "Lote"
long tabtextcolor = 134217730
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
integer width = 1719
integer height = 2212
integer taborder = 30
string dataobject = "d_abc_exportaciones_embarque_lote_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'dd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
	                     // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)




ii_ck[1] = 1	// columnas de lectrua de este dw
ii_ck[2] = 2	// columnas de lectrua de este dw

ii_rk[1] = 1 	// columnas que recibimos del master

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle

idw_mst = dw_master
idw_det = idw_caracteristicas
end event

event itemchanged;call super::itemchanged;String ls_nombre,ls_null
Long   ll_count

accepttext()
SetNull(ls_null)


choose case dwo.name
		 case 'cod_art'
				select und into :ls_nombre from articulo
				where (cod_art 	 = :data ) and
						(flag_estado = '1'   ) ;
						
			  if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Articulo No Existe o Esta Inactivo,Verifique!')	
				  this.object.cod_art [row] = ls_null
				  this.object.und_emb [row] = ls_null				  
				  Return 1
			  else
				  this.object.und_emb [row]	= ls_nombre
			  end if
						
		 case 'cod_templa'
				select count(*) into :ll_count
				  from templas
				 where (cod_templa = :data) ;
				
				
				if ll_count = 0 then
					Messagebox('Aviso','Codigo de Templa No Existe o Esta Inactivo,Verifique!')	
				   this.object.cod_templa [row] = ls_null
				   Return 1
				end if
				
		 case 'und_emb'	
				select count(*) into :ll_count
				  from unidad
				 where (und = :data) ;
				
				
				if ll_count = 0 then
					Messagebox('Aviso','Codigo de Unidad No Existe o Esta Inactivo,Verifique!')	
				   this.object.und_emb [row] = ls_null
				   Return 1
				end if
				
				
				
end choose




end event

event doubleclicked;call super::doubleclicked;String ls_name ,ls_prot 

IF Getrow() = 0 THEN Return
str_seleccionar lstr_seleccionar
str_parametros   sl_param
Datawindow		 ldw	
ls_name = dwo.name

ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_templa'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT TEMPLAS.COD_TEMPLA  AS CODIGO_TEMPLA ,'&
					       							 +'TEMPLAS.FLAG_ESTADO AS ESTADO ,'&
														 +'TEMPLAS.OBS AS OBSERVACIONES '&
														 +'FROM TEMPLAS '

							 
															
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.cod_templa [row] = lstr_seleccionar.param1[1]
					ii_update = 1
				END IF
														
		 CASE 'cod_art'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS CODIGO_ARTICULO ,'&
														 +'ARTICULO.NOM_ARTICULO AS DESCRIPCION_ARTICULO ,'&
														 +'ARTICULO.UND AS UNIDAD '&
														 +'FROM ARTICULO '&
														 +'WHERE ARTICULO.FLAG_ESTADO =  '+"'"+'1'+"'"

							 
															
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.cod_art [row] = lstr_seleccionar.param1[1]
					This.Object.und_emb [row] = lstr_seleccionar.param3[1]
					ii_update = 1
				END IF
				
				
								
		 case 'und_emb'	
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT UNIDAD.UND AS CODIGO ,'&
														 +'UNIDAD.DESC_UNIDAD AS DESCRIPCION '&
														 +'FROM UNIDAD '
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.und_emb [row] = lstr_seleccionar.param1[1]
					ii_update = 1
				END IF
				
				
				
			
END CHOOSE



end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	[al_row] = '1'
this.object.cant_emb			[al_row] = 0.00
this.object.cant_emb_und2	[al_row] = 0.00

this.object.nro_item			[al_row] =  String(this.of_nro_item())

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 1746
integer height = 2216
long backcolor = 79741120
string text = "Carateristica"
long tabtextcolor = 32768
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail_det dw_detail_det
end type

on tabpage_2.create
this.dw_detail_det=create dw_detail_det
this.Control[]={this.dw_detail_det}
end on

on tabpage_2.destroy
destroy(this.dw_detail_det)
end on

type dw_detail_det from u_dw_abc within tabpage_2
integer width = 1719
integer height = 2212
integer taborder = 20
string dataobject = "d_abc_exportaciones_emb_lote_caract_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
	                     // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)




ii_ck[1] = 1	// columnas de lectrua de este dw
ii_ck[2] = 2	// columnas de lectrua de este dw
ii_ck[3] = 3	// columnas de lectrua de este dw

ii_rk[1] = 1 	// columnas que recibimos del master
ii_rk[2] = 2 	// columnas que recibimos del master

idw_mst = idw_detail

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item    [al_row] = idw_detail.object.nro_item		[idw_detail.Getrow()]
this.object.cod_templa 	[al_row] = idw_detail.object.cod_templa	[idw_detail.Getrow()]
this.object.flag_estado [al_row] = '1'

end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_null

accepttext()

SetNull(ls_null)

choose case dwo.name
		
		 case 'cod_caract'
			
				select Count(*) into :ll_count
				  from caracteristicas
				 where (cod_caract = :data) ;
				 
				if ll_count = 0 then
					Messagebox('Aviso','Caracteristica no Existe ,Verirfique!')
					This.object.cod_caract [row] = ls_null
					Return 1		
				end if
				
				
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;String ls_name ,ls_prot 

IF Getrow() = 0 THEN Return
str_seleccionar lstr_seleccionar
str_parametros   sl_param
Datawindow		 ldw	
ls_name = dwo.name

ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 case 'cod_caract'	
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CARACTERISTICAS.COD_CARACT  AS CODIGO ,'&
														 +'CARACTERISTICAS.DESCRIPCION AS DESCRIPCION '&
														 +'FROM CARACTERISTICAS '
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.cod_caract [row] = lstr_seleccionar.param1[1]
					ii_update = 1
				END IF
END CHOOSE



end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type st_1 from statictext within w_ve315_exportaciones
integer x = 55
integer y = 64
integer width = 466
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro Embarque :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_ve315_exportaciones
integer x = 549
integer y = 44
integer width = 430
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ve315_exportaciones
integer x = 1019
integer y = 40
integer width = 402
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_nro_embaque

ls_nro_embaque = sle_1.text

of_retrieve(ls_nro_embaque)
end event

type dw_master from u_dw_abc within w_ve315_exportaciones
integer y = 172
integer width = 2354
integer height = 2240
string dataobject = "d_abc_exportaciones_embarque_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez





ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master

end event

event itemchanged;call super::itemchanged;String ls_nombre,ls_nro_ov,ls_null
Long   ll_count

Accepttext()

Setnull(ls_nro_ov)
Setnull(ls_null)


choose case dwo.name
		 case	'nro_ov'
				select count(*) into :ll_count from orden_venta 
				 where (nro_ov       =  :data ) and
				       (flag_mercado =  'E'   ) and
						 (flag_estado  <> '0'   );
							 
			   if ll_count = 0 then
				   Messagebox('Aviso','Orden de Venta No Existe o Esta Inactiva,Verifique!')	
					This.object.nro_ov [row] = ls_nro_ov
				   Return 1
			   end if
				
				
		 case 'agente_aduana'
				select nom_proveedor into :ls_nombre from proveedor 
				 where (proveedor   = :data ) and
				 		 (flag_estado = '1'   ) ; 
						  
			  if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Proveedor No Existe o Esta Inactivo,Verifique!')	
				  this.object.agente_aduana [row] = ls_null
				  This.object.nom_agente    [row] = ls_null
				  Return 1
			  else
			     This.object.nom_agente [row] = ls_nombre
			  end if
			  
				
		 case 'naviera'
				select nom_proveedor into :ls_nombre from proveedor 
				 where (proveedor   = :data ) and
				 		 (flag_estado = '1'   ) ; 
						  
			  if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Naviera No Existe o Esta Inactivo,Verifique!')	
  			     This.object.naviera     [row] = ls_null
			     This.object.nom_naviera [row] = ls_null
				  Return 1
			  else
			     This.object.nom_naviera [row] = ls_nombre
			  end if				
				
		 case 'courrier'
				select nom_proveedor into :ls_nombre from proveedor 
				 where (proveedor   = :data ) and
				 		 (flag_estado = '1'   ) ; 
						  
			  if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Courier No Existe o Esta Inactivo,Verifique!')	
  			     This.object.courrier    [row] = ls_null
			     This.object.nom_courier [row] = ls_null
				  Return 1
			  else
			     This.object.nom_courier [row] = ls_nombre
			  end if				
		 case 'incoterm'
				select descripcion into :ls_nombre from incoterm 
				 where (incoterm    = :data) and
				 		 (flag_estado = '1'	) ;
				
				if sqlca.sqlcode = 100 then
				   Messagebox('Aviso','Codigo de Incoterm No Existe o Esta Inactivo,Verifique!')						
				   This.object.incoterm 		[row] = ls_null
				   This.object.desc_incoterm 	[row] = ls_null
					Return 1
				end if
				
				This.object.incoterm_descripcion [row] = ls_nombre
				
		 case 'flete_instruccion'
				select texto into :ls_nombre 
			  	  from flete_instruccion
			 	 where (flete_instruccion = :data) and
			 			 (flag_estado		  = '1'  )	;
				
				if sqlca.sqlcode = 100 then
					Messagebox('Aviso','Flete de Isntruccion No Existe o Esta Inactivo,Verifique!')						
				   This.object.flete_instruccion    	[row] = ls_null
				   This.object.flete_instruccion_texto [row] = ls_null
					Return 1
				else
					This.object.flete_instruccion_texto [row] = ls_nombre
				end if
		 			  
				
		 case 'asegurador'			
				select nom_proveedor into :ls_nombre from proveedor 
				 where (proveedor   = :data ) and
				 		 (flag_estado = '1'   ) ; 
						  
			  if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Asegurador No Existe o Esta Inactivo,Verifique!')	
  			     This.object.asegurador     [row] = ls_null
			     This.object.nom_asegurador [row] = ls_null
				  Return 1
			  else
			     This.object.nom_asegurador [row] = ls_nombre
			  end if								
			  
		 case 'consignatario'			
				select nom_proveedor into :ls_nombre from proveedor 
				 where (proveedor   = :data ) and
				 		 (flag_estado = '1'   ) ; 
						  
			  if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Consignatario No Existe o Esta Inactivo,Verifique!')	
  			     This.object.consignatario  	  [row] = ls_null
			     This.object.nom_consignatario [row] = ls_null
				  Return 1
			  else
			     This.object.nom_consignatario [row] = ls_nombre
			  end if		
			  
		 case 'forma_empaque'
			
				select descripcion into :ls_nombre from forma_empaque 
				 where (forma_empaque = :data ) and
				 	    (flag_estado   = '1'   ) ;
						  
				if sqlca.sqlcode = 100 then
				   Messagebox('Aviso','Codigo de Consignatario No Existe o Esta Inactivo,Verifique!')	
  			      This.object.forma_empaque  	  		  [row] = ls_null
			      This.object.forma_empaque_descripcion [row] = ls_null
				   Return 1
			  else
			      This.object.forma_empaque_descripcion [row] = ls_nombre
			  end if		
			  
				
		 case 'puerto_origen'
				select descr_puerto into :ls_nombre from fl_puertos 
				 where (puerto      = :data) and
				 		 (flag_estado = '1'  );
				
				if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Puerto de Origen No Existe o Esta Inactivo,Verifique!')	
  			     This.object.puerto_origen  	   [row] = ls_null
			     This.object.desc_puerto_origen [row] = ls_null
				  Return 1
			  else
			     This.object.desc_puerto_origen [row] = ls_nombre
			  end if		
				
		 case 'puerto_destino'
				select descr_puerto into :ls_nombre from fl_puertos 
				 where (puerto      = :data) and
				 		 (flag_estado = '1'  );
				
				if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Puerto de Destino No Existe o Esta Inactivo,Verifique!')	
  			     This.object.puerto_destino  	 [row] = ls_null
			     This.object.desc_puerto_destino [row] = ls_null
				  Return 1
			  else
			     This.object.desc_puerto_destino [row] = ls_nombre
			  end if					
			
		 case 'puerto_carga'
				select descr_puerto into :ls_nombre from fl_puertos 
				 where (puerto      = :data) and
				 		 (flag_estado = '1'  );
				
				if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Puerto de Carga No Existe o Esta Inactivo,Verifique!')	
  			     This.object.puerto_carga      [row] = ls_null
			     This.object.desc_puerto_carga [row] = ls_null
				  Return 1
			  else
			     This.object.desc_puerto_carga [row] = ls_nombre
			  end if					
			
		 case 'doc_cobr_tipo'
				select desc_tipo_doc into :ls_nombre
				  from doc_tipo
				 where (tipo_doc    = :data) and
						 (flag_estado = '1'  ) ;

				if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Tipo de Documento No Existe o Esta Inactivo,Verifique!')	
  			     This.object.doc_cobr_tipo [row] = ls_null
			     This.object.desc_tipo_doc [row] = ls_null
				  Return 1
			  else
			     This.object.desc_tipo_doc [row] = ls_nombre
			  end if					
						 
						 
		 case 'doc_cobr_banco'	
				select nom_banco into :ls_nombre 
				  from banco
				 where (cod_banco = :data) ;

				if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Banco No Existe o Esta Inactivo,Verifique!')	
  			     This.object.doc_cobr_banco [row] = ls_null
			     This.object.nom_banco      [row] = ls_null
				  Return 1
			  else
			     This.object.nom_banco [row] = ls_nombre
			  end if					
			
			
end choose

end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
this.object.cod_usr     [al_row] = gs_user
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_banco
choose case lower(as_columna)
	case "nro_ov"
		ls_sql = "SELECT OV.NRO_OV     AS NUMERO_OVENTA  ,"&
				 + "OV.COD_MONEDA AS MONEDA  ,"&		
				 + "OV.CLIENTE 	  AS CLIENTE ,"&			
				 + "OV.FORMA_PAGO AS FORMA_PAGO "&				
				 + "FROM ORDEN_VENTA OV "&
				 + "WHERE OV.FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.nro_ov	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "agente_aduana"
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_PROVEEDOR , "&
				 + "P.NOM_PROVEEDOR AS DESCRIPCION , "&		
				 + "P.RUC AS CODIGO_RUC "&
				 + "FROM PROVEEDOR P "&
				 + "WHERE P.FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.agente_aduana	[al_row] = ls_codigo
			this.object.nom_agente		[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "naviera"
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_PROVEEDOR , "&
				 + "P.NOM_PROVEEDOR AS DESCRIPCION , "&		
				 + "P.RUC AS CODIGO_RUC "&
				 + "FROM PROVEEDOR P "&
				 + "WHERE P.FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.naviera		[al_row] = ls_codigo
			this.object.nom_naviera	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "courrier"
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_PROVEEDOR , "&
				 + "P.NOM_PROVEEDOR AS DESCRIPCION , "&		
				 + "P.RUC AS CODIGO_RUC "&
				 + "FROM PROVEEDOR P "&
				 + "WHERE P.FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.courrier		[al_row] = ls_codigo
			this.object.nom_courier	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "asegurador"
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_PROVEEDOR , "&
				 + "P.NOM_PROVEEDOR AS DESCRIPCION , "&		
				 + "P.RUC AS CODIGO_RUC "&
				 + "FROM PROVEEDOR P "&
				 + "WHERE P.FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.asegurador		[al_row] = ls_codigo
			this.object.nom_asegurador	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "consignatario"
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_PROVEEDOR , "&
				 + "P.NOM_PROVEEDOR AS DESCRIPCION , "&		
				 + "P.RUC AS CODIGO_RUC "&
				 + "FROM PROVEEDOR P "&
				 + "WHERE P.FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.consignatario		[al_row] = ls_codigo
			this.object.nom_consignatario	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "broker"
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_PROVEEDOR , "&
				 + "P.NOM_PROVEEDOR AS DESCRIPCION , "&		
				 + "P.RUC AS CODIGO_RUC "&
				 + "FROM PROVEEDOR P "&
				 + "WHERE P.FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.broker		[al_row] = ls_codigo
			this.object.nom_broker	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "puerto_origen"
		ls_sql = "SELECT FL.PUERTO AS CODIGO_PUERTO , "&
				 + "FL.DESCR_PUERTO AS DESCRIPCION "&	 
				 + "FROM FL_PUERTOS FL "&
				 + "WHERE FL.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.puerto_origen		[al_row] = ls_codigo
			this.object.desc_puerto_origen	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "puerto_destino"
		ls_sql = "SELECT FL.PUERTO AS CODIGO_PUERTO , "&
				 + "FL.DESCR_PUERTO AS DESCRIPCION "&	 
				 + "FROM FL_PUERTOS FL "&
				 + "WHERE FL.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.puerto_destino		[al_row] = ls_codigo
			this.object.desc_puerto_destino	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "puerto_carga"
		ls_sql = "SELECT FL.PUERTO AS CODIGO_PUERTO , "&
				 + "FL.DESCR_PUERTO AS DESCRIPCION "&	 
				 + "FROM FL_PUERTOS FL "&
				 + "WHERE FL.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.puerto_carga		[al_row] = ls_codigo
			this.object.desc_puerto_carga	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "incoterm"
		ls_sql = "SELECT I.INCOTERM CODIGO_INCOTERM, " &
				 + "I.DESCRIPCION AS DESCRIPCION "&
				 + "FROM INCOTERM I "&
				 + "WHERE I.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.incoterm			[al_row] = ls_codigo
			this.object.DESC_INCOTERM	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "flete_instruccion"
		ls_sql = "SELECT fl.FLETE_INSTRUCCION as CODIGO_FLETE," &
				 + "fl.TEXTO AS DESCRIPCION "&
				 + "FROM FLETE_INSTRUCCION fl "&
				 + "WHERE fl.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.flete_instruccion			[al_row] = ls_codigo
			this.object.flete_instruccion_texto	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "forma_empaque"
		ls_sql = "SELECT fe.FORMA_EMPAQUE AS CODIGO_FEMPAQUE,"&
				 + "fe.DESCRIPCION AS DESCRIPCION_FEMPAQUE "&
				 + "FROM FORMA_EMPAQUE fe "&
				 + "WHERE fe.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.forma_empaque					[al_row] = ls_codigo
			this.object.forma_empaque_descripcion	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "doc_cobr_banco"
		ls_sql = "SELECT b.COD_BANCO AS CODIGO, "&
				 + "b.NOM_BANCO AS DESCRIPCION "&
				 + "FROM BANCO b"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.doc_cobr_banco	[al_row] = ls_codigo
			this.object.nom_banco		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "doc_cobr_tipo"
		ls_sql = "SELECT dt.TIPO_DOC AS CODIGO, "&
				 + "dt.DESC_TIPO_DOC AS DESCRIPCION "&
				 + "FROM DOC_TIPO dt "&
				 + "WHERE dt.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.doc_cobr_tipo	[al_row] = ls_codigo
			this.object.desc_tipo_doc		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "nro_cuenta"
		ls_banco = this.object.doc_cobr_banco [al_Row]
		
		if IsNull(ls_banco) or ls_banco = '' then
			MessageBox('Error', 'Debe indicar primero el banco', Information!)
			this.SetColumn("doc_cobr_banco")
			return
		end if
		
		ls_sql = "select bc.cod_ctabco as nro_cuente, " &
				 + "bc.descripcion as descripcion_cuenta " &
				 + "from banco_cnta bc " &
				 + "where bc.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.nro_cuenta	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose



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

