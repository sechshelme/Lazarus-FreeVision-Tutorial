unit WMDesktop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  WMSystem,  WMView;

type
    { TDesktop }

  TDesktop = class(TView)
    constructor Create; override;
    procedure EventHandle(var Event: TEvent); override;
  end;


implementation

{ TDesktop }

constructor TDesktop.Create;
begin
  inherited Create;
end;

procedure TDesktop.EventHandle(var Event: TEvent);
var
  ev:TEvent;
begin
  inherited EventHandle(Event);
end;

end.

