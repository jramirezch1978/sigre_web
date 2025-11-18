$PBExportHeader$uo_w_empresas.sru
forward
global type uo_w_empresas from userobject
end type
type dw_master from datawindow within uo_w_empresas
end type
end forward

global type uo_w_empresas from userobject
integer width = 3502
integer height = 3316
long backcolor = 16777215
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_master dw_master
end type
global uo_w_empresas uo_w_empresas

type variables
datastore ids_findata
end variables

forward prototypes
public subroutine of_retrieve (string as_year)
end prototypes

public subroutine of_retrieve (string as_year);dw_master.retrieve()

end subroutine

on uo_w_empresas.create
this.dw_master=create dw_master
this.Control[]={this.dw_master}
end on

on uo_w_empresas.destroy
destroy(this.dw_master)
end on

event constructor;ids_findata = create datastore
ids_findata.dataobject = 'd_fin_data'
ids_findata.setTransObject(sqlca)
ids_findata.retrieve()


end event

type dw_master from datawindow within uo_w_empresas
integer y = 240
integer width = 3282
integer height = 1472
integer taborder = 10
string title = "none"
string dataobject = "d_abc_empresas_ff"
boolean border = false
boolean livescroll = true
end type

event constructor;this.SetTransObject(SQLCA)
this.Retrieve('2003')
end event

