# 99 - Test
## 05 - TabSheet
<br>
<img src="image.png" alt="Selfhtml"><br><br>
In den vererbten Dialogen ist es möglich Buttons einzubauen, welche lokal im Dialog eine Aktion ausführen.<br>
Im Beispiel wir eine MessageBox aufgerufen.<br>
<hr><br>
Im Hauptprogramm ändert sich nichts daran, dem ist egal, ob lokal noch etwas gemacht wird.<br>
```pascal  procedure TMyApp.HandleEvent(var Event: TEvent);
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
  end;```
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Dort sieht man gut, das es ein Button für lokale Ereignisse hat.<br>
Wichtig ist, bei den Nummernvergabe, das sich dies nicht mit einem anderen Eventnummer überschneidet.<br>
Vor allem dann, wen der Dialog nicht Modal geöffnet wird.<br>
Ausser es ist gewünscht, wen man zB. über das Menü auf den Dialog zugreifen will.<br>
```pascalunit MyDialog;
```
Für den Dialog kommt noch ein HandleEvent hinzu.<br>
```pascalconst
  cmMsg = 1003;  //
<br>
type
  PMyAbout = ^TMyAbout;
<br>
  TMyAbout = object(TDialog)
<br>
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
```
Im Konstruktor wird der Dialog noch um den Button Msg-box ergänzt, welcher das lokale Ereigniss <b>cmMsg</b> abarbeitet.<br>
```pascalconstructor TMyAbout.Init;
var
  R: TRect;
  Tabdef: PTabDef;
  Tab: PTab;
  bt0, bt1, bt2: PButton;
  Group: PGroup;
begin
  R.Assign(0, 0, 42, 16);
  R.Move(23, 3);
  inherited Init(R, 'About');
<br>
  R.Assign(2, 4, 12, 6);
  bt0 := new(PButton, Init(R, 'bt~a~', cmValid, bfDefault));
  R.Assign(2, 6, 12, 8);
  bt1 := new(PButton, Init(R, 'bt~b~', cmValid, bfDefault));
  R.Assign(2, 8, 12, 19);
  bt2 := new(PButton, Init(R, 'bt~c~', cmValid, bfDefault));
<br>

  // Tab
  R.Assign(1, 1, 10, 5);
  Group := new(PGroup, Init(R));
  Group^.BackgroundChar := 'x';
<br>
  R.Assign(5, 2, 41, 13);
  Tabdef := NewTabDef('Tab~1~', bt1, NewTabItem(bt0, NewTabItem(bt1, NewTabItem(bt2, nil))), NewTabDef('Tab~2~', nil, nil, nil));
  Tab := new(PTab, Init(R, Tabdef));
<br>
  Insert(Tab);
<br>
  // MessageBox-Button, mit lokalem Ereigniss.
  R.Assign(19, 13, 32, 15);
  Insert(new(PButton, Init(R, '~M~sg-Box', cmMsg, bfNormal)));
<br>
  // Ok-Button
  R.Assign(7, 13, 17, 15);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
```
Im neuen EventHandle, werden loake Ereigniss (cmMsg) abarbeitet.<br>
Andere Ereignisse, zB. <b>cmOk</b> wird an das Hauptprogramm weiter gereicht, welches dann den Dialog auch schliesst.<br>
```pascalprocedure TMyAbout.HandleEvent(var Event: TEvent);
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
```
<br>
