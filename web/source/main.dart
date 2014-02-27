library kiss_game;

import 'dart:html';

void main() {
  querySelector("h1").onClick.listen(
    (e) => querySelector("#canvas_container")
      .text = "Kiss game hellooooooooooo world");
}