#include Class_UIADo.ahk

#SingleInstance force
F12::reload

;查看当前鼠标下的元素信息和它父亲
F10:: {
    _UIADo.seeUIE(UIA.ElementFromPoint())
    elFather := UIA.ElementFromPoint().GetParent()
    aRect := elFather.GetBoundingRectangle()
    _UIADo.seeUIE(elFather)
    msgbox(json.stringify(aRect, 4))
}

F9:: {
    if WinActive("ahk_class Chrome_WidgetWin_1") { ;谷歌浏览器
        if WinActive("百度一下") { ;百度模拟搜索
            idA := WinGetID()
            ;设置搜索内容
            elEdit := UIA.GetFocusedElement()
            elEdit.GetCurrentPattern("Value").SetValue("火冷-博客园")
            sleep(2000)
            ;点击搜索按钮
            el := UIA.FindElement(idA, "Button", "百度一下")
            el.GetCurrentPattern("Invoke").Invoke()
            return
        } else { ;谷歌获取网址
            _UIADo.seeUIE(UIA.ElementFromHandle(ControlGetHwnd("Chrome_RenderWidgetHostHWND1", "A")))
        }
    } else if WinActive("ahk_class WeChatMainWndForPC") { ;微信右键消息内容并点击多选
        if !WinExist("ahk_class CMenuWnd")
            send("{RButton}")
        WinWait("ahk_class CMenuWnd")
        try
            UIA.FindElement(WinGetID(), "MenuItem", "多选").ClickByMouse()
    } else {
        ;记事本测试
        run("notepad.exe")
        WinWaitActive("ahk_class Notepad")
        ControlSetText("123123", "Edit1")
        el := UIA.GetFocusedElement()
        msgbox("当前内容 = 123123`n确定后会尝试用 UIA 修改当前内容",,0x40000)
        el.GetCurrentPattern("Value").SetValue("修改后")
        tooltip("等待关闭记事本")
        WinWaitClose()
        tooltip

    ;环境变量(win10 测试通过)
    run("rundll32.exe sysdm.cpl,EditEnvironmentVariables")
    WinWaitActive("环境变量")
    hwnd := WinGetID() ;通过窗口找控件(非标准窗口要用到)
    ;msgbox("遍历所有按钮，按任意键继续")
    ;elWin := UIA.ElementFromHandle(hwnd)
    ;cond := UIA.CreatePropertyCondition("ControlType", "Button")
    ;for el in elWin.FindAll(cond)
    ;    el.see(0)

    msgbox("查找指定的按钮`n方式1",,0x40000)
    cond := UIA.CreateAndCondition(UIA.CreatePropertyCondition("ControlType", "Button"), UIA.CreatePropertyCondition("Name", "确定"))
    el := UIA.ElementFromHandle(hwnd).FindFirst(cond)
    _UIADo.seeUIE(el)

    msgbox("查找指定的按钮`n方式2",,0x40000)
    el := UIA.FindElement(hwnd, "Button", "确定")
    _UIADo.seeUIE(el)

    msgbox("点击新建按钮",,0x40000)
    el := UIA.FindElement(hwnd, "Button", "新建(N)...")
    el.GetCurrentPattern("Invoke").Invoke()

    msgbox("演示结束",,0x40000)
    }
}
