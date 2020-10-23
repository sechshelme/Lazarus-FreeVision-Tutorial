unit WMApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Forms, Controls,
  WMView, WMDesktop, WMButton, WMMenu, WMToolbar;

{ TApplication }

type
  TApplication = class(TView)
  private
    Form: TForm;
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    procedure SetHeight(AValue: integer); override;
  public
    Desktop: TDesktop;
    ToolBar: TToolBar;
    Menu: TMenuWindow;
    constructor Create; override;
    destructor Destroy; override;
    procedure Run;
    procedure EventHandle(var Event: TEvent); override;
  end;

implementation

const
  rand = 40;

{ TApplication }

procedure TApplication.FormPaint(Sender: TObject);
var
  ev: TEvent;
begin
  ev.What := WMView.whRepaint;
  EventHandle(ev);
end;

procedure TApplication.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  ev: TEvent;
begin
  if Key in [33..46, 112..123] then begin
    ev.What := whKeyPress;
    ev.PressKey := #0;
    ev.DownKey := Key;
    ev.shift := Shift;
    EventHandle(ev);
  end;
end;

procedure TApplication.FormKeyPress(Sender: TObject; var Key: char);
var
  ev: TEvent;
begin
  ev.What := whKeyPress;
  ev.PressKey := Key;
  EventHandle(ev);
  Key := #0;
end;

procedure TApplication.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  if ssLeft in Shift then begin
    ev.What := whMouse;
    ev.MouseCommand := WMView.MouseDown;
    ev.x := x;
    ev.y := y;
    EventHandle(ev);
  end;
end;

procedure TApplication.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  if ssLeft in Shift then begin
    ev.What := whMouse;
    ev.MouseCommand := WMView.MouseMove;
    ev.x := x;
    ev.y := y;
    EventHandle(ev);
  end;
end;

procedure TApplication.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  ev.What := whMouse;
  ev.MouseCommand := WMView.MouseUp;
  ev.x := x;
  ev.y := y;
  EventHandle(ev);
end;

procedure TApplication.FormResize(Sender: TObject);
begin
  Width := Form.ClientWidth;
  Height := Form.ClientHeight;
end;

procedure TApplication.SetHeight(AValue: integer);
begin
  inherited SetHeight(AValue);
  if (Menu <> nil) and (ToolBar <> nil) and (Desktop <> nil) then begin
    ToolBar.Top := Menu.MenuBar.Height;
    Desktop.Top := Menu.MenuBar.Height + ToolBar.Height;
    Desktop.Height := Height - Menu.MenuBar.Height - ToolBar.Height;
  end;
end;

constructor TApplication.Create;
begin
  inherited Create;
  Randomize;

  Form := TForm.Create(nil);
  Form.Position:=poDesktopCenter;
  Form.ClientWidth := 800;
  Form.ClientHeight := 600;
  Form.DoubleBuffered := True;
  Form.Caption := '♿';
  Form.OnPaint := @FormPaint;
  Form.OnResize := @FormResize;
  Form.OnKeyDown := @FormKeyDown;
  Form.OnKeyPress := @FormKeyPress;
  Form.OnMouseDown := @FormMouseDown;
  Form.OnMouseMove := @FormMouseMove;
  Form.OnMouseUp := @FormMouseUp;

  Color := clMaroon;

  Menu := TMenuWindow.Create;
  InsertView(Menu);

  ToolBar := TToolBar.Create;
  InsertView(ToolBar);

  Desktop := TDesktop.Create;
  Desktop.Anchors := [akLeft, akRight, akTop, akBottom];
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';
  InsertView(Desktop);
end;

destructor TApplication.Destroy;
begin
  Form.Free;
  inherited Destroy;
end;

procedure TApplication.Run;
begin
  Form.ShowModal;
end;

procedure TApplication.EventHandle(var Event: TEvent);
var
  ev: TEvent;
begin
  case Event.What of
    whcmCommand: begin
      case Event.Command of
        cmQuit: begin
          Form.Close;
        end;
        cmClose: begin
          Desktop.DeleteView(0);
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whKeyPress: begin
      case Event.PressKey of
        #0: begin
          case Event.DownKey of
            121: begin   // F10
              if Event.shift = [] then begin
                FirstView(Menu);
                Menu.MenuBar.ShowCursor;
              end;
            end;
          end;
        end;
      end;
      ev.What := whRepaint;
      EventHandle(ev);
    end;
    whRepaint: begin
      Draw;
      DrawBitmap(Form.Canvas);
    end;
    else begin
    end;
  end;
  inherited EventHandle(Event);
end;

end.
