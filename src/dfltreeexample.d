import dfl.all;
import std.file;
import gui.dfl.dircontrol;

void main() {
  auto form = new Form;
  auto label = new Label;
  auto tree = new DirControl();
  tree.tree.afterSelect ~= delegate void (TreeView t, TreeViewEventArgs e) {
          label. text = "Text: " ~ e.node.text ~
          "\nPath: " ~ e.node.fullPath;
  };
  form.clientSize = dfl.all.Size(800, 600);
  form.controls.add(tree);
  label.dock = DockStyle.RIGHT;
  label.text = "Select a node.";
  form.controls.add(label);

  Application.run(form);
}
