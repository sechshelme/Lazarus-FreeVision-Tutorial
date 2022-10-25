# 04 - Dialoge als Komponente
## 00 - Ein einfaches About
<img src="image.png" alt="Selfhtml"><br><br>
Wen man immer wieder die gleichen Dialog braucht, packt man diesen am besten als Komponente in eine Unit.<br>
Dazu schreibt man einen Nachkommen von <b>TDialog</b>.<br>
Als Beispiel wird hier ein About-Dialog gebaut.<br>
---
Hier wird der About-Dialog geladen und anschliessend bei Close wieder frei gegeben.<br>
```pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyAbout;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          AboutDialog := New(PMyAbout, Init);         // Neurer Dialog erzeugen.
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
  end;```
---
<b>Unit mit dem neuen Dialog.</b><br>
<pre><code>unit MyDialog;
</code></pre>
Für den Dialog muss ein neuer Konstruktor erzeugt werden.<br>
Noch ein Hinweis zu StaticText, wen man eine Leerzeile einfügen will, muss man <b>#13#32#13</b> schreiben, bei <b>#13#13</b>, wird nur ein einfacher Zeilenumbruch ausgefühert.<br>
<pre><code>interface
<br>
uses
  App, Objects, Drivers, Views, Dialogs;
<br>
type
  PMyAbout = ^TMyAbout;
  TMyAbout = object(TDialog)
    constructor Init;  // Neuer Konstruktor, welche den Dialog mit den Komponenten baut.
  end;
</code></pre>
Im Konstruktor werden die Dialog-Komponeten erzeugt.<br>
<pre><code>implementation
<br>
constructor TMyAbout.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);</font>
  R.Move(23, 3);</font>
<br>
  inherited Init(R, 'About');  // Dialog in verdefinierter Grösse erzeugen.</font>
<br>
  // StaticText
  R.Assign(5, 2, 41, 8);</font>
  Insert(new(PStaticText, Init(R,
    'Free Vison Tutorial 1.0' + #13 +
    '2017' + #13 +</font>
    'Gechrieben von M. Burkhard' + #13#32#13 +</font>
    'FPC: '+ {$I %FPCVERSION%} + '   OS:'+ {$I %FPCTARGETOS%} + '   CPU:' + {$I %FPCTARGETCPU%})));
<br>
  // Ok-Button
  R.Assign(27, 8, 37, 10);</font>
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
end;
</code></pre>
<br>
