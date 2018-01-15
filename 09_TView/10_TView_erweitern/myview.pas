//head+
unit MyView;
//head-

interface

uses
  Views, Drivers, Objects,
  SysUtils;

//type+
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
//type-

implementation

constructor TMyView.Init(var Bounds: TRect);
begin
  inherited Init(Bounds);
  set

  Options := Options OR ofSelectable;  // Fenster anwählbar.
  Options := Options OR ofTopSelect;   // Fenster selektierbar.
  SetState(sfShadow, True);            // Schatten aktivieren.

  MyCol := 4;
end;

destructor TMyView.Done;
begin
  DisableCommands([cmClose]);
  inherited Done;
end;

//init+
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
//init-

//handleevent+
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
//handleevent-

end.
