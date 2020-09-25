unit WMApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Graphics,

  WMView, WMDesktop;

{ TApplication }

type
  TApplication = class(TView)
  private
  public
    Desktop: TDesktop;
    constructor Create; override;
    procedure EventHandle(Event: TEvent); override;
  end;

implementation

uses
  Unit1;  //????????????????????????????????????????????'''''
const
  rand = 40;


{ TApplication }

constructor TApplication.Create;
begin
  inherited Create;
  Color := clMaroon;

  Desktop := TDesktop.Create;
  with Form1 do begin
    Desktop.Assign(0, rand, Panel1.Width, Panel1.Height - rand);
  end;
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';
  Insert(Desktop);
end;

procedure TApplication.EventHandle(Event: TEvent);
begin
  inherited EventHandle(Event);
  case Event.What of
    whRepaint: begin
      Draw;
      DrawBitmap(Form1.Panel1.Canvas);
    end;
  end;
end;

end.


