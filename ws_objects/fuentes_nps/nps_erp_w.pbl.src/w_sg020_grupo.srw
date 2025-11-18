$PBExportHeader$w_sg020_grupo.srw
forward
global type w_sg020_grupo from w_abc_mastdet_smpl
end type
type dw_aplicaciones from u_dw_cns within w_sg020_grupo
end type
end forward

global type w_sg020_grupo from w_abc_mastdet_smpl
integer width = 3625
integer height = 2304
string title = "Mantenimiento de Roles  (SG020)"
dw_aplicaciones dw_aplicaciones
end type
global w_sg020_grupo w_sg020_grupo

forward prototypes
public subroutine of_resizepanels ()
end prototypes

public subroutine of_resizepanels ();//Overrides
Long		ll_Width, ll_Height

// Validate the controls.
If Not IsValid(idrg_Top) or Not IsValid(idrg_Bottom) Then
	Return 
End If

ll_Width = This.WorkSpaceWidth()
ll_Height = This.WorkspaceHeight() - p_pie.height

// Enforce a minimum window size
If ll_Height < idrg_Bottom.Y + 150 Then
	ll_Height = idrg_Bottom.Y + 150
End If

// Tengo que validar cual es la altura máxima para redimensionar


// Top processing
idrg_Top.Resize(ll_Width - idrg_Top.X, st_horizontal.Y - idrg_Top.Y)

					
// Bottom Procesing
idrg_Bottom.Move(idrg_bottom.x, st_horizontal.Y + cii_BarThickness)
idrg_Bottom.Resize(idrg_bottom.width, &
							ll_Height - idrg_Bottom.Y - cii_WindowBorder)

dw_aplicaciones.y = idrg_bottom.y
dw_aplicaciones.Resize( ll_Width - (cii_WindowBorder * 2), &
							ll_Height - idrg_Bottom.Y - cii_WindowBorder)

end subroutine

on w_sg020_grupo.create
int iCurrent
call super::create
this.dw_aplicaciones=create dw_aplicaciones
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_aplicaciones
end on

on w_sg020_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_aplicaciones)
end on

event ue_open_pre;call super::ue_open_pre;//f_centrar( this)
dw_aplicaciones.SetTransObject(SQLCA)
end event

event resize;//Overrite
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = ( newwidth / 3 ) - dw_detail.x - 10
dw_detail.height = p_pie.y - dw_detail.y - 10

dw_aplicaciones.x = dw_detail.x + dw_detail.width + 10 
dw_aplicaciones.width = newwidth - ( dw_detail.width + 10 )
dw_aplicaciones.height  = dw_detail.height 

uo_h.width		= newwidth
uo_h.of_resize( newwidth )
st_box.height = newheight - st_box.y - cii_WindowBorder

p_logo.x = uo_h.width - this.cii_WindowBorder - p_logo.width

p_pie.x 		= st_box.x + st_box.width
p_pie.width = newwidth - p_pie.x - this.cii_WindowBorder
p_pie.y 		= newheight - p_pie.height - this.cii_windowborder
end event

type p_pie from w_abc_mastdet_smpl`p_pie within w_sg020_grupo
end type

type ole_skin from w_abc_mastdet_smpl`ole_skin within w_sg020_grupo
end type

type uo_h from w_abc_mastdet_smpl`uo_h within w_sg020_grupo
end type

type st_box from w_abc_mastdet_smpl`st_box within w_sg020_grupo
end type

type phl_logonps from w_abc_mastdet_smpl`phl_logonps within w_sg020_grupo
end type

type p_mundi from w_abc_mastdet_smpl`p_mundi within w_sg020_grupo
end type

type p_logo from w_abc_mastdet_smpl`p_logo within w_sg020_grupo
end type

type st_horizontal from w_abc_mastdet_smpl`st_horizontal within w_sg020_grupo
end type

type st_filter from w_abc_mastdet_smpl`st_filter within w_sg020_grupo
end type

type uo_filter from w_abc_mastdet_smpl`uo_filter within w_sg020_grupo
end type

type dw_master from w_abc_mastdet_smpl`dw_master within w_sg020_grupo
integer width = 1865
integer height = 776
string dataobject = "d_grupo_tbl"
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1 
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
dw_detail.retrieve( dw_master.object.grupo[dw_master.getrow()] )
dw_aplicaciones.retrieve( dw_master.object.grupo[dw_master.getrow()] )
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])

dw_aplicaciones.retrieve( aa_id[1] )
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_sg020_grupo
integer x = 498
integer y = 1080
integer width = 1952
integer height = 1016
string dataobject = "d_grp_usr_tbl"
boolean livescroll = false
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cod_usr"
		ls_sql = "SELECT cod_usr AS CODIGO_usuario, " &
				  + "nombre AS nombre_usuario " &
				  + "FROM usuario " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_usr		[al_row] = ls_codigo
			this.object.nom_usuario	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_detail::itemchanged;call super::itemchanged;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_mensaje, ls_null

SetNull(ls_null)

choose case lower(dwo.name)
		
	case "cod_usr"
		SELECT nombre 
			into :ls_data
		FROM usuario 
		where cod_usr = :data
			and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de usuario no existe"
			gnvo_log.of_errorlog( ls_mensaje )
			Messagebox( "Error", "ls_mensaje")
			this.object.cod_usr		[row] = ls_null
			this.object.nom_usuario	[row] = ls_null
			return 1
		end if
		
		this.object.nom_usuario		[row] = ls_data
		return 2
		
		
end choose
end event

type dw_aplicaciones from u_dw_cns within w_sg020_grupo
integer x = 2510
integer y = 1080
integer width = 1943
integer height = 1020
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_grp_obj"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1 	
end event

event getfocus;call super::getfocus;if this.isvaliddataobject( ) then
	uo_filter.of_set_dw( this )
	uo_filter.of_retrieve_fields( )
end if

uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(this.RowCount()))
end event

