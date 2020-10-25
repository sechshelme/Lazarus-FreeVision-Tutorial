unit WMApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Forms, Controls,
  WMSystem, WMView, WMDesktop, WMButton, WMMenu, WMToolbar;

{ TApplication }

type
  TApplication = class(TView)
  private
    Form: TSystem;
    procedure EvH(var Event: TEvent);
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

procedure TApplication.EvH(var Event: TEvent);
begin
  EventHandle(Event);
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

  Form := TSystem.Create(nil);
  Form.ClientWidth := 800;
  Form.ClientHeight := 600;
  Form.DoubleBuffered := True;
  Form.Caption := '♿';

  Color := clMaroon;

  Form.OnEventHandle:=@EvH;

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
