$PBExportHeader$w_abc_carnet_trabajador_as104.srw
forward
global type w_abc_carnet_trabajador_as104 from w_abc_master
end type
type uo_1 from u_cst_quick_search within w_abc_carnet_trabajador_as104
end type
type st_1 from statictext within w_abc_carnet_trabajador_as104
end type
end forward

global type w_abc_carnet_trabajador_as104 from w_abc_master
int Width=1792
int Height=1632
boolean TitleBar=true
string Title="Asignación de Carnet a los Trabajadores (AS104)"
string MenuName="m_abc_master_smpl"
uo_1 uo_1
st_1 st_1
end type
global w_abc_carnet_trabajador_as104 w_abc_carnet_trabajador_as104

type variables
string is_codigo
end variables

on w_abc_carnet_trabajador_as104.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_1=create uo_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.st_1
end on

on w_abc_carnet_trabajador_as104.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.st_1)
end on

event ue_modify;call super::ue_modify;int li_protect
li_protect = integer(dw_master.Object.carnet_trabajador.Protect)

IF li_protect = 0 THEN
   dw_master.Object.carnet_trabajador.Protect = 1
END IF

end event

event ue_open_pre;call super::ue_open_pre;of_position_window(900,150)
uo_1.of_set_dw('d_maestro_lista_tbl')
uo_1.of_set_field('apel_paterno')

uo_1.of_retrieve_lista()
uo_1.of_sort_lista()
uo_1.of_protect()

end event

type dw_master from w_abc_master`dw_master within w_abc_carnet_trabajador_as104
int X=0
int Y=864
int Width=1737
int Height=580
boolean BringToTop=true
string DataObject="d_carnet_trabajador_tbl"
boolean VScrollBar=true
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'  // Tabular, grid, form (default)
ii_ck[1] = 1           // Forma el PK
ii_ck[2] = 2           // Forma el PK
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;Int li_count 
String ls_protect
//String ls_carnet
//ls_carnet=uo_1.dw_lista.object.carnet_trabaj[uo_1.dw_lista.getrow()]

this.setitem(al_row,"cod_trabajador",is_codigo)
ls_protect=dw_master.Describe("cod_trabajador.protect")

IF ls_protect='0' THEN
  	dw_master.of_column_protect('cod_trabajador')
END IF

end event

type uo_1 from u_cst_quick_search within w_abc_carnet_trabajador_as104
int X=0
int Y=4
int Width=1737
int Height=716
int TabOrder=10
boolean BringToTop=true
end type

on uo_1.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;dw_master.Retrieve(aa_id)
is_codigo=aa_id

end event

type st_1 from statictext within w_abc_carnet_trabajador_as104
int Y=748
int Width=1737
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="DETALLE DE CARNET"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=67108864
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
boolean Underline=true
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

