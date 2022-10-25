# 14 - TView
## 05 - TView erweitern
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<b>TView</b>, ist die unterste Ebene von allen Fenster, Dialog, Button, etc.<br>
Au diesem Grund habe ich dieses kleine Beispiel von <b>TView</b> gemacht.<br>
<hr><br>
Beim Fenster erzeugen, ist noch ein Counter hinzugekommen.<br>
Wen man bei den Fenster eine überlappend oder nebeneinader Darstellung will, muss man noch den Status <b>ofTileable</b> setzen.<br>
<pre><code=pascal>  procedure TMyApp.NewWindows;
  var
    Win: PMyView;
    R: TRect;
  const
    WinCounter: integer = 0;                    // Zählt Fenster</font>
  begin
    R.Assign(0, 0, 60, 20);</font>
    Inc(WinCounter);
    Win := New(PMyView, Init(R));
    Win^.Options := Win^.Options or ofTileable; // Für Tile und Cascade
<br>
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
  end;</code></pre>
Da es im View keine <b>cmClose</b> Abarbeitung gibt, wird manuell in einer Schleife überprüft, ob es Fenster gibt, wen ja, löschen.<br>
<pre><code=pascal>procedure TMyApp.CloseAll;
var
  v: PView;
begin
  v := Desktop^.Current;   // Gibt es Fenster ?
  while v <> nil do begin
    Desktop^.Delete(v);    // Fenster löschen.
    v := Desktop^.Current;
  end;
end;</code></pre>
<b>cmNewWin</b> muss man selbst abarbeiten. <b>cmClose</b> für das Schliessen des Fenster läuft im Hintergrund automatisch.<br>
<pre><code=pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows;    // Fenster erzeugen.
        end;
        cmRefresh: begin
          ReDraw;        // Anwendung neu zeichnen.
        end;
        cmCloseAll: begin
          CloseAll;
        end;
        cmClose: begin
          if Desktop^.Current <> nil then  Desktop^.Delete(Desktop^.Current);
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;</code></pre>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Mit den 3 oberen Button, kann man das Farb-Schema des Dialoges ändern.<br>
<pre><code>unit MyView;
</code></pre>
Hier sind 3 Event-Konstante hinzugekommen.<br>
<pre><code>type
  PMyView = ^TMyView;
<br>
  { TMyView }
<br>
  TMyView = object(TView)
    MyCol:Byte;
    constructor Init(var Bounds: TRect);
    destructor Done; Virtual;
<br>
    procedure Draw; virtual;
    procedure HandleEvent(var Event: TEvent); Virtual;
  end;
</code></pre>
Das Bauen des Dialoges ist nichts besonderes.<br>
<pre><code>procedure TMyView.Draw;
const
  Titel = 'MyTView';</font>
var
  B: TDrawBuffer;
  y: integer;
begin
  inherited Draw;
<br>
  EnableCommands([cmClose]);
<br>
  WriteChar(0, 0, #201, MyCol, 1);</font>
  WriteChar(1, 0, #205, MyCol, 3);</font>
  WriteStr(5, 0, Titel, 4);</font>
  WriteChar(Length(Titel) + 6, 0, #205, MyCol, Size.X - Length(Titel) - 7);</font>
  WriteChar(Size.X - 1, 0, #187, MyCol, 1);</font>
<br>
  for y := 1 to Size.Y - 2 do begin
    WriteChar(0, y, #186, MyCol, 1);</font>
    WriteChar(Size.X - 1, y, #186, MyCol, 1);</font>
  end;
<br>
  WriteChar(0, Size.Y - 1, #200, MyCol, 1);
  WriteChar(1, Size.Y - 1, #205, MyCol, Size.X - 2);</font>
  WriteChar(Size.X - 1, Size.Y - 1, #188, MyCol, 1);
end;
</code></pre>
Hier werden die Farb-Schemas mit Hilfe von <b>Palette := dpxxx</b> geändert.<br>
Auch hier ist wichtig, das man <b>Draw</b> aufruft, diemal nicht für eine Komponente, sonder für den ganzen Dialog.<br>
<pre><code>procedure TMyView.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
<br>
  case Event.What of
    evMouseDown: begin    // Maus-Taste wurde gedrückt.
      MyCol:=Random(16);</font>
      Draw;
    end;
  end;
end;
</code></pre>
<br>
