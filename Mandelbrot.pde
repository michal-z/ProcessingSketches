float zoom = 0.4;
float[] position = { -1.26, 0.12 };
PShader mandelbrot;
final String _ = "\n";

void setup() {
  size(1280, 720, P3D);
  noSmooth();
  noStroke();
  frameRate(60);

  String[] mandelbrotSrc = {
   _+  "#define PROCESSING_COLOR_SHADER"
  +_+  "uniform vec2 resolution;"
  +_+  "uniform vec2 position;"
  +_+  "uniform float zoom;"
  +_+  "vec2 complexMul(vec2 a, vec2 b) {"
  +_+  "  return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);"
  +_+  "}"
  +_+  "vec2 complexSq(vec2 a) {"
  +_+  "  return vec2(a.x * a.x - a.y * a.y, 2 * a.x * a.y);"
  +_+  "}"
  +_+  "void main() {"
  +_+  "  vec2 z = vec2(0.0, 0.0);"
  +_+  "  vec2 dz = vec2(1.0, 0.0);"
  +_+  "  float d = 0.0;"
  +_+  "  vec2 c = -1.0 + 2.0 * gl_FragCoord.xy / resolution;"
  +_+  "  c.x *= resolution.x / resolution.y;"
  +_+  "  c *= zoom;"
  +_+  "  c += position;"
  +_+  "  for (int i = 0; i < 256; ++i) {"
  +_+  "    dz = 2.0 * complexMul(z, dz) + vec2(1.0, 0.0);"
  +_+  "    z = complexSq(z) + c;"
  +_+  "    float m2 = dot(z, z);"
  +_+  "    if (m2 > 100.0) {"
  +_+  "      d = sqrt(m2 / dot(dz, dz)) * log(m2);"
  +_+  "      break;"
  +_+  "    }"
  +_+  "  }"
  +_+  "  d = 0.9 * pow(abs(d / zoom), 0.25);"
  +_+  "  gl_FragColor = vec4(d, d, d, 1.0);"
  +_+  "}"
  };
  saveStrings("data/mandelbrot.glsl", mandelbrotSrc);
  mandelbrot = loadShader("mandelbrot.glsl");

  mandelbrot.set("resolution", float(width), float(height));
}

void draw() {
  float dt = 1.0 / 60.0;
  if (keyPressed) {
    if (key == 'a') {
      zoom -= dt * zoom;
    } else if (key == 'z') {
      zoom += dt * zoom;
    }
    if (keyCode == LEFT) {
      position[0] -= dt * zoom;
    } else if (keyCode == RIGHT) {
      position[0] += dt * zoom;
    }
    if (keyCode == UP) {
      position[1] += dt * zoom;
    } else if (keyCode == DOWN) {
      position[1] -= dt * zoom;
    }
  }

  mandelbrot.set("position", position[0], position[1]);
  mandelbrot.set("zoom", zoom);
  shader(mandelbrot);
  rect(0, 0, width, height);
}
