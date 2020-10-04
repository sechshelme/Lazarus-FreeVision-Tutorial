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
  Width := 75;
  Height := 25;
  Color := clYellow;
end;

procedure TButton.Draw;
var
  w: integer = 0;
  h: integer = 0;
begin
  inherited Draw;
  Bitmap.Canvas.GetTextSize(Caption, w, h);
  Bitmap.Canvas.TextOut((Width - w) div 2, (Height - h) div 2, Caption);
end;

procedure TButton.EventHandle(Event: TEvent);
var
  x, y: integer;
  ev: TEvent;
begin
  if Event.What = whMouse then begin
    x := Event.x;
    y := Event.y;
    case Event.MouseCommand of
      MouseDown: begin
        Color := clGray;
        ev.What := whRepaint;
        EventHandle(ev);
        isMouseDown := True;
      end;
      MouseUp: begin
        Color := clYellow;
        ev.What := whRepaint;
        EventHandle(ev);
        if isMouseDown and IsMousInView(x, y) then begin
          ev.What := whcmCommand;
          ev.Command := FCommand;
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
  inherited EventHandle(Event);
end;

end.

