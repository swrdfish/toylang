var __rpn = {};
__rpn._stack = [];
__rpn.temp = 0;
__rpn.push = function (val) {
  __rpn._stack.push(val);
};
__rpn.pop = function () {
  if (__rpn._stack.length > 0) {
    return __rpn._stack.pop();
  }
  else {
    throw new Error('can\'t pop from empty stack');
  }
};
__rpn.print = function (val, repeat) {
  while (repeat-- > 0) {
    var el = document.createElement('div');
    var txt = document.createTextNode(val);
    el.appendChild(txt);
    document.body.appendChild(el);
  }
};
__rpn.push(8);
__rpn.push('a');
window[__rpn.pop()] = __rpn.pop();
__rpn.push(3);
__rpn.push('b');
window[__rpn.pop()] = __rpn.pop();
__rpn.push(window.a);
__rpn.push(window.b);
__rpn.push(1);
__rpn.temp = __rpn.pop();
__rpn.push(__rpn.pop() - __rpn.temp);
__rpn.temp = __rpn.pop();
if (__rpn.temp === 0) throw new Error('divide by zero error');
__rpn.push(__rpn.pop() / __rpn.temp);
__rpn.push('c');
window[__rpn.pop()] = __rpn.pop();
__rpn.push(window.c);
__rpn.push(1);
__rpn.temp = __rpn.pop();
if (__rpn.temp <= 0) throw new Error('argument must be greater than 0');
if (Math.floor(__rpn.temp) != __rpn.temp) throw new Error('argument must be an integer');
__rpn.print(__rpn.pop(), __rpn.temp);

//# sourceMappingURL=simple-example.js.map