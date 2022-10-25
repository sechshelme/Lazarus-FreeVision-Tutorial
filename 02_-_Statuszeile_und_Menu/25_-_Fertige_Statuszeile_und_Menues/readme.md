# 02 - Statuszeile und Menu
## 25 - Fertige Statuszeile und Menues
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

<br>

---
<br>

```pascal
  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;
<br>
    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF, StdStatusKeys(nil), nil)));
  end;
```
<br>

<br>
```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        StdFileMenuItems (nil)),
      NewSubMenu('~B~earbeiten', hcNoContext, NewMenu(
         StdEditMenuItems (nil)),
      NewSubMenu('~F~enster', hcNoContext, NewMenu(
        StdWindowMenuItems(nil)), nil))))));
  end;
```
<br>

