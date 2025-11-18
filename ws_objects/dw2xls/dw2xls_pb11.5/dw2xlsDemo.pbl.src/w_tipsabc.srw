$PBExportHeader$w_tipsabc.srw
forward
global type w_tipsabc from window
end type
type dw_1 from datawindow within w_tipsabc
end type
type st_1 from statictext within w_tipsabc
end type
end forward

global type w_tipsabc from window
integer width = 1723
integer height = 440
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_1 dw_1
st_1 st_1
end type
global w_tipsabc w_tipsabc

on w_tipsabc.create
this.dw_1=create dw_1
this.st_1=create st_1
this.Control[]={this.dw_1,&
this.st_1}
end on

on w_tipsabc.destroy
destroy(this.dw_1)
destroy(this.st_1)
end on

event open;IF Message.StringParm<>"" Then
	st_1.Text=Message.StringParm
END IF

dw_1.modify("st_text1.text='"+st_1.Text+"' st_text.Text='"+st_1.Text+"'") 
end event

type dw_1 from datawindow within w_tipsabc
integer x = 73
integer y = 140
integer width = 1513
integer height = 200
integer taborder = 10
string title = "none"
string dataobject = "d_wait"
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_tipsabc
boolean visible = false
integer x = 133
integer y = 76
integer width = 914
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "正在进行数据处理，请稍候........."
boolean focusrectangle = false
end type

