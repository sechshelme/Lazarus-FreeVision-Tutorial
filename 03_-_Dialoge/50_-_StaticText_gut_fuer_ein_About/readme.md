# 03 - Dialoge
## 50 - StaticText gut fuer ein About
<img src="image.png" alt="Selfhtml"><br><br>
Hier wird ein About-Dialog erstellt, das sieht man gut für was man Label gebrauchen kann.<br>
---
Die Datei, in welcher sich die Daten für den Dialog befinden.<br>
```pascal>const
  DialogDatei = 'parameter.cfg';</font>```
Eine neue Funktion <b>About</b> ist hinzugekommen.<br>
```pascal>type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Parameter für Dialog.
    fParameterData: file of TParameterData;            // File-Hander füe das speichern/laden der Daten des Dialoges.
<br>
    constructor Init;                                  // Neuer Constructor
<br>
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.
<br>
    procedure MyParameter;                             // neue Funktion für einen Dialog.
    procedure About;                                   // About Dialog.
  end;```
Hier wird das About augerufen, wen im Menü About gewält wird.<br>
```pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          About;   // About Dialog aufrufen
        end;
        cmList: begin
        end;
        cmPara: begin
          MyParameter;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;```
About Dialog erstellen.<br>
Mit <b>TRext.Grow(...</b> kann man das Rect verkleinern und vergrössern.<br>
Mit <b>#13</b> kann man eine Zeilenumbruch einfügen.<br>
Mit <b>#3</b> wird der Text horizontal im Rect zentriert.<br>
Mit <b>#2</b> wird der Text rechtbündig geschrieben.<br>
<br>
Mit <b>PLabel</b> könnte man auch Text ausgeben, aber für festen Text eignet sich <b>PStaticText</b> besser.<br>
```pascal>  procedure TMyApp.About;
  var
    Dlg: PDialog;
    R: TRect;
  begin
    R.Assign(0, 0, 42, 11);</font>
    R.Move(1, 1);</font>
    Dlg := New(PDialog, Init(R, 'About'));</font>
    with Dlg^ do begin
      Options := Options or ofCentered; // Dialog zentrieren
<br>
      // StaticText einfügen.
      R.Assign(2, 2, 40, 8);</font>
      Insert(New(PStaticText, Init(R,
        #13 +</font>
        'Free Vison Tutorial 1.0' + #13 +
        '2017' + #13 +</font>
        #3 + 'Zentriert' + #13 +
        #2 + 'Rechts')));</font>
      R.Assign(16, 8, 26, 10);</font>
      Insert(New(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
    end;
    if ValidView(Dlg) <> nil then begin
      Desktop^.ExecView(Dlg);           // Modal aufrufen, Funktionsergebniss wird nicht ausgewrtet.
      Dispose(Dlg, Done);               // Dialog frei geben.
    end;
  end;```
<br>
