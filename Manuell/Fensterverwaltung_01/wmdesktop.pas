unit WMDesktop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  WMView;

type
    { TDesktop }

  TDesktop = class(TView)
    constructor Create; override;
    procedure EventHandle(Event: TEvent); override;
  end;


implementation

uses
  Unit1;  // ?????????????????????????????????''

{ TDesktop }

constructor TDesktop.Create;
begin
  inherited Create;
end;

procedure TDesktop.EventHandle(Event: TEvent);
begin
  inherited EventHandle(Event);
  case Event.What of
    whRepaint: begin
      Draw;
      DrawBitmap(Form1.Panel1.Canvas);
    end;
    whcmCommand: begin
      if Event.Value0 = cmClose then begin
        Delete(nil);
        Draw;
        DrawBitmap(Form1.Panel1.Canvas);
      end;
    end;
  end;
end;

end.

