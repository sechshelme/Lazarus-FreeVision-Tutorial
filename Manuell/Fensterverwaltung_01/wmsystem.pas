unit WMSystem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Forms, Controls;

const
  cmNone = 0;
  cmClose = 1;
  cmQuit = 2;

  cmTest0 = 100;
  cmTest1 = 101;
  cmTest2 = 102;
  cmTest3 = 103;
  cmopti0 = 104;
  cmopti1 = 105;
  cmopti2 = 106;

  EvMouseDown = 0;
  EvMouseUp = 1;
  EvMouseMove = 2;

const
  BorderSize = 7;
  TitelBarSize = BorderSize * 5;
  minWinSize = 50;

type

  TEvent = record
    What: (whNone, whMouse, whKeyPress, whcmCommand, whMenuCommand, whRepaint);
    case integer of
      whNone: (Value0, Value1, Value2, Value3: PtrInt);
      whMouse: (MouseCommand, x, y: PtrInt);
      whKeyPress: (PressKey: char;
        DownKey: byte;
        shift: TShiftState);
      whcmCommand: (Command: PtrInt);
      whMenuCommand: (Index, Left, Top: PtrInt;
        Sender: TObject);
      whRepaint: (was: (all, Windows));
  end;

  TEventHandle = procedure(var Event: TEvent) of Object;

  { TSystem }

  TSystem = class(TForm)
  private
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure privEventHandle(var Event: TEvent); virtual;
  public
    OnEventHandle: TEventHandle;
    constructor Create(TheOwner: TComponent); override;
  end;


implementation

{ TSystem }

procedure TSystem.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  ev: TEvent;
begin
  WriteLn(Key);
  if Key in [33..46, 112..123] then begin
    ev.What := whKeyPress;
    ev.PressKey := #0;
    ev.DownKey := Key;
    ev.shift := Shift;
    privEventHandle(ev);
  end;
end;

procedure TSystem.FormKeyPress(Sender: TObject; var Key: char);
var
  ev: TEvent;
begin
  WriteLn(Key);
  ev.What := whKeyPress;
  ev.PressKey := Key;
  privEventHandle(ev);
  Key := #0;
end;

procedure TSystem.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  if ssLeft in Shift then begin
    ev.What := whMouse;
    ev.MouseCommand := EvMouseDown;
    ev.x := x;
    ev.y := y;
    privEventHandle(ev);
  end;
end;

procedure TSystem.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  if ssLeft in Shift then begin
    ev.What := whMouse;
    ev.MouseCommand := EvMouseMove;
    ev.x := x;
    ev.y := y;
    privEventHandle(ev);
  end;
end;

procedure TSystem.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  ev.What := whMouse;
  ev.MouseCommand := EvMouseUp;
  ev.x := x;
  ev.y := y;
  privEventHandle(ev);
end;


procedure TSystem.FormPaint(Sender: TObject);
var
  ev: TEvent;
begin
  ev.What := whRepaint;
  privEventHandle(ev);
end;

procedure TSystem.FormResize(Sender: TObject);
begin
  Repaint;
  //  Width := ClientWidth;
  //  Height := ClientHeight;
end;

procedure TSystem.privEventHandle(var Event: TEvent);
begin
  if OnEventHandle <> nil then begin
    OnEventHandle(Event);
  end;
end;

constructor TSystem.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Position := poDesktopCenter;
  DoubleBuffered := True;
  OnPaint := @FormPaint;
  OnResize := @FormResize;
  OnKeyDown := @FormKeyDown;
  OnKeyPress := @FormKeyPress;
  OnMouseDown := @FormMouseDown;
  OnMouseMove := @FormMouseMove;
  OnMouseUp := @FormMouseUp;
  OnEventHandle := nil;
end;

end.
