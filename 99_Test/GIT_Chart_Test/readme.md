## Chart Test

```mermaid
classDiagram


TObject ..> TView
TObject: 1 Ich bin die oberste Klasse !
TObject: 2 Ich bin die oberste Klasse !
TObject: 3 Ich bin die oberste Klasse !
TView ..> TGroup
TView ..> TFrame
TView ..> TScroller
TView ..> TListViewer
TListViewer ..> TListBox
TView ..> TInputLine
TView ..> TButton
TView ..> TCluster
TCluster ..> TRadioButton
TCluster ..> TCheckBoxes
TCluster ..> TMultiCheckBoxes
TGroup ..> TProgram
TGroup ..> TWindow
TProgram ..> TApplication 
TApplication ..> TMyApp
class TWindow {
  Ich bin ein Fenster
  oder auch nicht
}
```


