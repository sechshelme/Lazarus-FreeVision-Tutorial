# 14 - TView
## 05 - TView erweitern

<img src="image.png" alt="Selfhtml"><br><br>


---



```pascal
  procedure TMyApp.NewWindows;
  var
    Win: PMyView;
    R: TRect;
  const
    WinCounter: integer = 0;                    // Zählt Fenster
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PMyView, Init(R));
    Win^.Options := Win^.Options or ofTileable; // Für Tile und Cascade

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
  end;
```



```pascal
procedure TMyApp.CloseAll;
var
  v: PView;
begin
  v := Desktop^.Current;   // Gibt es Fenster ?
  while v <> nil do begin
    Desktop^.Delete(v);    // Fenster löschen.
    v := Desktop^.Current;
  end;
end;
```



```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

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
  end;
```

---




```pascal
unit MyView;

```



```pascal
type
  PMyView = ^TMyView;

  { TMyView }

  TMyView = object(TView)
    MyCol:Byte;
    constructor Init(var Bounds: TRect);
    destructor Done; Virtual;

    procedure Draw; virtual;
    procedure HandleEvent(var Event: TEvent); Virtual;
  end;

```



```pascal
procedure TMyView.Draw;
const
  Titel = 'MyTView';
var
  B: TDrawBuffer;
  y: integer;
begin
  inherited Draw;

  EnableCommands([cmClose]);

  WriteChar(0, 0, #201, MyCol, 1);
  WriteChar(1, 0, #205, MyCol, 3);
  WriteStr(5, 0, Titel, 4);
  WriteChar(Length(Titel) + 6, 0, #205, MyCol, Size.X - Length(Titel) - 7);
  WriteChar(Size.X - 1, 0, #187, MyCol, 1);

  for y := 1 to Size.Y - 2 do begin
    WriteChar(0, y, #186, MyCol, 1);
    WriteChar(Size.X - 1, y, #186, MyCol, 1);
  end;

  WriteChar(0, Size.Y - 1, #200, MyCol, 1);
  WriteChar(1, Size.Y - 1, #205, MyCol, Size.X - 2);
  WriteChar(Size.X - 1, Size.Y - 1, #188, MyCol, 1);
end;

```




```pascal
procedure TMyView.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);

  case Event.What of
    evMouseDown: begin    // Maus-Taste wurde gedrückt.
      MyCol:=Random(16);
      Draw;
    end;
  end;
end;

```


