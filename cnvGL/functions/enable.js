/*
Copyright (c) 2011 Cimaron Shanahan

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

function _glEnableDisable(cap, s) {
	var ctx;
	
	ctx = cnvgl_context.getCurrentContext();
	s = s ? GL_TRUE : GL_FALSE;

	switch (cap) {
		case GL_CULL_FACE:
			ctx.polygon.cullFlag = s;
			break;
		case GL_DEPTH_TEST:
			ctx.depth.test = s;
			break;
		case GL_BLEND:
			ctx.color.blendEnabled = s;
			break;

		default:
			throw new Error('Enable/Disable for ' + cap + ' not implemented yet');
	}
	
}

function glEnable(cap) {
	_glEnableDisable(cap, true);
}

function glDisable(cap) {
	_glEnableDisable(cap, false);
}
