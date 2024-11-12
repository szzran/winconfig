; Load library
#Include komorebic.lib.ahk

; Programs
!Enter:: Run "wt.exe"
!+Enter:: Run "explorer.exe"

!q:: Minimize()
!+q:: Close()

; Focus windows
!f:: Focus("up")
!g:: Focus("right")
!d:: Focus("down")
!s:: Focus("left")

; Move windows
!+f:: Move("up")
!+g:: Move("right")
!+d:: Move("down")
!+s:: Move("left")


>!Enter:: Promote()

; Stack windows
!^f:: Stack("up")
!^g:: Stack("right")
!^d:: Stack("down")
!^s:: Stack("left")

!;:: Unstack()


; Resize
!=:: ResizeAxis("horizontal", "increase")
!-:: ResizeAxis("horizontal", "decrease")
!+=:: ResizeAxis("vertical", "increase")
!+-:: ResizeAxis("vertical", "decrease")

; Manipulate windows
!y:: ToggleFloat()
!^y:: ToggleMaximize()
!t:: ToggleMonocle()
!b:: ToggleMouseFollowsFocus()

; Window manager options
!r:: TogglePause()

; Monitors
!w:: CycleMonitor('next')

; Workspaces
!1:: FocusWorkspace(0)
!2:: FocusWorkspace(1)
!3:: FocusWorkspace(2)
!4:: FocusWorkspace(3)
!5:: FocusWorkspace(4)
!6:: FocusWorkspace(5)
!7:: FocusWorkspace(6)

; Move windows across workspaces
!+1:: MoveToWorkspace(0)
!+2:: MoveToWorkspace(1)
!+3:: MoveToWorkspace(2)
!+4:: MoveToWorkspace(3)
!+5:: MoveToWorkspace(4)
!+6:: MoveToWorkspace(5)
!+7:: MoveToWorkspace(6)

