# 08 - EventHandle auserhalb Komponenten
## 00 - Maus-Event
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Man kann einen EventHandle im Dialog/Fenster abfangen, wen man die Maus bewegt/klickt.<br>
Im Hauptprogramm hat es dafür nichts besonders, dies alles läuft lokal im Dialog/Fenster ab.<br>
<hr><br>
Im Hauptprogramm wird nur der Dialog gebaut, aufgerufe und geschlossen.<br>
<pre><code=pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
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
  end;</code></pre>
<hr><br>
<b>Unit mit dem Mausaktions-Dialog.</b><br>
<br><br>
<pre><code>unit MyDialog;
</code></pre>
In dem Object sind die <b>PEditLine</b> globel deklariert, da diese später bei Mausaktionen modifiziert werden.<br>
<pre><code>type
  PMyMouse = ^TMyMouse;
  TMyMouse = object(TDialog)
    EditMB,
    EditX, EditY: PInputLine;
<br>
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
</code></pre>
Es wird ein Dialog mit EditLine, Label und Button gebaut.<br>
Einzig besonderes dort, die <b>Editlline</b> wird der Status auf <b>ReadOnly</b> gesetzt eigene Eingaben sind dort unerwünscht.<br>
<pre><code>constructor TMyMouse.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 13);</font>
  R.Move(23, 3);</font>
  inherited Init(R, 'Mausaktion');</font>
<br>
  // PosX
  R.Assign(25, 2, 30, 3);</font>
  EditX := new(PInputLine, Init(R, 5));</font>
  Insert(EditX);
  EditX^.State := sfDisabled or EditX^.State;    // ReadOnly
  R.Assign(5, 2, 20, 3);</font>
  Insert(New(PLabel, Init(R, 'MausPosition ~X~:', EditX)));</font>
<br>
  // PosY
  R.Assign(25, 4, 30, 5);</font>
  EditY := new(PInputLine, Init(R, 5));</font>
  EditY^.State := sfDisabled or EditY^.State;    // ReadOnly
  Insert(EditY);
  R.Assign(5, 4, 20, 5);</font>
  Insert(New(PLabel, Init(R, 'MausPosition ~Y~:', EditY)));</font>
<br>
  // Maus-Tasten
  R.Assign(25, 7, 32, 8);</font>
  EditMB := new(PInputLine, Init(R, 7));</font>
  EditMB^.State := sfDisabled or EditMB^.State;  // ReadOnly
  EditMB^.Data^:= 'oben';                        // Anfangs ist die Taste oben.</font>
  Insert(EditMB);
  R.Assign(5, 7, 20, 8);</font>
  Insert(New(PLabel, Init(R, '~M~austaste:', EditMB)));</font>
<br>
  // Ok-Button
  R.Assign(27, 10, 37, 12);</font>
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
end;
</code></pre>
Im EventHandle sieht man gut, das dort die Mausaktionen abgefangen werden.<br>
Die Maus-Daten werden an die <b>EditLines</b> ausgegeben.<br>
<pre><code>procedure TMyMouse.HandleEvent(var Event: TEvent);
var
  Mouse : TPoint;
begin
  inherited HandleEvent(Event);
<br>
  case Event.What of
    evMouseDown: begin                 // Taste wurde gedrückt.
      EditMB^.Data^:= 'unten';</font>
      EditMB^.Draw;
    end;
    evMouseUp: begin                   // Taste wurde losgelassen.
      EditMB^.Data^:= 'oben';</font>
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
</code></pre>
<br>
