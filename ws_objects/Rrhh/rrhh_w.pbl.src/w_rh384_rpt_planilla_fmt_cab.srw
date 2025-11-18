$PBExportHeader$w_rh384_rpt_planilla_fmt_cab.srw
forward
global type w_rh384_rpt_planilla_fmt_cab from w_abc_master_smpl
end type
type ddlb_tip_trab from u_ddlb_lista within w_rh384_rpt_planilla_fmt_cab
end type
type st_1 from statictext within w_rh384_rpt_planilla_fmt_cab
end type
type em_ini from editmask within w_rh384_rpt_planilla_fmt_cab
end type
type em_fin from editmask within w_rh384_rpt_planilla_fmt_cab
end type
type ddlb_origen from u_ddlb_lista within w_rh384_rpt_planilla_fmt_cab
end type
type st_2 from statictext within w_rh384_rpt_planilla_fmt_cab
end type
type hpb_1 from hprogressbar within w_rh384_rpt_planilla_fmt_cab
end type
type gb_1 from groupbox within w_rh384_rpt_planilla_fmt_cab
end type
end forward

global type w_rh384_rpt_planilla_fmt_cab from w_abc_master_smpl
integer width = 2903
integer height = 1504
string title = "(RH384) Cabecera de Formato de Planilla"
string menuname = "m_impresion"
windowstate windowstate = maximized!
ddlb_tip_trab ddlb_tip_trab
st_1 st_1
em_ini em_ini
em_fin em_fin
ddlb_origen ddlb_origen
st_2 st_2
hpb_1 hpb_1
gb_1 gb_1
end type
global w_rh384_rpt_planilla_fmt_cab w_rh384_rpt_planilla_fmt_cab

on w_rh384_rpt_planilla_fmt_cab.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.ddlb_tip_trab=create ddlb_tip_trab
this.st_1=create st_1
this.em_ini=create em_ini
this.em_fin=create em_fin
this.ddlb_origen=create ddlb_origen
this.st_2=create st_2
this.hpb_1=create hpb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_tip_trab
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_ini
this.Control[iCurrent+4]=this.em_fin
this.Control[iCurrent+5]=this.ddlb_origen
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.hpb_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_rh384_rpt_planilla_fmt_cab.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_tip_trab)
destroy(this.st_1)
destroy(this.em_ini)
destroy(this.em_fin)
destroy(this.ddlb_origen)
destroy(this.st_2)
destroy(this.hpb_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
end event

event ue_query_retrieve;integer li_print
string ls_cod_origen, ls_origen, ls_nombre, ls_ruc, ls_direccion, ls_tip_trab
long ll_ini, ll_fin, ll_nro
//override

dw_master.reset( )

ls_tip_trab = trim(left(ddlb_tip_trab.text, 50))
ls_cod_origen = trim(right(ddlb_origen.text, 3))

li_print = 0

ll_ini = long(em_ini.text)
ll_fin = long(em_fin.text)

select e.nombre, e.ruc
   into :ls_nombre, :ls_ruc
	from empresa e
	   inner join genparam g on e.cod_empresa = g.cod_empresa
	where g.reckey = '1';

if sqlca.sqlcode <> 0 then
	messagebox(this.title, 'No se pudo encotrar los datos de la emrpesa')
	return
end if

select o.nombre, trim(trim(trim(trim(trim(trim(trim(trim(nvl(o.dir_calle, '') || ' ' || nvl(o.dir_numero, '')) || ' ' || nvl(o.dir_numero, '')) || ' ' || nvl(o.dir_lote, '')) || ' ' || nvl(o.dir_mnz, '')) || ' ' || nvl(o.dir_urbanizacion, '')) || ' ' || nvl(o.dir_distrito, '')) || ' ' || nvl(o.dir_departamento, '')) || ' ' || nvl(o.dir_provincia, ''))  
    into :ls_origen, :ls_direccion
	 from origen o
	 where trim(o.cod_origen) = trim(:ls_cod_origen);

if sqlca.sqlcode <> 0 then
	messagebox(this.title, 'No se pudo encotrar el origen')
	return
end if

if dw_master.retrieve( ) < 1 then
	messagebox(this.title, 'No se pudo cargar el reporte')
	return
end if

if isnull(ls_ruc)  or trim(ls_ruc) = '' then ls_ruc = ' --- NO SE HA DEFINIDO EL RUC --- '
if isnull(ls_nombre) or trim(ls_nombre) = '' then ls_nombre = ' --- NO SE HA DEFINIDO EL NOMBRE --- '
if isnull(ls_direccion)  or trim(ls_direccion) = '' then ls_direccion = ' --- NO SE HA DEFINIDO LA DIRECCION --- '

dw_master.object.p_logo.filename = gs_logo
dw_master.object.st_empresa.text = ls_origen
dw_master.object.st_empresa_extendido.text = 'EMPRESA: ' + upper(ls_nombre) + '~rDIRECCION: ' + upper(ls_direccion) +  '~rR.U.C.: ' + upper(ls_ruc)
dw_master.object.st_titulo.text = "PLANILLA DE " + upper(trim (ls_tip_trab))


OpenWithParm(w_print_opt, dw_master)

li_print = Message.DoubleParm

If li_print = -1 Then Return


hpb_1.minposition = ll_ini
hpb_1.maxposition = ll_fin

for ll_nro = ll_ini to ll_fin
	dw_master.object.st_numero.text = 'Nº ' + right('00000000000' + trim(string(ll_nro)), 10)
	dw_master.print(true)
	hpb_1.position = ll_nro
next

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh384_rpt_planilla_fmt_cab
integer y = 216
integer width = 2811
integer height = 920
string dataobject = "d_rh_planilla_fmt_cab_cpst"
end type

event dw_master::constructor;call super::constructor;is_dwform =  'form' 
ii_ck[1] = 1
end event

type ddlb_tip_trab from u_ddlb_lista within w_rh384_rpt_planilla_fmt_cab
integer x = 439
integer y = 56
integer height = 776
boolean bringtotop = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_tipo_trabajador_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 3							// Longitud del campo 2

end event

type st_1 from statictext within w_rh384_rpt_planilla_fmt_cab
integer x = 5
integer y = 68
integer width = 425
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Trabaador:"
boolean focusrectangle = false
end type

type em_ini from editmask within w_rh384_rpt_planilla_fmt_cab
integer x = 1312
integer y = 56
integer width = 343
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###,###,##0"
end type

type em_fin from editmask within w_rh384_rpt_planilla_fmt_cab
integer x = 1687
integer y = 56
integer width = 343
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###,###,##0"
end type

type ddlb_origen from u_ddlb_lista within w_rh384_rpt_planilla_fmt_cab
integer x = 2254
integer y = 56
integer width = 567
integer height = 776
integer taborder = 30
boolean bringtotop = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_origen_usuario_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 2							// Longitud del campo 2

end event

event ue_item_add;//override
Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

ll_rows = ids_Data.Retrieve(gs_user)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, ' ')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

if ll_rows >= 1 then this.selectitem(1)
end event

type st_2 from statictext within w_rh384_rpt_planilla_fmt_cab
integer x = 2075
integer y = 68
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_rh384_rpt_planilla_fmt_cab
integer y = 168
integer width = 2811
integer height = 40
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 1
integer setstep = 10
end type

type gb_1 from groupbox within w_rh384_rpt_planilla_fmt_cab
integer x = 1294
integer width = 768
integer height = 164
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango:"
end type

