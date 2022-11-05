# 04 - Dialoge als Komponente
## 00 - Ein einfaches About

![image.png](image.png)

Wen man immer wieder die gleichen Dialog braucht, packt man diesen am besten als Komponente in eine Unit.
Dazu schreibt man einen Nachkommen von **TDialog**.
Als Beispiel wird hier ein About-Dialog gebaut.

---
Hier wird der About-Dialog geladen und anschliessend bei Close wieder frei gegeben.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyAbout;
  begin
    inherited HandleEvent(Event);

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
  end;
```


---
**Unit mit dem neuen Dialog.**

```pascal
unit MyDialog;

```

Für den Dialog muss ein neuer Konstruktor erzeugt werden.
Noch ein Hinweis zu StaticText, wen man eine Leerzeile einfügen will, muss man **#13#32#13** schreiben, bei **#13#13**, wird nur ein einfacher Zeilenumbruch ausgefühert.

```pascal
interface

uses
  App, Objects, Drivers, Views, Dialogs;

type
  PMyAbout = ^TMyAbout;
  TMyAbout = object(TDialog)
    constructor Init;  // Neuer Konstruktor, welche den Dialog mit den Komponenten baut.
  end;

```

Im Konstruktor werden die Dialog-Komponeten erzeugt.

```pascal
implementation

constructor TMyAbout.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  R.Move(23, 3);

  inherited Init(R, 'About');  // Dialog in verdefinierter Grösse erzeugen.

  // StaticText
  R.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(R,
    'Free Vison Tutorial 1.0' + #13 +
    '2017' + #13 +
    'Gechrieben von M. Burkhard' + #13#32#13 +
    'FPC: '+ {$I %FPCVERSION%} + '   OS:'+ {$I %FPCTARGETOS%} + '   CPU:' + {$I %FPCTARGETCPU%})));

  // Ok-Button
  R.Assign(27, 8, 37, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```


