import dfl.all;
import std.file;
import std.conv;
import gui.dfl.dircontrol;
import gui.dfl.filecontrol;


void main() {
  auto form = new Form;
  auto label = new Label;
  auto dircontrol = new DirControl();
  auto filecontrol = new FileControl();
  dircontrol.tree.afterSelect ~= &filecontrol.OnSelect_click;
  form.clientSize = dfl.all.Size(1200, 900);
  form.controls.add(dircontrol);
  filecontrol.dock = DockStyle.RIGHT;
  form.controls.add(filecontrol);
  Application.run(form);
}
