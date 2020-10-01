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

{ TDesktop }

constructor TDesktop.Create;
begin
  inherited Create;
end;

procedure TDesktop.EventHandle(Event: TEvent);
var
  ev:TEvent;
begin
  inherited EventHandle(Event);
end;

end.

