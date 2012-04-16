var compile = function(expr) {
  if(expr.tag === 'seq') {
    var compiled = [];
    compiled = compiled.concat(compile(expr.left));
    compiled = compiled.concat(compile(expr.right));
    return compiled;
  } else if(expr.tag === 'note') {
    return [expr];
  }
};

var playNote = function() {};

var playMusic = function(expr) {
  playNote(compile(expr));
}

var melody_music =
    { tag: 'seq',
      left:
       { tag: 'seq',
         left: { tag: 'note', pitch: 'a4', duration: 250 },
         right: { tag: 'note', pitch: 'b4', duration: 250 } },
      right:
       { tag: 'seq',
         left: { tag: 'note', pitch: 'c4', duration: 500 },
         right: { tag: 'note', pitch: 'd4', duration: 500 } } };

console.log(melody_music);
console.log(compile(melody_music));
