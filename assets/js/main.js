var acgFiles = document.getElementsByClassName("acg-file");

while (acgFiles.length > 0) {
  Elm.Main.init({
    node: acgFiles[0],
    flags: JSON.parse(acgFiles[0].dataset.flags),
  });
}
