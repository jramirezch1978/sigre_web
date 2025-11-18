$PBExportHeader$w_ap010_unidad_grupo.srw
forward
global type w_ap010_unidad_grupo from w_abc_master
end type
type st_master from statictext within w_ap010_unidad_grupo
end type
type st_grupo from statictext within w_ap010_unidad_grupo
end type
type st_relaciona from statictext within w_ap010_unidad_grupo
end type
type pb_1 from picturebutton within w_ap010_unidad_grupo
end type
type dw_grupo from u_dw_abc within w_ap010_unidad_grupo
end type
type dw_relaciona from u_dw_abc within w_ap010_unidad_grupo
end type
end forward

global type w_ap010_unidad_grupo from w_abc_master
integer width = 3200
integer height = 2000
string title = "Unidades y grupos de atributos  (AP010)"
string menuname = "m_mantto_smpl"
st_master st_master
st_grupo st_grupo
st_relaciona st_relaciona
pb_1 pb_1
dw_grupo dw_grupo
dw_relaciona dw_relaciona
end type
global w_ap010_unidad_grupo w_ap010_unidad_grupo

type variables
long il_st_color
StaticText ist_1
end variables

on w_ap010_unidad_grupo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_master=create st_master
this.st_grupo=create st_grupo
this.st_relaciona=create st_relaciona
this.pb_1=create pb_1
this.dw_grupo=create dw_grupo
this.dw_relaciona=create dw_relaciona
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_master
this.Control[iCurrent+2]=this.st_grupo
this.Control[iCurrent+3]=this.st_relaciona
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_grupo
this.Control[iCurrent+6]=this.dw_relaciona
end on

on w_ap010_unidad_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_master)
destroy(this.st_grupo)
destroy(this.st_relaciona)
destroy(this.pb_1)
destroy(this.dw_grupo)
destroy(this.dw_relaciona)
end on

event resize;st_master.width  = newwidth  - st_master.x - 10
dw_master.width  = newwidth  - dw_master.x - 10

st_relaciona.width  = newwidth  - st_relaciona.x - 10
dw_relaciona.width  = newwidth  - dw_relaciona.x - 10
dw_relaciona.height = newheight - dw_relaciona.y - 10
end event

event ue_open_pre;THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton  

//idw_query = dw_master
idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master

dw_grupo.SetTransObject(SQLCA)
dw_grupo.of_protect()         	// bloquear modificaciones al dw_master

dw_relaciona.SetTransObject(SQLCA)
dw_relaciona.of_protect()         	// bloquear modificaciones al dw_master


//idw_1.Retrieve()
//ii_help = 101            // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
//ib_log = TRUE
//is_tabla = 'Master'
//idw_query = dw_master

ist_1 = st_master
il_st_color = ist_1.BackColor


//Desactiva la opcion buscar del menu de tablas  //
this.MenuId.item[1].item[1].item[1].enabled = false
this.MenuId.item[1].item[1].item[1].visible = false
this.MenuId.item[1].item[1].item[1].ToolbarItemvisible = false
end event

event ue_dw_share;call super::ue_dw_share;if dw_master.Retrieve( ) = -1 then messagebox(this.title, 'Error al cargar Unidades', Stopsign!)
if dw_grupo.retrieve( ) = -1 then messagebox(this.title, 'Error al cargar Grupos', Stopsign!)
//if dw_relaciona.retrieve( ) = -1 then messagebox(this.title, 'Error al cargar Unidades por Grupo', Stopsign!)
end event

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	//in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion de las unidades
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_grupo.ii_update = 1 THEN
	IF dw_grupo.Update() = -1 then		// Grabacion de los grupos
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_relaciona.ii_update = 1 THEN
	IF dw_relaciona.Update() = -1 then		// Grabacion de las relaciones
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.Retrieve()
	dw_master.ii_update = 0
	dw_grupo.ii_update = 0
	dw_relaciona.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_grupo.il_totdel = 0
	dw_relaciona.il_totdel = 0
END IF

end event

event ue_update_request;Integer li_msg_result

IF dw_master.ii_update = 1 or dw_grupo.ii_update = 1 or dw_relaciona.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		THIS.EVENT ue_update()
	END IF
END IF


end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

if f_row_processing( dw_grupo, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

type dw_master from w_abc_master`dw_master within w_ap010_unidad_grupo
integer x = 1545
integer y = 76
integer width = 1591
integer height = 836
string dataobject = "d_ap_unidad_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor = il_st_color
ist_1.italic     = false
ist_1 = st_master
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		
is_dwform = 'tabular'
ii_ss = 0
ii_ck[1] = 1	
idw_mst  = dw_master
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_cod, ls_data, ls_null
long ll_row, ll_ini, ll_end, ll_find, ll_get
DwItemStatus 	l_rowstatus
SetNull(ls_null)
THIS.accepttext( )

// Verifica que no se ingrese un codigo existente
CHOOSE CASE lower(dwo.name)
		
	CASE 'und'
		ll_get 		= THIS.GetRow()
		l_rowStatus = THIS.GetItemStatus( ll_get, 1, primary! )
		ls_data 		= "und = '" + data +"'"
		ll_row 		= THIS.Rowcount()

		IF l_rowstatus = DataModified! AND ll_row > 1 THEN

			CHOOSE CASE ll_get
				CASE 1
					ll_find = This.Find(ls_data, 2, ll_row)
					
				CASE ll_row
					ll_find = This.Find(ls_data, 1, ll_row - 1)
					
				CASE ELSE
					ll_ini  = 1
					ll_end  = ll_get - 1  
					ll_find = This.Find(ls_data, ll_ini, ll_end)
					IF ll_find = 0 THEN 
						ll_ini  = ll_get + 1
						ll_end  = ll_row
						ll_find = This.Find(ls_data, ll_ini, ll_end)
					END IF
			END CHOOSE
			
			IF ll_find > 0 THEN 
				messagebox('Error de ingreso', 'Codigo Existe')
				THIS.object.und	[row] = ls_null
				RETURN 1				
			END IF
		END IF
END CHOOSE

end event

type st_master from statictext within w_ap010_unidad_grupo
integer x = 1545
integer width = 1591
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Unidades de Medida"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_grupo from statictext within w_ap010_unidad_grupo
integer width = 1408
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Grupos de Unidades de Medida"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_relaciona from statictext within w_ap010_unidad_grupo
integer y = 924
integer width = 3104
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Unidades de Medida por Grupo"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ap010_unidad_grupo
integer x = 1431
integer y = 452
integer width = 110
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "Move5!"
string powertiptext = "Relaciona Grupos y Unidades"
end type

event clicked;Long 	 ll_marca_und, ll_marca_grp, ll_inserta, ll_tot_und, &
	  	 ll_tot_grp, ll_tot_rel, ll_rec_und, ll_rec_grp, ll_find
String ls_und, ls_desc_und, ls_und_grp, ls_desc

ll_tot_und 	 = dw_master.RowCount( ) 			//total de filas en dw_master
ll_tot_grp 	 = dw_grupo.RowCount ( )  			// total de filas en dw_grupo
ll_marca_und = dw_master.GetSelectedRow( 0 ) // comprueba si selecciono unidad
ll_marca_grp = dw_grupo.GetSelectedRow ( 0 ) //comprueba si selecciono grupo

IF ll_tot_und <= 0 OR  ll_tot_grp <= 0 OR ll_marca_und = 0 OR &
	ll_marca_grp = 0 THEN RETURN

FOR ll_rec_und = 1 TO ll_tot_und 
	ll_marca_und = dw_master.GetSelectedRow( ll_rec_und - 1 )
	IF ll_rec_und = ll_marca_und THEN
		ls_und 		= dw_master.object.und         [ll_marca_und]
		ls_desc_und = dw_master.object.desc_unidad [ll_marca_und]
		FOR ll_rec_grp = 0 TO ll_tot_grp
			ll_marca_grp = dw_grupo.getselectedrow( ll_rec_grp - 1 )
			IF ll_rec_grp = ll_marca_grp THEN
				ls_und_grp = dw_grupo.object.und_grupo   [ll_marca_grp]
				ls_desc    = dw_grupo.object.descripcion [ll_marca_grp]
				ll_tot_rel = dw_relaciona.rowcount() //total de filas en dw_relaciona
				ll_find    = dw_relaciona.find("trim(und) = '" + trim(ls_und) + &
								 "' and trim(und_grupo) = '" + trim(ls_und_grp) + &
								 "'", 1, ll_tot_rel)
				IF ll_find <= 0 THEN
					ll_inserta = dw_relaciona.EVENT ue_insert()
					IF ll_inserta <= 0 THEN RETURN
					dw_relaciona.object.und         [ll_inserta]	= ls_und
					dw_relaciona.object.desc_unidad [ll_inserta] = ls_desc_und
					dw_relaciona.object.und_grupo   [ll_inserta] = ls_und_grp
					dw_relaciona.object.descripcion [ll_inserta] = ls_desc
					dw_relaciona.ii_update = 1
				END IF					
			END IF
		NEXT
	END IF
NEXT
dw_relaciona.setsort("und, und_grupo")
end event

type dw_grupo from u_dw_abc within w_ap010_unidad_grupo
integer y = 76
integer width = 1408
integer height = 836
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ap_unidad_grupo_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor = il_st_color
ist_1.italic     = false
ist_1 = st_grupo
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true
end event

event constructor;call super::constructor;is_mastdet = 'm'		
is_dwform = 'tabular'
ii_ss = 1
ii_ck[1] = 1	
idw_mst  = dw_master
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;string ls_cod, ls_data, ls_null
long ll_row, ll_ini, ll_end, ll_find, ll_get
DwItemStatus 	l_rowstatus
SetNull(ls_null)
THIS.accepttext( )

// Verifica que no se ingrese un codigo existente
CHOOSE CASE lower(dwo.name)
		
	CASE 'und_grupo'
		ll_get 		= THIS.GetRow()
		l_rowStatus = THIS.GetItemStatus( ll_get, 1, primary! )
		ls_data 		= "und_grupo = '" + data +"'"
		ll_row 		= THIS.Rowcount()

		IF l_rowstatus = DataModified! AND ll_row > 1 THEN

			CHOOSE CASE ll_get
				CASE 1
					ll_find = This.Find(ls_data, 2, ll_row)
					
				CASE ll_row
					ll_find = This.Find(ls_data, 1, ll_row - 1)
					
				CASE ELSE
					ll_ini  = 1
					ll_end  = ll_get - 1  
					ll_find = This.Find(ls_data, ll_ini, ll_end)
					IF ll_find = 0 THEN 
						ll_ini  = ll_get + 1
						ll_end  = ll_row
						ll_find = This.Find(ls_data, ll_ini, ll_end)
					END IF
			END CHOOSE
			
			IF ll_find > 0 THEN
				messagebox('Error de ingreso', 'Codigo Existe')
				THIS.object.und_grupo	[row] = ls_null
				RETURN 1				
			END IF
		END IF
END CHOOSE

end event

event ue_output;call super::ue_output;if al_row = 0 then return

dw_relaciona.retrieve(this.object.und_grupo[al_row])
end event

type dw_relaciona from u_dw_abc within w_ap010_unidad_grupo
integer y = 1008
integer width = 3109
integer height = 640
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ap_und_grp_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor = il_st_color
ist_1.italic     = false
ist_1 = st_relaciona
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true
end event

event constructor;call super::constructor;is_mastdet = 'm'		
is_dwform = 'tabular'
ii_ss = 1
ii_ck[1] = 1	
idw_mst  = dw_master
end event

