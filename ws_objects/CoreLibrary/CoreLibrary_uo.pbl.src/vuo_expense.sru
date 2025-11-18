$PBExportHeader$vuo_expense.sru
forward
global type vuo_expense from userobject
end type
type ddplb_1 from dropdownpicturelistbox within vuo_expense
end type
type dw_fin_data_graph_detail from datawindow within vuo_expense
end type
type dw_expense from datawindow within vuo_expense
end type
type dw_year from datawindow within vuo_expense
end type
end forward

global type vuo_expense from userobject
integer width = 3502
integer height = 3316
long backcolor = 16777215
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
ddplb_1 ddplb_1
dw_fin_data_graph_detail dw_fin_data_graph_detail
dw_expense dw_expense
dw_year dw_year
end type
global vuo_expense vuo_expense

type variables
datastore ids_findata
end variables

forward prototypes
public subroutine of_retrieve (string as_year)
end prototypes

public subroutine of_retrieve (string as_year);dw_expense.retrieve(as_year)

dw_year.retrieve(as_year)

end subroutine

on vuo_expense.create
this.ddplb_1=create ddplb_1
this.dw_fin_data_graph_detail=create dw_fin_data_graph_detail
this.dw_expense=create dw_expense
this.dw_year=create dw_year
this.Control[]={this.ddplb_1,&
this.dw_fin_data_graph_detail,&
this.dw_expense,&
this.dw_year}
end on

on vuo_expense.destroy
destroy(this.ddplb_1)
destroy(this.dw_fin_data_graph_detail)
destroy(this.dw_expense)
destroy(this.dw_year)
end on

event constructor;ids_findata = create datastore
ids_findata.dataobject = 'd_fin_data'
ids_findata.setTransObject(sqlca)
ids_findata.retrieve()


end event

type ddplb_1 from dropdownpicturelistbox within vuo_expense
integer x = 2537
integer width = 768
integer height = 448
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string item[] = {"2003","2004","2005","2006"}
integer itempictureindex[] = {1,2,3,4}
string picturename[] = {"res\Xbutton01.jpg","res\Xbutton02.jpg","res\Xbutton03.jpg","res\Xbutton04.jpg"}
integer picturewidth = 16
integer pictureheight = 16
long picturemaskcolor = 536870912
end type

event constructor;SelectItem(1)
end event

event selectionchanged;of_retrieve(text)
end event

type dw_fin_data_graph_detail from datawindow within vuo_expense
integer y = 1596
integer width = 1865
integer height = 1184
integer taborder = 30
boolean border = false
boolean livescroll = true
end type

event constructor;this.SetTransObject(SQLCA)
end event

type dw_expense from datawindow within vuo_expense
integer x = 1861
integer y = 124
integer width = 1609
integer height = 3168
integer taborder = 20
string title = "none"
boolean border = false
boolean livescroll = true
end type

event constructor;this.setTransObject(sqlca)
this.retrieve('2003')
end event

event rowfocuschanged;string ls_quarter
string ls_year,ls_desc

if currentrow>0 then 
	
	ls_year= getitemstring(currentrow,'year')
	ls_desc = getitemstring(currentrow,'description')
	dw_fin_data_graph_detail.retrieve(ls_year,ls_desc)


	ls_quarter = getitemstring(currentrow,'quarter')

	Choose case ls_quarter
		case 'Q1'
			dw_fin_data_graph_detail.post SetDataPieExplode('gr_1',1,1,20)
		case 'Q2'
			dw_fin_data_graph_detail.post SetDataPieExplode('gr_1',1,2,20)
		case 'Q3'
			dw_fin_data_graph_detail.post SetDataPieExplode('gr_1',1,3,20)
		case 'Q4'
			dw_fin_data_graph_detail.post SetDataPieExplode('gr_1',1,4,20)
	end choose
	
else
	dw_fin_data_graph_detail.reset()
end if	
end event

type dw_year from datawindow within vuo_expense
integer y = 124
integer width = 1865
integer height = 1472
integer taborder = 10
string title = "none"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event constructor;this.SetTransObject(SQLCA)
this.Retrieve('2003')
end event

