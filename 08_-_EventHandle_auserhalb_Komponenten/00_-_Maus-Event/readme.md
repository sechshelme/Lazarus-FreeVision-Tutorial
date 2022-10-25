# 08 - EventHandle auserhalb Komponenten
## 00 - Maus-Event
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Man kann einen EventHandle im Dialog/Fenster abfangen, wen man die Maus bewegt/klickt.<br>
Im Hauptprogramm hat es dafür nichts besonders, dies alles läuft lokal im Dialog/Fenster ab.<br>
<hr><br>
Im Hauptprogramm wird nur der Dialog gebaut, aufgerufe und geschlossen.<br>
<br>
```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MouseDialog: PMyMouse;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmMouseAktion: begin
          MouseDialog := New(PMyMouse, Init);
          if ValidView(MouseDialog) <> nil then begin // Prüfen ob genügend Speicher.
            Desktop^.ExecView(MouseDialog);           // Dialog Mausaktion ausführen.
            Dispose(MouseDialog, Done);               // Dialog und Speicher frei geben.
          end;
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
<hr><br>
<b>Unit mit dem Mausaktions-Dialog.</b><br>
<br><br>
<br>
```pascal
unit MyDialog;
<br>
```
<br>
In dem Object sind die <b>PEditLine</b> globel deklariert, da diese später bei Mausaktionen modifiziert werden.<br>
<br>
```pascal
type
  PMyMouse = ^TMyMouse;
  TMyMouse = object(TDialog)
    EditMB,
    EditX, EditY: PInputLine;
<br>
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
<br>
```
<br>
Es wird ein Dialog mit EditLine, Label und Button gebaut.<br>
Einzig besonderes dort, die <b>Editlline</b> wird der Status auf <b>ReadOnly</b> gesetzt eigene Eingaben sind dort unerwünscht.<br>
<br>
```pascal
constructor TMyMouse.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 13);
  R.Move(23, 3);
  inherited Init(R, 'Mausaktion');
<br>
  // PosX
  R.Assign(25, 2, 30, 3);
  EditX := new(PInputLine, Init(R, 5));
  Insert(EditX);
  EditX^.State := sfDisabled or EditX^.State;    // ReadOnly
  R.Assign(5, 2, 20, 3);
  Insert(New(PLabel, Init(R, 'MausPosition ~X~:', EditX)));
<br>
  // PosY
  R.Assign(25, 4, 30, 5);
  EditY := new(PInputLine, Init(R, 5));
  EditY^.State := sfDisabled or EditY^.State;    // ReadOnly
  Insert(EditY);
  R.Assign(5, 4, 20, 5);
  Insert(New(PLabel, Init(R, 'MausPosition ~Y~:', EditY)));
<br>
  // Maus-Tasten
  R.Assign(25, 7, 32, 8);
  EditMB := new(PInputLine, Init(R, 7));
  EditMB^.State := sfDisabled or EditMB^.State;  // ReadOnly
  EditMB^.Data^:= 'oben';                        // Anfangs ist die Taste oben.
  Insert(EditMB);
  R.Assign(5, 7, 20, 8);
  Insert(New(PLabel, Init(R, '~M~austaste:', EditMB)));
<br>
  // Ok-Button
  R.Assign(27, 10, 37, 12);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
<br>
```
<br>
Im EventHandle sieht man gut, das dort die Mausaktionen abgefangen werden.<br>
Die Maus-Daten werden an die <b>EditLines</b> ausgegeben.<br>
<br>
```pascal
procedure TMyMouse.HandleEvent(var Event: TEvent);
var
  Mouse : TPoint;
begin
  inherited HandleEvent(Event);
<br>
  case Event.What of
    evMouseDown: begin                 // Taste wurde gedrückt.
      EditMB^.Data^:= 'unten';
      EditMB^.Draw;
    end;
    evMouseUp: begin                   // Taste wurde losgelassen.
      EditMB^.Data^:= 'oben';
      EditMB^.Draw;
    end;
    evMouseMove: begin                 // Maus wurde bewegt.
      MakeLocal (Event.Where, Mouse);  // Mausposition ermitteln.
      EditX^.Data^:= IntToStr(Mouse.X);
      EditX^.Draw;
      EditY^.Data^:= IntToStr(Mouse.Y);
      EditY^.Draw;
    end;
  end;
<br>
end;
<br>
```
<br>

