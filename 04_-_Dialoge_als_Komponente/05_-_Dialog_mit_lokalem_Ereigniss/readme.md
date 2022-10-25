# 04 - Dialoge als Komponente
## 05 - Dialog mit lokalem Ereigniss
<br>
<img src="image.png" alt="Selfhtml"><br><br>
In den vererbten Dialogen ist es möglich Buttons einzubauen, welche lokal im Dialog eine Aktion ausführen.<br>
Im Beispiel wir eine MessageBox aufgerufen.<br>
<hr><br>
Im Hauptprogramm ändert sich nichts daran, dem ist egal, ob lokal noch etwas gemacht wird.<br>
<pre><code=pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyAbout;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmAbout: begin
          AboutDialog := New(PMyAbout, Init);
          if ValidView(AboutDialog) <> nil then begin // Prüfen ob genügend Speicher.
            Desktop^.ExecView(AboutDialog);           // Dialog About ausführen.
            Dispose(AboutDialog, Done);               // Dialog und Speicher frei geben.
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
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Dort sieht man gut, das es ein Button für lokale Ereignisse hat.<br>
Wichtig ist, bei den Nummernvergabe, das sich dies nicht mit einem anderen Eventnummer überschneidet.<br>
Vor allem dann, wen der Dialog nicht Modal geöffnet wird.<br>
Ausser es ist gewünscht, wen man zB. über das Menü auf den Dialog zugreifen will.<br>
<pre><code>unit MyDialog;
</code></pre>
Für den Dialog kommt noch ein HandleEvent hinzu.<br>
<pre><code>type
  PMyAbout = ^TMyAbout;
  TMyAbout = object(TDialog)
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
</code></pre>
Im Konstruktor wird der Dialog noch um den Button Msg-box ergänzt, welcher das lokale Ereigniss <b>cmMsg</b> abarbeitet.<br>
<pre><code>const
    cmMsg = 1003;  // Lokales Ereigniss</font>
<br>
constructor TMyAbout.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);</font>
  R.Move(23, 3);</font>
  inherited Init(R, 'About');</font>
<br>
  // StaticText
  R.Assign(5, 2, 41, 8);</font>
  Insert(new(PStaticText, Init(R,
    'Free Vison Tutorial 1.0' + #13 +
    '2017' + #13 +</font>
    'Gechrieben von MB'+ #13#32#13 +</font>
    'FPC: '+ {$I %FPCVERSION%} + '   OS:'+ {$I %FPCTARGETOS%} + '   CPU:' + {$I %FPCTARGETCPU%})));
<br>
  // MessageBox-Button, mit lokalem Ereigniss.
  R.Assign(19, 8, 32, 10);</font>
  Insert(new(PButton, Init(R, '~M~sg-Box', cmMsg, bfNormal)));</font>
<br>
  // Ok-Button
  R.Assign(7, 8, 17, 10);</font>
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
end;
</code></pre>
Im neuen EventHandle, werden loake Ereigniss (cmMsg) abarbeitet.<br>
Andere Ereignisse, zB. <b>cmOk</b> wird an das Hauptprogramm weiter gereicht, welches dann den Dialog auch schliesst.<br>
<pre><code>procedure TMyAbout.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
<br>
  case Event.What of
    evCommand: begin
      case Event.Command of
        // Lokales Ereigniss ausführen.
        cmMsg: begin
          MessageBox('Ich bin eine MessageBox !', nil, mfOKButton);
          ClearEvent(Event);  // Event beenden.
        end;
      end;
    end;
  end;
<br>
end;
</code></pre>
<br>
