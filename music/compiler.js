var endTime = function(expr, time) {
  if(expr.tag === 'note') {
    return expr.duration + time;
  } else if(expr.tag === 'seq') {
    return endTime(expr.right, endTime(expr.left, time));
  } else if(expr.tag === 'par') {
    return Math.max(endTime(expr.left, time), endTime(expr.right, time));
  }
}
var _compile = function(expr, start) {
  if(expr.tag === 'seq') {
    var left = _compile(expr.left, start);
    var rightStart = endTime(expr.left, start);
    var right = _compile(expr.right, rightStart);
    return left.concat(right);
  } else if(expr.tag === 'par') {
    var left = _compile(expr.left, start);
    var right = _compile(expr.right, start);
    return left.concat(right);
  } else if(expr.tag === 'note') {
    return [ {
      tag: 'note',
      start: start,
      pitch: expr.pitch,
      duration: expr.duration
    } ];
  }
};

var compile = function(expr) {
  return _compile(expr, 0);
}

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

var melody_parallel =
    { tag: 'seq',
      left:
       { tag: 'par',
         left: { tag: 'note', pitch: 'c3', duration: 250 },
         right: { tag: 'note', pitch: 'g4', duration: 500 } },
      right:
       { tag: 'par',
         left: { tag: 'note', pitch: 'd3', duration: 500 },
         right: { tag: 'note', pitch: 'f4', duration: 250 } } };

console.log(melody_parallel);
console.log(compile(melody_parallel));
