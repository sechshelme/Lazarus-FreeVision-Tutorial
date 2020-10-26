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
    SystemForm: TSystem;
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

  SystemForm := TSystem.Create(nil);
  SystemForm.ClientWidth := 800;
  SystemForm.ClientHeight := 600;
  SystemForm.DoubleBuffered := True;
  SystemForm.Caption := '♿';

  Color := clMaroon;

  SystemForm.OnEventHandle := @EvH;

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
  SystemForm.Free;
  inherited Destroy;
end;

procedure TApplication.Run;
begin
  SystemForm.ShowModal;
end;

procedure TApplication.EventHandle(var Event: TEvent);
var
  ev: TEvent;
begin
  case Event.What of
    whcmCommand: begin
      case Event.Command of
        cmQuit: begin
          SystemForm.Close;
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
      Height := SystemForm.Height;
      Width := SystemForm.Width;
      Draw;
      DrawBitmap(SystemForm.Canvas);
    end;
    else begin
    end;
  end;
  inherited EventHandle(Event);
end;

end.
