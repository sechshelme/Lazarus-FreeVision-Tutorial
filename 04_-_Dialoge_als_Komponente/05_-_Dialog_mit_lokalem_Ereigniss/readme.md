# 04 - Dialoge als Komponente
## 05 - Dialog mit lokalem Ereigniss
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

---
<br>

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
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
  end;
```
<br>
---
<br>

<br>

<br>

<br>
```pascal
unit MyDialog;
<br>
```
<br>

<br>
```pascal
type
  PMyAbout = ^TMyAbout;
  TMyAbout = object(TDialog)
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
<br>
```
<br>

<br>
```pascal
const
    cmMsg = 1003;  // Lokales Ereigniss
<br>
constructor TMyAbout.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  R.Move(23, 3);
  inherited Init(R, 'About');
<br>
  // StaticText
  R.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(R,
    'Free Vison Tutorial 1.0' + #13 +
    '2017' + #13 +
    'Gechrieben von MB'+ #13#32#13 +
    'FPC: '+ {$I %FPCVERSION%} + '   OS:'+ {$I %FPCTARGETOS%} + '   CPU:' + {$I %FPCTARGETCPU%})));
<br>
  // MessageBox-Button, mit lokalem Ereigniss.
  R.Assign(19, 8, 32, 10);
  Insert(new(PButton, Init(R, '~M~sg-Box', cmMsg, bfNormal)));
<br>
  // Ok-Button
  R.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
<br>
```
<br>

<br>

```pascal
procedure TMyAbout.HandleEvent(var Event: TEvent);
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
<br>
```
<br>

