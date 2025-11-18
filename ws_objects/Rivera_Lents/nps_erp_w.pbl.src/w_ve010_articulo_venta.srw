$PBExportHeader$w_ve010_articulo_venta.srw
forward
global type w_ve010_articulo_venta from w_abc_master
end type
type dw_lista from u_dw_list_tbl within w_ve010_articulo_venta
end type
type st_campo from statictext within w_ve010_articulo_venta
end type
type dw_text from datawindow within w_ve010_articulo_venta
end type
type gb_1 from groupbox within w_ve010_articulo_venta
end type
end forward

global type w_ve010_articulo_venta from w_abc_master
integer width = 2939
integer height = 2568
string title = "[VE010] Articulos de Venta"
string menuname = "m_mtto_smpl"
boolean maxbox = false
boolean resizable = false
dw_lista dw_lista
st_campo st_campo
dw_text dw_text
gb_1 gb_1
end type
global w_ve010_articulo_venta w_ve010_articulo_venta

type variables
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
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.dw_lista=create dw_lista
this.st_campo=create st_campo
this.dw_text=create dw_text
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.st_campo
this.Control[iCurrent+3]=this.dw_text
this.Control[iCurrent+4]=this.gb_1
end on

on w_ve010_articulo_venta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_row

ii_pregunta_delete = 1

is_col = dw_master.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col


end event

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.cod_Art.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_art.Protect = 1
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event resize;call super::resize;dw_lista.width  = newwidth  - dw_lista.x - cii_WindowBorder
end event

type ole_skin from w_abc_master`ole_skin within w_ve010_articulo_venta
end type

type st_filter from w_abc_master`st_filter within w_ve010_articulo_venta
end type

type uo_filter from w_abc_master`uo_filter within w_ve010_articulo_venta
end type

type st_box from w_abc_master`st_box within w_ve010_articulo_venta
end type

type uo_h from w_abc_master`uo_h within w_ve010_articulo_venta
end type

type dw_master from w_abc_master`dw_master within w_ve010_articulo_venta
event ue_display ( string as_columna,  long al_row )
integer x = 512
integer y = 1052
integer width = 2414
integer height = 996
string dataobject = "d_abc_articulo_venta_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_null
str_parametros sl_param

this.AcceptText()
SetNull(ls_null)

choose case lower(as_columna)
		
	case "cod_art"
		
		OpenWithParm (w_pop_articulos, parent)
		sl_param = MESSAGE.POWEROBJECTPARM
		IF sl_param.titulo <> 'n' then
			this.object.cod_art	[al_row] = sl_param.field_ret[1]
			this.object.desc_art	[al_row] = sl_param.field_ret[2]
		END IF
		
		return
		
	case "confin"
		sl_param.dw_master = "d_lista_grupo_financiero_tbl"
		sl_param.dw1 		 = "d_lista_confin_x_grupo_tbl"
		sl_param.titulo 	 = "Conceptos financieros"
		sl_param.dw_m = dw_master
		sl_param.opcion = 1			
	
		OpenWithParm( w_abc_seleccion_md2, sl_param)	

	case "confin_export"
		sl_param.dw_master = "d_lista_grupo_financiero_tbl"
		sl_param.dw1 		 = "d_lista_confin_x_grupo_tbl"
		sl_param.titulo 	 = "Conceptos financieros"
		sl_param.dw_m = dw_master
		sl_param.opcion = 2
	
		OpenWithParm( w_abc_seleccion_md2, sl_param)	
	
	case "tipo_envase"
		ls_Sql = "select und as codigo_unidad, " &
				 + "desc_unidad as descripcion_unidad " &
				 + "from unidad " &
				 + "order by desc_unidad "
		
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_envase [al_row] = ls_Codigo
		end if
		
	case "cnta_prsp"
		ls_Sql = "select cnta_prsp as codigo_cnta_prsp, " &
				 + "descripcion as descripcion_cnta_prsp " &
				 + "from presupuesto_cuenta " &
				 + "order by cnta_prsp "
		
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_Codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data	
		end if
		
	case "cnta_cntbl"
		ls_Sql = "select cnta_ctbl as cuenta_contable, " &
				 + "desc_cnta as desc_cuenta_contable " &
				 + "from cntbl_cnta " &
				 + "where flag_estado = '1' " &
				 + "order by cnta_ctbl "
		
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_cntbl		[al_row] = ls_Codigo
		end if
		
end choose		


end event

event dw_master::constructor;call super::constructor;
ii_ck[1] = 1			// columnas de lectura de este dw

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

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.costo_produccion		[al_row] = 0
this.object.precio_supermercado 	[al_row] = 0
this.object.precio_mayorista		[al_row] = 0
this.object.precio_minorista		[al_row] = 0
this.object.precio_distribuidor	[al_row] = 0
this.object.flag_dl27400			[al_row] = '0'


end event

type dw_lista from u_dw_list_tbl within w_ve010_articulo_venta
integer x = 512
integer y = 380
integer width = 2414
integer height = 644
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_articulo_venta_share"
end type

event constructor;call super::constructor;
ii_ck[1] = 1          // columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

dw_master.SetTransObject(SQLCA)
dw_lista.of_share_lista(dw_master)
dw_master.Retrieve()
dw_lista.of_sort_lista()

end event

event ue_output;call super::ue_output;
THIS.EVENT ue_retrieve_det(al_row)

dw_master.ScrollToRow(al_row)
dw_master.il_row = al_row
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	f_select_current_row(this)
	this.event ue_output(currentrow)
end if
end event

event doubleclicked;call super::doubleclicked;IF upper(right( dwo.name, 2 )) = '_T' THEN
	is_col 		= mid(dwo.name, 1, len(lower(dwo.name)) -2)
	st_campo.text = "Orden: " + is_col
	
	is_type = LEFT( this.Describe(is_col + ".ColType"),1)	
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
	return
END IF
end event

type st_campo from statictext within w_ve010_articulo_venta
integer x = 521
integer y = 288
integer width = 713
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_ve010_articulo_venta
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 1243
integer y = 284
integer width = 1509
integer height = 80
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_lista.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_lista.scrollnextrow()	
end if



end event

event constructor;// Adiciona registro en dw1
Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col ) <> '' THEN
	ls_item = upper( this.GetText() )

	li_longitud = len( ls_item )
	if li_longitud > 0 then		// si ha escrito algo
	   
		IF UPPER( is_type) = 'D' then
			ls_comando = "UPPER(LEFT(STRING(" + is_col +")," + String(li_longitud) + "))='" + ls_item + "'"
		ELSEIF UPPER( is_type) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF	

		ll_fila = dw_lista.find(ls_comando, 1, dw_lista.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_lista.selectrow(0, false)
			dw_lista.selectrow(ll_fila,true)
			dw_lista.scrolltorow(ll_fila)
		else
			dw_lista.selectrow(0, false)
		end if
	End if	
	
	this.SetFocus()
end if	
SetPointer(arrow!)
end event

type gb_1 from groupbox within w_ve010_articulo_venta
integer x = 37
integer y = 32
integer width = 2414
integer height = 164
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

