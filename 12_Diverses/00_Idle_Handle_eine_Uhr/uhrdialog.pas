//head+
unit UhrDialog;
//head-

interface

uses
  SysUtils,
  Drivers, Objects, Views, Dialogs;

//type+
const
  cmUhrRefresh = 1003;

type
  PUhrView = ^TUhrView;
  TUhrView = object(TDialog)
  private
    ZeitStr: String;
  public
    constructor Init;
    procedure Draw; Virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TUhrView.Init;
var
  Rect: TRect;
begin
  Rect.Assign(51, 1, 70, 8);
  inherited Init(Rect, 'Uhr');

  Rect.Assign(7, 4, 13, 6);
  Insert(new(PButton, Init(Rect, '~O~k', cmOK, bfDefault)));
end;
//init-

//draw+
procedure TUhrView.Draw;
var
  b: TDrawBuffer;
  c: Byte;
begin
  inherited Draw;
  c := GetColor(7);
  MoveChar(b, ' ', c, Size.X + 4);
  MoveStr(b, ZeitStr, c);
  WriteLine(5, 2, Size.X + 2, 1, b);
end;
//draw-

//handleevent+
procedure TUhrView.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);

  case Event.What of
    evBroadcast: begin
      case Event.Command of
        cmUhrRefresh: begin
          ZeitStr := String(Event.InfoPtr);
          Draw;
        end;
      end;
    end;
    evCommand: begin
      case Event.Command of
        cmOK: begin
          Close;
        end;
      end;
    end;
  end;
end;
//handleevent-

end.

