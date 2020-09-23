unit WMButton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMView;

type
  { TButton }

  TButton = class(TView)
  private
    FCommand: integer;
  public
    property Command: integer read FCommand write FCommand;
    constructor Create; override;
    procedure Draw; override;
    procedure EventHandle(Event: TEvent); override;
  end;

implementation

{ TButton }

constructor TButton.Create;
begin
  inherited Create;
  Color := clYellow;
end;

procedure TButton.Draw;
var
  w, h: integer;
begin
  inherited Draw;
  Bitmap.Canvas.GetTextSize(Caption, w, h);

  with ViewRect do begin
    Bitmap.Canvas.TextOut(Width div 2 - w div 2, 2, Caption);
  end;
end;

procedure TButton.EventHandle(Event: TEvent);
var
  x, y: integer;
  ev: TEvent;
begin
  inherited EventHandle(Event);

  if Event.What = whMouse then begin
    x := Event.Value1;
    y := Event.Value2;
    case Event.Value0 of
      MouseDown: begin
        Color := clGray;
        ev.What := whRepaint;
        EventHandle(ev);
      end;
      MouseUp: begin
        Color := clYellow;
        ev.What := whRepaint;
        EventHandle(ev);
        if IsMousInView(x, y) then begin
          ev.What := whcmCommand;
          ev.Value0 := FCommand;
          EventHandle(ev);
        end;
      end;
      MouseMove: begin
        if isMouseDown and IsMousInView(x, y) then begin
          Color := clGray;
        end else begin
          Color := clYellow;
        end;
        ev.What := whRepaint;
        EventHandle(ev);
      end;
    end;
  end;
end;

end.

