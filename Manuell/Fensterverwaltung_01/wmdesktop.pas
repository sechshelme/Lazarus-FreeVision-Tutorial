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
  //case Event.What of
  //  whcmCommand: begin
  //    if Event.Value0 = cmClose then begin
  //      Delete(nil);
  //      ev.What := whRepaint;
  //      EventHandle(ev);
  //    end;
  //  end;
  //end;
  inherited EventHandle(Event);
end;

end.

