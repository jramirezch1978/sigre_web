$PBExportHeader$w_ve010_articulo_venta.srw
forward
global type w_ve010_articulo_venta from w_abc_master
end type
type dw_lista from u_dw_list_tbl within w_ve010_articulo_venta
end type
type uo_search from n_cst_search within w_ve010_articulo_venta
end type
end forward

global type w_ve010_articulo_venta from w_abc_master
integer width = 4974
integer height = 2788
string title = "[VE010] Articulos de Venta"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
boolean resizable = false
dw_lista dw_lista
uo_search uo_search
end type
global w_ve010_articulo_venta w_ve010_articulo_venta

type variables
Dragobject	idrg_Top			//Reference to the Top control
Dragobject	idrg_Bottom		//Reference to the bottom control

Boolean		ib_Debug=False		//Debug mode
Long			il_HiddenColor=0	//Bar hidden color to match the window background
Constant Integer	cii_BarThickness=20	//Bar Thickness
Constant Integer	cii_WindowBorder=15	//Window border to be used on all sides
Constant Integer	cii_WindowTop = 81	//The virtual top of the window

string is_col, is_type
end variables

forward prototypes
public subroutine of_resizepanels ()
public subroutine of_refreshbars ()
public subroutine of_resizebars ()
end prototypes

public subroutine of_resizepanels ();//// Resize the panels according to the Vertical Line, Horizontal Line,
//// BarThickness, and WindowBorder.
//
//Long		ll_Width, ll_Height
//
//// Validate the controls.
//If Not IsValid(idrg_Top) or Not IsValid(idrg_Bottom) Then
//	Return 
//End If
//
//ll_Width 	= This.WorkSpaceWidth()
//ll_Height 	= This.WorkspaceHeight()
//
//// Enforce a minimum window size
//If ll_Width < idrg_Top.X + 150 Then
//	ll_Width = idrg_Top.X + 150
//End If
//
//If ll_Height < idrg_Bottom.Y + 150 Then
//	ll_Height = idrg_Bottom.Y + 150
//End If
//
//// Top processing
//idrg_Top.height = st_horizontal.Y - idrg_Top.Y
//
//// Bottom Procesing
//idrg_Bottom.Y 		 = st_horizontal.Y + cii_BarThickness
//idrg_Bottom.height = ll_Height - idrg_Bottom.Y - cii_WindowBorder

end subroutine

public subroutine of_refreshbars ();//// Refresh the size bars
//
//// Force appropriate order
//st_horizontal.SetPosition(ToTop!)
//
//// Make sure the Width is not lost
//st_horizontal.Height = cii_BarThickness
//
end subroutine

public subroutine of_resizebars ();////Resize Bars according to Bars themselves, WindowBorder, and BarThickness.
//
//st_horizontal.Move (cii_WindowBorder, st_horizontal.Y)
//st_horizontal.Resize (This.WorkSpaceWidth() - st_horizontal.X - cii_WindowBorder, cii_BarThickness)
//
//of_RefreshBars()
//
end subroutine

on w_ve010_articulo_venta.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.dw_lista=create dw_lista
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.uo_search
end on

on w_ve010_articulo_venta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.uo_search)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_row

ii_pregunta_delete = 1


uo_search.of_set_dw( dw_lista )

dw_lista.SetTransObject(SQLCA)
dw_master.SetTransObject(SQLCA)

dw_lista.Retrieve()
dw_master.Reset()

if dw_lista.RowCount()> 0 then
	dw_lista.setRow(1)
	dw_lista.Selectrow(0, false)
	dw_lista.Selectrow(1, true)
	dw_lista.event ue_output(1)
end if
end event

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.cod_Art.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_art.Protect = 1
END IF
end event

event resize;//Override
dw_lista.height 	= newheight - dw_lista.y - 10

dw_master.width	= newwidth - dw_master.x - 10
dw_master.height	= newheight - dw_master.y - 10

uo_search.width 	= dw_lista.width - 10 - uo_Search.x

uo_Search.event ue_resize(sizetype, dw_lista.width, newheight)

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event ue_insert;//Override
Long  ll_row

if idw_1 = dw_master then
	dw_master.Reset()
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

type dw_master from w_abc_master`dw_master within w_ve010_articulo_venta
event ue_display ( string as_columna,  long al_row )
integer x = 2482
integer width = 2414
integer height = 1920
string dataobject = "d_abc_articulo_venta_ff"
end type

event dw_master::ue_display;boolean 			lb_ret
string 			ls_data, ls_sql, ls_codigo, ls_almacen, ls_und, ls_und2, ls_flag_und2
decimal			ldc_factor_conv_und
str_Articulo	lstr_articulo
str_parametros	lstr_param

this.AcceptText()


choose case lower(as_columna)
		
	case "cod_art"
		
		lstr_articulo = gnvo_app.almacen.of_get_articulos_all()

		if lstr_articulo.b_Return then
			this.object.cod_art	[al_row] = lstr_articulo.cod_art
			this.object.desc_art	[al_row] = lstr_articulo.desc_art
			
			select und, und2, flag_und2, factor_conv_und
				into :ls_und, :ls_und2, :ls_flag_und2, :ldc_factor_conv_und
			from articulo a
			where a.cod_Art = :lstr_articulo.cod_art;
			
			this.object.und					[al_row] = ls_und
			this.object.und2					[al_row] = ls_und2
			this.object.flag_und2			[al_row] = ls_flag_und2
			this.object.factor_conv_und	[al_row] = ldc_factor_conv_und
			this.ii_update = 1
		END IF
		
		
	case "confin_nacional"
		lstr_param.dw_master = "d_lista_grupo_financiero_tbl"
		lstr_param.dw1 		= "d_lista_confin_x_grupo_tbl"
		lstr_param.titulo 	= "Conceptos financieros"
		lstr_param.dw_m 		= dw_master
		lstr_param.opcion 	= 2			
	
		OpenWithParm( w_abc_seleccion_md2, lstr_param)	
		lstr_param = MESSAGE.POWEROBJECTPARM
		IF lstr_param.titulo <> 'n' then
			this.ii_update = 1
		end if

	case "confin_export"
		lstr_param.dw_master = "d_lista_grupo_financiero_tbl"
		lstr_param.dw1 		= "d_lista_confin_x_grupo_tbl"
		lstr_param.titulo 	= "Conceptos financieros"
		lstr_param.dw_m 		= dw_master
		lstr_param.opcion 	= 3
	
		OpenWithParm( w_abc_seleccion_md2, lstr_param)	
		lstr_param = MESSAGE.POWEROBJECTPARM
		IF lstr_param.titulo <> 'n' then
			this.ii_update = 1
		end if
	
	case "tipo_envase"
		ls_Sql = "select und as codigo_unidad, " &
				 + "desc_unidad as descripcion_unidad " &
				 + "from unidad " &
				 + "order by desc_unidad "
		
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_envase [al_row] = ls_Codigo
			this.ii_update = 1
		end if
		
	case "cnta_prsp"
		ls_Sql = "select cnta_prsp as codigo_cnta_prsp, " &
				 + "descripcion as descripcion_cnta_prsp " &
				 + "from presupuesto_cuenta " &
				 + "order by cnta_prsp "
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cnta_prsp				[al_row] = ls_Codigo
			this.object.desc_cntas_prsp_egr	[al_row] = ls_data	
			this.ii_update = 1
		end if

	case "cnta_prsp_ingreso"
		ls_Sql = "select cnta_prsp as codigo_cnta_prsp, " &
				 + "descripcion as descripcion_cnta_prsp " &
				 + "from presupuesto_cuenta " &
				 + "order by cnta_prsp "
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cnta_prsp_ingreso		[al_row] = ls_Codigo
			this.object.desc_cnta_prsp_ing	[al_row] = ls_data	
			this.ii_update = 1
		end if		
		
	case "cencos_ingreso"
		ls_Sql = "select cc.cencos as cencos, " &
				 + "cc.desc_cencos as descripcion_Cencos " &
				 + "  from centros_costo cc " &
				 + " where cc.flag_estado = '1'"
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cencos_ingreso		[al_row] = ls_Codigo
			this.object.desc_cencos_ing	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose		


end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectura de este dw

end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_sql, ls_codigo, ls_null, ls_und
Integer 	li_count
str_parametros sl_param

this.AcceptText()
SetNull(ls_null)

choose case lower(dwo.name)
		
	case "cod_art"
		
		// Verifica que codigo ingresado exista			
		Select desc_art
			into :ls_data
		from articulo 
		Where cod_Art = :data;
		
		if Sqlca.sqlcode = 100 then 
			Messagebox( "Atencion", "Codigo no existe")
			this.object.cod_art	[row] = ls_null
			this.object.desc_art [row] = ls_null
			Return 1
		end if
		
		this.object.desc_art[row] = ls_data
		
	case "confin"
		
		// Verifica que codigo ingresado exista			
		Select descripcion
			into :ls_data
		from concepto_financiero
		Where confin = :data;
		
		if Sqlca.sqlcode = 100 then 
			Messagebox( "Atencion", "Concepto Financiero No existe")
			this.object.confin		[row] = ls_null
			this.object.desc_confin [row] = ls_null
			Return 1
		end if
		
		this.object.desc_confin 	[row] = ls_data
	
	case "tipo_envase"
		
		// Verifica que codigo ingresado exista			
		Select desc_unidad
			into :ls_data
		from unidad
		Where und = :data;
		
		if Sqlca.sqlcode = 100 then 
			Messagebox( "Atencion", "Concepto Financiero No existe")
			this.object.tipo_envase	[row] = ls_null
			Return 1
		end if
		
	case "cnta_prsp"
		
		// Verifica que codigo ingresado exista			
		Select descripcion
			into :ls_data
		from presupuesto_cuenta
		Where cnta_prsp = :data;
		
		if Sqlca.sqlcode = 100 then 
			Messagebox( "Atencion", "Cuenta Presupuestal No existe")
			this.object.cnta_prsp_vale_sal[row] = ls_null
			this.object.desc_cnta_prsp		[row] = ls_null	
			Return 1
		end if
		
		this.object.desc_cnta_prsp		[row] = ls_data	
		
	case "cnta_cntbl"
		
		// Verifica que codigo ingresado exista			
		Select count(*)
			into :li_count
		from cntbl_cnta
		Where cnta_ctbl = :data
		  and flag_estado = '1';
		
		if li_count = 0 then 
			Messagebox( "Atencion", "Cuenta Contable No existe o no esta activo")
			this.object.cnta_cntbl	[row] = ls_null
			Return 1
		end if
		
end choose		


end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.costo_produccion		[al_row] = 0
this.object.precio_supermercado 	[al_row] = 0
this.object.precio_mayorista		[al_row] = 0
this.object.precio_minorista		[al_row] = 0
this.object.precio_distribuidor	[al_row] = 0
this.object.flag_dl27400			[al_row] = '0'


end event

type dw_lista from u_dw_list_tbl within w_ve010_articulo_venta
integer y = 96
integer width = 2459
integer height = 2484
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_articulo_venta_share"
end type

event constructor;call super::constructor;
ii_ck[1] = 1          // columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle



end event

event ue_output;call super::ue_output;if al_row = 0 then return

dw_master.REtrieve(dw_lista.object.cod_art [al_row])

end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	f_select_current_row(this)
	this.event ue_output(currentrow)
end if
end event

type uo_search from n_cst_search within w_ve010_articulo_venta
event destroy ( )
integer width = 2459
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

