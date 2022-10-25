# 10 - Komponenten modifizieren
## 00 - Button modifizieren
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

<br>
---
<br>

<br>
```pascal
  procedure TMyApp.MyParameter;
  var
    Dia: PDialog;
    R: TRect;
  begin
    R.Assign(0, 0, 35, 15);                    // Grösse des Dialogs.
    R.Move(23, 3);                             // Position des Dialogs.
    Dia := New(PDialog, Init(R, 'Parameter')); // Dialog erzeugen.
    with Dia^ do begin
      // oben
      Insert(new(PMyButton, Init(7, 8, 'sehr langer ~T~ext', cmValid, bfDefault)));
<br>
      // mitte
      Insert(new(PMyButton, Init(7, 4, '~k~urz', cmValid, bfDefault)));
<br>
      // Ok-Button
      Insert(new(PMyButton, Init(7, 12, '~O~K', cmOK, bfDefault)));
<br>
      // Schliessen-Button
      Insert(new(PMyButton, Init(19, 12, '~A~bbruch', cmCancel, bfNormal)));
    end;
    Desktop^.ExecView(Dia);   // Dialog Modal öffnen.
    Dispose(Dia, Done);       // Dialog und Speicher frei geben.
  end;
```
<br>
---
<br>

<br>

```pascal
unit MyButton;
<br>
```
<br>

<br>

```pascal
type
  PMyButton = ^TMyButton;
  TMyButton = object(TButton)
    constructor Init(x, y: integer; ATitle: TTitleStr; ACommand: word; AFlags: word);
  end;
<br>
```
<br>

<br>

```pascal
constructor TMyButton.Init(x, y: integer; ATitle: TTitleStr; ACommand: word; AFlags: word);
var
  R: TRect;
begin
  R.Assign(x, y, x + Length(StringReplace(ATitle, '~', '', [])) + 2, y + 2);
<br>
  inherited Init(R, ATitle, ACommand, AFlags);
end;
<br>
```
<br>

