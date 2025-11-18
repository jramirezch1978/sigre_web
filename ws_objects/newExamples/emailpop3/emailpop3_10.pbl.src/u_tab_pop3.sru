$PBExportHeader$u_tab_pop3.sru
forward
global type u_tab_pop3 from u_tab
end type
type tabpage_html from u_tabpg_html within u_tab_pop3
end type
type tabpage_html from u_tabpg_html within u_tab_pop3
end type
type tabpage_text from u_tabpg_text within u_tab_pop3
end type
type tabpage_text from u_tabpg_text within u_tab_pop3
end type
type tabpage_attachments from u_tabpg_attachments within u_tab_pop3
end type
type tabpage_attachments from u_tabpg_attachments within u_tab_pop3
end type
type tabpage_raw from u_tabpg_raw within u_tab_pop3
end type
type tabpage_raw from u_tabpg_raw within u_tab_pop3
end type
end forward

global type u_tab_pop3 from u_tab
integer width = 3483
integer height = 1784
tabpage_html tabpage_html
tabpage_text tabpage_text
tabpage_attachments tabpage_attachments
tabpage_raw tabpage_raw
end type
global u_tab_pop3 u_tab_pop3

type variables
Integer ii_msgnum
String is_parts[]
String is_types[]

end variables

forward prototypes
public subroutine of_load (integer ai_msgnum)
end prototypes

public subroutine of_load (integer ai_msgnum);// save the message number
ii_msgnum = ai_msgnum

// split the raw message into parts
gn_pop3.of_MsgBody(ai_msgnum, is_parts, is_types)

// load the tabpages
tabpage_html.of_Load()
tabpage_text.of_Load()
tabpage_attachments.of_Load()
tabpage_raw.of_Load()

end subroutine

on u_tab_pop3.create
this.tabpage_html=create tabpage_html
this.tabpage_text=create tabpage_text
this.tabpage_attachments=create tabpage_attachments
this.tabpage_raw=create tabpage_raw
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_html
this.Control[iCurrent+2]=this.tabpage_text
this.Control[iCurrent+3]=this.tabpage_attachments
this.Control[iCurrent+4]=this.tabpage_raw
end on

on u_tab_pop3.destroy
call super::destroy
destroy(this.tabpage_html)
destroy(this.tabpage_text)
destroy(this.tabpage_attachments)
destroy(this.tabpage_raw)
end on

type tabpage_html from u_tabpg_html within u_tab_pop3
integer x = 18
integer y = 100
integer width = 3447
integer height = 1668
end type

type tabpage_text from u_tabpg_text within u_tab_pop3
integer x = 18
integer y = 100
integer width = 3447
integer height = 1668
end type

type tabpage_attachments from u_tabpg_attachments within u_tab_pop3
integer x = 18
integer y = 100
integer width = 3447
integer height = 1668
end type

type tabpage_raw from u_tabpg_raw within u_tab_pop3
integer x = 18
integer y = 100
integer width = 3447
integer height = 1668
end type

