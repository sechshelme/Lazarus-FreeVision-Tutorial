# 02 - Statuszeile und Menu
## 25 - Fertige Statuszeile und Menues

![image.png](image.png)

Für die Statuszeile und das Menü gibt es fertige Items, aber ich bevorzuge es, die Items selbst zu erstellen.
Die fetigen Items sind nur in Englisch.
Die Statuszeile ist Textlos, das einzige, sie bringt Schnellkomandos mit. ( cmQuit, cmMenu, cmClose, cmZoom, cmNext, cmPrev )
Bis aus **OS shell** und **Exit** passiert nichts.

---
Mit **StdStatusKeys(...** wird eine Statuszeile estellt, aber wie oben beschrieben, sieht man keinne Text.

```pascal
  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF, StdStatusKeys(nil), nil)));
  end;
```

Fur das Menü gibt es 3 fertige Items, für Datei, Bearbeiten und Fenster, aber eben in Englisch.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        StdFileMenuItems (nil)),
      NewSubMenu('~B~earbeiten', hcNoContext, NewMenu(
         StdEditMenuItems (nil)),
      NewSubMenu('~F~enster', hcNoContext, NewMenu(
        StdWindowMenuItems(nil)), nil))))));
  end;
```


