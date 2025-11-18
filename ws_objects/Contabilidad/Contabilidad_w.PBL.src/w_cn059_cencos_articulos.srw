$PBExportHeader$w_cn059_cencos_articulos.srw
forward
global type w_cn059_cencos_articulos from w_abc_master_lstmst
end type
type uo_search from n_cst_search within w_cn059_cencos_articulos
end type
end forward

global type w_cn059_cencos_articulos from w_abc_master_lstmst
integer width = 3355
integer height = 1976
string title = "[CN059] Asignación de artículos por Centro de Costos"
string menuname = "m_abc_master_smpl"
uo_search uo_search
end type
global w_cn059_cencos_articulos w_cn059_cencos_articulos

type variables
DatawindowChild idw_child_n2, idw_child_n3
end variables

on w_cn059_cencos_articulos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
end on

on w_cn059_cencos_articulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cencos.protect")
IF ls_protect='0' THEN
  	dw_master.of_column_protect("cencos")
END IF

end event

event resize;// Override

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
dw_lista.height = newheight - dw_lista.y - 10

uo_search.width  = dw_lista.width
uo_search.event ue_resize( sizetype, dw_lista.width, newheight)
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

dw_master.of_set_flag_replicacion()

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master) <> true then return


ib_update_check = true
end event

event ue_open_pre;call super::ue_open_pre;
this.event ue_retrieve()

uo_search.of_set_dw( dw_lista )
end event

event ue_dw_share;//Override
end event

event ue_retrieve;call super::ue_retrieve;dw_lista.Retrieve()

if dw_lista.RowCount() > 0 then
	dw_lista.SetRow(1)
	dw_lista.SelectRow(0, false)
	dw_lista.SelectRow(1, true)
	dw_lista.event ue_output(1)
else
	dw_master.Reset()
	
	dw_master.ii_update = 0

end if
end event

event ue_insert;//Overrite

Long  ll_row

if idw_1 = dw_master then
	if dw_lista.getrow() = 0 then
		MessageBox('Error', 'No hay registro de centros de costo en el listado, por favor verifique!', StopSign!)
		return
	end if
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if


end event

type dw_master from w_abc_master_lstmst`dw_master within w_cn059_cencos_articulos
integer x = 1947
integer width = 1659
integer height = 1664
string dataobject = "d_abc_cencos_articulos_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 1			// columnas de lectrua de este dw

is_dwform = 'tabular'	// tabular, form (default)

end event

event dw_master::ue_insert_pre;if dw_lista.getRow()= 0 then return

THIS.OBJECT.cencos 		[al_row] = dw_lista.object.cencos 	[dw_lista.getRow()]


end event

event dw_master::ue_display;call super::ue_display;// Abre ventana de ayuda 
str_Articulo	lstr_articulo

if dw_lista.getRow() = 0 then return

if al_Row = 0 then return

choose case lower(as_columna)
	case "cod_art"
		lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
		
		if lstr_articulo.b_Return then
			this.object.cod_art				[al_row] = lstr_articulo.cod_art
			this.object.desc_art				[al_row] = lstr_articulo.desc_art
			this.object.und					[al_row] = lstr_articulo.und
			this.object.und2					[al_row] = lstr_articulo.und2
		
			this.ii_update = 1

		end if
			
		
		
	
end choose


end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc_Art, ls_und, ls_und2


dw_master.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_art'		
   	// Si no pide el factor, evalua por el c.costo		
		Select desc_art, und, und2
			into :ls_desc_art, :ls_und, :ls_und2
	   from articulo 
		where cod_Art = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox( "Atencion", "Código de articulo " + data + " no existe o no se encuentra activo", StopSign!)
			this.object.desc_Art		[row] = gnvo_app.is_null
			this.object.und			[row] = gnvo_app.is_null
			this.object.und2			[row] = gnvo_app.is_null
			return 1
		end if
		
   	this.object.desc_Art		[row] = ls_desc_Art
		this.object.und			[row] = ls_und
		this.object.und2			[row] = ls_und2
		
	
END CHOOSE


end event

type dw_lista from w_abc_master_lstmst`dw_lista within w_cn059_cencos_articulos
integer x = 0
integer y = 84
integer width = 1938
integer height = 1676
string dataobject = "d_lista_centros_costo_tbl"
end type

event dw_lista::constructor;call super::constructor;ii_ck[1] = 1      // columnas de lectrua de este dw

end event

event dw_lista::ue_output;call super::ue_output;if al_row = 0 then return
dw_master.retrieve(this.object.cencos[al_row])
end event

event dw_lista::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
if currentrow > 0 then
	this.event ue_output(currentrow)
end if
end event

type uo_search from n_cst_search within w_cn059_cencos_articulos
integer width = 1911
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

