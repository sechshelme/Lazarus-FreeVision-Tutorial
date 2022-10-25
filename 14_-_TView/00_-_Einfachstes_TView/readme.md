# 14 - TView
## 00 - Einfachstes TView
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

<br>
---
<br>

```pascal
  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewView;          // View erzeugen.
  end;
```
<br>

<br>
```pascal
  procedure TMyApp.NewView;
  var
    Win: PView;
    R: TRect;
  begin
    R.Assign(10, 5, 60, 20);
    Win := New(PView, Init(R));
<br>
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;
```
<br>

