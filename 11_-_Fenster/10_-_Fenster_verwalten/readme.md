# 11 - Fenster
## 10 - Fenster verwalten
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

---
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
        NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),
      NewSubMenu('~F~enster', hcNoContext, NewMenu(
        NewItem('~N~ebeneinander', '', kbNoKey, cmTile, hcNoContext,
        NewItem(#154'ber~l~append', '', kbNoKey, cmCascade, hcNoContext,
        NewItem('~A~lle schliessen', '', kbNoKey, cmCloseAll, hcNoContext,
        NewItem('Anzeige ~e~rneuern', '', kbNoKey, cmRefresh, hcNoContext,
        NewLine(
        NewItem('Gr'#148'sse/~P~osition', 'Ctrl+F5', kbCtrlF5, cmResize, hcNoContext,
        NewItem('Ver~g~'#148'ssern', 'F5', kbF5, cmZoom, hcNoContext,
        NewItem('~N~'#132'chstes', 'F6', kbF6, cmNext, hcNoContext,
        NewItem('~V~orheriges', 'Shift+F6', kbShiftF6, cmPrev, hcNoContext,
        NewLine(
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, Nil)))))))))))), nil)))));
<br>
  end;
```
<br>

<br>

```pascal
  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    R: TRect;
  const
    WinCounter: integer = 0;                    // Zählt Fenster
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PWindow, Init(R, 'Fenster', WinCounter));
    Win^.Options := Win^.Options or ofTileable; // Für Tile und Cascade
<br>
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
  end;
```
<br>

<br>

```pascal
  procedure TMyApp.CloseAll;
<br>
    procedure SendClose(P: PView);
    begin
      Message(P, evCommand, cmClose, nil);
    end;
<br>
  begin
    Desktop^.ForEach(@SendClose);
  end;
```
<br>

<br>
```pascal
<br>
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows;    // Fenster erzeugen.
        end;
        cmCloseAll:begin
          CloseAll;      // Schliesst alle Fenster.
        end;
        cmRefresh: begin
          ReDraw;        // Anwendung neu zeichnen.
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```
<br>

