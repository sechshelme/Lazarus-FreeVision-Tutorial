# 12 - Editor
## 00 - Einfaches Editor-Fenster

![image.png](image.png)

Das Fenster ist nun ein Text-Editor, das man diese Funktion erreicht, nimmt man ein **PEditWindow**.
Die Verwaltung der Fenster ist gleich, wie bei einem **TWindow**.

---
Einfügen eines leeren Editorfensters.

```pascal
  procedure TMyApp.NewWindows;
  var
    Win: PEditWindow;
    R: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PEditWindow, Init(R, '', WinCounter));

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin                // Fügt das Fenster ein.
      Dec(WinCounter);
    end;
  end;
```


