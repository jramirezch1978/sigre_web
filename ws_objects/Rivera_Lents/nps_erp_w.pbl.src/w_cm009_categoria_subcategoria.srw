$PBExportHeader$w_cm009_categoria_subcategoria.srw
forward
global type w_cm009_categoria_subcategoria from w_abc_mastdet_smpl_v
end type
type st_1 from statictext within w_cm009_categoria_subcategoria
end type
type st_2 from statictext within w_cm009_categoria_subcategoria
end type
end forward

global type w_cm009_categoria_subcategoria from w_abc_mastdet_smpl_v
integer width = 4123
integer height = 2520
string title = "[CM009] Categorias - Sub Categorias "
st_1 st_1
st_2 st_2
end type
global w_cm009_categoria_subcategoria w_cm009_categoria_subcategoria

forward prototypes
public subroutine of_resize_others ()
end prototypes

public subroutine of_resize_others ();st_1.x = dw_master.x
st_1.width = dw_master.width

st_2.x = dw_detail.x
st_2.width = dw_detail.width
end subroutine

on w_cm009_categoria_subcategoria.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_cm009_categoria_subcategoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_modify;call super::ue_modify;int li_protect_categoria, li_protect_subcateg

li_protect_categoria = integer(dw_master.Object.cat_art.Protect)

IF li_protect_categoria = 0 THEN
   dw_master.Object.cat_art.Protect = 1
END IF

li_protect_subcateg = integer(dw_detail.Object.cod_sub_cat.Protect)

IF li_protect_subcateg = 0 THEN
   dw_detail.Object.cod_sub_cat.Protect = 1
END IF




end event

event ue_open_pre;call super::ue_open_pre;
ii_pregunta_delete = 1

dw_master.Retrieve(gnvo_app.invo_empresa.is_empresa)
end event

type p_pie from w_abc_mastdet_smpl_v`p_pie within w_cm009_categoria_subcategoria
end type

type ole_skin from w_abc_mastdet_smpl_v`ole_skin within w_cm009_categoria_subcategoria
end type

type uo_h from w_abc_mastdet_smpl_v`uo_h within w_cm009_categoria_subcategoria
end type

type st_box from w_abc_mastdet_smpl_v`st_box within w_cm009_categoria_subcategoria
end type

type phl_logonps from w_abc_mastdet_smpl_v`phl_logonps within w_cm009_categoria_subcategoria
end type

type p_mundi from w_abc_mastdet_smpl_v`p_mundi within w_cm009_categoria_subcategoria
end type

type p_logo from w_abc_mastdet_smpl_v`p_logo within w_cm009_categoria_subcategoria
end type

type st_filter from w_abc_mastdet_smpl_v`st_filter within w_cm009_categoria_subcategoria
end type

type uo_filter from w_abc_mastdet_smpl_v`uo_filter within w_cm009_categoria_subcategoria
end type

type dw_master from w_abc_mastdet_smpl_v`dw_master within w_cm009_categoria_subcategoria
integer x = 512
integer y = 392
integer width = 1778
integer height = 1648
string dataobject = "d_abc_articulo_categ_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

is_dwform = 'tabular'

//ib_delete_cascada = true
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve( aa_id[1])

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_servicio	[al_row] = '0'
this.object.flag_estado		[al_row] = '1'
this.object.cod_empresa		[al_row] = gnvo_App.invo_empresa.is_empresa
end event

event dw_master::itemchanged;call super::itemchanged;Long ll_i

this.AcceptText()

if lower(dwo.name) = 'flag_servicio' then
	for ll_i = 1 to dw_detail.RowCount()
		dw_detail.object.flag_servicio[ll_i] = data
		dw_detail.ii_update = 1
	next
end if	
end event

type dw_detail from w_abc_mastdet_smpl_v`dw_detail within w_cm009_categoria_subcategoria
integer x = 2327
integer y = 392
integer width = 1742
integer height = 1644
string dataobject = "d_abc_articulo_sub_categ_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 3	      // columnas que recibimos del master

end event

event dw_detail::itemerror;call super::itemerror;Return 1		// Fuerza a no mostrar mensaje
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this )
end event

event dw_detail::doubleclicked;call super::doubleclicked;str_parametros sl_param
String ls_provee, ls_prot
Long ln_mes, ln_ano

this.AcceptText()
ls_prot = this.Describe( "cod_calculo.Protect")
if ls_prot = '1' then return

if dwo.name = 'cod_calculo'  then
	sl_param.dw1 = "d_sel_calculos_x_tipo"
	sl_param.titulo = "Calculo"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2
	//sl_param.retrieve = 'S'
	sl_param.tipo = '1S'
	sl_param.string1 = 'P'

	OpenWithParm( w_lista, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then		
		this.object.cod_calculo[this.getrow()] = sl_param.field_ret[1]
//		this.object.desc_calculo[this.getrow()] = sl_param.field_ret[2]
		ii_update = 1
	END IF		
END IF

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() <> 0 then
	this.object.flag_servicio[al_row] = dw_master.object.flag_servicio [dw_master.GetRow()]
end if

this.object.flag_estado 	[al_row] = '1'
end event

type st_vertical from w_abc_mastdet_smpl_v`st_vertical within w_cm009_categoria_subcategoria
integer x = 2299
integer y = 392
end type

type st_1 from statictext within w_cm009_categoria_subcategoria
integer x = 512
integer y = 300
integer width = 1778
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
boolean enabled = false
string text = "Categorias"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm009_categoria_subcategoria
integer x = 2327
integer y = 300
integer width = 1742
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
boolean enabled = false
string text = "Sub Categorias"
alignment alignment = center!
boolean focusrectangle = false
end type

